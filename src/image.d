module meat.image;

import derelict.opengl3.gl3;
import derelict.sdl2.sdl;
import derelict.sdl2.image;

static this()
	{ IMG_Init( IMG_INIT_PNG ); }
static ~this()
	{ IMG_Quit(); }

class Image
{
	public this()
		{ glGenTextures( 1, &_buffer ); }
	public this( string path )
	{
		this();
		load( path );
	}
	public ~this()
		{ glDeleteTextures( 1, &_buffer );}
	public int load( string path )
	{
		SDL_Surface* img =IMG_Load( cast(const(char)*)(path) );
		if( img is null )
			{ return 0; }
			
		glBindTexture( GL_TEXTURE_2D, _buffer );
		glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT );
		glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT );
		glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST );
		glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST );
		
		glTexImage2D( GL_TEXTURE_2D, 0, GL_RGBA, img.w, img.h, 0, GL_RGBA, GL_UNSIGNED_BYTE, cast(const(void)*)img.pixels );
		glBindTexture( GL_TEXTURE_2D, 0 );
		return 1;
	}
	static this()
	{
		
	}
private:
	static uint box;
	uint _buffer;
}