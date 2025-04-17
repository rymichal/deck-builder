extends Node2D

@onready var start_end_day_btn = $PanelContainer/start_end_day_btn
@onready var deck_builder = $deck_builder
@onready var play = $play
@onready var restart_btn = %restart_btn
@onready var game_over_menu = %GameOverMenu


@onready var trouble_label = %trouble_label
@onready var money_label = %money_label
@onready var pop_label = %pop_label


enum states {
	DEFAULT,
	TITLE_SCREEN,
	GAME_PLAY,
	GAME_BUILDING,
	GAME_BUST,
	PAUSED
}
var state : states : set = _set_state

var stats = {
	"popularity": 0,
	"money": 0,
	"trouble": 0
}

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
	calc_score()
	play.restart_day()
	_update_stats_and_labels({"trouble": 0})
	deck.shuffle()
	_set_state(states.GAME_BUILDING)
	
func _day_begin():
	_set_state(states.GAME_PLAY)

func calc_score():
	pass
	
func _verify_trouble(trouble: int):
	if stats.trouble > 2:
		_set_state(states.GAME_BUST)
		game_over_menu.show()

func _update_stats_from_card(drawn_card: CardData) -> void:
	stats.trouble += drawn_card.trouble
	stats.money += drawn_card.money
	stats.popularity += drawn_card.popularity

	trouble_label.text = str("Trouble: ", stats.trouble)
	money_label.text = str("Money: ", stats.money)
	pop_label.text = str("Popularity: ", stats.popularity)
	
func _update_stats_and_labels(new_stats: Dictionary) -> void:
	print("new stats: ", new_stats, new_stats.has("trouble"))
	if new_stats.has("trouble"):
		stats.trouble = new_stats.trouble
		trouble_label.text = str("Trouble: ", stats.trouble)

	if new_stats.has("money"):
		stats.money = new_stats.money
		money_label.text = str("Money: ", stats.money)

	if new_stats.has("popularity"):
		stats.popularity = new_stats.popularity
		pop_label.text = str("Popularity: ", stats.popularity)
	
func reset_stats() -> void:
	stats = {
		"popularity": 0,
		"money": 0,
		"trouble": 0
	}

func _on_draw_card(): 
	print('card drawn in game')
	## figure out the card. 
	## pass the card dta to play area
	if deck.is_empty():
		return
		
	var drawn_card_id = deck.draw_card()
	var drawn_card: CardData = CardData.create_from_db(cards_db.get_array()[drawn_card_id])
	play.play_card(drawn_card)
	
	_update_stats_from_card(drawn_card)
	_verify_trouble(drawn_card.trouble)
