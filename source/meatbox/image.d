module meatbox.image;

import derelict.opengl3.gl;
import derelict.opengl3.gl3;
import derelict.sdl2.sdl;
import derelict.sdl2.image;

class Image
{
public:
	this()
	{ 
		glGenTextures( 1, &buffer );
	}
	///
	this( string path )
	{
		this();
		load( path );
	}
	~this()
		{ glDeleteTextures( 1, &buffer );}
	///Returns: if it loaded properly because why not
	bool load( string path )
	{
		SDL_Surface* img =IMG_Load( cast(const(char)*)(path) );
		if( img is null )
		{ 
			return false; 
		}
			
		glBindTexture( GL_TEXTURE_2D, buffer );
		glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT );
		glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT );
		glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST );
		glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST );
		
		this._aspect =cast(float)img.w /img.h;
		glTexImage2D( GL_TEXTURE_2D, 0, GL_RGBA, img.w, img.h, 0, GL_RGBA, GL_UNSIGNED_BYTE, cast(const(void)*)img.pixels );
		glBindTexture( GL_TEXTURE_2D, 0 );
		SDL_FreeSurface( img );
		return true;
	}
	uint buffer;
	float aspect() const @property { return this._aspect; }
private:
	float _aspect;
}