extends Node2D

@export var number_of_cards: int = 0
@export var initial_card_position: Vector2 = Vector2(120, 532)
@export var card_spacing: int = 200

@onready var deck = $Deck
@onready var points_label = %points_label
@onready var game_over = %GameOver

var points: int = 0
var cards

func _ready() -> void:
	cards = TextDatabase.load_database("res://cards/CustomCards.gd", "res://cards/Cards.cfg")
	
	deck.connect("draw_card_sg", _on_draw_card)
	deck.initalize_default_cards()

func _on_draw_card():
	var card_scn = preload("res://scenes/card.tscn")
	var new_card = card_scn.instantiate()
	
	if deck.cards.size() < 0:
		# invalid draw
		return
		
	var drawn_card_id = deck.draw_card()
	var drawn_card = CardData.create_from_db(cards.get_array()[drawn_card_id])
	
	# set card view; we have to defer this call as its not guanteed to be created yet. 
	new_card.call_deferred("set_card_data", drawn_card.title, drawn_card.description, drawn_card.cost, drawn_card.image)
	
	# score cards + handle lose conditions
	points += drawn_card.cost
	points_label.text = str(points)
	if points > 21:
		_handle_bust()
	
	# place card in scene. 
	new_card.position = initial_card_position + Vector2(card_spacing * number_of_cards, 0)
	add_child(new_card)
	number_of_cards += 1
	
func _handle_bust():
	game_over.show()
	if deck.is_connected("draw_card_sg", _on_draw_card):
		deck.disconnect("draw_card_sg", _on_draw_card)
