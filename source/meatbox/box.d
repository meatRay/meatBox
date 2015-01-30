module meatbox.box;

class Box
{
public:
	int x() @property{ return this._x; }
	int y() @property{ return this._y; }
	int width() @property{ return this._width; }
	int height() @property{ return this._height; }
	void x( int x ) @property{ this._x =x; }
	void y( int y) @property{ this._y =y; }
	void width( int width ) @property{ this._width =width; }
	void height( int height ) @property{ this._height =height; }
	this( int x, int y, int width, int height )
	{
		this.x =x; this.y =y;
		this.width =width; this.height =height;
	}
	this()
	{}
private:
	int _x, _y, _width, _height;
}