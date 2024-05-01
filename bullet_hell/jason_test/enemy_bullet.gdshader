shader_type spatial;
uniform sampler2D sprite_texture : source_color, filter_nearest;

uniform vec4 flash_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform bool active = false;
uniform float glow_strength = 1.0;

void vertex() {
    MODELVIEW_MATRIX = VIEW_MATRIX * mat4(
        vec4(normalize(cross(vec3(0.0, 1.0, 0.0), INV_VIEW_MATRIX[2].xyz)), 0.0),
        vec4(0.0, 1.0, 0.0, 0.0),
        vec4(normalize(cross(INV_VIEW_MATRIX[0].xyz, vec3(0.0, 1.0, 0.0))), 0.0),
        MODEL_MATRIX[3]
    );
    MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
}

void fragment() {
    vec4 original_color = texture(sprite_texture, UV);
    if (original_color.a < 0.5) {
        discard;
    }
    
    vec3 glow_color = active ? flash_color.rgb : original_color.rgb;
    vec3 final_color = glow_color * glow_strength;
    
    ALBEDO = final_color;
    ALPHA = active ? flash_color.a : original_color.a;
    EMISSION = final_color * glow_strength;
}