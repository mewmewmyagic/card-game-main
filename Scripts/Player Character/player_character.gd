extends Node
class_name PlayerCharacter

@onready var character_state_machine: PlayerCharacterStateMachine = $PlayerCharacterStateMachine
@onready var body: CharacterBody2D = $PlayerMovementController

var facing: Vector2 = Vector2.DOWN

func _ready() -> void:
	character_state_machine.init(self)
	
func play_anim(anim_name: String) -> void:
	pass
