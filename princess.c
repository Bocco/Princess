//for cc65, for NES
//constructs a simple metasprite, gets input, and moves him around
//doug fraker 2015
//feel free to reuse any code here


void __fastcall__ Shuffle_Sprites(void);

void __fastcall__ Sprite_Zero(void);

void __fastcall__ Reset(void);

void __fastcall__ Blank_sprite3(void);

void __fastcall__ Play_Fx(unsigned char effect);

void __fastcall__ Reset_Music(void);

void __fastcall__ Play_Music(unsigned char song);

void __fastcall__ Music_Update(void);

void __fastcall__ Wait_Vblank(void);

void __fastcall__ UnRLE(int data);


void __fastcall__ Get_Input(void); //this calls an asm function, written in asm4c.s
//it will read both joypads and store their reads in joypad1 and joypad2
//The buttons come in the order of A, B, Select, Start, Up, Down, Left, Right

#define PPU_CTRL		*((unsigned char*)0x2000)
#define PPU_MASK		*((unsigned char*)0x2001)
#define PPU_STATUS		*((unsigned char*)0x2002)
#define OAM_ADDRESS		*((unsigned char*)0x2003)
#define SCROLL			*((unsigned char*)0x2005)
#define PPU_ADDRESS		*((unsigned char*)0x2006)
#define PPU_DATA		*((unsigned char*)0x2007)
#define OAM_DMA			*((unsigned char*)0x4014)




#define MAP_ADR(x,y)	((((y)-2)<<MAP_WDT_BIT)|(x))



//bullets
#define MAX_BULLETS 6 

#define RIGHT		0x01
#define LEFT		0x02
#define DOWN		0x04
#define UP			0x08
#define START		0x10
#define SELECT		0x20
#define B_BUTTON	0x40
#define A_BUTTON	0x80


//Globals
//our startup code initialized all values to zero
#pragma bss-name(push, "ZEROPAGE")
unsigned char NMI_flag;
unsigned char Frame_Count;
unsigned char index;
unsigned char index4;
unsigned char X1;
unsigned char Y1;
unsigned char state;
unsigned char state4;
unsigned char joypad1;
unsigned char joypad1old;
unsigned char joypad1test; 
unsigned char joypad2; 
unsigned char joypad2old;
unsigned char joypad2test;


//bullets
unsigned char bullet_wait;
unsigned char bullet_index;
unsigned char bullet_x[MAX_BULLETS];
unsigned char bullet_y[MAX_BULLETS];
unsigned char aux; //counter

#pragma bss-name(push, "OAM")
unsigned char SPRITE_PLAYER[0x10];
//OAM equals ram addresses 200-2ff
unsigned char SPRITE_BULLET[0x40];

#define Going_Right 0
#define Going_Down	1
#define Going_Left	2
#define Going_Up	3

//Bullet Sprite
//


//char sprite
const unsigned char PALETTE[]={0x19, 0, 0, 0,
								0, 0, 0, 0,  
								0, 0, 0, 0,  
								0, 0, 0, 0,
								0x3c,0x20,0x0f,0x26,
								0, 0, 0, 0,
								0, 0, 0, 0,
								0, 0, 0, 0};

const unsigned char MetaSprite_Y[] = {0, 0, 8, 8}; //relative y coordinates

const unsigned char MetaSprite_Tile[] = {
0x0,0x1,0x10,0x11
};
 //up

const unsigned char MetaSprite_Attrib[] = {0, 0, 0, 0}; //attributes = flipping, palette

const unsigned char MetaSprite_X[] = {0, 8, 0, 8}; //relative x coordinates
//we are using 4 sprites, each one has a relative position from the top left sprite




void All_Off(void) {
	PPU_CTRL = 0;
	PPU_MASK = 0;
}
	
void All_On(void) {
	PPU_CTRL = 0x90; //screen is on, NMI on
	PPU_MASK = 0x1e; 
}
	
