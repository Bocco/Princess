;
; File generated by cc65 v 2.15
;
	.fopt		compiler,"cc65 v 2.15"
	.setcpu		"6502"
	.smart		on
	.autoimport	on
	.case		on
	.debuginfo	off
	.importzp	sp, sreg, regsave, regbank
	.importzp	tmp1, tmp2, tmp3, tmp4, ptr1, ptr2, ptr3, ptr4
	.macpack	longbranch
	.forceimport	__STARTUP__
	.import		_Get_Input
	.export		_NMI_flag
	.export		_Frame_Count
	.export		_index
	.export		_index4
	.export		_X1
	.export		_Y1
	.export		_state
	.export		_state4
	.export		_joypad1
	.export		_joypad1old
	.export		_joypad1test
	.export		_joypad2
	.export		_joypad2old
	.export		_joypad2test
	.export		_bullet_wait
	.export		_bullet_index
	.export		_bullet_x
	.export		_bullet_y
	.export		_aux
	.export		_SPRITE_PLAYER
	.export		_SPRITE_BULLET
	.export		_PALETTE
	.export		_MetaSprite_Y
	.export		_MetaSprite_Tile
	.export		_MetaSprite_Attrib
	.export		_MetaSprite_X
	.export		_All_Off
	.export		_All_On
	.export		_Reset_Scroll
	.export		_Load_Palette
	.export		_every_frame
	.export		_move_logic
	.export		_update_Sprites
	.export		_main

.segment	"RODATA"

_PALETTE:
	.byte	$19
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$3C
	.byte	$20
	.byte	$0F
	.byte	$26
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
_MetaSprite_Y:
	.byte	$00
	.byte	$00
	.byte	$08
	.byte	$08
_MetaSprite_Tile:
	.byte	$00
	.byte	$01
	.byte	$10
	.byte	$11
_MetaSprite_Attrib:
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
_MetaSprite_X:
	.byte	$00
	.byte	$08
	.byte	$00
	.byte	$08

.segment	"BSS"

.segment	"ZEROPAGE"
_NMI_flag:
	.res	1,$00
_Frame_Count:
	.res	1,$00
_index:
	.res	1,$00
_index4:
	.res	1,$00
_X1:
	.res	1,$00
_Y1:
	.res	1,$00
_state:
	.res	1,$00
_state4:
	.res	1,$00
_joypad1:
	.res	1,$00
_joypad1old:
	.res	1,$00
_joypad1test:
	.res	1,$00
_joypad2:
	.res	1,$00
_joypad2old:
	.res	1,$00
_joypad2test:
	.res	1,$00
_bullet_wait:
	.res	1,$00
_bullet_index:
	.res	1,$00
_bullet_x:
	.res	6,$00
_bullet_y:
	.res	6,$00
_aux:
	.res	1,$00
.segment	"OAM"
_SPRITE_PLAYER:
	.res	16,$00
_SPRITE_BULLET:
	.res	64,$00

; ---------------------------------------------------------------
; void __near__ All_Off (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_All_Off: near

.segment	"CODE"

;
; PPU_CTRL = 0;
;
	lda     #$00
	sta     $2000
;
; PPU_MASK = 0;
;
	sta     $2001
;
; }
;
	rts

.endproc

; ---------------------------------------------------------------
; void __near__ All_On (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_All_On: near

.segment	"CODE"

;
; PPU_CTRL = 0x90; //screen is on, NMI on
;
	lda     #$90
	sta     $2000
;
; PPU_MASK = 0x1e; 
;
	lda     #$1E
	sta     $2001
;
; }
;
	rts

.endproc

; ---------------------------------------------------------------
; void __near__ Reset_Scroll (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_Reset_Scroll: near

.segment	"CODE"

;
; PPU_ADDRESS = 0;
;
	lda     #$00
	sta     $2006
;
; PPU_ADDRESS = 0;
;
	sta     $2006
;
; SCROLL = 0;
;
	sta     $2005
;
; SCROLL = 0;
;
	sta     $2005
;
; }
;
	rts

