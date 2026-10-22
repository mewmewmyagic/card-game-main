extends Button
class_name SkipRoundButton

@export var hold_time: float = 0.75

var parent: Combatant
var battle: BattleState
@onready var hold_timer: Timer = $HoldTimer
@onready var prog_bar: TextureProgressBar = $HoldProgressBar

func bind(c: Combatant) -> void:
	parent = c

func _ready() -> void:
	hold_timer.wait_time = hold_time
	prog_bar.hide()

	button_down.connect(_on_button_down)
	button_up.connect(_on_button_up)
	hold_timer.timeout.connect(_on_hold_complete)
	
func _process(_delta: float) -> void:
	if not hold_timer.is_stopped():
		prog_bar.global_position = get_global_mouse_position() - prog_bar.size/2.0
		var progress = 1.0 - hold_timer.time_left/hold_timer.wait_time
		prog_bar.value = progress * 100

func _on_button_down() -> void:
	if parent and parent.is_playing:
		prog_bar.value = 0;
		prog_bar.show()
		hold_timer.start()


func _on_button_up() -> void:
	hold_timer.stop()
	prog_bar.hide()


func _on_hold_complete() -> void:
	prog_bar.hide()
	if parent:
		parent.discard_hand()
		parent.battle_state.turn_manager.output_phase()
		parent.play_other_animation()
