void io_hlt(void);
void write_mem8(int addr, int data);

#define VRAM_START_ADDR	(0xa0000)
#define VRAM_LENGTH		(0xffff)
#define COLOR_WHITE		(0xf)

void HariMain() {
	int i;
	for (i = 0xa0000; i <= 0xaffff; i++) {
		write_mem8(i, 15); /* MOV BYTE [i],15 */
	}

	/* _io_hlt in naskfunc.nas */
	for(;;) {
		io_hlt();
	}
}
