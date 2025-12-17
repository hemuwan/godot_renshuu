shader_type spatial;

void vertex() {
	// 波打つ表面
	VERTEX.y += sin(VERTEX.x * 4.0 + TIME * 2.0);
}

void fragment() {
	// 位置により色が変化
	float gradient = NODE_POSITION_WORLD.x * 0.1; // x位置で変化
	gradient = clamp(gradient, 0.0, 1.0); // gradient の範囲を 0.0 - 1.0 で制限
	ALBEDO = vec3(gradient, 0.0, 1.0 - gradient); // 青、紫のグラデーション	
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
