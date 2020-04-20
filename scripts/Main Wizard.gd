extends KinematicBody2D


signal health_updated(health)
signal killed()



const MAX_SPEED = 130
const ACCELERATION = 100
const FRICTION = 100
const GRAVITY = 10
const JUMP_FORCE = 200
const FLOOR = Vector2(0,-1)
const FIREBALL = preload("res://main scrn/FireBall.tscn")


var velocity = Vector2.ZERO
var on_ground = true
var is_attacking = false
var damage = 30


func _physics_process(delta):

	
		
		if Input.is_action_pressed("ui_right"):
			if is_attacking == false or is_on_floor() == false:
				velocity.x = MAX_SPEED
				 #with fireballs#
				if is_attacking == false:
					$Sprite.play("walk")
					$Sprite.flip_h = false
					if sign($Position2D.position.x) == -1:
						$Position2D.position.x *= -1
		elif Input.is_action_pressed("ui_left"):
			if is_attacking == false or is_on_floor() == false:
				velocity.x = -MAX_SPEED

				 #with fireballs#

				if is_attacking == false:
					$Sprite.play("walk")
					$Sprite.flip_h = true
					if sign($Position2D.position.x) == 1:
						$Position2D.position.x *= -1
		else:
			velocity.x = 0
			if on_ground == true && is_attacking == false:
				$Sprite.play("idle")
	
		if Input.is_action_pressed("ui_up"):
			if is_attacking == false:
				if on_ground == true:
					velocity.y = -JUMP_FORCE
					$Sprite.play("jump up")
					on_ground = false

		velocity.y += GRAVITY
		
		
		
		if Input.is_action_just_pressed("ui_focus_next") && is_attacking == false:
			if is_on_floor():
				velocity.x = 0
			is_attacking = true
			var fireball = FIREBALL.instance()
			if sign($Position2D.position.x) == 1:
				fireball.set_fireball_direction(1)
				$Sprite.play("Blast attack")
				$Sprite.flip_h = false
			else:
				fireball.set_fireball_direction(-1)
				$Sprite.play("Blast attack")
				$Sprite.flip_h = true
			get_parent().add_child(fireball)
			fireball.position = $Position2D.global_position
			
		if Input.is_action_just_pressed("ui_focus_prev") && is_attacking == false:
				if is_on_floor():
					velocity.x = 0
				is_attacking = true
				$AnimationPlayer.play("melee attack")
				$Sprite.play("melee")
			
			
		if is_on_floor():
			if on_ground == false:
				is_attacking = false
			on_ground = true
		else:
			if is_attacking == false:
				on_ground = false
				if velocity.y < 0:
					$Sprite.play("jump up")
				else:
					$Sprite.play("jump down")
				
				
		velocity = move_and_slide(velocity, FLOOR)


func _on_Sprite_animation_finished() -> void:
	is_attacking = false



func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_in_group("Enemies"):
		body.Onhit(damage)



