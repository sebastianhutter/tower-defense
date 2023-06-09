shader_type canvas_item;

uniform vec4 flash_color: source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float lerp_percent : hint_range(0.0, 1.0);

void fragment() {
	//vec4 texture_color = textureLod(card_texture, SCREEN_UV, 0.0);
	vec4 flash = mix(COLOR, vec4(flash_color.rgb, COLOR.a), lerp_percent);
	COLOR = flash;
}
