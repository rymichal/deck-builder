class_name Card extends Node2D

@onready var area_2d = %Area2D
@onready var name_label = %Name
@onready var description_label = %Description
@onready var card_cost_label = %CardCost
@onready var image = %Image

var card_name: String = "Card Name"
var card_description: String = "Card Description"
var card_cost: int = 1
var card_image: Texture


func _ready(): 
	area_2d.input_event.connect(_on_card_clicked)
	set_card_data(card_name, card_description, card_cost, card_image)
	
func set_card_data(_name, _description, _cost, _image):
	name_label.text = _name
	description_label.text = _description
	card_cost_label.text = str(_cost)
	image.set_texture(_image)

func _on_card_clicked(viewport: Viewport, event: InputEvent, shape_index: int):
	var event_is_mouse_click: bool = (
		event is InputEventMouseButton and
		event.button_index == MOUSE_BUTTON_LEFT and 
		event.is_pressed()
	)
	if event_is_mouse_click:
		print("card clicked")
