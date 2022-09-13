extends KinematicBody2D

const EnemyDeathFX = preload ("res://Effects/EnemyDeathFX.tscn")

onready var stats = $Stats
onready var playerdetection = $PlayerDetection
onready var sprite = $AnimatedSprite
onready var hurtbox = $Hurtbox
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController

export var max_speed = 60
export var acc = 100
export var friction = 150
export var wanderSpeed = 2

enum{
	idle,
	wander,
	chase
}

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

var state = chase

func _ready():
	randomize()
	state = pick_random_state([idle, wander])

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, friction * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		idle:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			seek_player()
			if wanderController.get_time_left() == 0:
				state = pick_random_state([idle, wander])
				wanderController.start_wander_timer(rand_range(1, 3))
			
		wander:
			seek_player()
			if wanderController.get_time_left() == 0:
				state = pick_random_state([idle, wander])
				wanderController.start_wander_timer(rand_range(1, 3))
			
			var direction = global_position.direction_to(wanderController.targetposition)
			velocity = velocity.move_toward(direction * max_speed, acc * delta)
			sprite.flip_h = velocity.x < 0
			
			if global_position.distance_to(wanderController.targetposition) <= wanderSpeed:
				state = pick_random_state([idle, wander])
				wanderController.start_wander_timer(rand_range(1, 3))
			
		chase:
			var player = playerdetection.player
			if player != null:
				var direction = global_position.direction_to(player.global_position)
				velocity = velocity.move_toward(direction * max_speed, acc * delta)
			else:
				state = idle
			sprite.flip_h = velocity.x < 0
			
	if softCollision._is_colliding():
		velocity += softCollision._get_push_vector() * delta * 500
	
	velocity = move_and_slide(velocity)


func seek_player():
	if playerdetection.can_see_player():
		state = chase

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()


func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * 120
	hurtbox.create_hit_effect()
	


func _on_Stats_no_healt():
	queue_free()
	var enemyDeathFX = EnemyDeathFX.instance()
	get_parent().add_child(enemyDeathFX)
	enemyDeathFX.global_position = global_position
