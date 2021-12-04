extends Node
class_name Gui

onready var _order_label: Label = $"OrderLabel"

func show_order() -> void:
	_order_label.visible = true


func order_ready() -> void:
	_order_label.visible = false


func order_progress(current, max_progress) -> void:
	_order_label.text = str(current) + "/" + str(max_progress)