.endproc

; ---------------------------------------------------------------
; void __near__ Load_Palette (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_Load_Palette: near

.segment	"CODE"

;
; PPU_ADDRESS = 0x3f;
;
	lda     #$3F
	sta     $2006
;
; PPU_ADDRESS = 0x00;
;
	lda     #$00
	sta     $2006
;
; for( index = 0; index < sizeof(PALETTE); ++index ){
;
	sta     _index
L0135:	lda     _index
	cmp     #$20
	bcs     L005A
;
; PPU_DATA = PALETTE[index];
;
	ldy     _index
	lda     _PALETTE,y
	sta     $2007
;
; for( index = 0; index < sizeof(PALETTE); ++index ){
;
	inc     _index
	jmp     L0135
;
; }
;
L005A:	rts

.endproc

; ---------------------------------------------------------------
; void __near__ every_frame (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_every_frame: near

.segment	"CODE"

;
; OAM_ADDRESS = 0;
;
	lda     #$00
	sta     $2003
;
; OAM_DMA = 2; //push all the sprite data from the ram at 200-2ff to the sprite memory
;
	lda     #$02
	sta     $4014
;
; PPU_CTRL = 0x90; //screen is on, NMI on
;
	lda     #$90
	sta     $2000
;
; PPU_MASK = 0x1e;
;
	lda     #$1E
	sta     $2001
;
; SCROLL = 0;
;
	lda     #$00
	sta     $2005
;
; SCROLL = 0;  //just double checking that the scroll is set to 0
;
	sta     $2005
;
; Get_Input();
;
	jmp     _Get_Input

.endproc

; ---------------------------------------------------------------
; void __near__ move_logic (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_move_logic: near

.segment	"CODE"

;
; if ((joypad1 & RIGHT) > 0 & X1<0xF0){
;
	lda     _joypad1
	and     #$01
	jsr     boolne
	jsr     pusha0
	lda     _X1
	cmp     #$F0
	jsr     boolult
	jsr     tosanda0
	cmp     #$00
	beq     L0136
;
; ++X1;
;
	inc     _X1
;
; if ((joypad1 & LEFT ) > 0 & X1>0x0){
;
L0136:	lda     _joypad1
	and     #$02
	jsr     boolne
	jsr     pusha0
	lda     _X1
	jsr     boolne
	jsr     tosanda0
	cmp     #$00
	beq     L0137
;
; --X1;
;
	dec     _X1
;
; if ((joypad1 & DOWN) > 0 & Y1<0xB0){
;
L0137:	lda     _joypad1
	and     #$04
	jsr     boolne
	jsr     pusha0
	lda     _Y1
	cmp     #$B0
	jsr     boolult
	jsr     tosanda0
	cmp     #$00
	beq     L0138
;
; ++Y1;
;
	inc     _Y1
;
; if ((joypad1 & UP) > 0 & Y1>0x8){
;
L0138:	lda     _joypad1
	and     #$08
	jsr     boolne
	sta     ptr1
	lda     _Y1
	cmp     #$09
	txa
	rol     a
	and     ptr1
	pha
	pla
	beq     L0139
;
; --Y1;
;
	dec     _Y1
;
; if(bullet_wait==0x0){
;
L0139:	lda     _bullet_wait
	bne     L013B
;
; if((joypad1 & (B_BUTTON)) > 0){
;
	lda     _joypad1
	and     #$40
	beq     L013A
;
; bullet_wait=0x50;
;
	lda     #$50
	sta     _bullet_wait
;
; bullet_x[bullet_index]=X1+0x10;
;
	lda     #<(_bullet_x)
	ldx     #>(_bullet_x)
	clc
	adc     _bullet_index
	bcc     L009B
	inx
L009B:	sta     ptr1
	stx     ptr1+1
	lda     _X1
	clc
	adc     #$10
	ldy     #$00
	sta     (ptr1),y
;
; bullet_y[bullet_index]=Y1+0x4;
;
	lda     #<(_bullet_y)
	ldx     #>(_bullet_y)
	clc
	adc     _bullet_index
	bcc     L00A0
	inx
L00A0:	sta     ptr1
	stx     ptr1+1
	lda     _Y1
	clc
	adc     #$04
	sta     (ptr1),y
;
; ++bullet_index;
;
L013A:	inc     _bullet_index
;
; if(bullet_index>=MAX_BULLETS){
;
	lda     _bullet_index
	cmp     #$06
	lda     #$00
	bcc     L013D
;
; bullet_index=0;
;
	sta     _bullet_index
;
; else{
;
	jmp     L013D
;
; --bullet_wait;
;
L013B:	dec     _bullet_wait
;
; for(aux=0;aux<MAX_BULLETS;aux++){
;
	txa
L013D:	sta     _aux
	cmp     #$06
	bcs     L00AB
;
; if(bullet_x[aux]<250){
;
	ldy     _aux
	lda     _bullet_x,y
	cmp     #$FA
	bcs     L00B2
;
; ++bullet_x[aux];
;
	lda     #<(_bullet_x)
	ldx     #>(_bullet_x)
	clc
	adc     _aux
	bcc     L00B8
	inx
L00B8:	sta     ptr1
	stx     ptr1+1
	ldy     #$00
	lda     #$01
	clc
	adc     (ptr1),y
	sta     (ptr1),y
;
; }else{
;
	jmp     L013F
;
; bullet_x[aux]=255;
;
L00B2:	ldy     _aux
	lda     #$FF
	sta     _bullet_x,y
;
; bullet_y[aux]=0;
;
	ldy     _aux
	lda     #$00
	sta     _bullet_y,y
;
; for(aux=0;aux<MAX_BULLETS;aux++){
;
L013F:	lda     _aux
	clc
	adc     #$01
	jmp     L013D
;
; }
;
L00AB:	rts

.endproc

; ---------------------------------------------------------------
; void __near__ update_Sprites (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_update_Sprites: near

.segment	"CODE"

;
; index4 = 0;
;
	lda     #$00
	sta     _index4
;
; for (index = 0; index < 4; ++index ){
;
	sta     _index
L0142:	lda     _index
	cmp     #$04
	jcs     L0143
;
; SPRITE_PLAYER[index4] = MetaSprite_Y[index] + Y1; //relative y + master y
;
	lda     #<(_SPRITE_PLAYER)
	ldx     #>(_SPRITE_PLAYER)
	clc
	adc     _index4
	bcc     L00CF
	inx
L00CF:	sta     ptr1
	stx     ptr1+1
	ldy     _index
	lda     _MetaSprite_Y,y
	clc
	adc     _Y1
	ldy     #$00
	sta     (ptr1),y
;
; ++index4;
;
	inc     _index4
;
; SPRITE_PLAYER[index4] = MetaSprite_Tile[index]; //tile numbers
;
	lda     #<(_SPRITE_PLAYER)
	ldx     #>(_SPRITE_PLAYER)
	clc
	adc     _index4
	bcc     L00D6
	inx
L00D6:	sta     ptr1
	stx     ptr1+1
	ldy     _index
	lda     _MetaSprite_Tile,y
	ldy     #$00
	sta     (ptr1),y
;
; ++index4;
;
	inc     _index4
;
; SPRITE_PLAYER[index4] = MetaSprite_Attrib[index]; //attributes, all zero here
;
	lda     #<(_SPRITE_PLAYER)
	ldx     #>(_SPRITE_PLAYER)
	clc
	adc     _index4
	bcc     L00DD
	inx
L00DD:	sta     ptr1
	stx     ptr1+1
	ldy     _index
	lda     _MetaSprite_Attrib,y
	ldy     #$00
	sta     (ptr1),y
;
; ++index4;
;
	inc     _index4
;
; SPRITE_PLAYER[index4] = MetaSprite_X[index] + X1; //relative x + master x
;
	lda     #<(_SPRITE_PLAYER)
	ldx     #>(_SPRITE_PLAYER)
	clc
	adc     _index4
	bcc     L00E4
	inx
L00E4:	sta     ptr1
	stx     ptr1+1
	ldy     _index
	lda     _MetaSprite_X,y
	clc
	adc     _X1
	ldy     #$00
	sta     (ptr1),y
;
; ++index4;
;
	inc     _index4
;
; for (index = 0; index < 4; ++index ){
;
	inc     _index
	jmp     L0142
;
; index4=0;
;
L0143:	lda     #$00
	sta     _index4
;
; for(aux=0;aux<MAX_BULLETS;++aux){
;
	sta     _aux
L0144:	lda     _aux
	cmp     #$06
	bcs     L00EC
;
; SPRITE_BULLET[index4] = bullet_y[aux];
;
	lda     #<(_SPRITE_BULLET)
	ldx     #>(_SPRITE_BULLET)
	clc
	adc     _index4
	bcc     L00F5
	inx
L00F5:	sta     ptr1
	stx     ptr1+1
	ldy     _aux
	lda     _bullet_y,y
	ldy     #$00
	sta     (ptr1),y
;
; ++index4;
;
	inc     _index4
;
; SPRITE_BULLET[index4] = 0x0; //which tile
;
	ldy     _index4
	lda     #$00
	sta     _SPRITE_BULLET,y
;
; ++index4;
;
	inc     _index4
;
; SPRITE_BULLET[index4] = 0;
;
	ldy     _index4
	sta     _SPRITE_BULLET,y
;
; ++index4;
;
	inc     _index4
;
; SPRITE_BULLET[index4] = bullet_x[aux];
;
	lda     #<(_SPRITE_BULLET)
	ldx     #>(_SPRITE_BULLET)
	clc
	adc     _index4
	bcc     L0106
	inx
L0106:	sta     ptr1
	stx     ptr1+1
	ldy     _aux
	lda     _bullet_x,y
	ldy     #$00
	sta     (ptr1),y
;
; ++index4;
;
	inc     _index4
;
; for(aux=0;aux<MAX_BULLETS;++aux){
;
	inc     _aux
	jmp     L0144
;
; }
;
L00EC:	rts

.endproc

; ---------------------------------------------------------------
; void __near__ main (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_main: near

.segment	"CODE"

;
; All_Off(); //turn off screen
;
	jsr     _All_Off
;
; X1 = 0x00;
;
	lda     #$00
	sta     _X1
;
; Y1 = 0x58; //middle of screen
;
	lda     #$58
	sta     _Y1
;
; for(bullet_index=0;bullet_index<MAX_BULLETS;bullet_index++){
;
	lda     #$00
L0148:	sta     _bullet_index
	cmp     #$06
	bcs     L0146
;
; bullet_x[bullet_index]=255; //out of screen
;
	ldy     _bullet_index
	lda     #$FF
	sta     _bullet_x,y
;
; bullet_y[bullet_index]=0x0;
;
	ldy     _bullet_index
	lda     #$00
	sta     _bullet_y,y
;
; for(bullet_index=0;bullet_index<MAX_BULLETS;bullet_index++){
;
	lda     _bullet_index
	clc
	adc     #$01
	jmp     L0148
;
; bullet_index=0x0;
;
L0146:	lda     #$00
	sta     _bullet_index
;
; bullet_wait=0x0;
;
	sta     _bullet_wait
;
; Load_Palette();
;
	jsr     _Load_Palette
;
; Reset_Scroll();
;
	jsr     _Reset_Scroll
;
; All_On(); //turn on screen
;
	jsr     _All_On
;
; while (NMI_flag == 0);//wait till NMI
;
L0147:	lda     _NMI_flag
	beq     L0147
;
; NMI_flag = 0;
;
	lda     #$00
	sta     _NMI_flag
;
; every_frame(); //should be done first every v-blank
;
	jsr     _every_frame
;
; move_logic();
;
	jsr     _move_logic
;
; update_Sprites();
;
	jsr     _update_Sprites
;
; while (1){ //infinite loop
;
	jmp     L0147

.endproc

