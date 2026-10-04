class_name EffectAddModifier
extends CardEffect


@export var stack: int
@export var count: int

func execute(context: CardEffectContext) -> void:
	var dmg := context.source.modifer_manager.get_modifier(Modifier.Type.dmg_dealt)
	
	var m := dmg.get_value("fuck")
	
	if not m:
		m = ModifierValue.create_new_modifier("fuck", ModifierValue.Type.FLAT)
	m.flat_value = 10
	dmg.add_new_value(m)
