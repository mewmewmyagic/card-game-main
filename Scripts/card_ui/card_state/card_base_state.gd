extends CardState

func enter() -> void:
	if not card_ui.is_node_ready():
		await card_ui.ready
		
	card_ui.color.color = Color.SEA_GREEN
	card_ui.stam_label.text = "%s" % [card_ui.card.stamina_cost]
	card_ui.rc_label.text = "%s" % [card_ui.card.recovery_cost]
	card_ui.name_label.text = "%s" % [card_ui.card.card_name]
	card_ui.pivot_offset = Vector2.ZERO
		
func on_mouse_entered() -> void:
	if CardState.any_card_dragging or not card_ui.playable:
		return
	transition_requested.emit(self, CardState.State.HOVER)
