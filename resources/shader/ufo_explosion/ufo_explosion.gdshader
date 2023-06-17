// https://www.youtube.com/watch?v=Q1Z9u9bHlGI

shader_type canvas_item;

uniform vec2 fragment_number = vec2(30,30);
uniform float dissolve_state : hint_range(0.0, 1.0, 0.1) = 1;


void fragment() {
	vec2 pixelFract = fract(UV * fragment_number);
	float pixelDist = distance(pixelFract, vec2(0.5,0.5));
	COLOR = texture(TEXTURE, UV);
	COLOR.a *= step(pixelDist, dissolve_state);
}