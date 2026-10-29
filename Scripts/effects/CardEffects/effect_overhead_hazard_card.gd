class_name EffectOverheadHazardCard
extends CardEffect

@export var amount: int = 1
func execute(context: CardEffectContext) -> void:
	var last_played := context.target.card_piles_handler.get_last_played()
	
	if (last_played != null):
		if (last_played.card_type != Card.CardType.DEFENSE):
			var health := context.target.stats.get_percentage_health()
			
			context.target.apply_damage(0, 25)
			if (health < 0.75):
				context.battle_state.add_recovery_time_to_every(context.target, amount)
			if (health < 0.25):
				context.target.stats.take_health_damage(context.target.stats.max_health)
