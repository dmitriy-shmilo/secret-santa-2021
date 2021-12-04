extends Node2D


onready var _gui: Gui = $"Gui"
onready var _pause_container: ColorRect = $"Gui/PauseContainer"
onready var _anvil_slot: Node2D = $"AnvilSlot"
onready var _bellows_slot: Node2D = $"BellowsSlot"
onready var _character: Character = $"Character"
onready var _anvil: Anvil = $"Anvil"
onready var _bellows: Bellows = $"Bellows"
onready var _animation_player: AnimationPlayer = $"AnimationPlayer"
onready var _order_delay_timer: Timer = $"OrderDelay"

var _is_at_anvil = true
var _has_order = false
var _max_order_progress = 5
var _order_progress = 0

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
			_order_progress()
		else:
			_character.bellows_down()
			_bellows.bellows_down()


func _order_progress() -> void:
	if not _has_order:
		printerr("Can't progress empty order")
		return
	
	_order_progress += 1
	if _order_progress >= _max_order_progress:
		_order_ready()
	
	_gui.order_progress(_order_progress, _max_order_progress)


func _order_item() -> void:
	if _has_order:
		printerr("Order is already in progress")
		return
	
	_max_order_progress = 5
	_order_progress = 0
	_has_order = true
	_animation_player.play("client_enter")
	_gui.order_progress(_order_progress, _max_order_progress)
	_gui.show_order()
	


func _order_ready() -> void:
	if not _has_order:
		printerr("Can't ready empty order")
		return
	
	_has_order = false
	_animation_player.play("client_leave")
	_gui.order_ready()
	_order_delay_timer.start()


func _on_QuitButton_pressed():
	_pause_container.visible = false
	get_tree().paused = false
	var err = get_tree().change_scene("res://title_screen/title_screen.tscn")
	ErrorHandler.handle(err)


func _on_ContinueButton_pressed():
	_pause_container.visible = false
	get_tree().paused = false


func _on_OrderDelay_timeout():
	_order_item()
