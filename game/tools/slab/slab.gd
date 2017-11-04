extends RigidBody2D

var place_dir = Vector2(0,0)
var place_len = 100

var wall = preload("res://game/tools/slab/wall/wall.tscn")

export var use_delay = 2
var use_timer = use_delay

func _ready():
	set_process(true)
	get_node("wall_placement_area/Sprite").set_hidden(true)

func _process(delta):
	use_timer += delta

func be_carried(b):
	get_node("wall_placement_area/Sprite").set_hidden(!b)

func update_carried(dir):
	get_node("wall_placement_area").set_rot(atan2(dir.x,dir.y))

func do_action(dir,person):
	if use_timer >= use_delay:
		get_node("wall_placement_area").set_rot(atan2(dir.x,dir.y))
		if get_node("wall_placement_area").get_overlapping_bodies().size() == 0:
			place_dir = dir
			var new_wall = wall.instance()
			get_node("/root/split_screen/left/view/world/map").add_child(new_wall)
			new_wall.set_global_pos(get_global_pos()+(place_dir*place_len))
			new_wall.set_rot(PI/2 - atan2(place_dir.y,place_dir.x))

			use_timer = 0

func be_thrown(dir):
	apply_impulse(Vector2(0,0),dir*1000)

func get_pushed(force,dir,by):
	apply_impulse(Vector2(0,0),dir*force)