void Reset_Scroll (void) {
	PPU_ADDRESS = 0;
	PPU_ADDRESS = 0;
	SCROLL = 0;
	SCROLL = 0;
}
	
void Load_Palette(void) {
	PPU_ADDRESS = 0x3f;
	PPU_ADDRESS = 0x00;
	for( index = 0; index < sizeof(PALETTE); ++index ){
		PPU_DATA = PALETTE[index];
	}
}

void every_frame(void) {
	//do any PPU updates first
	OAM_ADDRESS = 0;
	OAM_DMA = 2;	//push all the sprite data from the ram at 200-2ff to the sprite memory
	PPU_CTRL = 0x90; //screen is on, NMI on
	PPU_MASK = 0x1e;
	SCROLL = 0;
	SCROLL = 0;		//just double checking that the scroll is set to 0
	Get_Input();
}

void move_logic(void) {
	if ((joypad1 & RIGHT) > 0 & X1<0xF0){
		//state = Going_Right;
		++X1;
	}
	if ((joypad1 & LEFT ) > 0 & X1>0x0){
		//state = Going_Left;
		--X1;
	}
	if ((joypad1 & DOWN) > 0 & Y1<0xB0){
		//state = Going_Down;
		++Y1;
	}
	if ((joypad1 & UP) > 0 & Y1>0x8){
		//state = Going_Up;
		--Y1;
	}
	
	
	//bullets
	if(bullet_wait==0x0){
		
		
		if((joypad1 & (B_BUTTON)) > 0){
			bullet_wait=0x50;
			bullet_x[bullet_index]=X1+0x10;
			bullet_y[bullet_index]=Y1+0x4;
		}
		++bullet_index;
		if(bullet_index>=MAX_BULLETS){
			bullet_index=0;
		}
	}
	else{
		--bullet_wait;
	}
	
	//update bullet sprites
	for(aux=0;aux<MAX_BULLETS;aux++){
	if(bullet_x[aux]<250){
		
		++bullet_x[aux];
	}else{
		bullet_x[aux]=255;
		bullet_y[aux]=0;
	}
	
	}
	
}

void update_Sprites (void) {
	//state4 = state << 2; //same as state * 4
	index4 = 0;
	for (index = 0; index < 4; ++index ){
		SPRITE_PLAYER[index4] = MetaSprite_Y[index] + Y1; //relative y + master y
		++index4;
		SPRITE_PLAYER[index4] = MetaSprite_Tile[index]; //tile numbers
		++index4;
		SPRITE_PLAYER[index4] = MetaSprite_Attrib[index]; //attributes, all zero here
		++index4;
		SPRITE_PLAYER[index4] = MetaSprite_X[index] + X1; //relative x + master x
		++index4;
	}
	index4=0;
	for(aux=0;aux<MAX_BULLETS;++aux){
		SPRITE_BULLET[index4] = bullet_y[aux];
		++index4;
		SPRITE_BULLET[index4] = 0x0; //which tile
		++index4;
		SPRITE_BULLET[index4] = 0;
		++index4;
		SPRITE_BULLET[index4] = bullet_x[aux];
		++index4;
	}
}

void main (void) {
	All_Off(); //turn off screen
	X1 = 0x00;
	Y1 = 0x58; //middle of screen
	//Initializing bullets
	
	for(bullet_index=0;bullet_index<MAX_BULLETS;bullet_index++){
		bullet_x[bullet_index]=255; //out of screen
		bullet_y[bullet_index]=0x0;
	}
	bullet_index=0x0;
	bullet_wait=0x0;
	Load_Palette();
	Reset_Scroll();
	All_On(); //turn on screen
	while (1){ //infinite loop
		while (NMI_flag == 0);//wait till NMI
		NMI_flag = 0;
		every_frame();	//should be done first every v-blank
		move_logic();
		update_Sprites();
	}
	
	
}
	
//inside the startup code, the NMI routine will ++NMI_flag and ++Frame_Count at each V-blank
	