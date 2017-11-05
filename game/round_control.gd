extends Node

export var round_time = 60
var round_timer = 0

var round_stage = 0

var player_plat = null

func _ready():
	pass

func _process(delta):
	if round_stage == 1: #Select your starting spot and people you want to send out
		if player_plat != null:
			switch_to_stage(1)
	elif round_stage == 1:
		round_timer += delta
		if round_timer >= round_time:
			#Save the player's ghost and go back to stage 1
			pass

func switch_to_stage(stage):
	if stage == 0:
		pass
	elif stage == 1:
		for plat in get_tree().get_nodes_in_group("platforms"):
			if !plat.selected:
				#Disable people on non-selected pedestals
				round_stage = 0