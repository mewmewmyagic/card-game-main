class_name Card
extends Resource

@export var card_name: String = ""
@export var stamina_cost: int = 0
@export var recovery_cost: int = 0
@export var effects: Array[CardEffect] = []

func _to_string() -> String:
	return "%s (%d)" % [card_name, stamina_cost]
