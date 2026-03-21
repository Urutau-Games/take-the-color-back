shader_type canvas_item;

uniform bool has_red = true;
uniform bool has_green = true;
uniform bool has_blue = true;

const vec3 grayscale_factors = vec3(0.299, 0.587, 0.114);

vec3 calculate_colors(vec3 colors) {
	float gray = dot(colors, grayscale_factors);
	
	return vec3(
		has_red ? colors.r : gray,
		has_green ? colors.g : gray,
		has_blue ? colors.b : gray
	);
}

void fragment() {
	COLOR.rgb = calculate_colors(COLOR.rgb);
}
