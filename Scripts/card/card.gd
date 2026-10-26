class_name Card
extends Resource


enum TargetType {
	ENEMY,
	ALLY,
	SELF,
	ALL_ENEMY,
	RANDOM_ENEMY
}

enum CardType {
	ATTACK,
	DEFENSE
}

enum AfterPlayType {
	DISCARD,
	EXHAUST
}


@export_group("Card Information")
@export var card_name: String = ""
@export var card_art: Texture2D

@export_group("Combat Properties")
@export var card_type: CardType = CardType.ATTACK
@export var target_type: TargetType = TargetType.ENEMY
@export var stamina_cost: int = 0
@export var recovery_cost: int = 0

@export_group("Effects")
@export var effects: Array[CardEffect] = []

@export_group("Card Lifecycle")
@export var after_play_type: AfterPlayType = AfterPlayType.DISCARD


func _to_string() -> String:
	return "%s (%d) (%d)" % [
		card_name,
		stamina_cost,
		recovery_cost
	]
