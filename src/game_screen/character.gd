extends Node2D
class_name Character

const UP_SOUNDS = [
	preload("res://assets/audio/up1.wav"),
	preload("res://assets/audio/up2.wav"),
	preload("res://assets/audio/up3.wav"),
]

const DOWN_SOUNDS = [
	preload("res://assets/audio/down1.wav"),
	preload("res://assets/audio/down2.wav"),
	preload("res://assets/audio/down3.wav"),
]

enum CharacterState {
	CONFUSED,

	ANVIL_IDLE,
	ANVIL_UP,
	ANVIL_DOWN,

	BELLOWS_IDLE,
	BELLOWS_UP,
	BELLOWS_DOWN
}

signal progress_made()

onready var _animation_player: AnimationPlayer = $"AnimationPlayer"
onready var _voice_player: AudioStreamPlayer = $"VoicePlayer"

var _state = CharacterState.ANVIL_IDLE
var _previous_state = CharacterState.CONFUSED

func _ready() -> void:
	pass # Replace with function body.


func confuse() -> void:
	if _animation_player.is_playing():
		return

	if _state == CharacterState.CONFUSED:
		print("Prevented double-confuse")
		return

	_previous_state = _state
	_state = CharacterState.CONFUSED
	_animation_player.play("confused")


func unconfuse() -> void:
	_state = _previous_state
	return
# TODO: consider returning to idle state instead
#	match _previous_state:
#		CharacterState.ANVIL_DOWN, CharacterState.ANVIL_UP, CharacterState.ANVIL_IDLE:
#			anvil_idle()
#		CharacterState.BELLOWS_DOWN, CharacterState.BELLOWS_UP, CharacterState.BELLOWS_IDLE:
#			bellows_idle()


func anvil_up() -> void:
	if _state == CharacterState.ANVIL_IDLE:
		_animation_player.play("anvil_up")
		_voice_player.stream = UP_SOUNDS[randi() % UP_SOUNDS.size()]
		_voice_player.play()
		_state = CharacterState.ANVIL_UP
		return
	
	confuse()


func anvil_down() -> void:
	if _state != CharacterState.ANVIL_UP:
		confuse()
		return

	_animation_player.play("anvil_down")
	_voice_player.stream = DOWN_SOUNDS[randi() % DOWN_SOUNDS.size()]
	_voice_player.play()
	_state = CharacterState.ANVIL_DOWN
	emit_signal("progress_made")	


func anvil_idle() -> void:
	if _state ==  CharacterState.ANVIL_IDLE:
		return

	if _state in [CharacterState.CONFUSED, CharacterState.ANVIL_DOWN, CharacterState.BELLOWS_IDLE]:
		_animation_player.play("anvil_idle")
		_state = CharacterState.ANVIL_IDLE
		return
	
	confuse()


func bellows_up() -> void:
	if _state == CharacterState.BELLOWS_IDLE:
		_animation_player.play("bellows_up")
		_voice_player.stream = UP_SOUNDS[randi() % UP_SOUNDS.size()]
		_voice_player.play()
		_state = CharacterState.BELLOWS_UP
		return
	
	confuse()


func bellows_down() -> void:
	if _state == CharacterState.BELLOWS_UP:
		_animation_player.play("bellows_down")
		_voice_player.stream = DOWN_SOUNDS[randi() % DOWN_SOUNDS.size()]
		_voice_player.play()
		_state = CharacterState.BELLOWS_DOWN
		return
	
	confuse()


func bellows_idle() -> void:
	if _state == CharacterState.BELLOWS_IDLE:
		return

	# TODO: introduce intermediate states
	if _state in [CharacterState.CONFUSED, CharacterState.BELLOWS_DOWN, CharacterState.ANVIL_IDLE]:
		_animation_player.play("bellows_idle")
		_state = CharacterState.BELLOWS_IDLE
		return
	
	confuse()
	
