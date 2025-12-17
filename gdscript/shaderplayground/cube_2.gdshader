shader_type spatial;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float r = abs(sin(TIME));
	float g = abs(sin(TIME) + 1.0);
	float b = abs(sin(TIME) + 2.0);
	ALBEDO = vec3(r, g, b);
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
