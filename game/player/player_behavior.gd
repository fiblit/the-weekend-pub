extends KinematicBody2D

export var move_speed = 200

var look_dir = Vector2(0,0)

func _ready():
	set_process(true)

func _process(delta):
	#For now look_dir is from mouse - should be right stick in future
	look_dir = (get_global_mouse_pos() - get_global_pos()).normalized()
	
	var ymove = Input.is_action_pressed("mv_up") - Input.is_action_pressed("mv_down")
	if ymove == 1:
		move_up(delta)
	elif ymove == -1:
		move_down(delta)
	var xmove = Input.is_action_pressed("mv_right") - Input.is_action_pressed("mv_left")
	if xmove == 1:
		move_right(delta)
	elif xmove == -1:
		move_left(delta)
		
func move_up(delta):
	set_pos(get_pos() + Vector2(0,-move_speed*delta))

func move_down(delta):
	set_pos(get_pos() + Vector2(0,move_speed*delta))

func move_right(delta):
	set_pos(get_pos() + Vector2(move_speed*delta,0))

func move_left(delta):
	set_pos(get_pos() + Vector2(-move_speed*delta,0))