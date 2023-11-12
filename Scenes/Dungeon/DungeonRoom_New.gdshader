shader_type canvas_item;
uniform vec2 player_position = vec2(0.5, 0.5);
uniform vec4 color = vec4(0.305, 0.298, 0.341,1);
uniform sampler2D screen_tex : hint_screen_texture;
uniform float MULTIPLIER = 0.56;
uniform float SCALE = 0.5;
uniform float SOFTNESS = 0.45;

void fragment(){
	vec2 screen_uv = SCREEN_UV;
	screen_uv -= 0.5;
	float val = distance(vec2(screen_uv.x , screen_uv.y * MULTIPLIER), vec2(screen_uv.x/8.0 ,screen_uv.y/8.0  * MULTIPLIER));
	val = val / SCALE;
	float vignette = smoothstep(0.0, SOFTNESS, val);
	vec4 screen_color = texture(screen_tex, SCREEN_UV);
	screen_color -= 0.5;
	//COLOR = vec4(screen_uv, 0, 1);
	COLOR = vec4(screen_color.rgb , vignette );
}