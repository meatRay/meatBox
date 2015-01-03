module meat.mouse;

class Mouse
{
public:
	int x() const @property
		{ return this._x;}
	int y() const @property
		{ return this._y;}
private:
	int _x, _y;
}