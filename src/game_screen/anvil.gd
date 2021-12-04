extends Sprite
class_name Anvil

enum AnvilState {
	IN_USE,
	LEFT
}

const DOWN_SOUNDS = [
	preload("res://assets/audio/ding.wav")
]

onready var _animation_player: AnimationPlayer = $"AnimationPlayer"
onready var _audio_player: AudioStreamPlayer = $"AudioPlayer"
onready var _metal_sprite: AnimatedSprite = $"MetalSprite"

var _state = AnvilState.IN_USE

func _ready() -> void:
	anvil_use()


func anvil_use() -> void:
	_state = AnvilState.IN_USE
	_animation_player.play("anvil_use")


func anvil_leave() -> void:
	_state = AnvilState.LEFT
	_animation_player.play("anvil_leave")


func anvil_down() -> void:
	_audio_player.stream = DOWN_SOUNDS[randi() % DOWN_SOUNDS.size()]
	_audio_player.play()


func anvil_break() -> void:
	_metal_sprite.frame = 0
	_metal_sprite.play()
	

func anvil_reset() -> void:
	_metal_sprite.frame = 0
	_metal_sprite.stop()
	_animation_player.play("anvil_reset")

func anvil_done() -> void:
	# TODO: show an item here
	_metal_sprite.visible = false
