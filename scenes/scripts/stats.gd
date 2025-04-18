class_name Stats extends Resource

var stats = {
	"popularity": 0,
	"money": 0,
	"trouble": 0
}

func all() -> Dictionary:
	return stats

# Override the indexing operator
func _get(property: StringName) -> Variant:
	if stats.has(property):
		return stats[property]
	return null

func _set(property: StringName, value: Variant) -> bool:
	if stats.has(property):
		stats[property] = value
		return true
	return false
	
func update(new_stats: Dictionary):
	for key in new_stats.keys():
		if stats.has(key):
			stats[key] = new_stats[key]
	
func reset_stats() -> void:
	stats = {
		"popularity": 0,
		"money": 0,
		"trouble": 0
	}
