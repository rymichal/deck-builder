extends Node2D

@onready var card_slot_1 = %card_slot_1
@onready var card_slot_2 = %card_slot_2
@onready var card_slot_3 = %card_slot_3

var cards_db
var storeFront: Array[Node2D]

signal add_card
signal del_card

func _ready() -> void:
	storeFront = [card_slot_1, card_slot_2, card_slot_3]
	cards_db = TextDatabase.load_database("res://cards/CustomCards.gd", "res://cards/Cards.cfg")

	_setup_card_store(0, "Old Friend")
	_setup_card_store(1, "Rock Star")
	_setup_card_store(2, "Hippy")

func _setup_card_store(store_slot: int, name: StringName):
	var card := CardData.create_from_db(cards_db.get_dictionary()[name])
	storeFront[store_slot].get_node("card").set_card_data(card)
	storeFront[store_slot].get_node("add").connect("pressed", emit_signal.bind("add_card", card.id))
	storeFront[store_slot].get_node("rm").connect("pressed", emit_signal.bind("del_card", card.id))
