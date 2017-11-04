extends RigidBody2D

var laser_dir = Vector2(0,0)
var laser_len = 100

func _ready():
	#set_process(true)
	pass

func do_action(dir):
	laser_dir = dir
	print("Fire towards " + str(dir))