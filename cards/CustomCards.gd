extends TextDatabase

func _schema_initialize():
	add_mandatory_property("description", TYPE_STRING)
	add_mandatory_property("image", TYPE_STRING)

	add_mandatory_property("cost", TYPE_INT)
	add_mandatory_property("popularity", TYPE_INT)
	add_mandatory_property("money", TYPE_INT)
	add_mandatory_property("trouble", TYPE_INT)
	
func _postprocess_entry(entry: Dictionary):
	entry.image = load("res://sprites/" + entry.image + ".png")
