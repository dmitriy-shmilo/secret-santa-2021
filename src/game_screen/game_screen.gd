extends Node2D


onready var _pause_container: ColorRect = $"Gui/PauseContainer"
onready var _anvil_slot: Node2D = $"AnvilSlot"
onready var _bellows_slot: Node2D = $"BellowsSlot"
onready var _character: Character = $"Character"


func _unhandled_input(event):
	if event.is_action("system_pause"):
		get_tree().paused = true
		_pause_container.visible = true
		


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("left"):
		_character.global_position = _bellows_slot.global_position
		return
	
	if Input.is_action_just_pressed("right"):
		_character.global_position = _anvil_slot.global_position
		return
	
	if Input.is_action_just_pressed("up"):
		_character.anvil_up()
	
	
	if Input.is_action_just_pressed("down"):
		_character.anvil_down()


func _on_QuitButton_pressed():
	_pause_container.visible = false
	get_tree().paused = false
	var err = get_tree().change_scene("res://title_screen/title_screen.tscn")
	ErrorHandler.handle(err)


func _on_ContinueButton_pressed():
	_pause_container.visible = false
	get_tree().paused = false
