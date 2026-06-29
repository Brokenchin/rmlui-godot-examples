extends Control
## Embedding showcase (issue #56). One coordinator RmlContext composes two
## separately-authored panels (character_panel.rml, inventory_panel.rml) as real
## subtrees sharing ONE layout domain. Demonstrates:
##   - shared layout + reflow (the resize button)
##   - parent -> child via the cached <script> instance (the damage button)
##   - an in-embed button handled by the embed's own <script> (Heal)
##   - data-for / data-event INSIDE an embed (the inventory list)
##
## Note the data path here: the coordinator owns the inventory data model and the
## embedded panel renders it with data-for. Models are context-wide by name, so
## this works for a single inventory panel; two instances of the same panel would
## need per-embed namespacing (a documented follow-up).

var _items: Array = ["Sword", "Shield", "Potion", "Torch"]

func _ready() -> void:
	var rml: RmlContext = $RmlContext
	# Create the inventory model BEFORE the document loads (it loads deferred,
	# after this _ready), so the embedded panel's data-for binds to it on mount.
	rml.create_data_model("inv")
	rml.bind_data_array("inv", "items", _items.duplicate())
	rml.bind_data_variable("inv", "item_count", _items.size())
	rml.bind_data_event("inv", "on_add", _on_add)
	rml.bind_data_event("inv", "on_remove", _on_remove)


func _on_add() -> void:
	var rml: RmlContext = $RmlContext
	var pool := ["Helmet", "Ring", "Amulet", "Boots", "Bow", "Staff"]
	rml.push_data_array_item("inv", "items", pool[_items.size() % pool.size()])
	_items.append("x")
	rml.set_data_variable("inv", "item_count", rml.get_data_array_size("inv", "items"))


func _on_remove() -> void:
	var rml: RmlContext = $RmlContext
	var n := rml.get_data_array_size("inv", "items")
	if n > 0:
		rml.remove_data_array_item("inv", "items", n - 1)
		if not _items.is_empty():
			_items.pop_back()
		rml.set_data_variable("inv", "item_count", rml.get_data_array_size("inv", "items"))
