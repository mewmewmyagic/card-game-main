extends Control
class_name  TurnOrderIcon

var turn: CombatantTurn   

@export var combatant_name: Label
@export var amount: Label
@export var combatant_icon: TextureRect
@export var background: ColorRect
@export var animator: TurnOrderIconAnimator

func _ready() -> void:
	animator.init(self)
	background.color = Color.ROYAL_BLUE
	EventBus.highlight_these_turn_ui.connect(_on_target_changed)
	
func update_owner(c: CombatantTurn) -> void:
	turn = c
	combatant_name.text = turn.combatant.name
	amount.text = str(turn.recovery_time)
	combatant_icon.texture = turn.combatant.appearance.combatant_icon
	
func _on_recovery_time_changed() -> void:
	amount.text = str(turn.recovery_time)
	
func _on_target_changed(affected: Array[Combatant]) -> void:
	if affected.has(turn.combatant):
		background.color = Color.ORANGE_RED      # will be hit
	else:
		background.color = Color.ROYAL_BLUE
