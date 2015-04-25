depreciated( "Imagemapping does not comply with meatBox standards; If needed, be sure to resize width to ~1." ) module meatbox.textbox;

import meatbox.window;
import meatbox.colour;
import meatbox.box;

import derelict.sdl2.ttf;
import derelict.sdl2.sdl;

static this()
{ 
	DerelictSDL2ttf.load();
	TTF_Init(); 
}
static ~this()
	{ TTF_Quit(); }

alias Font =TTF_Font*;
alias openFont =TTF_OpenFont;

//This entire file is festering with evil. Beware.
class Textbox: Box
{
public:
	TTF_Font* font;
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
	override void render()
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
		if( text == "" )
		{ text = " "; }
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
	static void startRender()
	{
		glEnableClientState( GL_VERTEX_ARRAY );
		glEnableClientState( GL_TEXTURE_COORD_ARRAY );
		glEnable( GL_TEXTURE_2D );
		glEnable( GL_BLEND );
		glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA );	
		glColor4f( 1f, 1f, 1f, 1f );
		glTexCoordPointer( 2, GL_FLOAT, 0, Box.vertices.ptr );	
	}
	static void endRender()
	{
		glDisable( GL_BLEND);
		glDisable( GL_TEXTURE_2D);
		glDisableClientState( GL_TEXTURE_COORD_ARRAY);
		glDisableClientState( GL_VERTEX_ARRAY);
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