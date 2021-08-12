nvim 环境搭建
参考
https://www.cnblogs.com/cniwoq/p/13272746.html
下载nvim.appimage
https://github.com/neovim/neovim/releases/
Download nvim.appimage
Run chmod u+x nvim.appimage && ./nvim.appimage
If your system does not have FUSE you can extract the appimage:
./nvim.appimage --appimage-extract
./squashfs-root/usr/bin/nvim
创建链接
ln -s /usr/local/squashfs-root/usr/bin/nvim /usr/bin/vim
2. 下载管理插件
https://github.com/junegunn/vim-plug
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
下载coc 安装nodjs
curl -sL install-node.now.sh/lts | bash
https://github.com/neoclide/coc.nvim
go 开发环境配置
https://github.com/josa42/coc-go
C开发环境
sudo -s ln -s /home/ltj/.config/coc/extensions/coc-clangd-data/install/12.0.1/clangd_12.0.1/bin/clangd /usr/local/bin/clangd
安装coc-clangd之后，没有在系统路径中
//如何配置参考
https://github.com/neoclide/coc.nvim/wiki/Language-servers
配置coc之后不生效:
通过coccommand 查看worksapceoutput 查看对应的log是  安装glic之后就可以了.
/lib64/libc.so.6: version `GLIBC_2.18‘ not found (required by /lib64/libstdc++.so.6)“
curl -O http://ftp.gnu.org/gnu/glibc/glibc-2.18.tar.gz
tar zxf glibc-2.18.tar.gz  
cd glibc-2.18/
mkdir build
cd build/
../configure --prefix=/usr
make -j2
make install
