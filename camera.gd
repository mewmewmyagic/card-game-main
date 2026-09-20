extends Camera2D

var dragging: bool = false

func _ready():
	#make_current()
	limit_left = -1000
	limit_right = 1000
	limit_top = -600
	limit_bottom = 600

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_MIDDLE:
		dragging = event.pressed

	if event is InputEventMouseMotion and dragging:
		position -= event.relative * zoom
