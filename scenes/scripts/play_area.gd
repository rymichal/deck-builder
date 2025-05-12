extends Node2D

@onready var deck = $playable_deck
@onready var played_card_area = %play_card_area

var created_cards: Array[Node2D] = [] 
var number_of_cards: int = 0

var initial_card_position: Vector2 = Vector2(120, 532)
var card_spacing: int = 100

func play_card(card: CardData):
	var card_scn = preload("res://scenes/card.tscn")
	var new_card = card_scn.instantiate()
	new_card.call_deferred("set_card_data", card)
	created_cards.append(new_card)

	# place card in scene. 
	new_card.position = initial_card_position + Vector2(card_spacing * number_of_cards, 0)
	played_card_area.add_child(new_card)
	number_of_cards += 1

func restart_day() -> void:
	number_of_cards = 0
	for card in created_cards:
		if card and card.get_parent(): 
			card.queue_free()
	created_cards.clear()  
