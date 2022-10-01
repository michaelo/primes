Primes!
=============

Math-oriented puzzle game for (primarily) handheld devices.

Scope:
--------
* Utilize old assets
* Recreate original gameplay - i.e. no animations in-game, but will keep it in mind and try to accomodate for it
* Use zig and SDL2 (SDL2, SDL2_image, SDL2_ttf, ...)

Targets:
--------
* "desktop" for development, but primarily iOS for release. Then Android.

Repository structure:
--------
* core/: core gameplay and rendering logics
* desktop/: wraps core and makes it runnable as a native executable
* ios/: wraps core and makes it runnable as an iOS application

Design:
-------
...
