-- Infrastructure as Code: Terraform / CloudFormation / Azure ARM / 各种 YAML·JSON 配置
--
--   Terraform        terraform-ls（补全/跳转/hover）+ tflint（LSP 方式出诊断）
--   CloudFormation   yamlls / jsonls 套 CFN schema（资源类型、属性补全和校验）+ cfn-lint
--   Azure ARM        只有 JSON 语法检查（官方 schema 坏了，见 jsonls 的注释）；.bicep 有高亮
--   其它             SchemaStore 目录里的几百个 schema：docker-compose、GitHub Actions、
--                    package.json、tsconfig …… 按文件名自动匹配
--
-- server 二进制由 Mason 装（见 lsp.lua 的 ensure_installed / tools）。

-- CloudFormation 模板没有固定的文件名，只能看内容认。
-- 结果缓存到 vim.b.cfn："cfn" / "sam" / false
local function cfn_kind(bufnr)
  if vim.b[bufnr].cfn ~= nil then return vim.b[bufnr].cfn end
  local kind = false
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, 200, false)
  local text = table.concat(lines, "\n")
  if text:find("AWSTemplateFormatVersion", 1, true)
    or text:match("[\"']?Type[\"']?%s*:%s*[\"']?AWS::%w+::") then
    kind = text:find("AWS::Serverless", 1, true) and "sam" or "cfn"
  end
  vim.b[bufnr].cfn = kind
  return kind
end

-- CFN 的短语法 !Ref / !GetAtt …，不声明的话 yamlls 会把每一个都标成 "Unresolved tag"
local cfn_tags = {
  "!And sequence", "!Or sequence", "!Not sequence", "!Equals sequence", "!If sequence",
  "!Condition scalar", "!Ref scalar", "!Base64 scalar", "!Base64 mapping",
  "!Cidr sequence", "!FindInMap sequence", "!GetAtt scalar", "!GetAtt sequence",
  "!GetAZs scalar", "!ImportValue scalar", "!ImportValue mapping", "!Join sequence",
  "!Select sequence", "!Split sequence", "!Sub scalar", "!Sub sequence",
  "!Transform mapping", "!ToJsonString mapping", "!ToJsonString sequence",
  "!Length sequence",
}

return {
  {
    "b0o/SchemaStore.nvim",
    lazy = false,
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      local schemastore = require("schemastore")

      local function schema_url(name)
        local s = schemastore.json.schemas({ select = { name } })[1]
        return s and s.url
      end
      local cfn_url = schema_url("AWS CloudFormation")
      local sam_url = schema_url("AWS CloudFormation Serverless Application Model (SAM)")

      vim.lsp.config("terraformls", {
        -- lspconfig 自带的 on_attach 调 vim.lsp.codelens.enable，那是 0.12 的 API，
        -- 0.11 上直接报错。codelens（引用计数）在 0.11 上走 refresh。
        on_attach = function(_, bufnr)
          if vim.lsp.codelens.enable then
            vim.lsp.codelens.enable(true, { bufnr = bufnr })
          else
            vim.lsp.codelens.refresh({ bufnr = bufnr })
          end
        end,
      })
      vim.lsp.config("tflint", {})

      vim.lsp.config("yamlls", {
        settings = {
          redhat = { telemetry = { enabled = false } },
          yaml = {
            -- 用 SchemaStore.nvim 内置的目录，不让 yamlls 自己去网上拉 catalog
            schemaStore = { enable = false, url = "" },
            schemas = schemastore.yaml.schemas(),
            customTags = cfn_tags,
            keyOrdering = false,
            format = { enable = false }, -- 格式化交给 conform 的 yamlfmt
          },
        },
      })

      vim.lsp.config("jsonls", {
        -- Azure 官方的 ARM schema 里有 $ref 指向不存在的定义（比如
        -- accounts_shareSubscriptions_triggers），每个 ARM 模板第 2 行都会挂一条
        -- "Problems loading reference"。这是上游 schema 的 bug（2015 / 2019 两版都有），
        -- 而且一条 $ref 挂了整个 schema 就不校验了 —— ARM 模板实际上只有 JSON 语法检查。
        -- 这条报错只是噪音，滤掉。
        -- push 和 pull 两种诊断都要拦（0.11 上 jsonls 走的是 pull）
        handlers = (function()
          local function drop_broken_refs(list)
            return list and vim.tbl_filter(function(d)
              return not d.message:find("^Problems loading reference")
            end, list)
          end
          return {
            ["textDocument/publishDiagnostics"] = function(err, result, ctx)
              if result then result.diagnostics = drop_broken_refs(result.diagnostics) end
              return vim.lsp.handlers["textDocument/publishDiagnostics"](err, result, ctx)
            end,
            ["textDocument/diagnostic"] = function(err, result, ctx)
              if result then result.items = drop_broken_refs(result.items) end
              return vim.lsp.handlers["textDocument/diagnostic"](err, result, ctx)
            end,
          }
        end)(),
        settings = {
          json = {
            schemas = schemastore.json.schemas(),
            validate = { enable = true },
          },
        },
      })

      -- CFN 模板按内容识别，没法写成 glob。attach 的时候把这个文件的路径临时加进
      -- 对应 schema 的匹配列表，然后推一次 didChangeConfiguration 让 server 重新校验。
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("iac_cfn_schema", { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client or (client.name ~= "yamlls" and client.name ~= "jsonls") then return end
          local kind = cfn_kind(args.buf)
          local url = (kind == "sam" and sam_url) or (kind == "cfn" and cfn_url)
          local path = vim.api.nvim_buf_get_name(args.buf)
          if not url or path == "" then return end

          if client.name == "yamlls" then
            local schemas = client.settings.yaml.schemas
            local globs = schemas[url]
            if type(globs) ~= "table" then
              globs = globs and { globs } or {}
              schemas[url] = globs
            end
            if vim.tbl_contains(globs, path) then return end
            table.insert(globs, path)
          else
            table.insert(client.settings.json.schemas, { fileMatch = { path }, url = url })
          end
          client:notify("workspace/didChangeConfiguration", { settings = client.settings })
        end,
      })

      vim.lsp.enable({ "terraformls", "tflint", "yamlls", "jsonls" })
    end,
  },

  -- cfn-lint：比 schema 校验深得多（跨资源引用、区域可用性、最佳实践），只在识别出
  -- 是 CFN 模板的 buffer 上跑
  {
    "mfussenegger/nvim-lint",
    -- 按 filetype 懒加载：lazy 会在加载完之后重放这次 FileType，下面的 autocmd 能接住
    ft = { "yaml", "json" },
    config = function()
      local lint = require("lint")
      vim.api.nvim_create_autocmd({ "FileType", "BufWritePost", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("iac_cfn_lint", { clear = true }),
        pattern = { "yaml", "json", "*.yaml", "*.yml", "*.json", "*.template" },
        callback = function(args)
          -- 新建的空文件第一次识别肯定是 false，保存时重新看一遍内容
          if args.event == "BufWritePost" then vim.b[args.buf].cfn = nil end
          local ft = vim.bo[args.buf].filetype
          if (ft == "yaml" or ft == "json") and cfn_kind(args.buf) then
            vim.api.nvim_buf_call(args.buf, function() lint.try_lint("cfn_lint") end)
          end
        end,
      })
    end,
  },
}
