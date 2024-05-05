shader_type canvas_item;

uniform float speed = 1;
uniform vec4 mixColor = vec4(0);
uniform float minAlphaChannel = 0.0;
uniform bool Vertical = true;

void fragment()
{
    vec4 c = texture(TEXTURE,UV); 
    if(c.a > minAlphaChannel){
        float coord = UV.y;
		
        if(!Vertical) coord = UV.x;
        float lerp_pos = clamp(cos(TIME * speed - coord),0,1);
        c = mix(c,mixColor,lerp_pos);
    }
    COLOR = c;
}