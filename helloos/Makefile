# variables
z_tool_dir=../z_tools
z_tool_dir_win=..\z_tools

default:
	$(z_tool_dir)/make.exe img

# rule of files
ipl.bin: ipl.nas Makefile
	$(z_tool_dir)/nask.exe ipl.nas ipl.bin ipl.lst

helloos.img: ipl.bin Makefile
	$(z_tool_dir)/edimg.exe imgin:$(z_tool_dir)/fdimg0at.tek \
		wbinimg src:ipl.bin len:512 from:0 to:0 imgout:helloos.img

# commands
asm:
	$(z_tool_dir)/make.exe -r ipl.bin

img:
	$(z_tool_dir)/make.exe -r helloos.img

run:
	$(z_tool_dir)/make.exe img
	copy helloos.img $(z_tool_dir_win)\qemu\fdimage0.bin
	$(z_tool_dir)/make.exe -C $(z_tool_dir)/qemu

install:
	$(z_tool_dir)/make.exe img
	$(z_tool_dir)/imgtol.com w a: helloos.img

clean:
	-del ipl.bin
	-del ipl.lst
	-del helloos.img
