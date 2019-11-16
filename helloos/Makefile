# variables
TOOLPATH=../z_tools
MAKE=$(TOOLPATH)/make.exe -r
NASK=$(TOOLPATH)/nask.exe
EDIMG=$(TOOLPATH)/edimg.exe
IMGTOL=$(TOOLPATH)/imgtol.exe
COPY=copy
DEL=del

default:
	$(MAKE) img

# rule of files
ipl.bin: ipl.nas Makefile
	$(NASK) ipl.nas ipl.bin ipl.lst

turing.sys: turing.nas Makefile
	$(NASK)	turing.nas turing.sys turing.lst

turing.img: ipl.bin turing.sys Makefile
	$(EDIMG) imgin:$(TOOLPATH)/fdimg0at.tek \
		wbinimg src:ipl.bin len:512 from:0 to:0 \
		copy from:turing.sys to:@: \
		imgout:turing.img

# commands
img:
	$(MAKE) turing.img

run:
	$(MAKE) img
	$(COPY)	turing.img	..\z_tools\qemu\fdimage0.bin
	$(MAKE) -C ../z_tools/qemu

install:
	$(MAKE) img
	$(IMGTOL) w a: turing.img

clean:
	-del ipl.bin
	-del ipl.lst
	-del turing.sys
	-del turing.lst
	-del helloos.img
