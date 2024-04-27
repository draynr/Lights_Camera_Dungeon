shader_type canvas_item;

uniform sampler2D screen_texture: hint_screen_texture, filter_nearest, repeat_disable;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	float uvx = SCREEN_UV.x + 0.004*sin(5.*TIME + 50.*SCREEN_UV.y);
	float uvy = SCREEN_UV.y + 0.001 * sin(1.*TIME + 5.*SCREEN_UV.x);
	vec4 color = texture(screen_texture, vec2(uvx,uvy));
	// color.rgb += 0.1*sin(FRAGCOORD.x*FRAGCOORD.y*TIME);
	COLOR = color;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
