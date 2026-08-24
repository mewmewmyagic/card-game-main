extends Control
class_name TurnUI

@onready var label: RichTextLabel = $Label
var turns: Array[Combatant] = []
var turn_manager: TurnManager
func bind(turnManager: TurnManager):
	turn_manager = turnManager
	turn_manager.turn_started.connect(func(_c): _refresh())
	_refresh()
	
	
func _refresh() -> void:
	label.bbcode_enabled = true
	var parts: PackedStringArray = []
	turns = turn_manager.combatants.duplicate()
	var i = 0
	for combatant in turns:
		if i == 0:
			parts.append("[color=red]%s %s[/color]" % [combatant.myname, combatant.stats.recovery_time])
		else:
			parts.append("%s %s" % [combatant.myname, combatant.stats.recovery_time])
		i += 1
		

	#label.clear()
	label.text = ", ".join(parts)
