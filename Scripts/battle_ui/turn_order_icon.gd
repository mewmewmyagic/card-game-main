extends Control
class_name  TurnOrderIcon

var combatant: Combatant

@export var combatant_name: Label
@export var amount: Label
@export var animator: TurnOrderIconAnimator

func _ready() -> void:
	animator.init(self)
	
func init(c: Combatant) -> void:
	combatant = c
	combatant_name.text = c.name
	amount.text = str(c.stats.recovery_time)
	
func _on_recovery_time_changed() -> void:
	amount.text = str(combatant.stats.recovery_time)
	
