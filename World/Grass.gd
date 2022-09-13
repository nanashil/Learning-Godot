extends Node2D

#func _process(delta):
#	if Input.is_action_just_pressed("Attack"):
#
#		var GrassFX = load("res://Effects/GrassFX.tscn")
#		var grassFX = GrassFX.instance()
#		var world = get_tree().current_scene
#		world.add_child(grassFX)
#		grassFX.global_position = global_position
#
#		queue_free()
#
#		This line of code is for test purposes and also a good cheatsheet
const GrassFX = preload ("res://Effects/GrassEffect.tscn")

func create_grass_effect():
		var grassFX = GrassFX.instance()
		get_parent().add_child(grassFX)
		grassFX.global_position = global_position

func _on_Hurtbox_area_entered(area):
	create_grass_effect()
	queue_free()
