extends Control

onready var _score_label: Label = $"ScoreLabel"
onready var _highest_score_label: Label = $"HighestScoreLabel"

func _ready() -> void:
	_score_label.text = tr("ui_format_score") % UserSaveData.current_score
	if UserSaveData.current_score >= UserSaveData.highest_score:
		_highest_score_label.text = tr("ui_highest_score")
		UserSaveData.highest_score = UserSaveData.current_score
		UserSaveData.save_data()
	else:
		_highest_score_label.text = tr("ui_format_highest_score") % UserSaveData.highest_score


func _on_QuitButton_pressed():
	get_tree().change_scene("res://title_screen/title_screen.tscn")


func _on_RetryButton_pressed():
	get_tree().change_scene("res://game_screen/game_screen.tscn")
