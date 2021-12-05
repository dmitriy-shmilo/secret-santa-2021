extends Sprite
class_name Forge

const SMOKE_SCENE = preload("res://game_screen/smoke_explosion.tscn")
const FIRE_SCENE = preload("res://game_screen/fire_explosion.tscn")

onready var _smoke = $"Smoke"
onready var _fire = $"Fire"

var _heat = 0

func heat_update(current: float, total: float) -> void:
	
	if _heat >= current:
		_heat = current
		return

	_heat = current

	var smoke = SMOKE_SCENE.instance()
	add_child(smoke)
	smoke.position = _smoke.position
	smoke.restart()

	var fire = FIRE_SCENE.instance()
	add_child(fire)
	fire.position = _fire.position
	fire.restart()
	
	var timer = Timer.new()
	timer.start(max(smoke.lifetime * 2, fire.lifetime * 2))
	
	yield(timer, "timeout")
	smoke.queue_free()
	fire.queue_free()
	timer.queue_free()
