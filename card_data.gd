class_name CardData extends RefCounted

var title: String
var description: String
var cost: int
var image: Texture
	
static func create_from_db(card_db: Dictionary) -> CardData:
	# Check that the dictionary has the required keys
	if not card_db.has("name") or not card_db.has("description") or not card_db.has("cost") or not card_db.has("image"):
		push_error("Dictionary is missing required keys")
		return null

	var instance = CardData.new()
	instance.title = card_db["name"]
	instance.description = card_db["description"]
	instance.cost = card_db["cost"]
	instance.image = card_db["image"]

	return instance
