shader_type canvas_item;

uniform bool active = false;
uniform vec3 outline_color : source_color = vec3(1.0, 1.0, 1.0);
void fragment() {
	vec4 sprite_color = texture(TEXTURE, UV);
	vec4 outline = vec4(outline_color, sprite_color.a);
	vec4 new_color = sprite_color;
	if (active == true){
		new_color = outline;
	}
	COLOR = new_color;
}