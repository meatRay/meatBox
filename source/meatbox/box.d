module meatbox.box;

import meatbox.colour;

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
		0f, 1f,
		1f, 1f,
		1f, 0f
	];
private:
}