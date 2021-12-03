extends Node2D
class_name Character

enum CharacterState {
	CONFUSED,

	ANVIL_IDLE,
	ANVIL_UP,
	ANVIL_DOWN,

	BELLOWS_IDLE,
	BELLOWS_UP,
	BELLOWS_DOWN
}

onready var _animation_player: AnimationPlayer = $"AnimationPlayer"

var _state = CharacterState.ANVIL_IDLE
var _previous_state = CharacterState.CONFUSED

func _ready() -> void:
	pass # Replace with function body.


func confuse() -> void:
	if _state == CharacterState.CONFUSED:
		print("Prevented double-confuse")
		return

	_previous_state = _state
	_state = CharacterState.CONFUSED
	_animation_player.play("confused")


func unconfuse() -> void:
	match _previous_state:
		CharacterState.ANVIL_DOWN, CharacterState.ANVIL_UP, CharacterState.ANVIL_UP:
			anvil_idle()
		CharacterState.BELLOWS_DOWN, CharacterState.BELLOWS_UP, CharacterState.BELLOWS_UP:
			bellows_idle()


func anvil_up() -> void:
	if _state == CharacterState.ANVIL_IDLE:
		_animation_player.play("anvil_up")
		_state = CharacterState.ANVIL_UP
		return
	
	confuse()


func anvil_down() -> void:
	if _state == CharacterState.ANVIL_UP:
		_animation_player.play("anvil_down")
		_state = CharacterState.ANVIL_DOWN
		return
	
	confuse()


func anvil_idle() -> void:
	if _state in [CharacterState.CONFUSED, CharacterState.ANVIL_DOWN]:
		_animation_player.play("anvil_idle")
		_state = CharacterState.ANVIL_IDLE
		return
	
	confuse()


func bellows_up() -> void:
	if _state == CharacterState.BELLOWS_IDLE:
		_animation_player.play("bellows_up")
		_state = CharacterState.BELLOWS_UP
		return
	
	confuse()


func bellows_down() -> void:
	if _state == CharacterState.BELLOWS_UP:
		_animation_player.play("bellows_down")
		_state = CharacterState.BELLOWS_DOWN
		return
	
	confuse()


func bellows_idle() -> void:
	if _state in [CharacterState.CONFUSED, CharacterState.BELLOWS_DOWN]:
		_animation_player.play("bellows_idle")
		_state = CharacterState.BELLOWS_IDLE
		return
	
	confuse()
	
