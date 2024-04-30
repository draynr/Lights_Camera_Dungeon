shader_type spatial;
uniform sampler2D sprite_texture : source_color, filter_nearest;
instance uniform float begin_time;

void vertex() {

	// MODELVIEW_MATRIX = VIEW_MATRIX * mat4(vec4(normalize(cross(vec3(0.0, 1.0, 0.0), INV_VIEW_MATRIX[2].xyz)), 0.0), vec4(0.0, 1.0, 0.0, 0.0), vec4(normalize(cross(INV_VIEW_MATRIX[0].xyz, vec3(0.0, 1.0, 0.0))), 0.0), MODEL_MATRIX[3]);
	// MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
}
void fragment() {
	vec4 original_color = texture(sprite_texture, UV);
	if (original_color.a < 1.) {
		discard;
	}
    if (original_color.b > 0.7 && (original_color.r + original_color.g + original_color.b) < 1.6) {
		float delta_t = begin_time - TIME;
		ALPHA = 0.4;
		if (delta_t > 0.) {
			ALBEDO = original_color.rgb / 10. + delta_t;
		}
		else {
			ALBEDO = original_color.rgb / 10.;
		}
   	} else {
		ALBEDO = original_color.rgb;
	}
	// ALBEDO = original_color.rgb * clamp(10. - 10.*TIME, 0.1, 10.);
	//ALBEDO = original_color.rgb * clamp(0.1*begin_time, 0., 100.);
    //// ALBEDO = 0.5*original_color.rgb * clamp(1. + 0.01*abs(1. - TIME + begin_time), 0.5, 1.5);
	//// ALBEDO = vec3(1.,0.,0.);
	//ALPHA = 0.4;
}