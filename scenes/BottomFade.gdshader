shader_type canvas_item;

void fragment() {
    float alpha = UV.y; // 0 at top, 1 at bottom
    COLOR = vec4(0.0, 0.0, 0.0, alpha);
}