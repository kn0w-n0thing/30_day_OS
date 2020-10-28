void io_hlt(void);
void io_cli(void);
void io_out8(int port, int data);
int io_load_eflags(void);
void io_store_eflags(int eflags);

#define VRAM_START_ADDR			(0xa0000)
#define VRAM_LENGTH				(0xffff)
#define COLOR_WHITE				(0xf)
#define VGA_WRITE_ENTRY_PORT 	(0x3c8)
#define VGA_WRITE_BUFF_PORT 	(0x3c9)

void init_palette(void);
void set_palette(int start, int end, unsigned char *rgb);

void HariMain() {
	int i;
	char *p = (char*) VRAM_START_ADDR;

	init_palette();

	for (i = 0; i <= VRAM_LENGTH; i++) {
		p[i] = i & 0x0f; /* MOV BYTE [i],15 */
	}

	/* _io_hlt in naskfunc.nas */
	for(;;) {
		io_hlt();
	}
}

void init_palette(void)
{
	static unsigned char table_rgb[16 * 3] = {
		0x00, 0x00, 0x00,	/*  0: black */
		0xff, 0x00, 0x00,	/*  1: red */
		0x00, 0xff, 0x00,	/*  2: lime */
		0xff, 0xff, 0x00,	/*  3: yellow */
		0x00, 0x00, 0xff,	/*  4: blue */
		0xff, 0x00, 0xff,	/*  5: magenta */
		0x00, 0xff, 0xff,	/*  6: cyan */
		0xff, 0xff, 0xff,	/*  7: white */
		0xc6, 0xc6, 0xc6,	/*  8: bright gray */
		0x84, 0x00, 0x00,	/*  9: dark red */
		0x00, 0x84, 0x00,	/* 10: dark green */
		0x84, 0x84, 0x00,	/* 11: dark yellow */
		0x00, 0x00, 0x84,	/* 12: dark blue */
		0x84, 0x00, 0x84,	/* 13: dark purple */
		0x00, 0x84, 0x84,	/* 14: dark water color */
		0x84, 0x84, 0x84	/* 15: dark gray */
	};
	set_palette(0, 15, table_rgb);
	return;

}

void set_palette(int start, int end, unsigned char *rgb) {
	int i, eflags;
	eflags = io_load_eflags();
	io_cli();
	io_out8(VGA_WRITE_ENTRY_PORT, start);
	for (i = start; i <= end; i++) {
		io_out8(VGA_WRITE_BUFF_PORT, rgb[0] / 4);
		io_out8(VGA_WRITE_BUFF_PORT, rgb[1] / 4);
		io_out8(VGA_WRITE_BUFF_PORT, rgb[3] / 4);
		rgb += 3;
	}
	io_store_eflags(eflags);
}
