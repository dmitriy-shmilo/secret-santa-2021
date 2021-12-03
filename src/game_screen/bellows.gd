extends Sprite
class_name Bellows

enum BellowsState {
	UP,
	DOWN
}

onready var _animation_player: AnimationPlayer = $"AnimationPlayer"

var _state = BellowsState.DOWN

func _ready() -> void:
	bellows_down()


func bellows_down() -> void:
	_state = BellowsState.DOWN
	_animation_player.play("bellows_down")


func bellows_up() -> void:
	_state = BellowsState.UP
	_animation_player.play("bellows_up")
