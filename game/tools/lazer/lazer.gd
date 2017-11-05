extends RigidBody2D

export var use_delay = .5
var use_timer = use_delay

var shot = preload("res://game/tools/lazer/laser_beam/laser_beam.tscn")
var shot_speed = 1000

func _ready():
	set_process(true)

func _process(delta):
	use_timer += delta

func do_action(dir,person):
	if use_timer >= use_delay:
		var my_shot = shot.instance()
		get_node("/root/split_screen/left/view/world/map").add_child(my_shot)
		my_shot.set_global_pos(get_global_pos())
		my_shot.add_collision_exception_with(person)
		my_shot.set_rot(atan2(dir.x,dir.y) + PI/2)

		my_shot.velocity = (dir*shot_speed)

		use_timer = 0

func be_thrown(dir):
	apply_impulse(Vector2(0,0),dir*1000)

func get_pushed(force,dir):
	apply_impulse(Vector2(0,0),dir*force)