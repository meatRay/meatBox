module meatbox.imagebox;

import meatbox.box;
import meatbox.colour;
import meatbox.image;

//Don't need all these. Remove some?
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

///
class Imagebox: Box
{
public:
	Image image;
	///
	void width( int width ) @property
	{
		this._verts[4] =width;
		this._verts[6] =width;
		super.width =width;
	}
	///
	int width() const @property{ return super.width; }
	///
	void height( int height ) @property
	{
		this._verts[3] =height;
		this._verts[5] =height;
		super.height =height;
	}
	///
	int height() const @property{ return super.height; }
	///
	this()
	{ 
		this.colour =Colour.white;
	}
	///
	this( string path )
	{
		this();
		this.image = new Image( path );
	}
	this( Image image )
	{
		this();
		this.image = image;
	}
	///
	void render()
	{
		//glColor3ub( colour.red, colour.green, colour.blue );
		glVertexPointer( 2, GL_FLOAT, 0, _verts.ptr );	
		glBindTexture( GL_TEXTURE_2D, image.buffer );
		
		glPushMatrix();
		glTranslatef( x, y, 0);
		glDrawArrays( GL_QUADS, 0, 4);
		glPopMatrix();	
	}
	static void render( Image image, float x, float y )
	{
		//Please stop me.
		glVertexPointer( 2, GL_FLOAT, 0, [ 
		0f, 0f,
		0f, 1f,
		1f, 1f,
		1f, 0f
	].ptr );	
		glBindTexture( GL_TEXTURE_2D, image.buffer );
		
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
	///
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
	///
	static void endRender()
	{
		glDisable( GL_BLEND);
		glDisable( GL_TEXTURE_2D);
		glDisableClientState( GL_TEXTURE_COORD_ARRAY);
		glDisableClientState( GL_VERTEX_ARRAY);
	}
private:
	float[8] _verts =
	[ 
		0f, 0f,
		0f, 1f,
		1f, 1f,
		1f, 0f
	];
}