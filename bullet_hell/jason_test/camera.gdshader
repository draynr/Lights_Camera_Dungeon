shader_type spatial;

uniform float ring_thickness = 0.1;

void fragment() {
    float dist = distance(UV, vec2(0.5));
    float ring = smoothstep(0.5 - ring_thickness, 0.5, dist) - smoothstep(0.5, 0.5 + ring_thickness, dist);
    ALPHA = ring;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
