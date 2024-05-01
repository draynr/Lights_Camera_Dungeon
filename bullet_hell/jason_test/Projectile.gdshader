shader_type spatial;
uniform sampler2D sprite_texture : source_color, filter_nearest;


uniform vec4 flash_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform bool active = false;
uniform float glow_strength = 1.0;
// const float PI = 3.14159265358979323846;
// varying 

// void vertex() {
// 	// Called for every vertex the material is visible on.
// 	return;
// }

void fragment() {
	vec4 color = texture(sprite_texture, UV);
	// float r = float(int(TIME * 100.) % 255) / 255.;
	// float g = float((int(TIME * 100.)+85) % 255) / 255.;
	// float b = float((int(TIME * 100.)+170) % 255) / 255.;
	// float xxx = sin(TIME*100. + PI / 3.);
	float r = sin(TIME + PI / 3.) / 2. + 0.5;
	float g = sin(TIME + 2. * PI / 3.) / 2. + 0.5;
	float b = sin(TIME) / 2. + 0.5;
	vec3 addcol = vec3(r, g, b);
	ALBEDO = color.rgb + addcol;
	ALPHA = color.a;
	EMISSION = ALBEDO* glow_strength;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
