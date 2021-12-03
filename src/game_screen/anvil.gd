extends Sprite
class_name Anvil

enum AnvilState {
	IN_USE,
	LEFT
}

onready var _animation_player: AnimationPlayer = $"AnimationPlayer"

var _state = AnvilState.IN_USE

func _ready() -> void:
	anvil_use()


func anvil_use() -> void:
	_state = AnvilState.IN_USE
	_animation_player.play("anvil_use")


func anvil_leave() -> void:
	_state = AnvilState.LEFT
	_animation_player.play("anvil_leave")
