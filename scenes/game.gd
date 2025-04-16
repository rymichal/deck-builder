extends Node2D



@onready var deck = $Deck
@onready var game_over_menu = %GameOverMenu
@onready var restart_btn = %restart_btn
@onready var played_card_area = %Played_Card_Area


@onready var trouble_label: Label = %trouble_label
@onready var money_label: Label = %money_label
@onready var pop_label: Label = %pop_label

var stats = {
	"popularity": 0,
	"money": 0,
	"trouble": 0
}

var gameplay_state = false
var cards_db
var created_cards: Array[Node2D] = [] 

var number_of_cards: int = 0
var initial_card_position: Vector2 = Vector2(120, 532)
var card_spacing: int = 100

func _ready() -> void:
	cards_db = TextDatabase.load_database("res://cards/CustomCards.gd", "res://cards/Cards.cfg")
	
	deck.connect("draw_card_sg", _on_draw_card)
	deck.initalize_default_cards()
	
	restart_btn.connect("button_down", _restart_game)

func _on_draw_card():
	var card_scn = preload("res://scenes/card.tscn")
	var new_card = card_scn.instantiate()
	
	if deck.cards.size() < 0:
		# invalid draw
		return
		
	var drawn_card_id = deck.draw_card()
	print(deck.get_number_of_cards_remaining())
	var drawn_card = CardData.create_from_db(cards_db.get_array()[drawn_card_id])
	
	# set card view; we have to defer this call as its not guanteed to be created yet. 
	new_card.call_deferred("set_card_data", drawn_card.name, drawn_card.description, drawn_card.cost, drawn_card.image)
	
	created_cards.append(new_card)
	
	# score cards + handle lose conditions
	update_stats(drawn_card)
	
	if stats.trouble > 2:
		_handle_bust()
	
	# place card in scene. 
	new_card.position = initial_card_position + Vector2(card_spacing * number_of_cards, 0)
	played_card_area.add_child(new_card)
	number_of_cards += 1
	
func _handle_bust():
	game_over_menu.show()
	if deck.is_connected("draw_card_sg", _on_draw_card):
		deck.disconnect("draw_card_sg", _on_draw_card)
		
func _restart_game() -> void:
	deck.initalize_default_cards()
	reset_stats()
	number_of_cards = 0
	for card in created_cards:
		if card and card.get_parent(): 
			card.queue_free()
	created_cards.clear()  
	game_over_menu.hide()
	deck.connect("draw_card_sg", _on_draw_card)

func update_stats(drawn_card: CardData) -> void:
	
	stats.trouble += drawn_card.trouble
	stats.money += drawn_card.money
	stats.popularity += drawn_card.popularity

	trouble_label.text = str("Trouble: ", stats.trouble)
	money_label.text = str("Money: ", stats.money)
	pop_label.text = str("Popularity: ", stats.popularity)
	
func reset_stats() -> void:
	stats = {
		"popularity": 0,
		"money": 0,
		"trouble": 0
	}
