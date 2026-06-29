extends Control
## Issue #56 — per-embed data-model namespacing. One reusable grid_panel.rml,
## mounted twice with model opt-in, each fed DIFFERENT data through its handle.
## Both author `data-model="grid"`, but they stay completely independent.

const PANEL := "res://addons/rmlui-godot/examples/advanced/embed_grids/grid_panel.rml"

func _ready() -> void:
	var rml: RmlContext = $RmlContext
	# Load the board synchronously here (no document_path), so we can mount and
	# feed the grids immediately afterward — mount_embed is synchronous.
	rml.load_document("res://addons/rmlui-godot/examples/advanced/embed_grids/board.rml")
	_make_grid(rml, "heroes", "Heroes", ["Knight", "Mage", "Archer"])
	_make_grid(rml, "loot", "Loot", ["Gold", "Gem"])


func _make_grid(rml: RmlContext, id: String, title: String, items: Array) -> void:
	rml.mount_embed("lanes", PANEL, {"id": id, "model": "grid"})
	var d := rml.get_embedded_data(id)   # handle to this instance's namespaced model
	d.set_value("title", title)
	d.set_array("items", items)
	d.set_value("count", items.size())
