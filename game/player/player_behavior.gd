extends KinematicBody2D

export var move_speed = 200

var look_dir = Vector2(0,0)
var drop_dist = 64

var held = null
var use_timer = 0

var am_carried = false

func _ready():
	set_process(true)

func _process(delta):
	#For now look_dir is from mouse - should be right stick in future
	look_dir = (get_global_mouse_pos() - get_global_pos()).normalized()
	
	#Walking
	if !am_carried:
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
	
	#Picking up objects
	if Input.is_action_pressed("pick_up"):
		if held == null:
			for obj in get_node("grab_range").get_overlapping_bodies():
				if obj != self:
					held = obj
					add_collision_exception_with(held)
					held.get_parent().remove_child(held)
					add_child(held)
					held.set_pos(Vector2(0,0))
					if held.has_method("set_mode"):
						held.set_mode(held.MODE_STATIC)
					if held.has_method("be_carried"):
						held.be_carried(true)
					break;
	
	if Input.is_action_pressed("drop_held"):
		if held != null:
			remove_collision_exception_with(held)
			remove_child(held)
			get_parent().add_child(held)
			held.set_pos(get_pos() + look_dir*drop_dist)
			if held.has_method("set_mode"):
				held.set_mode(held.MODE_CHARACTER)
			if held.has_method("be_carried"):
				held.be_carried(false)
			held = null
	
	if Input.is_action_pressed("use_held"):
		if held != null:
			if held.has_method("do_action"):
				held.do_action(look_dir,self)
	
	if held != null:
		if held.has_method("update_carried"):
			held.update_carried(look_dir)
	
	if Input.is_action_pressed("throw_held"):
		#Same as drop but we call thrown at the end
		if held != null:
			remove_collision_exception_with(held)
			remove_child(held)
			get_parent().add_child(held)
			held.set_pos(get_pos() + look_dir*drop_dist)
			if held.has_method("set_mode"):
				held.set_mode(held.MODE_CHARACTER)
			if held.has_method("be_carried"):
				held.be_carried(false)
				
			if held.has_method("be_thrown"):
				held.be_thrown(look_dir)
		
		held = null
		

func be_carried(b):
	am_carried = b
	
func move_up(delta):
	move(Vector2(0,-move_speed*delta))
	#set_pos(get_pos() + (Vector2(0,-move_speed*delta)))
	
func move_down(delta):
	move(Vector2(0,move_speed*delta))
	#set_pos(get_pos() + Vector2(0,move_speed*delta))
	
func move_right(delta):
	move(Vector2(move_speed*delta,0))
	#set_pos(get_pos() + Vector2(move_speed*delta,0))
	
func move_left(delta):
	move(Vector2(-move_speed*delta,0))
	#set_pos(get_pos() + Vector2(-move_speed*delta,0))