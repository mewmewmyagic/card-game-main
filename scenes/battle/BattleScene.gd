extends Node2D
class_name BattleScene


@export var battle_state: BattleState
@export var battle_ui: BattleUI

@export var data: BattleData

func _ready() -> void:
	battle_state.setup_actors(data)
	var bg := data.Background.instantiate()
	self.add_child(bg)
