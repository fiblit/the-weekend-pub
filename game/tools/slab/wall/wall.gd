extends StaticBody2D

export var max_health = 30
var health = max_health

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func take_damage(dmg):
	health -= dmg
	if health <= 0:
		queue_free()
