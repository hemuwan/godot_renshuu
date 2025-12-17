shader_type spatial;

uniform sampler2D albedo_tex;
uniform float scroll_speed = 1.0;

void vertex() {
}

void fragment() {
	vec2 uv = UV;
	uv.y += TIME * scroll_speed;
	ALBEDO = texture(albedo_tex, uv).rgb;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
