import dgrid.actor;
import dgrid.grid;
import dgrid.gamewindow;

import derelict.sdl2.sdl;
import derelict.opengl3.gl3;

import std.stdio;
import std.math;
import core.time;
import std.random;

void main()
{
	auto window =new KbWindow();
	window.grid.placeThing( new Nom(), 2, 4);
	window.grid.loadTexture( "Baddy"); /+I regret that I have but one bug to give+/
	
	window.run( 30);
}

class Nom: Thing
{
public:
	this()
	{ super();}
}

class Baddy: Actor
{
public:
	this()
	{ super();}
	override void act()
	{
		auto next =Position.add( position, direction);
		foreach( thing; grid.thingsAt( next))
		{
			if( !cast(Baddy)thing)
			{
				grid.rmvThing( thing);
				grid.placeThing( new Nom(), uniform( -7, 8), uniform( -7, 8));
				if( cast(Kobold)thing)
				{
					writeln( "OOPS YOU'RE DEAD");
				}
			}
		}
		if( !uniform( 0, 3))
		{
			if(( next.x < 10 && next.x > -10)
			&&( next.y < 10 && next.y > -10))
			{
				step();
			}
			rotate( (uniform( 0, 2))? rotateCcw: rotateCw);
		}
	}
}

class Kobold: Actor
{
private:
	Position _tp;
public:
	uint food;
	this()
	{ super();}
	void setTarget( Position pos)
	{
		this._tp =pos;
	}
	override void act()
	{
		if( this.position.x != _tp.x)
		{
			this.position.x +=sgn( _tp.x -position.x);
		}
		else if( this.position.y != _tp.y)
		{
			this.position.y +=sgn( _tp.y -position.y);
		}
		Thing et =null;
		foreach( thing; grid.thingsAt(position))
		{
			if( cast(Nom)thing)
			{
				et =thing;
				++food;
				writefln( "\"Nomnomnom! I've eaten %d nom%s.\"", food, ((food>1)?"s":""));
				break;
			}
		}
		if( et)
			{
				grid.rmvThing( et);
				grid.placeThing( new Nom(), uniform( -7, 8), uniform( -7, 8));
				Baddy bad =new Baddy();
				bad.direction =uniform!Direction();
				grid.placeThing( bad, uniform( -7, 8), uniform( -7, 8));
			}
	}
}

class KbWindow: GameWindow
{
private:
	Kobold _kobold;
protected:
	float _pixp, _piyp;
	override void load()
	{
		super.load();
		glClearColor( 0.9f, 0.9f, 0.9f, 1f);
		this._pixp =(this.width/20);
		this._piyp =(this.height /(20 /aspectRatio));
	}
	override void resize()
	{
		super.resize();
		this._pixp =(this.width/20);
		this._piyp =(this.height /(20 /aspectRatio));
	}
	override void processEvent( SDL_Event evnt)
	{
		super.processEvent( evnt);
		if( evnt.type == SDL_MOUSEBUTTONDOWN && evnt.button.button == SDL_BUTTON_LEFT)
		{
			auto pos =Position( cast(int)floor(((mouse.x -(width/2)) +(camera.x *_pixp)) /_pixp),
			-cast(int)ceil(((mouse.y -(height/2)) -(camera.y *_piyp)) /_piyp));
			writefln( "%d, %d", pos.x, pos.y);
			this._kobold.setTarget( pos);
		}
	}
public:
	this()
	{
		super( "Kobolds", 200, 100, 600, 450);
		this._kobold =new Kobold();
		this.grid =new Grid();
		this.grid.ticktime =dur!"msecs"(500);
		this.grid.placeThing( _kobold, 0, 0);
	}
}