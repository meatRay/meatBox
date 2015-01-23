module meat.mouse;

class Mouse
{
public:
	int x() const @property
		{ return this._x;}
	int y() const @property
		{ return this._y;}
	void update( int x, int y)
	{
		this._x =x; this._y =y;
	}
private:
	int _x, _y;
}