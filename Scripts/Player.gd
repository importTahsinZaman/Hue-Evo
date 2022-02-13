extends KinematicBody2D

const UP = Vector2(0,-1)
const GRAVITY = 10
const MAX_SPEED = 230
const ACCELERATION = 65
const JUMP_HEIGHT = -200
var velocity = Vector2(0,0)


const BULLET = preload("res://Scenes/Bullet.tscn")
var can_fire = true
var gun_knockback = 80
var shooting = false

var coyote_time = true
var jump_was_pressed = false
var double_jump = false

func _physics_process(delta):
	if !Global.current_player:
		velocity.y += GRAVITY
		velocity.x = 0
		velocity = move_and_slide(velocity, UP)
	else:
		var friction = false
		velocity.y += GRAVITY
		
		if Input.is_action_pressed("right"):
			velocity.x = min(velocity.x + ACCELERATION, MAX_SPEED)
			$Sprite.flip_h = false
			$muzzle_flash.position.x = abs($muzzle_flash.position.x)
			$Gun.position.x = abs($Gun.position.x)
			$RayCast2D.cast_to.y = abs($RayCast2D.cast_to.y)
			gun_knockback = abs(gun_knockback)
			if shooting:
				$Sprite.play("Run_Shoot")
			else:
				$Sprite.play("Run")
		elif Input.is_action_pressed("left"):
			velocity.x = min(velocity.x + ACCELERATION, -MAX_SPEED)
			$Sprite.flip_h = true
			$muzzle_flash.position.x = -1 * abs($muzzle_flash.position.x)
			$Gun.position.x = -1 * abs($Gun.position.x)
			$RayCast2D.cast_to.y = abs($RayCast2D.cast_to.y) * -1
			gun_knockback = abs(gun_knockback) * -1
			if shooting:
				$Sprite.play("Run_Shoot")
			else:
				$Sprite.play("Run")
		else:
			friction = true
			if can_fire:
				$Sprite.play("Idle")
			
		if is_on_floor():
			coyote_time = true
			if jump_was_pressed:
				velocity.y = JUMP_HEIGHT
			
		if Input.is_action_just_pressed("jump"):
			jump_was_pressed = true
			remember_jump_time()
			if coyote_time:
				double_jump = true
				velocity.y = JUMP_HEIGHT
		if friction == true:
			velocity.x = lerp(velocity.x,0,0.2)
			
		if !is_on_floor():
			coyote_time_calc()
			if Input.is_action_just_pressed("jump") and double_jump:
				velocity.y = JUMP_HEIGHT
				double_jump = false
			if velocity.y < 0:
				pass
				$Sprite.play("Jump")
			else:
				pass
				#$Sprite.play("Fall")
			if friction == true:
				velocity.x = lerp(velocity.x,0,0.05)
		
		if Input.is_action_pressed("shoot") and can_fire:
			shooting = true
			if friction:
				$Sprite.play("Stationary_Shoot")
			$AnimationPlayer.play("muzzle_flash_animation")
			shoot()
			velocity = move_and_slide(velocity + Vector2(-gun_knockback, -1))
		elif Input.is_action_pressed("shoot"):
			shooting = true
		else:
			shooting = false
		
		velocity = move_and_slide(velocity, UP)

func shoot():
	for i in range(1):
		var bullet = BULLET.instance()
		bullet.position = $Gun.get_global_position()
		if $Gun.position.x == abs($Gun.position.x):
			bullet.speed = -bullet.speed
		get_tree().root.add_child(bullet)
		get_parent().get_node("MainCamera").shake(180, 0.2, 180)
		if $RayCast2D.is_colliding():
			$RayCast2D.get_collider().play_hit_animation()
			bullet.queue_free()
			freeze_frame(0.1, 0.02)
			$RayCast2D.get_collider().health -= 1
	can_fire = false
	yield(get_tree().create_timer(0.09), "timeout")
	can_fire = true

func coyote_time_calc():
	yield(get_tree().create_timer(.1), "timeout")
	coyote_time = false

func remember_jump_time():
	yield(get_tree().create_timer(.1), "timeout")
	jump_was_pressed = false
	
func freeze_frame(timeScale, duration):
	Engine.time_scale = timeScale
	yield(get_tree().create_timer(duration * timeScale), "timeout")
	Engine.time_scale = 1.0
