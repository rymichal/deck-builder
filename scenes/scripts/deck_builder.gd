extends Node2D

@export var deck: Deck

@onready var card_slot_1 = %card_slot_1
@onready var card_slot_2 = %card_slot_2
@onready var card_slot_3 = %card_slot_3

var cards_db
var storeFront: Array[Node2D]

signal add_card
signal rm_card

func _ready() -> void:
	storeFront = [card_slot_1, card_slot_2, card_slot_3]
	cards_db = TextDatabase.load_database("res://cards/CustomCards.gd", "res://cards/Cards.cfg")

	_setup_card_store(0, "Friend")
	_setup_card_store(1, "Wild Buddy")
	_setup_card_store(2, "Rich Friend")

func set_deck(d: Deck) -> void:
	deck = d

func _setup_card_store(store_slot: int, name: StringName):
	var card := CardData.create_from_db(cards_db.get_dictionary()[name])
	storeFront[store_slot].get_node("card").set_card_data(card)
	storeFront[store_slot].get_node("add").connect("pressed", _add_btn.bind(card.id))
	storeFront[store_slot].get_node("rm").connect("pressed", _remove_btn.bind(card.id))

func _add_btn(card_id: int):
	deck.add_card(card_id)
	deck.shuffle()
	emit_signal("add_card")

func _remove_btn(card_id: int):
	deck.delete_card(card_id)
	deck.shuffle()
	emit_signal("add_card")
