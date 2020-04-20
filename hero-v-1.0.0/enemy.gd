extends KinematicBody2D

const gravity=10
const speed=50
const Floor=Vector2(0,-1)
var dir = 1
var velocity = Vector2()
func _ready():
	pass
func _physics_process(delta):
	velocity.x = speed * dir
	velocity.y += gravity
	velocity = move_and_slide(velocity,Floor)


	if is_on_wall():
		dir = dir*-1




