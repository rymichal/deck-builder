extends Node2D

@onready var att_add = $PanelContainer2/HBoxContainer/VBoxContainer/att_add
@onready var att_remove = $PanelContainer2/HBoxContainer/VBoxContainer/att_remove
@onready var def_add = $PanelContainer2/HBoxContainer/VBoxContainer2/def_add
@onready var def_remove = $PanelContainer2/HBoxContainer/VBoxContainer2/def_remove
@onready var deck = $Deck

#labels: 
@onready var points_label = %points_label

@onready var attack_count = $"PanelContainer/VBoxContainer/card_count_attack/attack_count"
@onready var def_count = $"PanelContainer/VBoxContainer/card_count_def/def_count"

var card_db

func _ready() -> void:
	card_db = TextDatabase.load_database("res://cards/CustomCards.gd", "res://cards/Cards.cfg")
	for entry in card_db.get_array():
		print("Card Title: ", entry.name)
		
	att_add.connect("pressed", _on_att_add_pressed)
	att_remove.connect("pressed", _on_att_remove_pressed)
	def_add.connect("pressed", _on_def_add_pressed)
	def_remove.connect("pressed", _on_def_remove_pressed)

func _on_att_add_pressed():
	var card_data = CardData.create_from_db(card_db.get_array()[0]) # Assuming the first card is the attack card
	deck.add_card(card_data.id)
	update_card_counts()

func _on_att_remove_pressed():
	var card_data = CardData.create_from_db(card_db.get_array()[0]) # Assuming the first card is the attack card
	deck.remove_card(card_data.id)
	update_card_counts()

func _on_def_add_pressed():
	var card_data = CardData.create_from_db(card_db.get_array()[1]) # Assuming the second card is the defense card
	deck.add_card(card_data.id)
	update_card_counts()

func _on_def_remove_pressed():
	var card_data = CardData.create_from_db(card_db.get_array()[1]) # Assuming the second card is the defense card
	deck.remove_card(card_data.id)  #this would never work. we should pass in what card we awnt remove
	update_card_counts()

func update_card_counts():
	var attack_count_num = 0
	var def_count_num = 0
	
	for card_id in deck.cards:
		if card_id == card_db.get_array()[0].id:
			attack_count_num += 1
		elif card_id == card_db.get_array()[1].id:
			def_count_num += 1
			
	points_label.text = str(deck.cards.size())
	attack_count.text = str(attack_count_num)
	def_count.text = str(def_count_num)
