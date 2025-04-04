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
	for entry in cards.get_array():
		print("Card: ", entry.name)
		print("Description: ", entry.description)
		print("cost: ", entry.cost)
	
	deck.connect("draw_card", _on_draw_card)

func _on_draw_card():
	var card_scn = preload("res://scenes/card.tscn")
	var new_card = card_scn.instantiate()
	
	# get random card draw
	var select_card = randi() % 2
	var new_card_res = cards.get_array()[select_card]
	
	# build card data
	new_card.call_deferred("set_card_data", new_card_res.name, new_card_res.description, new_card_res.cost, new_card_res.image)
	
	# score cards + handle lose conditions
	points += new_card_res.cost
	points_label.text = str(points)
	if points > 21:
		_handle_bust()
	
	# place card in scene. 
	new_card.position = initial_card_position + Vector2(card_spacing * number_of_cards, 0)
	add_child(new_card)
	number_of_cards += 1
	
func _handle_bust():
	game_over.show()
	if deck.is_connected("draw_card", _on_draw_card):
		deck.disconnect("draw_card", _on_draw_card)
