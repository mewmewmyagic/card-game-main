shader_type canvas_item;

void fragment() {
    vec2 p = UV - vec2(0.5);

    // Diamond equation:
    // |x| + |y| <= 0.5
    if (abs(p.x) + abs(p.y) > 0.5) {
        discard;
    }

    COLOR = texture(TEXTURE, UV);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
