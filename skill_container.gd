extends GridContainer
class_name SkillContainer

@export var parent: Combatant
@export var card_ui_scene: PackedScene
# Called when the node enters the scene tree for the first time.
func refresh() -> void:
	for child in get_children():
		child.queue_free()
	for card in parent.hand_pile.cards:
		print(card.card_name)
		var card_ui := card_ui_scene.instantiate() as CardUI
		card_ui.card = card
		card_ui.owner_combatant = parent
		add_child(card_ui)
