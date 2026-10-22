extends BattleAction
class_name StatusProcAction

var status: StatusEffect
static func create(p_status: StatusEffect) -> StatusProcAction:
	var action := StatusProcAction.new()
	action.status = p_status
	return action

func execute() -> void:
	status.proc_status_effect()
