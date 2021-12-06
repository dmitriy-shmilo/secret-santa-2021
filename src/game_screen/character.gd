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
	BELLOWS_DOWN,
	
	RUNNING,
	DYING
}

signal progress_made()
signal anvil_run_ended()
signal bellows_run_ended()
signal bellows_raised()
signal bellows_lowered()
signal died()

onready var _animation_player: AnimationPlayer = $"AnimationPlayer"
onready var _voice_player: AudioStreamPlayer = $"VoicePlayer"

var _state = CharacterState.ANVIL_IDLE
var _previous_state = CharacterState.CONFUSED


func _process(_delta: float) -> void:
	if _state == CharacterState.DYING:
		return

	if Input.is_action_just_pressed("left"):
		_transition(CharacterState.BELLOWS_IDLE)
		return
	
	if Input.is_action_just_pressed("right"):
		_transition(CharacterState.ANVIL_IDLE)
		return
	
	if Input.is_action_just_pressed("up"):
		match _state:
			CharacterState.ANVIL_IDLE, CharacterState.ANVIL_DOWN, CharacterState.ANVIL_UP:
				_anvil_up()
			CharacterState.BELLOWS_IDLE, CharacterState.BELLOWS_DOWN, CharacterState.BELLOWS_UP:
				_bellows_up()
		return
	
	
	if Input.is_action_just_pressed("down"):
		match _state:
			CharacterState.ANVIL_IDLE, CharacterState.ANVIL_DOWN, CharacterState.ANVIL_UP:
				_anvil_down()
			CharacterState.BELLOWS_IDLE, CharacterState.BELLOWS_DOWN, CharacterState.BELLOWS_UP:
				_bellows_down()
		return


func die() -> void:
	_state = CharacterState.DYING
	_animation_player.play("die")


func _die_end() -> void:
	emit_signal("died")


func _confuse() -> void:
	if _animation_player.is_playing():
		return


	if _state == CharacterState.CONFUSED:
		print("Prevented double-confuse")
		return

	_previous_state = _state
	_state = CharacterState.CONFUSED
	_animation_player.play("confused")


func _unconfuse() -> void:
	_state = _previous_state


func _anvil_run_end() -> void:
	_state = CharacterState.ANVIL_IDLE
	emit_signal("anvil_run_ended")


func _anvil_up() -> void:
	if _state == CharacterState.ANVIL_IDLE:
		_animation_player.play("anvil_up")
		_voice_player.stream = UP_SOUNDS[randi() % UP_SOUNDS.size()]
		_voice_player.play()
		_state = CharacterState.ANVIL_UP
		return
	
	_confuse()


func _anvil_down() -> void:
	if _state != CharacterState.ANVIL_UP:
		_confuse()
		return

	_animation_player.play("anvil_down")
	_voice_player.stream = DOWN_SOUNDS[randi() % DOWN_SOUNDS.size()]
	_voice_player.play()
	_state = CharacterState.ANVIL_DOWN
	emit_signal("progress_made")	


func _anvil_idle() -> void:
	if _state ==  CharacterState.ANVIL_IDLE:
		return

	if _state in [CharacterState.CONFUSED, CharacterState.RUNNING, CharacterState.ANVIL_DOWN, CharacterState.BELLOWS_IDLE]:
		_animation_player.play("anvil_idle")
		_state = CharacterState.ANVIL_IDLE
		return
	
	_confuse()

func _bellows_run_end() -> void:
	_state = CharacterState.BELLOWS_IDLE
	emit_signal("bellows_run_ended")


func _bellows_up() -> void:
	if _state == CharacterState.BELLOWS_IDLE:
		_animation_player.play("bellows_up")
		_voice_player.stream = UP_SOUNDS[randi() % UP_SOUNDS.size()]
		_voice_player.play()
		_state = CharacterState.BELLOWS_UP
		emit_signal("bellows_raised")
		return
	
	_confuse()


func _bellows_down() -> void:
	if _state != CharacterState.BELLOWS_UP:
		_confuse()
		return

	_animation_player.play("bellows_down")
	_voice_player.stream = DOWN_SOUNDS[randi() % DOWN_SOUNDS.size()]
	_voice_player.play()
	_state = CharacterState.BELLOWS_DOWN
	emit_signal("bellows_lowered")


func _bellows_idle() -> void:
	if _state == CharacterState.BELLOWS_IDLE:
		return

	# TODO: introduce intermediate states
	if _state in [CharacterState.CONFUSED, CharacterState.RUNNING, CharacterState.BELLOWS_DOWN, CharacterState.ANVIL_IDLE]:
		_animation_player.play("bellows_idle")
		_state = CharacterState.BELLOWS_IDLE
		return
	
	_confuse()
	

func _transition(next_state: int) -> void:
	if _state == CharacterState.CONFUSED:
		return
	
	_state = CharacterState.RUNNING
	
	match next_state:
		CharacterState.ANVIL_IDLE:
			_animation_player.play("anvil_run")
		CharacterState.BELLOWS_IDLE:
			_animation_player.play("bellows_run")
		_:
			printerr("Can't transition to ", next_state)
			return
