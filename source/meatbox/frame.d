module meatbox.frame;

import meatbox.window;

class Frame
{
private:
	RenderContext _renderContext;
public:
	RenderContext renderContext() @property
		{ return this._renderContext; }
	void renderContext( RenderContext intext ) @property
	{
		this._renderContext =intext;
		
		//Requires context to know its own size.
		//intext();
	}
	//Set up Render enviroment,
	//Store IRenderable objects
}

interface IRenderable
{
	//Render
}

/++Turn into class
+ -Store Modelmatrix info
+ -Turn into full "renderer"
+/
alias RenderContext =void function( int, int );
static RenderContext TwoDRender =(int width, int height)
{
	glViewport( 0, 0, width, height);
	glMatrixMode( GL_PROJECTION);
	glLoadIdentity();
	glOrtho(0f, 1f, 0f, cast(float)height /width, -1f, 1f);
	glMatrixMode( GL_MODELVIEW);
};