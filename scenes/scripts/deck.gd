extends Node2D

@onready var area_2d = %Area2D

signal draw_card_sg

var cards: Array[int] = []
var _cards_removed: Array[int] = []

func _ready():
	area_2d.connect("input_event", _on_card_clicked)
	
func initalize_default_cards():
	cards = [0, 0, 1, 1, 0, 2, 2];
	shuffle()
	
func get_number_of_cards_remaining() -> int:
	return cards.size()

func _on_card_clicked(viewport: Viewport, event: InputEvent, shape_index: int):
	var event_is_mouse_click: bool = (
		event is InputEventMouseButton and
		event.button_index == MOUSE_BUTTON_LEFT and 
		event.is_pressed()
	)
	if event_is_mouse_click:
		emit_signal("draw_card_sg")

func add_card(card_id: int) -> void:
	print("card id: ", card_id)
	cards.append(card_id)

func remove_card(card_id_to_remove: int) -> void:
	for id in cards:
		if id == card_id_to_remove:
			_cards_removed.append(card_id_to_remove)
			cards.erase(id)
			break
	shuffle()

func draw_card() -> int:
	if !is_empty():
		var drawn_card_id = cards.pop_front()
		_cards_removed.append(drawn_card_id)
		if is_empty():
			hide()
		return drawn_card_id
	else:
		return -1  # return invalid

func is_empty() -> bool:
	return cards.size() < 1
	
func shuffle():
	cards.shuffle()
