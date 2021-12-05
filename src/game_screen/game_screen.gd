extends Node2D


onready var _gui: Gui = $"Gui"
onready var _pause_container: ColorRect = $"Gui/PauseContainer"
onready var _anvil_slot: Node2D = $"AnvilSlot"
onready var _bellows_slot: Node2D = $"BellowsSlot"
onready var _character: Character = $"Character"
onready var _client: Client = $"Client"
onready var _anvil: Anvil = $"Anvil"
onready var _bellows: Bellows = $"Bellows"
onready var _animation_player: AnimationPlayer = $"AnimationPlayer"
onready var _order_delay_timer: Timer = $"OrderDelay"
onready var _heat_decrease_timer: Timer = $"HeatDecrease"
onready var _forge: Forge = $"Forge"

var _is_at_anvil = true
var _has_order = false
var _max_order_progress = 5
var _order_progress = 0
var _max_heat = 5
var _heat = 0
var _score = 0

func _unhandled_input(event):
	if event.is_action("system_pause"):
		get_tree().paused = true
		_pause_container.visible = true


func _process(_delta: float) -> void:
	# TODO: move these actions to character 
	# TODO: get rid of _is_at_anvil
	if Input.is_action_just_pressed("left"):
		_character.transition(Character.CharacterState.BELLOWS_IDLE)
		return
	
	if Input.is_action_just_pressed("right"):
		_character.transition(Character.CharacterState.ANVIL_IDLE)
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


func _order_increase_progress() -> void:
	if not _has_order:
		printerr("Can't progress empty order")
		return
	
	_order_progress += 1
	if _order_progress >= _max_order_progress:
		_order_ready()
	
	_gui.order_progress(_order_progress, _max_order_progress)


func _heat_increase() -> void:
	if not _has_order:
		printerr("Can't heat with empty order")
		return
	
	_heat_decrease_timer.start()
	
	_heat += 1
	if _heat > _max_heat:
		_order_break()
	
	_gui.heat_update(_heat, _max_heat)
	_forge.heat_update(_heat, _max_heat)


func _order_item() -> void:
	if _has_order:
		printerr("Order is already in progress")
		return
	
	_heat_decrease_timer.start()
	_max_order_progress = 5
	_order_progress = 0
	_max_heat = 5
	_heat = 0
	_anvil.anvil_reset()
	_has_order = true
	_animation_player.play("client_enter")
	_gui.order_progress(_order_progress, _max_order_progress)
	_gui.reset_for_order()
	


func _order_ready() -> void:
	if not _has_order:
		printerr("Can't ready empty order")
		return
	
	_has_order = false
	_score += _client.get_score()
	_animation_player.play("client_leave")
	_order_delay_timer.start()
	_anvil.anvil_done()

	_gui.order_ready()
	_gui.score_update(_client.get_score(), _score)


func _order_break() -> void:
	_anvil.anvil_break()
	_order_progress = 0
	_heat = 0
	_gui.order_progress(_order_progress, _max_order_progress)
	_gui.heat_update(_heat, _max_heat)
	_forge.heat_update(_heat, _max_heat)


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


func _on_Character_progress_made():
	if _anvil.has_metal():
		_order_increase_progress()
	_anvil.anvil_down()

	if _heat <= 0:
		_order_break()


func _on_Character_heat_increased():
	_heat_increase()
	_bellows.bellows_down()


func _on_HeatDecrease_timeout():
	_heat = clamp(_heat - 1, 0, _max_heat)
	_gui.heat_update(_heat, _max_heat)
	_forge.heat_update(_heat, _max_heat)


func _on_Character_bellows_run_started():
	_is_at_anvil = false
	_anvil.anvil_leave()
	_character.bellows_idle() # move to Character?
	_character.global_position = _bellows_slot.global_position


func _on_Character_anvil_run_started():
	_is_at_anvil = true
	_bellows.bellows_down()
	_anvil.anvil_use()
	_character.anvil_idle()
	_character.global_position = _anvil_slot.global_position


func _on_Character_bellows_raised():
	_bellows.bellows_up()


func _on_Character_bellows_lowered():
	_bellows.bellows_down()
