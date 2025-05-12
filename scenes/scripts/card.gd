class_name Card extends Node2D

@onready var area_2d = %Area2D
@onready var name_label = %Name
@onready var description_label = %Description
@onready var card_popularity_label: Label = %CardPopularity
@onready var image = %Image

var card_name: String = "Card Name"
var card_description: String = "Card Description"
var card_cost: int = 1
var card_image: Texture

func _ready(): 
	area_2d.input_event.connect(_on_card_clicked)
	_set_card_data_from_fields(card_name, card_description, card_cost, card_image)
	
func _set_card_data_from_fields(_name, _description, _cost, _image):
	name_label.text = _name
	description_label.text = _description
	card_popularity_label.text = str(_cost)
	image.set_texture(_image)
	
func set_card_data(card: CardData):
	name_label.text = card.name
	description_label.text = card.description
	card_popularity_label.text = str(card.cost)
	image.set_texture(card.image)

func _on_card_clicked(viewport: Viewport, event: InputEvent, shape_index: int):
	var event_is_mouse_click: bool = (
		event is InputEventMouseButton and
		event.button_index == MOUSE_BUTTON_LEFT and 
		event.is_pressed()
	)
	if event_is_mouse_click:
		print("card clicked")
