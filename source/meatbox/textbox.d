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

class Textbox
{
public:
	float x, y, width, height;
	string text() @property
		{ return this._text; }
	static this()
		{ Textbox.font =TTF_OpenFont( `\font\lucon.ttf`, 16 ); }
	static ~this()
		{ TTF_CloseFont( font ); }
	this( string text )
		{ setText( text ); }
	void setText( string text )
	{
		this._text =text;
		import std.string: toStringz;
		SDL_Surface* surf =TTF_RenderText_Solid( Textbox.font, toStringz( text ), SDL_Color(0, 0, 0, 255) );
		
		glGenTextures( 1, &_texture );
		glBindTexture( GL_TEXTURE_2D, _texture );
			
			glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
			glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
			glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
			glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
			glTexImage2D( GL_TEXTURE_2D, 0, GL_RGBA, surf.w, surf.h, 0, GL_RGBA, GL_UNSIGNED_BYTE, cast(const(void)*)surf.pixels);
		glBindTexture( GL_TEXTURE_2D, 0);
		this.width =surf.w; this.height =surf.h;
	}
private:
	static TTF_Font* font;
	string _text;
	uint _texture;
}