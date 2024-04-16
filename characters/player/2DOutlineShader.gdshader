shader_type canvas_item;

uniform vec3 outline_color : source_color = vec3(1.0, 1.0, 1.0);
uniform float outline_size: hint_range(0.011, 1.0) = 1.0;

void fragment() {
	vec4 sprite_color = texture(TEXTURE, UV);
	vec4 outline = vec4(outline_color, sprite_color.a);
	float aplha_threshold = step(sprite_color.a, 1.0 - outline_size) - step(sprite_color.a, 1.0);
	vec4 final_color = mix(sprite_color, outline, aplha_threshold);
	COLOR = final_color;
}
