extends KinematicBody2D

export var acc = 500
export var max_speed = 85
export var roll_speed = 120
export var friction = 500


enum {
	move,
	roll,
	atk
}

var velocity = Vector2.ZERO
var state = move
var roll_vector = Vector2.DOWN
var stats = PlayerStats

onready var animationplayer = $AnimationPlayer
onready var animationtree = $AnimationTree
onready var animationstate = animationtree.get("parameters/playback")
onready var SwordHitbox = $"Hitbox pivot/SwordHitbox"
onready var hurtbox = $Hurtbox

func _ready():
	animationtree.active = true
	SwordHitbox.knockback_vector = roll_vector
	stats.connect("no_healt", self, "queue_free")

func _physics_process(delta):
	match state:
		move:
			move_state(delta)
		
		roll:
			roll_state(delta)
		
		atk:
			atk_state(delta)
		

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		SwordHitbox.knockback_vector = input_vector
		animationtree.set("parameters/Idle/blend_position", input_vector)
		animationtree.set("parameters/Run/blend_position", input_vector)
		animationtree.set("parameters/Atk/blend_position", input_vector)
		animationtree.set("parameters/Roll/blend_position", input_vector)
		animationstate.travel("Run")
		velocity = velocity.move_toward(input_vector * max_speed, acc * delta)
	else:
		animationstate.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	move()
	
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("Attack"):
		state = atk
	
	if Input.is_action_just_pressed("Roll"):
		hurtbox.start_Iframe(0.5)
		state = roll

func roll_state(delta):
	velocity = roll_vector * roll_speed
	animationstate.travel("Roll")
	move()

func atk_state(delta):
	animationstate.travel("Atk")
	velocity = Vector2.ZERO

func move():
	velocity = move_and_slide(velocity)

func roll_animation_finish():
	velocity = velocity * 0.5
	state = move


func atk_animation_end():
	state = move


func _on_Hurtbox_area_entered(area):
	stats.health -= 1
	hurtbox.start_Iframe(1)
	hurtbox.create_hit_effect()
