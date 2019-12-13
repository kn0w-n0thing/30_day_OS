/* A funtion declared in other file */
void io_hlt(void);

void HariMain() {

fin:
	/* _io_hlt in naskfunc.nas */
	io_hlt();
	goto fin;
}
