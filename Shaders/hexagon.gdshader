shader_type canvas_item;

uniform bool pointy_top = false;       // false = flat edges on top/bottom, true = corner pointing up
uniform bool stretch_to_square = true; // true = hexagon touches all 4 sides (not regular on a square texture)

void fragment() {
    vec2 p = UV - vec2(0.5);

    if (pointy_top) {
        p = p.yx;
    }
    if (stretch_to_square) {
        p.y *= 0.8660254;
    }
    p = abs(p);

    // Hexagon equation (regular, corners touch the sides of the square):
    // |x|*cos(30) + |y|*sin(30) <= 0.433  and  |y| <= 0.433
    if (max(dot(p, vec2(0.8660254, 0.5)), p.y) > 0.4330127) {
        discard;
    }

    COLOR = texture(TEXTURE, UV);
}
