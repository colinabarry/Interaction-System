shader_type spatial;

uniform sampler2D albedo;
uniform sampler2D heightmap;
uniform float height_multiplier = 1.0;

void fragment() {
	ALBEDO = texture(albedo, UV).rgb;
}

void vertex() {
	VERTEX.y += texture(heightmap, UV).r * height_multiplier;
}
