set Z_TOOL_DIR=..\z_tools
set IMG_NAME=helloos.img
%Z_TOOL_DIR%\nask.exe hello.nas %IMG_NAME%
copy %IMG_NAME% %Z_TOOL_DIR%\qemu\fdimage0.bin
%Z_TOOL_DIR%\make.exe -C %Z_TOOL_DIR%/qemu
