extends Node2D

const SOUNDTRACKS = [
	preload("res://assets/audio/soundtrack1.mp3"),
	preload("res://assets/audio/soundtrack2.mp3")
]
const CLIENT_COUNT: int = 6
const MAX_DIFFICULTY: float = 2.5
const MIN_DIFFICULTY: float = 0.75
const HEAT_DECREASE_TIME: float = 1.0

onready var _gui: Gui = $"Gui"
onready var _fader: Fader = $"Fader"
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
onready var _soundtrack_player: AudioStreamPlayer = $"SoundtrackPlayer"

var _game_over = false
var _has_order = false
var _max_order_progress = 5
var _order_progress = 0
var _max_heat = 5
var _heat = 0
var _score = 0
var _client_index = 0
var _order_index = 0
var _difficulty = MIN_DIFFICULTY
var _current_soundtrack = 0

func _ready() -> void:
	if Settings.particles:
		$CloudParticles.visible = true
		$CloudParticles.emitting = true
		$StaticClouds.visible = false
	else:
		$CloudParticles.visible = false
		$CloudParticles.emitting = false
		$StaticClouds.visible = true
	
	_soundtrack_player.stream = SOUNDTRACKS[_current_soundtrack]
	_soundtrack_player.play()


func _unhandled_input(event):
	if event.is_action("system_pause"):
		get_tree().paused = true
		_pause_container.visible = true


func _order_increase_progress() -> void:
	if not _has_order:
		printerr("Can't progress empty order")
		return
	
	_order_progress += 1
	if _order_progress >= _max_order_progress:
		_order_ready()
	
	_gui.order_progress(_order_progress, _max_order_progress)


func _heat_increase() -> void:	
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
	
	_order_index = _next_order_index()
	_heat_decrease_timer.start()
	_order_progress = 0
	_anvil.anvil_reset()
	_has_order = true
	_client.set_client_index(_order_index)
	_animation_player.play("client_enter")
	_gui.order_progress(_order_progress, _max_order_progress)
	_gui.reset_for_order(_order_index)
	


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
	_difficulty = clamp(_difficulty * 1.08, 0.0, MAX_DIFFICULTY)
	
	_heat_decrease_timer.wait_time = HEAT_DECREASE_TIME / _difficulty
	_client.mood_decay_speed *= _difficulty


func _order_break() -> void:
	_anvil.anvil_break()
	_order_progress = 0
	_heat = 0
	_gui.order_progress(_order_progress, _max_order_progress)
	_gui.heat_update(_heat, _max_heat)
	_forge.heat_update(_heat, _max_heat)


func _next_order_index() -> int:
	var result = randi() % CLIENT_COUNT
	if result == _order_index:
		result = (result + 1) % CLIENT_COUNT
	return result


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


func _on_HeatDecrease_timeout():
	_heat = clamp(_heat - 1, 0, _max_heat)
	_gui.heat_update(_heat, _max_heat)
	_forge.heat_update(_heat, _max_heat)


func _on_Character_progress_made():
	if _anvil.has_metal():
		_order_increase_progress()
	_anvil.anvil_down()

	if _heat <= 0:
		_order_break()


func _on_Character_bellows_run_ended():
	_anvil.anvil_leave()
	_character.global_position = _bellows_slot.global_position


func _on_Character_anvil_run_ended():
	_bellows.bellows_down()
	_anvil.anvil_use()
	_character.global_position = _anvil_slot.global_position


func _on_Character_bellows_raised():
	_bellows.bellows_up()


func _on_Character_bellows_lowered():
	_bellows.bellows_down()
	_heat_increase()


func _on_Character_died() -> void:
	_fader.fade_out()


func _on_Fader_fade_out_completed() -> void:
	get_tree().change_scene("res://game_over_screen/game_over_screen.tscn")


func _on_Client_state_changed(new_state) -> void:
	match new_state:
		Client.ClientState.DISSATISFIED:
			if not _game_over:
				_game_over = true
				_soundtrack_player.stop()
				_character.die()
				_animation_player.play("client_kill")
		Client.ClientState.WAITING_GOOD, \
		Client.ClientState.WAITING_NORMAL, \
		Client.ClientState.WAITING_BAD:
				_animation_player.play("client_talk")


func _on_SoundtrackPlayer_finished() -> void:
	if _game_over:
		return

	_current_soundtrack = (_current_soundtrack + 1) % SOUNDTRACKS.size()
	_soundtrack_player.stream = SOUNDTRACKS[_current_soundtrack]
	_soundtrack_player.play()
