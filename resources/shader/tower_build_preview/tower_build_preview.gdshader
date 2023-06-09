shader_type canvas_item;

uniform bool enabled = true;
uniform vec4 highlight_color: source_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
	if (enabled == false) {
		COLOR = COLOR;
	} else {
		vec4 sprite_color = texture(TEXTURE, UV);
		COLOR = mix(sprite_color, highlight_color, highlight_color.a);
	}
}
