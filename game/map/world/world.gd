extends Node

var lcam
var lpos
var rcam
var rpos

func _ready():
	set_process(true)
	rcam = get_node("player_right/cam")
	rpos = rcam.get_pos()
	lcam = get_node("player_left/cam")
	lpos = lcam.get_pos()

var time = 0
func _process(delta):
	pass
	time += delta
	if (time > 10):
		cam_to_stage()
	elif (time > 5):
		cam_to_shack()

func cam_to_stage():
	rcam.set_pos(rpos)
	lcam.set_pos(lpos)

func cam_to_shack():
	rcam.set_pos(rpos + Vector2(1024, 0))
	lcam.set_pos(lpos - Vector2(1024, 0))
