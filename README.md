# foliage-shader

Unity surface shader for leaves/pine needles (on alpha cutout textures).

![Foliage Shader](FoliageShader.gif)

Conceptually very simple; use alpha `_Cutoff` in combination with the built-in shadow map to control how much of the light is transmitted through the foliage (an additional alpha offset is added to control the rendered alpha cutoff): 

![Light Transmission](LightTransmission.gif)

To break up uniformity (specially needed for areas that are completely lit or completely shadowed), I used the classic `dot(sunWorldDir, normal)` and a bunch of tweaking parameters, for example `Lambert90deg` and `Lambert180deg`, which allows for control of the "shine though" lighting gain for 90 degrees and 180 degrees.

Trees are CC0 and were created by ALTER'49, for the full set, and also with higher polycounts: [PRO Forest Bundle](https://gumroad.com/l/proforestpack)
