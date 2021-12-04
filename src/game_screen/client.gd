extends Node2D
class_name Client

enum ClientState {
	OFF_SCREEN,
	WAITING,
	SATISFIED
}

const MAX_MOOD = 100.0
const GOOD_MOOD_OFFSET = 32
const NORMAL_MOOD_OFFSET = GOOD_MOOD_OFFSET + 16
const BAD_MOOD_OFFSET = GOOD_MOOD_OFFSET + 32

signal mood_changed(current, total)

var mood_decay_speed = 5.0

onready var _mood_indicator: Sprite = $"MoodIndicator"
onready var _mood_progress: TextureProgress = $"MoodProgress"

var _mood = MAX_MOOD
var _state = ClientState.OFF_SCREEN

func _process(delta) -> void:
	if _state == ClientState.WAITING:
		_mood = clamp(_mood - mood_decay_speed * delta, 0, MAX_MOOD)
		_update_ui()
		emit_signal("mood_changed", _mood, MAX_MOOD)


func start_waiting() -> void:
	if _state == ClientState.WAITING:
		printerr("Client is already waiting")
		return

	_state = ClientState.WAITING


func go_offscreen() -> void:
	if _state == ClientState.OFF_SCREEN:
		printerr("Client is already off screen")
		return
	
	_state = ClientState.OFF_SCREEN
	_reset()


func satisfy() -> void:
	if _state != ClientState.WAITING:
		printerr("Can't satisfy client while not waiting")
		return
	
	_state = ClientState.SATISFIED


func generate_client() -> void:
	if _state != ClientState.OFF_SCREEN:
		printerr("Client can't be generated while on screen")
		return
	
	# TODO: pick a different character, with a respective item and voice


func _reset() -> void:
	_mood = MAX_MOOD
	_update_ui()
	emit_signal("mood_changed", _mood, MAX_MOOD)

func _update_ui() -> void:
	_mood_progress.value = _mood
	if _mood <= MAX_MOOD / 3.0:
		_mood_indicator.region_rect.position.y = BAD_MOOD_OFFSET
	elif _mood >= MAX_MOOD / 1.5:
		_mood_indicator.region_rect.position.y = GOOD_MOOD_OFFSET
	else:
		_mood_indicator.region_rect.position.y = NORMAL_MOOD_OFFSET
