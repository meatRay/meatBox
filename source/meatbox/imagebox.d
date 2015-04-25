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
	this()
	{ 
		this.colour =Colour.white;
	}
	///
	this( string path )
	{
		this( new Image(path) );		
	}
	///
	this( Image image )
	{
		this();
		this.image = image;
		this.x =0f; this.y =0f; //Floats init to NaN; Use proper constructors.
		this.width =1f;
		this.height =1f/ image.aspect;
	}
	///
	override void render()
	{
		//glColor3ub( colour.red, colour.green, colour.blue );
		glBindTexture( GL_TEXTURE_2D, image.buffer );
		
		glPushMatrix();
		glTranslatef( x, y, 0);
		glScalef( width, height, 1f );
		glDrawArrays( GL_QUADS, 0, 4);
		glPopMatrix();	
	}
	static void render( Image image, float x, float y )
	{
		//glColor3ub( colour.red, colour.green, colour.blue );
		glBindTexture( GL_TEXTURE_2D, image.buffer );
		
		glPushMatrix();
		glTranslatef( x, y, 0);
		glScalef( 1f, image.aspect, 1f );
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
		glVertexPointer( 2, GL_FLOAT, 0, Box.vertices.ptr );
	}
	///
	static void endRender()
	{
		glDisable( GL_BLEND);
		glDisable( GL_TEXTURE_2D);
		glDisableClientState( GL_TEXTURE_COORD_ARRAY);
		glDisableClientState( GL_VERTEX_ARRAY);
	}
	static immutable float[8] vertices =
	[ 
		0f, 1f,
		1f, 1f,
		1f, 0f,
		0f, 0f
	];
}