extends Control
class_name  TurnOrderIcon

var turn: CombatantTurn   

@export var combatant_name: Label
@export var amount: Label
@export var combatant_icon: TextureRect
@export var animator: TurnOrderIconAnimator

func _ready() -> void:
	animator.init(self)
	
func init(c: CombatantTurn) -> void:
	turn = c
	combatant_name.text = turn.combatant.name
	amount.text = str(turn.recovery_time)
	combatant_icon.texture = turn.combatant.appearance.combatant_icon
	
func _on_recovery_time_changed() -> void:
	amount.text = str(turn.recovery_time)
	
