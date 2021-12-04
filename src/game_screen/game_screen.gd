extends Node2D


onready var _pause_container: ColorRect = $"Gui/PauseContainer"
onready var _anvil_slot: Node2D = $"AnvilSlot"
onready var _bellows_slot: Node2D = $"BellowsSlot"
onready var _character: Character = $"Character"
onready var _anvil: Anvil = $"Anvil"
onready var _bellows: Bellows = $"Bellows"
onready var _animation_player: AnimationPlayer = $"AnimationPlayer"

var _is_at_anvil = true
var _has_order = false

func _unhandled_input(event):
	if event.is_action("system_pause"):
		get_tree().paused = true
		_pause_container.visible = true
		


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("left"):
		_is_at_anvil = false
		_anvil.anvil_leave()
		_character.bellows_idle()
		_character.global_position = _bellows_slot.global_position
		return
	
	if Input.is_action_just_pressed("right"):
		_is_at_anvil = true
		_anvil.anvil_use()
		_character.anvil_idle()
		_character.global_position = _anvil_slot.global_position
		return
	
	if Input.is_action_just_pressed("up"):
		if _is_at_anvil:
			_character.anvil_up()
		else:
			_character.bellows_up()
			_bellows.bellows_up()
	
	
	if Input.is_action_just_pressed("down"):
		if _is_at_anvil:
			_character.anvil_down()
			_anvil.anvil_down()
		else:
			_character.bellows_down()
			_bellows.bellows_down()


func order_item() -> void:
	if _has_order:
		printerr("Order is already in progress")
		return
	
	_has_order = true
	_animation_player.play("client_enter")


func order_ready() -> void:
	if not _has_order:
		printerr("Can't ready empty order")
		return
	
	_has_order = false
	_animation_player.play("client_leave")


func _on_QuitButton_pressed():
	_pause_container.visible = false
	get_tree().paused = false
	var err = get_tree().change_scene("res://title_screen/title_screen.tscn")
	ErrorHandler.handle(err)


func _on_ContinueButton_pressed():
	_pause_container.visible = false
	get_tree().paused = false
