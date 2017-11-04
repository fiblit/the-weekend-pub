extends KinematicBody2D

var velocity = Vector2(0,0)
var can_move = true
var throw_time = 0
var throw_timer = 0
var thrown_by = null

func _ready():
	set_process(true)

func _process(delta):
	#Walking
	if can_move:
		pass
	else: #being thrown or carried
		if throw_time != 0:
			move(velocity*delta)
			velocity * 0.8
			throw_timer += delta
			if throw_timer > throw_time:
				remove_collision_exception_with(thrown_by)
				throw_time = 0
				throw_timer = 0
				can_move = true

func take_damage(dmg):
	queue_free()

func get_pushed(force,dir,by):
	thrown_by = by
	add_collision_exception_with(thrown_by)
	can_move = false
	velocity = dir*force/10
	throw_time = force #/2000.0