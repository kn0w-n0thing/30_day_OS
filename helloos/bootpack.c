void io_hlt(void);
void write_mem8(int addr, int data);

#define VRAM_START_ADDR	(0xa0000)
#define VRAM_LENGTH		(0xffff)
#define COLOR_WHITE		(0xf)

void HariMain() {
	int i;
	char *p = (char*) VRAM_START_ADDR;
	for (i = 0; i <= VRAM_LENGTH; i++) {
		p[i] = i & 0x0f; /* MOV BYTE [i],15 */
	}

	/* _io_hlt in naskfunc.nas */
	for(;;) {
		io_hlt();
	}
}
