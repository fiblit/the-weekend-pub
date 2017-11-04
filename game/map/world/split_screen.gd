extends Control

func _ready():
	var rview = get_node("right/view")
	var lview = get_node("left/view")
	var rcam = get_node("left/view/world/player_right/ghost/cam")
	var lcam = get_node("left/view/world/player_left/ghost/cam")
	rview.set_world_2d(lview.get_world_2d())
	rcam.set_custom_viewport(rview)

	rcam.make_current()
	lcam.make_current()
