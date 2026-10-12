extends GridContainer
class_name SkillContainer

@export var parent: Combatant
@export var card_ui_scene: PackedScene

#temporary
func refresh_display(_amount: int) -> void:
	for child in get_children():
		child.queue_free()
	for card in parent.hand_pile.cards:
		var card_ui := card_ui_scene.instantiate() as HandDisplay
		card_ui.card = card
		card_ui.owner_combatant = parent
		add_child(card_ui)
