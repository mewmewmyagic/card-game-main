extends Button
class_name SkipRoundButton

var parent: Combatant

func bind(c: Combatant) -> void:
	parent = c
	
func _on_button_pressed() -> void:
	if parent.is_current_turn:
		parent.discard_hand()
		parent.battle_state.turn_manager.end_turn(0)
