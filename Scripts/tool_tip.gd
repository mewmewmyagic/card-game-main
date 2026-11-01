extends PanelContainer

const offset := Vector2.ONE * 30
var opacity_tween: Tween

func _ready() -> void:
	toggle(false)

func _input(event: InputEvent) -> void:
	if visible and event is InputEventMouseMotion:
		global_position = get_global_mouse_position() + offset
		
func toggle(on: bool) -> void:
	if on:
		show()
		modulate.a = 0.0
		tween_opacity(1.0)
	else:
		modulate.a = 1.0
		await tween_opacity(0.0).finished
		hide()
		
func tween_opacity(to: float) -> Tween:
	if opacity_tween:
		opacity_tween.kill()
		
	opacity_tween = get_tree().create_tween()
	opacity_tween.tween_property(self, 'modulate', to, 0.3)
	return opacity_tween
