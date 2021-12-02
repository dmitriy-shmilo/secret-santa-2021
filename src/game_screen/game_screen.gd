extends Node2D


onready var _pause_container: ColorRect = $"Gui/PauseContainer"
onready var _anvil_slot: Node2D = $"AnvilSlot"
onready var _bellows_slot: Node2D = $"BellowsSlot"
onready var _character: Character = $"Character"


var _is_at_anvil = true

func _unhandled_input(event):
	if event.is_action("system_pause"):
		get_tree().paused = true
		_pause_container.visible = true
		


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("left"):
		_character.global_position = _bellows_slot.global_position
		_is_at_anvil = false
		_character.bellows_idle()
		return
	
	if Input.is_action_just_pressed("right"):
		_character.global_position = _anvil_slot.global_position
		_is_at_anvil = true
		_character.anvil_idle()
		return
	
	if Input.is_action_just_pressed("up"):
		if _is_at_anvil:
			_character.anvil_up()
		else:
			_character.bellows_up()
	
	
	if Input.is_action_just_pressed("down"):
		if _is_at_anvil:
			_character.anvil_down()
		else:
			_character.bellows_down()


func _on_QuitButton_pressed():
	_pause_container.visible = false
	get_tree().paused = false
	var err = get_tree().change_scene("res://title_screen/title_screen.tscn")
	ErrorHandler.handle(err)


func _on_ContinueButton_pressed():
	_pause_container.visible = false
	get_tree().paused = false
