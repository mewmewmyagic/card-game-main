extends Node
class_name CardPilesHandler

var draw_pile: CardPile = CardPile.new()
var discard_pile: CardPile = CardPile.new()
var exhaust_pile: CardPile = CardPile.new()
var hand_pile: CardPile = CardPile.new()

var card_play_history: Array[Card] = []

var max_hand_size := 10
var opening_hand_size := 5

func setup(starting: CardPile, max_hand: int, opening: int) -> void:
	max_hand_size = max_hand
	opening_hand_size = opening
	for card in starting.cards:
		draw_pile.add_card(card.duplicate())
	draw_pile.shuffle()

func discard_hand() -> void:
	if hand_pile.empty():
		return
	for card in hand_pile.cards.duplicate():
		hand_pile.remove_card(card)
		discard_pile.add_card(card)

	hand_pile.card_pile_size_changed.emit(hand_pile.cards.size())
	

func build_hand() -> void:
	discard_hand() #hand gets discarded and added back to discard pile
	for i in opening_hand_size:
		draw_to_hand()
	
#draws from draw_pile. draw_pile empty? fill it with discard pile then draw. discard empty? some stupid shit happened
func draw_to_hand() -> void:
	if draw_pile.empty(): 
		if discard_pile.empty():
			return
		draw_pile.cards = discard_pile.cards.duplicate() 
		discard_pile.clear() 
		draw_pile.shuffle() 
	var card := draw_pile.draw_card()
	add_to_hand(card)

func add_to_hand(card: Card) -> void:
	if hand_pile.cards.size() >= max_hand_size:
		discard_pile.add_card(card)
	else:
		hand_pile.add_card(card)

func after_card_played(card: Card) -> void:
	hand_pile.remove_card(card)
	if card.after_play_type == card.AfterPlayType.EXHAUST:
		exhaust_pile.add_card(card)
	else:
		discard_pile.add_card(card)
