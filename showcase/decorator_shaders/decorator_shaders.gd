extends Control

const PLASMA := preload("res://addons/rmlui-godot/examples/showcase/decorator_shaders/plasma.gdshader")
const RIPPLE := preload("res://addons/rmlui-godot/examples/showcase/decorator_shaders/ripple.gdshader")

var _rml: RmlContext


func _ready() -> void:
	# Inspector-configured document, which loads AFTER _ready — shader
	# decorators registered here exist before the document's styles resolve.
	_rml = $RmlContext

	# Path 1: bare Shader — the decorator uses the shader's default uniforms.
	_rml.register_decorator_shader("plasma", PLASMA)
	_rml.register_decorator_shader("ripple", RIPPLE)

	# Path 2: configured ShaderMaterial — tuned uniforms (speed, colors) are
	# carried onto every element that uses this decorator. The bridge duplicates
	# the material per element so element_dimensions stays per-instance.
	var fast := ShaderMaterial.new()
	fast.shader = PLASMA
	fast.set_shader_parameter("speed", 3.0)
	fast.set_shader_parameter("scale", 12.0)
	fast.set_shader_parameter("color_a", Color(0.0, 0.12, 0.05))
	fast.set_shader_parameter("color_b", Color(0.25, 1.0, 0.55))
	_rml.register_decorator_material("plasma_fast", fast)

