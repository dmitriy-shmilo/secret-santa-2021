extends Node2D
class_name Client

enum ClientState {
	OFF_SCREEN,
	WAITING,
	SATISFIED
}

const MAX_MOOD = 100.0

signal mood_changed(current, total)

var mood_decay_speed = 5.0

var _mood = MAX_MOOD
var _state = ClientState.OFF_SCREEN

func _process(delta) -> void:
	if _state == ClientState.WAITING:
		_mood = clamp(_mood - mood_decay_speed * delta, 0, MAX_MOOD)
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
	emit_signal("mood_changed", _mood, MAX_MOOD)
