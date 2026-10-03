extends Control
class_name TurnUI

@onready var label: RichTextLabel = $Label
@export var turn_icon_scene: PackedScene

var turn_icons: Array[TurnOrderIcon] = []
var turn_to_ui: Dictionary = {}

var turn_manager: TurnManager

func bind(turnManager: TurnManager) -> void:
	turn_manager = turnManager
	turn_manager.turn_order_changed.connect(sync)
	
func spawn_icon(c: Combatant) -> void:
	var turn_icon := turn_icon_scene.instantiate() as TurnOrderIcon
	turn_icon.init(c)
	add_child(turn_icon)
	turn_to_ui[c] = turn_icon
	
func sync() -> void:
	var combatants := turn_manager._active_combatants().duplicate()
	
	#loops through combatants, spawn icon and assigning it to the dict
	for c in combatants:
		if not turn_to_ui.has(c):
			spawn_icon(c)
	
	#loops through dict, despawn icon and unassigning it to the dict
	for c in turn_to_ui.keys().duplicate():
		if not combatants.has(c):
			_despawn_icon(c)

	_refresh_turn_icons()
	_update_layout()
	
func _despawn_icon(c: Combatant) -> void:
	var turn_icon: TurnOrderIcon = turn_to_ui[c]
	turn_to_ui.erase(c)
	turn_icon.queue_free()
	
func _refresh_turn_icons() -> void:
	turn_icons.clear()
	for c in turn_manager.combatants:
		if turn_to_ui.has(c):
			turn_icons.append(turn_to_ui[c])
		
func _update_layout() -> void:
	var spacing = 27
	for i in turn_icons.size():
		turn_icons[i].animator.move_to(Vector2(i * spacing, 10), 0.0, 0.25)
		turn_icons[i].amount.text = str(turn_icons[i].combatant.stats.recovery_time)

func _refresh() -> void:
	label.bbcode_enabled = true
	var parts: PackedStringArray = []
	
	var ordered := turn_manager.combatants.duplicate()
	
	var i = 0
	for combatant in ordered:
		if not combatant.is_active_combatant():
			continue
		if i == 0:
			parts.append("[color=red]%s %s[/color]" % [combatant.name, combatant.stats.recovery_time])
		else:
			parts.append("%s %s" % [combatant.name, combatant.stats.recovery_time])
		i += 1

	#label.clear()
	label.text = ", ".join(parts)
