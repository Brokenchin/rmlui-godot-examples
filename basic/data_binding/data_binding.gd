extends Control

var _score: int = 0

func _ready() -> void:
	# Document + fonts come from the inspector (document_path / font_paths) so
	# the scene also renders in the editor (editor_mock_data fills the model
	# there). The document loads AFTER _ready — models created here bind on
	# load, no reload needed.
	var rml: RmlContext = $RmlContext
	rml.create_data_model("test")
	rml.bind_data_variable("test", "title", "Hello from GDScript!")
	rml.bind_data_variable("test", "score", _score)
	rml.bind_data_event("test", "on_increment", _on_increment)


func _on_increment() -> void:
	_score += 1
	var rml: RmlContext = $RmlContext
	rml.set_data_variable("test", "score", _score)
