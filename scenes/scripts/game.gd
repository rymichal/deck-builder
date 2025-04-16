extends Node2D

@onready var start_end_day_btn = $PanelContainer/start_end_day_btn
@onready var deck_builder = $deck_builder
@onready var play = $play

enum states {
	DEFAULT,
	TITLE_SCREEN,
	GAME_PLAY,
	GAME_BUILDING,
	PAUSED
}
var state : states : set = _set_state

func _ready():
	start_end_day_btn.connect("button_down", _start_end_day_btn_pressed)
	_set_state(states.GAME_PLAY)

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
		
func _start_end_day_btn_pressed():
	if state == states.GAME_PLAY:
		play.restart_game()
		_set_state(states.GAME_BUILDING)
	elif state == states.GAME_BUILDING:
		_set_state(states.GAME_PLAY)
