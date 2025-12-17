shader_type spatial;

void vertex() {
	//VERTEX.y += sin(VERTEX.x * 4.0 + TIME *2.0) * 0.2;
	//VERTEX.x += sin(VERTEX.x *4.0 + TIME *2.0) * 0.2;
	VERTEX.z += sin(VERTEX.x * 4.0 + TIME);
}

void fragment() {
	// 金属管
	ALBEDO = vec3(0.8, 0.7, 0.2); // 黄土色
	METALLIC = 1.0; // 金属の反射
	ROUGHNESS = 0.1; // 表面のザラザラ館
	
	//　ノーマル、光の当たり方を変化
	//NORMAL = NORMAL + vec3(0.0, 0.0, 0.5);
	//ALBEDO = vec3(0.6, 0.6, 0.1);
	
	//時間で色が変化
	//float brightness = abs(sin(TIME));
	//ALBEDO = vec3(brightness, 0.2, 1.0 - brightness);
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
