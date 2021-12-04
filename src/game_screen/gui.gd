extends Node
class_name Gui

onready var _order_progress_bar: TextureProgress = $"OrderProgress"
onready var _heat_level_bar: TextureProgress = $"HeatLevel"


func show_order() -> void:
	_order_progress_bar.value = 0


func order_ready() -> void:
	pass


func order_progress(current, total) -> void:
	_order_progress_bar.value = current
	_order_progress_bar.max_value = total
