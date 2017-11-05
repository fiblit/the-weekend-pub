extends Node2D

export var tooltype = "lazer"
var tl# = preload("res://game/tools/lazer/lazer.tscn")

func _ready():
	tool_removed()

func tool_removed():
	tl = load("res://game/tools/" + tooltype + "/" + tooltype + ".tscn")
	#tl = load("res://game/tools/lazer/lazer.tscn")
	var new_tool = tl.instance()
	add_child(new_tool)
	#new_tool.stored_in = self
