module meat.textbox;

import meat.window;

import derelict.freetype.ft;

static this()
	{ DerelictFT.load(); }

class Textbox
{
public:
	float x, y;
	string text;
	Font font;
}

class Font
{
public:
	this( string fontPath, uint size =16 )
	{
		{
			import std.string;
			FT_New_Face( Font.lib, toStringz(fontPath), 0, &_face );
		}
		FT_Set_Pixel_Sizes( _face, 0, size );
		for( uint i =' '; i <= '~'; ++i )
		{
			FT_Load_Char( _face, i, FT_LOAD_RENDER );
			FT_Render_Glyph( _face.glyph, FT_RENDER_MODE_NORMAL );
			
			Glyph glyph;
			glGenTextures( 1, &glyph.texture );
			glBindTexture( GL_TEXTURE_2D, glyph.texture );
			
			glPixelStorei( GL_UNPACK_ALIGNMENT, 1 );
			glTexImage2D( GL_TEXTURE_2D, 0, GL_R8, 0, GL_RED, face.glyph.bitmap.width, face.glyph.bitmap.rows, GL_UNSIGNED_BYTE, face.glyph.bitmap.buffer );
			glPixelStorei(GL_UNPACK_ALIGNMENT, 4);
			
			this._map[cast(char)i] =glyph;
		}
	}
	void print( string text )
	{
		/+ Make better in future PLEASE+/
		uint x =0;
		uint y =0;
		for( size_t i =0; i < text.length; ++i )
		{
			glBindTexture( GL_TEXTURE_2D, _map[text[i]].texture );
			glEnable( GL_TEXTURE_2D );
			glBegin( GL_QUADS );
			glTexCoord2f( 0, 0 ); glVertex2f( x, y +1 );
			glTexCoord2f( 0, 1 ); glVertex2f( x +1, y +1 );
			glTexCoord2f( 1, 1 ); glVertex2f( x +1, y );
			glTexCoord2f( 1, 0 ); glVertex2f( x, y );
			glEnd();
			glDisable( GL_TEXTURE_2D );
			++x;
		}
	}
	static this()
	{
		FT_Init_FreeType( &lib );
	}
private:
	struct Glyph
	{
		uint texture;
	}
	Glyph[char] _map;
	FT_Face _face;
	
	static FT_Library lib;
	static FT_Face face;
}