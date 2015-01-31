module meatbox.imagebox;

import meatbox.box;

import derelict.opengl3.gl;
import derelict.opengl3.gl3;
import derelict.sdl2.sdl;
import derelict.sdl2.image;

static this()
{ 
	DerelictSDL2Image.load();
	IMG_Init( IMG_INIT_PNG );
}
static ~this()
	{ IMG_Quit(); }

class Imagebox: Box
{
public:
	void width( int width ) @property
	{
		this._verts[4] =width;
		this._verts[6] =width;
		super.width =width;
	}
	int width() const @property{ return super.width; }
	void height( int height ) @property
	{
		this._verts[3] =height;
		this._verts[5] =height;
		super.height =height;
	}
	int height() const @property{ return super.height; }
	this()
	{ 
		glGenTextures( 1, &_buffer );
	}
	this( string path )
	{
		this();
		load( path );
	}
	~this()
		{ glDeleteTextures( 1, &_buffer );}
	/+ Returns if it loaded properly because why not+/
	bool load( string path )
	{
		SDL_Surface* img =IMG_Load( cast(const(char)*)(path) );
		if( img is null )
		{ 
			return false; 
		}
			
		glBindTexture( GL_TEXTURE_2D, _buffer );
		glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT );
		glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT );
		glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST );
		glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST );
		
		this.width =img.w; this.height =img.h;
		glTexImage2D( GL_TEXTURE_2D, 0, GL_RGBA, img.w, img.h, 0, GL_RGBA, GL_UNSIGNED_BYTE, cast(const(void)*)img.pixels );
		glBindTexture( GL_TEXTURE_2D, 0 );
		SDL_FreeSurface( img );
		return true;
	}
	void render()
	{
		glVertexPointer( 2, GL_FLOAT, 0, _verts.ptr );	
		glBindTexture( GL_TEXTURE_2D, _buffer );
		
		glPushMatrix();
		glTranslatef( x, y, 0);
		glDrawArrays( GL_QUADS, 0, 4);
		glPopMatrix();	
	}
	static this()
	{
		//Preload box vectors into GPU memory.
		//Stick into base Box class?
	}
	static void startRender()
	{
		glEnableClientState( GL_VERTEX_ARRAY );
		glEnableClientState( GL_TEXTURE_COORD_ARRAY );
		glEnable( GL_TEXTURE_2D );
		glEnable( GL_BLEND );
		glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA );	
		glColor4f( 1f, 1f, 1f, 1f );
		glTexCoordPointer( 2, GL_FLOAT, 0, Imagebox.texbox.ptr );	
	}
	static void endRender()
	{
		glDisable( GL_BLEND);
		glDisable( GL_TEXTURE_2D);
		glDisableClientState( GL_TEXTURE_COORD_ARRAY);
		glDisableClientState( GL_VERTEX_ARRAY);
	}
private:
	static immutable float[8] texbox =
	[ 
		0f, 0f,
		0f, 1f,
		1f, 1f,
		1f, 0f
	];
	uint _buffer;
	float[8] _verts =
	[ 
		0f, 0f,
		0f, 1f,
		1f, 1f,
		1f, 0f
	];
}