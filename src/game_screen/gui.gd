extends Node
class_name Gui

const ITEM_ICON_WIDTH = 16

onready var _progress_icon: Sprite = $"ProgressIcon"
onready var _order_progress_bar: TextureProgress = $"OrderProgress"
onready var _heat_level_bar: TextureProgress = $"HeatLevel"
onready var _score_label: Label = $"ScoreLabel"

func reset_for_order(icon_index: int) -> void:
	_heat_level_bar.value = 0
	_order_progress_bar.value = 0
	_order_progress_bar.visible = true
	_progress_icon.visible = true
	_progress_icon.region_rect.position.x = ITEM_ICON_WIDTH * icon_index


func order_ready() -> void:
	_progress_icon.visible = false
	_order_progress_bar.visible = false


func order_progress(current, total) -> void:
	_order_progress_bar.value = current
	_order_progress_bar.max_value = total


func heat_update(current, total) -> void:
	_heat_level_bar.value = current
	_heat_level_bar.max_value = total


func score_update(_change_by, total) -> void:
	_score_label.text = "x" + str(floor(total))
