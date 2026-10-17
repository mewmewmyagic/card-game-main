extends Control
class_name TurnOrderUI

const ICON_SPACING = 32

@export var turn_icon_scene: PackedScene

@export var big_icon: TurnOrderIcon
var turn_icons: Array[TurnOrderIcon] = []
var turn_to_ui: Dictionary = {}

var turn_manager: TurnManager

func bind(turnManager: TurnManager) -> void:
	turn_manager = turnManager
	turn_manager.turn_order_changed.connect(sync)
	big_icon.amount.hide()
	
func spawn_icon(t: CombatantTurn) -> void:
	var turn_icon := turn_icon_scene.instantiate() as TurnOrderIcon
	turn_icon.init(t)
	add_child(turn_icon)
	turn_icon.global_position = Vector2(self.size.x, self.size.y/2 - ICON_SPACING/2)
	turn_to_ui[t] = turn_icon
	
#should be called when sort combatant has already been called. cause you know, thats how syncing works 
func sync() -> void:
	var turns := turn_manager.turn_order.duplicate()
	
	#loops through dict, despawn icon not in turns and unassigning it to the dict
	for t in turn_to_ui.keys().duplicate():
		if not turns.has(t):
			_despawn_icon(t)
	
	#loops through turns, spawn icon not in dict and assigning it to the dict
	for t in turns:
		if not turn_to_ui.has(t):
			spawn_icon(t)

	_refresh_turn_icons()
	_update_layout()
	
func _despawn_icon(t: CombatantTurn) -> void:
	var turn_icon: TurnOrderIcon = turn_to_ui[t]
	turn_to_ui.erase(t)
	turn_icon.animator.move_to(Vector2(turn_icon.position.x, -100), 0.0, 0.25)
	await get_tree().create_timer(0.25).timeout
	turn_icon.queue_free()
	
func _refresh_turn_icons() -> void:
	turn_icons.clear()
	for t in turn_manager.turn_order: #has to be sorted
		if turn_to_ui.has(t):
			turn_icons.append(turn_to_ui[t])
		
func _update_layout() -> void:
	var spacing = ICON_SPACING
	for i in turn_icons.size():
		if (i == 0):
			big_icon.combatant_icon.texture = turn_icons[i].combatant_icon.texture
		
		turn_icons[i].animator.move_to(Vector2((i-1) * spacing + big_icon.size.x * big_icon.scale.x, self.size.y/2 - ICON_SPACING/2), 0.0, 0.25) #
		turn_icons[i].amount.text = str(turn_icons[i].turn.recovery_time)
		
