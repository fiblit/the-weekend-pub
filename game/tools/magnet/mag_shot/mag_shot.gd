extends KinematicBody2D

var velocity = Vector2(0,0)
var force = 1000

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	if is_colliding():
		var hit = get_collider()
		if hit.has_method("get_pushed"):
			hit.get_pushed(force,-velocity.normalized())
		queue_free()
	else:
		move(velocity*delta)
