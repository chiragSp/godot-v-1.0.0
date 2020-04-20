extends KinematicBody2D

const MAX_SPEED = 100
const ACCELERATION = 100
const FRICTION = 100
const GRAVITY = 10
const JUMP_FORCE = 280
const FLOOR = Vector2(0,-1)

var velocity = Vector2.ZERO
var direction = 1
var is_dead = false
var max_hp = 100
var current_hp
onready var hp_bar = get_node("Hp_Bar")
var percentage_hp


func _ready() -> void:
	current_hp = max_hp



func Onhit(damage):
	print("i_got_hit")
	current_hp -= damage
	hp_bar.value = int(float(current_hp)/(max_hp) * 100)
	hp_barUpdate()
	if current_hp <= 0:
		Ondeath()
		
func hp_barUpdate():
	percentage_hp = int(float(current_hp)/(max_hp) * 100)
	hp_bar.value = percentage_hp
	if percentage_hp >= 60:
		hp_bar.set_tint_progress("14e114")#green 14e114
	elif percentage_hp <= 60:
		hp_bar.set_tint_progress("e1be32")#oraange e1be32
	else:
		hp_bar.set_tint_progress("e11e1e")#red e11e1e



func Ondeath():
	is_dead = true
	get_node("AnimatedSprite").play("die")
	hp_bar.hide()
	$Timer.start()
	velocity = Vector2(0,0)

func _physics_process(delta):
	if is_dead == false: 
		velocity.x = MAX_SPEED * direction
		if direction == 1:
			$AnimatedSprite.play("walk")
			$AnimatedSprite.flip_h = false
		else:
			$AnimatedSprite.play("walk")
			$AnimatedSprite.flip_h = true

		velocity.y += GRAVITY  
		velocity = move_and_slide(velocity, FLOOR)
	
		if is_on_wall():
			direction = direction * -1
			$RayCast2D.position.x *= -1
	
	
		if $RayCast2D.is_colliding() == false:
			 direction = direction * -1
			 $RayCast2D.position.x *= -1

func _on_Timer_timeout() -> void:
	get_node("CollisionShape2D").set_deferred("disabled", true)
