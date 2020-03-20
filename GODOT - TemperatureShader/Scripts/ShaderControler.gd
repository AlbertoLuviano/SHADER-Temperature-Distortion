extends Control

onready var slider = $HSlider
onready var tweenNode = $Tween
onready var forestTiles = get_node("/root/World/Forest")
onready var fireTiles = get_node("/root/World/Fire")
onready var iceTiles = get_node("/root/World/Ice")
onready var shaderRef = get_node("/root/World/PostProcessing").material

func _ready():
	shaderRef.set_shader_param("temperatureRange", slider.value)

func _on_HSlider_value_changed(value):
	shaderRef.set_shader_param("temperatureRange", value)

func _on_ChangeWeather_pressed(value : int, forestAlpha : int, fireAlpha : int, iceAlpha : int):
	tweenNode.interpolate_property(slider, "value", slider.value, value, 1, Tween.TRANS_CUBIC,Tween.EASE_IN_OUT)
	
	tweenNode.interpolate_property(forestTiles, "modulate", \
		forestTiles.modulate, Color(1.0, 1.0, 1.0, forestAlpha), 1,Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tweenNode.interpolate_property(fireTiles, "modulate", \
		fireTiles.modulate, Color(1.0, 1.0, 1.0, fireAlpha), 1,Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tweenNode.interpolate_property(iceTiles, "modulate", \
		iceTiles.modulate, Color(1.0, 1.0, 1.0, iceAlpha), 1,Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	
	tweenNode.start()
