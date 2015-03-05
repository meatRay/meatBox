/++Authors: meatRay+/
module meatbox.window;

public import derelict.opengl3.gl;
public import derelict.opengl3.gl3;
import derelict.sdl2.sdl;
import core.thread;

import meatbox.keyboard;
import meatbox.mouse;

static this()
{
	DerelictGL3.load();
	DerelictGL.load();
	DerelictSDL2.load();
}

/++ Encapsulates state-based OpenGL and SDL2 into something much more friendly.+/
public class Window
{
private:
	SDL_Window* _window;
	SDL_GLContext _context;
	SDL_Event _wndwEvnt;
	Thread _updateThread;
	Keyboard _keyboard;
	bool _running;
	int _width, _height;
	uint _mspf =16, _mspu =16;
	
	void setSize( int width, int height )
	{
		this._width =width;
		this._height =height;
	}
	void runUpdate()
	{
		while( this._running )
		{
			this.update();
			Thread.sleep( dur!("msecs")( _mspu ) );
		}
	}
	
protected:
	/++ Returns: Renders made each second.+/
	uint framesPerSecond() @property const
		{ return 1000 /_mspf; }
	/++ Returns: Updates made each second.+/
	uint updatesPerSecond() @property const
		{ return 1000 /_mspu; }
	/++ Override to specify update behaviour. 
	+ Called by the Worker-thread to run non-visual updates.+/
	void update()
		{ this.onUpdate(); }
	/++
	+ Override to specify Render behaviour. 
	+ Called once for each frame per second.
	+/
	void render()
		{ this.onRender(); }
	/++ Override to specify loading behaviour.+/
	void load()
		{ this.onLoad(); }
	/++ Override to specify resizing behaviour.+/
	void resize()
		{ this.onResize(); }
	/++ Override to specify unique actions on SDL events.+/
	void processEvent( SDL_Event event )
		{}
		
public:
	/++ Returns: Reference to keyboard state.+/
	Keyboard keyboard() @property
		{ return this._keyboard; }
	/++ Returns: Window width in pixels+/
	int width() @property const
		{ return this._width; }
	/++ Returns: Window height in pixels+/
	int height() @property const
		{ return this._height; }
	///
	float aspectRatio() @property const
		{ return cast(float)this._width /_height; }
	/++ Halt running.+/
	void quit()
		{ this._running = false; }
	///
	void run( ubyte fps, ubyte ups )
	{
		this._mspu =1000 /ups;
		this._mspf =1000 /fps;
		run();
	}
	///
	void run( ubyte fps )
	{
		run( fps, fps);
	}
	///
	void run()
	{
		this.load();
		_running = true;
		
		_updateThread = new Thread( &runUpdate );
		_updateThread.start();
		
		while( _running)
		{
			while( SDL_PollEvent( &_wndwEvnt ) == 1)
			{
				switch ( _wndwEvnt.type )
				{
					case( SDL_WINDOWEVENT ):
						if( _wndwEvnt.window.event == SDL_WINDOWEVENT_RESIZED )
						{
							this.setSize( _wndwEvnt.window.data1, _wndwEvnt.window.data2 );
							this.resize();
						}
						break;
					case( SDL_QUIT ):
						this._running = false;
						break;
					default:
						processEvent( _wndwEvnt );
						break;
				}
			}
			render();
			SDL_GL_SwapWindow( _window );
			Thread.sleep( dur!("msecs")( _mspf ) );
		}
		//if( _updateThread.isRunning )
		//	{ _updateThread.join(); }
	}
	///
	void delegate() onUpdate, onRender, onLoad, onResize;
	///
	this( string title, int x, int y, int width, int height )
	{
		SDL_Init( SDL_INIT_VIDEO );

		SDL_GL_SetAttribute( SDL_GL_DOUBLEBUFFER, 1 );
		SDL_GL_SetAttribute( SDL_GL_DEPTH_SIZE, 24 );
		
		import std.string: toStringz;
		this._window =SDL_CreateWindow( toStringz(title), x, y, width, height, SDL_WINDOW_OPENGL | SDL_WINDOW_SHOWN | SDL_WINDOW_RESIZABLE );
		this._context =SDL_GL_CreateContext( _window );
		this._keyboard =new Keyboard();
		
		setSize( width, height );
		onUpdate =onRender =onLoad =(){};
		
		scope( failure )
			{ destroy( this ); }
		scope( success )
		{
			DerelictGL3.reload();
			DerelictGL.reload();
		}
	}
	~this()
	{
		SDL_GL_DeleteContext( _context );
		SDL_DestroyWindow( _window );
		SDL_Quit();
	}	
}