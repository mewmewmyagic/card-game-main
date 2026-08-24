extends CardState
func enter() -> void:
	if not card_ui.is_node_ready():
		await card_ui.ready
		
	card_ui.color.color = Color.SEA_GREEN
	card_ui.state.text = "%s %s" % [card_ui.card.card_name, card_ui.card.stamina_cost]
	card_ui.pivot_offset = Vector2.ZERO

	var hand := card_ui.get_parent() as TheHand
	if hand:
		hand._update_layout()

		
func on_mouse_entered() -> void:
	if CardState.any_card_dragging or not card_ui.playable:
		return
	#if card_ui.animator.is_animating:
		#return
	transition_requested.emit(self, CardState.State.HOVER)
