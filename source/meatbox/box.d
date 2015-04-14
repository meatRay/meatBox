module meatbox.box;

import meatbox.colour;

import derelict.opengl3.gl;

class Box
{
public:	
	alias color =colour;
	Colour colour;
	int x, y, width, height;
	this( int x, int y, int width, int height )
	{
		this.x =x; this.y =y;
		this.width =width; this.height =height;
	}
	this()
	{}
	static immutable float[8] vertices =
	[ 
		0f, 0f,
		1f, 0f,
		1f, 1f,
		0f, 1f
	];
	void render()
	{
		//glColor3ub( colour.red, colour.green, colour.blue );
		
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
		glEnable( GL_BLEND );
		glBlendFunc( GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA );	
		glColor4f( 1f, 1f, 1f, 1f );
		glVertexPointer( 2, GL_FLOAT, 0, Box.vertices.ptr );		
	}
	///
	static void endRender()
	{
		glDisable( GL_BLEND );
		glDisableClientState( GL_VERTEX_ARRAY );
	}
private:
}