shader_type canvas_item;

uniform bool grayscale = true;

void fragment() {
	vec4 input_color = texture(TEXTURE, UV);
	float color_average = (input_color.r + input_color.g + input_color.b) / 3.0;
	vec4 grayscale_color = vec4(color_average, color_average, color_average, input_color.a);
	if (grayscale) {
		COLOR = grayscale_color;
	} else {
		COLOR = input_color;
	}
}
