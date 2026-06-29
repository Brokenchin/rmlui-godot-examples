extends Control
## Issue #56 — drag-and-drop ACROSS embeds (the inventory use case). The draggable
## item lives in embed "a"; the drop slot lives in embed "b". The coordinator
## registers the source/target by id (the addon resolves them across embeds) and
## reflects the drop. Run this scene and drag the item onto the slot.

func _ready() -> void:
	var rml: RmlContext = $RmlContext
	# Load synchronously so the declarative embeds are mounted before we register.
	rml.load_document("res://addons/rmlui-godot/examples/advanced/embed_drag/board.rml")
	rml.register_drag_source("drag-item", _payload)
	rml.register_drop_target("drop-slot", _on_drop)


func _payload(_element_id: String, _at_pos: Vector2) -> Dictionary:
	return {"item": "Sword", "color": "#cc8844"}


func _on_drop(_element_id: String, data) -> void:
	# Reflect the drop in the target embed: show the item and recolor the slot.
	var slot := ($RmlContext as RmlContext).get_element_by_id("drop-slot")
	if slot != null and slot.is_valid():
		slot.set_inner_rml(str(data.get("item", "?")) + "\ndropped!")
		slot.set_property("background-color", str(data.get("color", "#33334d")))
		slot.set_property("color", "#2a1500")
