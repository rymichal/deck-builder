extends Node2D

@export var number_of_cards: int = 0
@export var initial_card_position: Vector2 = Vector2(120, 532)
@export var card_spacing: int = 200

@onready var deck = $Deck
@onready var points_label = %points_label
@onready var game_over = %GameOver

var points: int = 0

func _ready() -> void:
	deck.connect("draw_card", _on_draw_card)

func _on_draw_card():
	var card_scn = preload("res://scenes/card.tscn")
	
	var attack_card = preload("res://cards/attack_card.tres")
	var defend_card = preload("res://cards/defend_card.tres")
	
	var deck_resource := [attack_card, defend_card]
	
	var new_card = card_scn.instantiate()
	
	var select_card = randi() % 2
	var new_card_res = deck_resource[select_card]
	print(new_card_res.title, new_card_res.description, new_card_res.cost)
	new_card.call_deferred("set_card_data", new_card_res.title, new_card_res.description, new_card_res.cost, new_card_res.image)
	
	points += new_card_res.cost
	points_label.text = str(points)
	if points > 21:
		_handle_bust()
	
	new_card.position = initial_card_position + Vector2(card_spacing * number_of_cards, 0)
	add_child(new_card)
	number_of_cards += 1
	
func _handle_bust():
	game_over.show()
	if deck.is_connected("draw_card", _on_draw_card):
		deck.disconnect("draw_card", _on_draw_card)
