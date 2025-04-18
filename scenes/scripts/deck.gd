class_name Deck extends Resource

var cards: Array[int] = []
var _cards_removed: Array[int] = []

func initalize_default_cards():
	cards = [0, 0, 1, 1, 1, 2, 2];
	_cards_removed.clear()
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
	cards.append(card_id)

# consider using draw_card or delete_card instead!
# this will remove the card put also place the removed card into _cards_removed
func remove_card(card_id_to_remove: int) -> void:
	for id in cards:
		if id == card_id_to_remove:
			_cards_removed.append(card_id_to_remove)
			cards.erase(id)
			break

# returns true if card was succesfully deleted
func delete_card(card_id_to_delete: int) -> bool:
	for id in cards:
		if id == card_id_to_delete:
			cards.erase(id)
			return true
	return false

func draw_card() -> int:
	if !is_empty():
		var drawn_card_id = cards.pop_front()
		_cards_removed.append(drawn_card_id)
		return drawn_card_id
	else:
		return -1  # return invalid

func is_empty() -> bool:
	return cards.size() < 1

func shuffle():
	cards.append_array(_cards_removed)
	_cards_removed.clear()
	cards.shuffle()
