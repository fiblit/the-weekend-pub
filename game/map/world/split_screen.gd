extends Control

func _ready():
	get_node("right/view").set_world_2d(get_node("left/view").get_world_2d())
	get_node("left/view/world/cam_right").set_custom_viewport(get_node("left/view"))
	get_node("left/view/world/cam_right").make_current()
