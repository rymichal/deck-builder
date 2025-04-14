class_name CardData extends RefCounted

var id: int
var name: String
var description: String
var image: Texture
var cost: int
var popularity: int
var money: int
var trouble: int
	
static func create_from_db(card_db: Dictionary) -> CardData:
	# Check that the dictionary has the required keys
	if not card_db.has("name") or not card_db.has("description") or not card_db.has("cost") or not card_db.has("image"):
		push_error("Dictionary is missing required keys")
		return null

	var instance = CardData.new()
	instance.id = card_db["id"]
	instance.name = card_db["name"]
	
	instance.description = card_db["description"]
	instance.image = card_db["image"]
	
	instance.cost = card_db["cost"]
	instance.popularity = card_db["popularity"]
	instance.money = card_db["money"]
	instance.trouble = card_db["trouble"]

	return instance
