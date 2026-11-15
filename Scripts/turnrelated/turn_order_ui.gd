extends Control
class_name TurnOrderUI

const ICON_SPACING = 32
const MOVE_TIME := 0.25
const DROP_IN_OFFSET_Y := -48.0 #how far above its slot a returning icon starts

@export var turn_icon_scene: PackedScene

@export var big_icon: TurnOrderIcon
var turn_icons: Array[TurnOrderIcon] = []
var turn_to_ui: Dictionary = {} #combatant turn, turn icon

var turn_manager: TurnManager

#true between round_started and the first sync after it, so new icons fly in from the right
var _round_starting := false

func bind(turnManager: TurnManager) -> void:
	turn_manager = turnManager
	turn_manager.turn_order_changed.connect(sync)
	EventBus.round_started.connect(func(): _round_starting = true)
	big_icon.amount.hide()

#where the icon in slot i belongs. slot 0 sits under the big icon
func _slot_position(i: int) -> Vector2:
	var y := self.size.y / 2.0 - ICON_SPACING / 2.0
	var big_width := big_icon.size.x * big_icon.scale.x
	if i == 0:
		return Vector2(big_width / 4, y)
	return Vector2((i - 1) * ICON_SPACING + big_width, y)

func _create_icon(t: CombatantTurn) -> TurnOrderIcon:
	var turn_icon := turn_icon_scene.instantiate() as TurnOrderIcon
	turn_icon.update_owner(t)
	add_child(turn_icon)
	turn_to_ui[t] = turn_icon
	return turn_icon

#round start: right to left
func round_start_spawn_icon(t: CombatantTurn) -> void:
	var turn_icon := _create_icon(t)
	turn_icon.position = Vector2(self.size.x, self.size.y / 2.0 - ICON_SPACING / 2.0)

#mid round: starts hidden, _update_layout drops it in from above its slot
func spawn_icon(t: CombatantTurn) -> void:
	var turn_icon := _create_icon(t)
	turn_icon.hide()

func _despawn_icon(t: CombatantTurn) -> void:
	var turn_icon: TurnOrderIcon = turn_to_ui[t]
	turn_to_ui.erase(t)
	
	#the first icon is hidden under the big icon, nothing to animate
	if not turn_icon.visible:
		turn_icon.queue_free()
		return
	
	turn_icon.animator.move_to(Vector2(turn_icon.position.x, -100), 0.0, 0.25)
	await get_tree().create_timer(0.25).timeout
	if is_instance_valid(turn_icon):
		turn_icon.queue_free()

#should be called when sort combatant has already been called. cause you know, thats how syncing works
func sync() -> void:
	var turns := turn_manager.get_active_turns().duplicate()
	
	for t in turn_to_ui.keys().duplicate():
		if not turns.has(t):
			_despawn_icon(t)
	
	for t in turns:
		if not turn_to_ui.has(t):
			if _round_starting:
				round_start_spawn_icon(t)
			else:
				spawn_icon(t)
	
	_round_starting = false
	
	_refresh_turn_icons()
	_update_layout()

func _refresh_turn_icons() -> void:
	turn_icons.clear()
	for t in turn_manager.get_active_turns(): #has to be sorted
		if turn_to_ui.has(t):
			turn_icons.append(turn_to_ui[t])

func _update_layout() -> void:
	for i in turn_icons.size():
		var icon := turn_icons[i]
		var target := _slot_position(i)
		
		if i == 0:
			#slides under the big icon, then gets hidden. the big icon never moves
			big_icon.update_owner(icon.turn)
			var tween := icon.animator.move_to(target, 0.0, MOVE_TIME)
			#a killed tween never emits finished, so if this icon gets moved again before arriving it wont get hidden
			tween.finished.connect(func():
				if not turn_icons.is_empty() and turn_icons[0] == icon:
					icon.hide()
			)
		else:
			if not icon.visible:
				#it was the first icon (or is brand new): appear above its slot and tween down into it
				icon.show()
			icon.animator.move_to(target, 0.0, MOVE_TIME)
			icon.amount.text = str(icon.turn.recovery_time)
