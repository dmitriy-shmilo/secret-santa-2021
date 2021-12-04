extends Node
class_name Gui

onready var _order_label: Label = $"OrderLabel"
onready var _mood_label: Label = $"MoodLabel"

func mood_update(current, total) -> void:
	_mood_label.text = str(current) + "/" + str(total)


func show_order() -> void:
	_order_label.visible = true


func order_ready() -> void:
	_order_label.visible = false


func order_progress(current, total) -> void:
	_order_label.text = str(current) + "/" + str(total)
