extends RigidBody2D

#e[0] = event name
#e[1] = event time
#e[2..-3] = params
#e[-2] = deltat (automatically packed on)
#e[-1] = errort (automattically packed on)

enum FLAG {
	val,
	deltaT,
	errorT
}
enum EV {
	act,
	val,
	time,
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
	mv_d
}
var name_of = {
	ACT.mv_r:"mv_r",
	ACT.mv_l:"mv_l",
	ACT.mv_u:"mv_u",
	ACT.mv_d:"mv_d"
}
#ACT: VAL
var action_flags = {}

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
export var base_speed = 200

func erase():
	events = []

func record(action, value, time):
	events += [[action, value, time]]

func play(event):
	action_flags[event[EV.act]] = event[EV.val]

var playing = false
func play_back():
	# don't do this if a player is controlling the ghost
	playing = true

var play_timer = 0
var play_i = 0
func _process(delta):
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

	#For now look_dir is from mouse - should be right stick in future
	var look_dir = (get_global_mouse_pos() - get_global_pos()).normalized()

	move_y(anydown(ACT.mv_d) - anydown(ACT.mv_u))
	move_x(anydown(ACT.mv_r) - anydown(ACT.mv_l))

func move_y(dir):
	set_linear_velocity(Vector2(get_linear_velocity().x, dir*base_speed))

func move_x(dir):
	set_linear_velocity(Vector2(dir*base_speed, get_linear_velocity().y))
