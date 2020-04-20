extends KinematicBody2D
const speed = 80
const g = 10
const jump = -280
const FLOOR = Vector2(0,-1)
var velocity = Vector2()
var ground = false

func _physics_process(delta):

	if Input.is_action_pressed("ui_right"):
		velocity.x = speed
		$AnimatedSprite.play("run")
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -speed
		$AnimatedSprite.play("run-L")
	else:
		velocity.x = 0
		if ground==true:
			$AnimatedSprite.play("ideal")

	if Input.is_action_pressed("ui_up"):
		if ground == true:
			velocity.y = jump
	ground = false

	velocity.y += g
	if is_on_floor():
		ground = true
	else:
		ground=false
	if velocity.y<0:
		$AnimatedSprite.play("jump")
	#else:
	#	$AnimatedSprite.play("fall")
	velocity = move_and_slide(velocity,FLOOR)
