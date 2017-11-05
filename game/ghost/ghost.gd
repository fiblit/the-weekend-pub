extends KinematicBody2D

#e[0] = event name
#e[1] = event time
#e[2..-3] = params
#e[-2] = deltat (automatically packed on)
#e[-1] = errort (automattically packed on)

enum FLAG {
	val,
	look_dir,
	deltaT,
	errorT
}
enum EV {
	act,
	val,
	time,
	look_dir,
	deltaT,
	errorT
}
enum VAL {
	up,
	edge_up,
	edge_down,
	down
}
var val_name = {
	VAL.up:"up",
	VAL.edge_up:"edge_up",
	VAL.edge_down:"edge_down",
	VAL.down:"down"
}
enum ACT {
	mv_r,
	mv_l,
	mv_u,
	mv_d,
	pick_up,
	drop_held,
	use_held,
	throw_held,
	lk_r,
	lk_l,
	lk_u,
	lk_d
}
var name_of = {
	ACT.mv_r:"mv_r",
	ACT.mv_l:"mv_l",
	ACT.mv_u:"mv_u",
	ACT.mv_d:"mv_d",
	ACT.pick_up:"pick_up",
	ACT.drop_held:"drop_held",
	ACT.use_held:"use_held",
	ACT.throw_held:"throw_held",
	ACT.lk_r:"lk_r",
	ACT.lk_l:"lk_l",
	ACT.lk_u:"lk_u",
	ACT.lk_d:"lk_d"
}
#ACT: VAL
var action_flags = {}
var look_dir_flag = {}

var look_dir_flag

func anydown(a):
	var av = action_flags[a]
	return av == VAL.down or av == VAL.edge_down

func anyup(a):
	var av = action_flags[a]
	return av == VAL.up or av == VAL.edge_up

func _ready():
	set_process(true)
	for a in ACT.values():
		action_flags[a] = VAL.up

var events = []

func erase():
	events = []

func record(action, value, time, look):
	events += [[action, value, time, look]]

func play(event):
	action_flags[event[EV.act]] = event[EV.val]
	look_dir_flag = event[EV.look_dir]

var playing = false
func play_back():
	# don't do this if a player is controlling the ghost
	playing = true

var play_timer = 0
var play_i = 0
func player(delta):
	var errorT = 0
	if playing:
		var e = events[play_i]
		if e[EV.time] < play_timer:
			errorT = play_timer - e[EV.time]
			play(e)
			play_i += 1
		if play_i >= len(events):
			playing = false
			play_timer = 0
			play_i = 0
		play_timer += delta

#### behavior globals
var drop_dist = 64
var throw_force = 1000

var throw_time = 0
var throw_timer = 0
var thrown = false

var held = null
var use_timer = 0

var can_move = true
var velocity = Vector2(0,0)
var move_speed = 200

var is_dead = false

func _process(delta):
	player(delta)

	#For now look_dir is from mouse - should be right stick in future
	#look_dir = (get_global_mouse_pos() - get_global_pos()).normalized()
	#look_dir = Vector2(anydown(ACT.lk_r) - anydown(ACT.lk_l), anydown(ACT.lk_d) - anydown(ACT.lk_u)).normalized()

	#Walking
	if can_move:
		var ymove = anydown(ACT.mv_u) - anydown(ACT.mv_d)
		if ymove == 1:
			move_up(delta)
		elif ymove == -1:
			move_down(delta)
		var xmove = anydown(ACT.mv_r) - anydown(ACT.mv_l)
		if xmove == 1:
			move_right(delta)
		elif xmove == -1:
			move_left(delta)
	else: #being thrown or carried

		if thrown:
			move(velocity*delta)
			velocity *= 0.9
			if velocity.length() < 1:
				can_move = true
				thrown = false
				velocity = Vector2(0,0)


	#Picking up objects
	if anydown(ACT.pick_up):
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

	if anydown(ACT.drop_held):
		if held != null:
			remove_collision_exception_with(held)
			remove_child(held)
			get_parent().add_child(held)
			held.set_pos(get_pos() + look_dir_flag*drop_dist)
			if held.has_method("set_mode"):
				held.set_mode(held.MODE_CHARACTER)
			if held.has_method("be_carried"):
				held.be_carried(false)
			held = null

	if anydown(ACT.use_held):
		if held != null:
			if look_dir_flag != Vector2(0,0):
				if held.has_method("do_action"):
					held.do_action(look_dir_flag,self)

	if held != null:
		if held.has_method("update_carried"):
			held.update_carried(look_dir_flag)

	if anydown(ACT.throw_held):
		#Same as drop but we call thrown at the end
		if held != null:
			remove_collision_exception_with(held)
			remove_child(held)
			get_parent().add_child(held)
			held.set_pos(get_pos() + look_dir_flag*drop_dist)
			if held.has_method("set_mode"):
				held.set_mode(held.MODE_CHARACTER)
			if held.has_method("be_carried"):
				held.be_carried(false)

			if held.has_method("get_pushed"):
				held.get_pushed(throw_force,look_dir_flag)

		held = null

func be_carried(b):
	can_move = !b
	if b:
		throw_time = 0
		throw_timer = 0

func move_up(delta):
	move(Vector2(0,-move_speed*delta))

func move_down(delta):
	move(Vector2(0,move_speed*delta))

func move_right(delta):
	move(Vector2(move_speed*delta,0))

func move_left(delta):
	move(Vector2(-move_speed*delta,0))

func take_damage(dmg):
	is_dead = true

func get_pushed(force,dir):
	thrown = true
	can_move = false
	velocity = dir*force/2.0
