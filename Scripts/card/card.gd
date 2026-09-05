class_name Card
extends Resource

enum TargetType {ENEMY, ALLY, SELF, ALL_ENEMY, RANDOM_ENEMY}

@export var card_name: String = ""
@export var stamina_cost: int = 0
@export var recovery_cost: int = 0
@export var effects: Array[CardEffect] = []
@export var target_type: TargetType


func _to_string() -> String:
	return "%s (%d)" % [card_name, stamina_cost]
