extends KinematicBody2D

var velocity = Vector2(0,0)
var damage = 10

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	if is_colliding():
		var hit = get_collider()
		if hit.has_method("take_damage"):
			hit.take_damage(damage)
		queue_free()
	else:
		move(velocity*delta)
