extends Control
class_name  TurnOrderIcon

var combatant: Combatant

@onready var combatant_name: Label = $Name
@onready var amount: Label = $Amount

func refresh(c: Combatant) -> void:
	combatant_name.text = c.name
	amount.text = str(c.stats.recovery_time)
