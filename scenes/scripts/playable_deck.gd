extends Node2D

@onready var area_2d = %Area2D

signal draw_card_sg

func _ready():
	area_2d.connect("input_event", _on_card_clicked)

func _on_card_clicked(viewport: Viewport, event: InputEvent, shape_index: int):
	var event_is_mouse_click: bool = (
		event is InputEventMouseButton and
		event.button_index == MOUSE_BUTTON_LEFT and 
		event.is_pressed()
	)
	if event_is_mouse_click:
		emit_signal("draw_card_sg")
