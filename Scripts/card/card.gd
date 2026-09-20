class_name Card
extends Resource

enum TargetType {ENEMY, ALLY, SELF, ALL_ENEMY, RANDOM_ENEMY}

@export var card_name: String = ""
@export var stamina_cost: int = 0
@export var recovery_cost: int = 0
@export var effects: Array[CardEffect] = []
@export var target_type: TargetType
@export var card_art: Texture2D

func _to_string() -> String:
	return "%s (%d) (%d)" % [card_name, stamina_cost, recovery_cost]
