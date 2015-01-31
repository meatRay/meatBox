module meatbox.textbox;

import meatbox.window;

import derelict.sdl2.ttf;
import derelict.sdl2.sdl;

static this()
{ 
	DerelictSDL2ttf.load();
	TTF_Init(); 
}
static ~this()
	{ TTF_Quit(); }

alias Color =Colour;
struct Colour
{
public:
	ubyte red, green, blue;
}

alias Font =TTF_Font*;
alias openFont =TTF_OpenFont;
class Textbox
{
public:
	TTF_Font* font;
	alias color =colour;
	Colour colour;
	int x, y, width, height;
	string text() @property
		{ return this._text; }
	this( string text )
		{ this( text, TTF_OpenFont("lucon.ttf", 16)); }
	this( string text, Font font )
		{
			this.font =font;
			setText( text );
		}
	~this()
		{ TTF_CloseFont( font ); }
	void render()
	{
		glColor3ub( colour.red, colour.green, colour.blue );
		glVertexPointer( 2, GL_FLOAT, 0, _verts.ptr );	
		glBindTexture( GL_TEXTURE_2D, _texture );
		
		glPushMatrix();
		glTranslatef( x, y, 0);
		glDrawArrays( GL_QUADS, 0, 4);
		glPopMatrix();	
	}
	void setText( string text )
	{
		this._text =text;
		import std.string: toStringz;
		SDL_Surface* surf =TTF_RenderText_Blended( font, toStringz(text), SDL_Color(255, 255, 255) );		
		//May be faster to render to 8bit pallet, and convert? Let's just make it nice I guess.
		
		glGenTextures( 1, &_texture );
		glBindTexture( GL_TEXTURE_2D, _texture );
			
			glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
			glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
			glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
			glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
			glTexImage2D( GL_TEXTURE_2D, 0, GL_RGBA, surf.w, surf.h, 0, GL_RGBA, GL_UNSIGNED_BYTE, cast(const(void)*)surf.pixels);
		glBindTexture( GL_TEXTURE_2D, 0);
		this.width =surf.w; this.height =surf.h;
		this._verts[4] =width;
		this._verts[6] =width;
		this._verts[3] =height;
		this._verts[5] =height;
		
		SDL_FreeSurface( surf );
	}
private:
	string _text;
	uint _texture;
	float[8] _verts =
	[ 
		0f, 0f,
		0f, 1f,
		1f, 1f,
		1f, 0f
	];
}