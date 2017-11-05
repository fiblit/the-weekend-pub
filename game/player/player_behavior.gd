extends Node

export var pid = 0
var g

func _ready():
	g = get_node("ghost")
	set_process(true)

var time = 0
func _process(delta):
	if g != null and not g.is_dead:
		for a in g.ACT.values():
			var change = false
			var candidate = g.action_flags[a]
			var val = g.action_flags[a]
			if Input.is_action_pressed("p"+str(pid)+"_"+g.name_of[a]):
				# up key = off
				# down key = on
				if val == g.VAL.up or val == g.VAL.edge_up:
					candidate = g.VAL.edge_down
					change = true
				elif val == g.VAL.edge_down:
					candidate = g.VAL.down
					change = true
			else:
				if val == g.VAL.down or val == g.VAL.edge_down:
					candidate = g.VAL.edge_up
					change = true
				elif val == g.VAL.edge_up:
					candidate = g.VAL.up
					change = true
			if change == true:
				g.record(a, candidate, time)
				g.play([a, candidate, time])
		time += delta
	elif g != null: #no ghooooost, _you_ died!
		#save the ghoooost!/move to roster
		remove_child(g)
		g = null
