extends Node2D
class_name Character

onready var _animation_player: AnimationPlayer = $"AnimationPlayer"

func _ready() -> void:
	pass # Replace with function body.


func anvil_up() -> void:
	_animation_player.play("anvil_up")


func anvil_down() -> void:
	_animation_player.play("anvil_down")


func anvil_idle() -> void:
	_animation_player.play("anvil_idle")


func bellows_up() -> void:
	_animation_player.play("bellows_up")


func bellows_down() -> void:
	_animation_player.play("bellows_down")


func bellows_idle() -> void:
	_animation_player.play("bellows_idle")
	
