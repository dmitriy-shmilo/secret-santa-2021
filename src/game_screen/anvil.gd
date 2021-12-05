extends Sprite
class_name Anvil

enum AnvilState {
	IN_USE,
	LEFT
}

enum MetalState {
	PRESENT,
	GONE
}

const DOWN_SOUNDS = [
	preload("res://assets/audio/ding.wav")
]

onready var _animation_player: AnimationPlayer = $"AnimationPlayer"
onready var _metal_animation_player: AnimationPlayer = $"MetalAnimationPlayer"
onready var _audio_player: AudioStreamPlayer = $"AudioPlayer"
onready var _metal_sprite: AnimatedSprite = $"MetalSprite"

var _state = AnvilState.IN_USE
var _metal_state = MetalState.PRESENT

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
	_metal_animation_player.play("metal_break")
	_metal_state = MetalState.GONE

func anvil_reset() -> void:
	_metal_sprite.frame = 0
	_metal_sprite.stop()
	_metal_animation_player.play("metal_reset")
	_metal_state = MetalState.PRESENT


func anvil_done() -> void:
	# TODO: show an item here
	_metal_sprite.visible = false
	_metal_state = MetalState.GONE
	

func has_metal() -> bool:
	return _metal_state == MetalState.PRESENT
