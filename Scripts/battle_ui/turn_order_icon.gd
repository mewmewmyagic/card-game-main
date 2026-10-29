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
	
func init(c: CombatantTurn) -> void:
	turn = c
	combatant_name.text = turn.combatant.name
	amount.text = str(turn.recovery_time)
	combatant_icon.texture = turn.combatant.appearance.combatant_icon
	
	EventBus.card_entered_area.connect(_on_combatant_selected)
	EventBus.card_exited_area.connect(_on_combatant_deselected)
	
func _on_recovery_time_changed() -> void:
	amount.text = str(turn.recovery_time)
	
func _on_combatant_selected(_c: Card, comb: Combatant) -> void:
	if comb == turn.combatant:
		background.color = Color.ORANGE_RED
	
func _on_combatant_deselected(_c: Card, comb: Combatant) -> void:
	if comb == turn.combatant:
		background.color = Color.ROYAL_BLUE
