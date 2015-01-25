/++Authors: meatRay+/
module meatbox.camera;

/++
+ Stores translations and velocities.
+/
class Camera
{
public:
	/++Velocity to increment the x position by.+/
	float velx =0f;
	/++Velocity to increment the y position by.+/
	float vely =0f;
	/++X position.+/
	float x =0f;
	/++Y position.+/
	float y =0f;
	
	/++Increment position by velocity.+/
	void update()
	{
		this.x +=velx;
		this.y +=vely;
	}
}