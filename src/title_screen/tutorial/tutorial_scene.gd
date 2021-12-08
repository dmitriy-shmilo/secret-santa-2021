extends Control
class_name TutorialScene

func _ready() -> void:
	$TutorialLabel.bbcode_text = tr("msg_tutorial")
