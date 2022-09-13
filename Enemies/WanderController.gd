extends Node2D

export (int) var wanderrange = 2

onready var startposition = global_position
onready var targetposition = global_position

onready var timer = $Timer

func _ready():
	_update_target_position()

func _update_target_position():
	var target_vector =  Vector2(rand_range(-wanderrange,wanderrange), rand_range(-wanderrange,wanderrange))
	targetposition = targetposition + startposition
	

func get_time_left():
	return timer.time_left
	
func start_wander_timer(duration):
	timer.start(duration)


func _on_Timer_timeout():
	_update_target_position()
