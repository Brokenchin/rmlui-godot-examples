extends Control

var _created_elements: Array[Dictionary] = []
var _attribute_changes: Array[Dictionary] = []
var _log_lines: Array[String] = []
var _document_loaded: bool = false

func _ready() -> void:
	# Inspector-configured document, which loads AFTER _ready — registering
	# the custom tags here means the load instantiates them with factories
	# already in place.
	var rml: RmlContext = $RmlContext
	rml.register_custom_element("test-widget", _on_widget_created, _on_widget_attr_changed)
	rml.register_custom_element("stat-bar", _on_stat_bar_created)
	await get_tree().process_frame  # document loads deferred
	_document_loaded = true


func _log(msg: String) -> void:
	_log_lines.append(msg)
	if _log_lines.size() > 20:
		_log_lines.remove_at(0)
	if not _document_loaded:
		return
	var rml: RmlContext = $RmlContext
	var html := ""
	for line in _log_lines:
		html += "<p>" + line + "</p>"
	rml.set_element_inner_rml("log-output", html)


func _on_widget_created(info: Dictionary) -> void:
	_created_elements.append(info)
	_log("widget created: " + str(info.get("id", "?")) + " tag=" + str(info.get("tag", "?")))


func _on_widget_attr_changed(info: Dictionary) -> void:
	_attribute_changes.append(info)
	_log("widget attr changed: " + str(info.get("id", "?")) + " changed=" + str(info.get("changed", {})))


func _on_stat_bar_created(info: Dictionary) -> void:
	_created_elements.append(info)
	_log("stat-bar created: " + str(info.get("id", "?")) + " stat=" + str(info.get("attributes", {}).get("stat", "?")))
