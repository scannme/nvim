### 目录结构

```shell
root@ubuntu:~/.config/nvim# tree 
.
├── init.lua  //配置入口
├── lua
│   ├── core  
│   │   ├── keymaps.lua //快捷键
│   │   └── options.lua //配置vim选项
│   └── plugins //常用插件
│       ├── autopairs.lua  //配置括号补全
│       ├── bufferline.lua //打开文件的管理
│       ├── cmp.lua //自动补全插件
│       ├── comment.lua //注释插件
│       ├── gitsigns.lua //git 图标
│       ├── lsp.lua //自动补全
│       ├── lualine.lua //状态栏
│       ├── nvim-tree.lua //文档树, 目录管理
│       ├── plugins-setup.lua //安装插件
│       ├── rust-lang.lua //rust语言插件
│       ├── telescope.lua //搜索插件
│       └── treesitter.lua
├── plugin
│   └── packer_compiled.lua //安装时生成的目录，不要修改
└── README.md
```

### 安装
```shell
git clone https://github.com/scannme/nvim.git  ~/.config/nvim/
```

### 常用命令

该工程使用" "作为主键, space
VIM模式
- n: 普通模式 使用`ESC` 进入
- v: 视图模式 使用`V或v` 进入

| 插件  | 模式|快捷键 |功能 |
| :----- | :--:| :--: | :-------|
| bufferline |   n | \<space>bn | 选择下一个buffer   |
|    |  n | \<space>bh|    选择上一个buffer |
|  |   n |  \<space>bp| 指定名称选择一个buffer|  |
|lsp| n | gD| 跳转到声明|
||n|gd|跳转到定义|
||n|K| 显示函数声明信息|
||n|gi|在结构体上,显示所有的声明|
||n|\<C-k>| 显示函数参数的信息|
||n|\<space>wa| 把当前目录加入到工作区中,这样lsp server就会从这个工作时就会也寻找这个目录的文件|
||n|\<space>wr| 从workspace中删除当前目录|
||n|\<space>wl| 列出workspace的目录|
||n|\<space>D|跳转到结构体定义处|
||n|\<space>rn| 修改名称，全局修改|
||n,v|\<space>ca|选中一段代码,做相应的代码生成|
||n|gr|调用当前函数的列表|
||n|\<space>f| 选中一个函数,格式化这个函数|
||n|\<space>d| 打开diagnostic 错误信息|
||n|[d| 上一个错误信息|
||n|]d| 下一个错误信息|
||n|\<space>q| |
|nvim-tree|n|<space>t| 打开文件树|
||n|?| 打开nvim-tree的帮助信息|
||n|\<C-t>|到系统的跟目录|
|telescope https://github.com/nvim-telescope/telescope.nvim|n|\<space>ff| 查找文件|
||n|\<space>fg| 使用grep查找文件的内容信息, 需要安装 ripgrep|
||n|\<space>fb|查找buffer|
||n|\<space>lk|列出keymap的信息|
|float term|n|\<F7>|create a float term|
|float term|n|\<F8>|delete a float term|
|G|v|K|选中多行移动|
|G|v|J|选中多行移动|
|G|n|<space>sv|水平新增窗口|
|G|n|<space>sh|垂直新增窗口|
|G|n|<space>nh|取消高亮|


