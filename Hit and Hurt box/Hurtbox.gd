extends Area2D

const HitEffect = preload ("res://Effects/HitEffect.tscn")

onready var timer = $Timer

var Iframe = false setget set_Iframe

signal Iframe_start
signal Iframe_end

func set_Iframe(value):
	Iframe = value
	if Iframe == true:
		emit_signal("Iframe_start")
	else:
		emit_signal("Iframe_end")

func start_Iframe(duration):
	self.Iframe = true
	timer.start(duration)
	
func create_hit_effect():
	var effect = HitEffect.instance()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position


func _on_Timer_timeout():
	self.Iframe = false


func _on_Hurtbox_Iframe_start():
	set_deferred("monitoring", false)

func _on_Hurtbox_Iframe_end():
	set_deferred("monitoring", true)
	#both this functions must be deffered and it's monitoring not monitorable, solved the Iframes not working problem
