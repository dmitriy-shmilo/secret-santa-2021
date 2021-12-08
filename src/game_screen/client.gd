extends Node2D
class_name Client

enum ClientState {
	OFF_SCREEN,
	WAITING_GOOD,
	WAITING_NORMAL,
	WAITING_BAD,
	DISSATISFIED,
	SATISFIED
}

const MAX_MOOD = 100.0
const GOOD_MOOD_OFFSET = 32
const NORMAL_MOOD_OFFSET = GOOD_MOOD_OFFSET + 16
const BAD_MOOD_OFFSET = GOOD_MOOD_OFFSET + 32
const ZERO_MOOD_OFFSET = GOOD_MOOD_OFFSET + 48
const SPRITE_OFFSET = 64
const SPRITE_HEIGHT = 64

signal state_changed(new_state)

var mood_decay_speed = 2.0

onready var _body: Sprite = $"Body"
onready var _mood_indicator: Sprite = $"MoodIndicator"
onready var _mood_progress: TextureProgress = $"MoodProgress"

var _mood = MAX_MOOD
var _state = ClientState.OFF_SCREEN

func _process(delta) -> void:
	if _state in [ClientState.WAITING_GOOD, ClientState.WAITING_NORMAL, ClientState.WAITING_BAD]:
		_mood = clamp(_mood - mood_decay_speed * delta, 0, MAX_MOOD)
		_update_ui()
		
		var old_state = _state
		if _mood <= 0.0:
			_state = ClientState.DISSATISFIED
		elif _mood <= MAX_MOOD / 3.0:
			_state = ClientState.WAITING_BAD
		elif _mood >= MAX_MOOD / 1.5:
			_state = ClientState.WAITING_GOOD
		else:
			_state = ClientState.WAITING_NORMAL
		
		if _state != old_state:
			emit_signal("state_changed", _state)


func start_waiting() -> void:
	if _state in [ClientState.WAITING_GOOD, ClientState.WAITING_NORMAL, ClientState.WAITING_BAD]:
		printerr("Client is already waiting")
		return

	_state = ClientState.WAITING_GOOD


func go_offscreen() -> void:
	if _state == ClientState.OFF_SCREEN:
		printerr("Client is already off screen")
		return
	
	_state = ClientState.OFF_SCREEN
	_reset()


func satisfy() -> void:
	if not _state in [ClientState.WAITING_GOOD, ClientState.WAITING_NORMAL, ClientState.WAITING_BAD]:
		printerr("Can't satisfy client while not waiting")
		return
	
	_state = ClientState.SATISFIED


func set_client_index(index: int) -> void:
	if _state != ClientState.OFF_SCREEN:
		printerr("Client can't be changed while on screen")
		return
	
	_body.region_rect.position.y = index * SPRITE_HEIGHT + SPRITE_OFFSET
	

func get_score() -> float:
	return _mood


func _reset() -> void:
	_mood = MAX_MOOD
	_update_ui()


func _update_ui() -> void:
	_mood_progress.value = _mood
	if _mood <= 0.0:
		_mood_indicator.region_rect.position.y = ZERO_MOOD_OFFSET
	elif _mood <= MAX_MOOD / 3.0:
		_mood_indicator.region_rect.position.y = BAD_MOOD_OFFSET
	elif _mood >= MAX_MOOD / 1.5:
		_mood_indicator.region_rect.position.y = GOOD_MOOD_OFFSET
	else:
		_mood_indicator.region_rect.position.y = NORMAL_MOOD_OFFSET
