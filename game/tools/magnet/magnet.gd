extends RigidBody2D

export var use_delay = .5
var use_timer = use_delay

var shot = preload("res://game/tools/magnet/mag_shot/mag_shot.tscn")
var shot_speed = 5000

func _ready():
	set_process(true)
	set_mode(MODE_CHARACTER)

func _process(delta):
	use_timer += delta

func do_action(dir,person):
	if use_timer >= use_delay:
		var my_shot = shot.instance()
		get_node("/root/Node").add_child(my_shot)
		my_shot.set_global_pos(get_global_pos())
		my_shot.add_collision_exception_with(person)
		my_shot.add_collision_exception_with(person.get_node("tool_collision"))
		my_shot.add_collision_exception_with(self)
		my_shot.set_rot(atan2(dir.x,dir.y) + PI/2)
		
		my_shot.velocity = (dir*shot_speed)
		
		use_timer = 0

func be_thrown(dir):
	apply_impulse(Vector2(0,0),dir*1000)

func get_pushed(force,dir,by):
	apply_impulse(Vector2(0,0),dir*force)