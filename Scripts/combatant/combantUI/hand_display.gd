extends HBoxContainer
class_name HandDisplay

@export var parent: Combatant
@export var card_ui_scene: PackedScene

#temporary
func spawn_icon(card: Card) -> void:
	var icon := card_ui_scene.instantiate() as HandDisplayIcon
	icon.card = card
	icon.owner_combatant = parent
	add_child(icon)

func refresh_display(_amount: int) -> void:
	for child in get_children():
		child.queue_free()
	
	for card in parent.hand_pile.cards:
		spawn_icon(card)
