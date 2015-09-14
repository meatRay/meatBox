# This repository is Unmaintained.

# meatBox
OpenGL /SDL2 container

Not really fit for public consumption, but try ahead if you wish.
Designed to encapsulate and ease the fun of simple rendering, without all that mucking about in hyperspace. Aims to be lightweight, and modular.

# Usage

meatBox has a handful of different modules, and I'll try to keep updated documentation in the doc folder, and also I should probably host that folder somewhere.

If you want to make something work off the bat, `window`.d is the home-block of the set. When you inialize a `Window`, it will reserve a GPU context, create a window, hook it to openGL and create multithreading rendering and updating.
You can either create delegates to the window's `onRender`, `onUpdate`, ect; or the cleaner way, and create your own class that inherits and `override`s the `render` and jazz. Currently you will need to set up your own matrices, but I'm working on that.

From there, I have some data blocks like Keyboard, Camera, and Mouse which should initialize themselves on their own. Works in progress, including tihs terrible readme!
