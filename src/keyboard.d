/++Authors: meatRay+/
module meat.keyboard;

import derelict.sdl2.sdl;

/++Duplicates of SDL_Scancodes. Alias?+/
public enum Key{ A =4, B =5, C =6, D =7, E =8, F =9, G =10, H =11, I =12, J =13, K =14,
L =15, M =16, N =17, O =18, P =19, Q =20, R =21, S =22, T =23, U =24, V =25,
W =26, X =27, Y =28, Z =29 }

/++
+ Stores a pointer into SDL's keyboard data,
+ and provides methods to read it.
+/
public class Keyboard
{
private:
	const ubyte* _keyptr;
package:
	this()
	{
		this._keyptr =SDL_GetKeyboardState(null);
	}
public:
	/++ Checks if key is pressed.+/
	bool keyDown( SDL_Scancode key ) const
		{ return this._keyptr[key] == 1; }
}