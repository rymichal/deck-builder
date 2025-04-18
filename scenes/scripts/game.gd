extends Node2D

@onready var start_end_day_btn = %start_end_day_btn
@onready var deck_builder = $deck_builder
@onready var play = $play
@onready var restart_btn = %restart_btn
@onready var game_over_menu = %GameOverMenu

@onready var trouble_label = %trouble_label
@onready var money_label = %money_label
@onready var pop_label = %pop_label

@onready var deck_id_display = %deck_id_display
@onready var cards_remaining_display = %cards_remaining_display

enum states {
	DEFAULT,
	TITLE_SCREEN,
	GAME_PLAY,
	GAME_BUILDING,
	GAME_BUST,
	PAUSED
}
var state : states : set = _set_state

var stats: Stats = Stats.new()
var deck: Deck = Deck.new()
var cards_db

func _ready():
	play.connect("bust_sg", _set_state)
	play.connect("verify_trouble", _verify_trouble)
	play.deck.connect("draw_card_sg", _on_draw_card)
	start_end_day_btn.connect("button_down", _start_end_day_btn_pressed)
	restart_btn.connect("button_down", _restart_game)
	
	cards_db = TextDatabase.load_database("res://cards/CustomCards.gd", "res://cards/Cards.cfg")
	deck.initalize_default_cards()
	_set_state(states.GAME_PLAY)
	
	_display_deck_to_diag()
	
func _restart_game():
	play.restart_day()
	deck.shuffle()
	_set_state(states.GAME_PLAY)
	_update_stats_and_labels({
		"popularity": 0,
		"money": 0,
		"trouble": 0
	})
	game_over_menu.hide()
	_display_deck_to_diag()

func _set_state(new_state: states):
	state = new_state
	if new_state == states.GAME_PLAY:
		play.show()
		deck_builder.hide()
		start_end_day_btn.text = "end day"
	elif new_state == states.GAME_BUILDING:
		play.hide()
		deck_builder.show()
		start_end_day_btn.text = "start day"
	elif new_state == states.GAME_BUILDING:
		## TODO: show a day failed message then change state to game_buildling in 3 seconds. 
		game_over_menu.show()
		
func _start_end_day_btn_pressed():
	print("button pressed", state)
	if state == states.GAME_PLAY:
		_day_end()
	elif state == states.GAME_BUILDING:
		_day_begin()
		
func _day_end():
	deck.shuffle()
	calc_score()
	play.restart_day()
	_update_stats_and_labels({"trouble": 0})
	_set_state(states.GAME_BUILDING)
	_display_deck_to_diag()
	
func _day_begin():
	_set_state(states.GAME_PLAY)

func calc_score():
	pass
	
func _verify_trouble(trouble: int):
	if stats.trouble > 2:
		_set_state(states.GAME_BUST)
		game_over_menu.show()

func _update_stats_from_card(drawn_card: CardData) -> void:
	var new_stats = stats.all()
	new_stats.trouble += drawn_card.trouble
	new_stats.money += drawn_card.money
	new_stats.popularity += drawn_card.popularity
	stats.update(new_stats)

	trouble_label.text = str("Trouble: ", stats.trouble)
	money_label.text = str("Money: ", stats.money)
	pop_label.text = str("Popularity: ", stats.popularity)
	
func _update_stats_and_labels(new_stats: Dictionary) -> void:
	stats.update(new_stats)
	if new_stats.has("trouble"):
		trouble_label.text = str("Trouble: ", stats.trouble)
	if new_stats.has("money"):
		stats.money = new_stats.money
		money_label.text = str("Money: ", stats.money)
	if new_stats.has("popularity"):
		stats.popularity = new_stats.popularity
		pop_label.text = str("Popularity: ", stats.popularity)

func _on_draw_card(): 
	## figure out the card. 
	## pass the card dta to play area
	if deck.is_empty():
		return
		
	var drawn_card_id = deck.draw_card()
	var drawn_card: CardData = CardData.create_from_db(cards_db.get_array()[drawn_card_id])
	play.play_card(drawn_card)
	_display_deck_to_diag()
	
	_update_stats_from_card(drawn_card)
	_verify_trouble(drawn_card.trouble)
	
func _display_deck_to_diag():
	deck_id_display.text = str(deck.cards)
	cards_remaining_display.text = str(deck.cards.size())
