extends BattleAction
class_name AnimationAction

var parent: Combatant
var card: Card
static func create(p_parent: Combatant, p_card: Card) -> AnimationAction:
	var action := AnimationAction.new()
	action.parent = p_parent
	action.card = p_card
	return action


# Called every frame. 'delta' is the elapsed time since the previous frame.
func execute() -> void:
	await parent.play_skill_animation(card)
