extends KinematicBody2D

onready var doJumpTimer = $doJump
onready var animSprites = $Kid

export var gravity : float = 9.8
export var jumpForce = -550.0
export var xVelocity = 200.0
var velocity : Vector2

func _ready():
	pass

func _input(_event):
	if Input.is_action_just_pressed("Jump"):
		doJumpTimer.start()

func _process(_delta):
	if is_on_floor():
		if abs(velocity.y) >= 25:
			velocity.y = 0.0
			if animSprites.animation == "Fall":
				animSprites.play("Idle")
		if doJumpTimer.time_left > 0.0:
			velocity.y = 0.0
			velocity.y += jumpForce
			animSprites.play("Jump")
		if Input.is_action_just_pressed("Attack") and velocity.x == 0:
			animSprites.play("Attack")
	else:
		if velocity.y < 0.0:
			if Input.is_action_just_released("Jump"):
				velocity.y = velocity.y / 2.0
		elif velocity.y > 0.1:
			animSprites.play("Fall")
		velocity.y += gravity
	
	if animSprites.animation != "Attack":
		#Horizontal Movement
		velocity.x = (-Input.get_action_strength("Left") + Input.get_action_strength("Right")) * xVelocity
		#flip sprite
		if velocity.x != 0:
			animSprites.flip_h = (velocity.x < 0)
			if !(animSprites.animation == "Jump" or animSprites.animation == "Fall"):
				animSprites.play("Run")
		else:
			if !(animSprites.animation == "Jump" or animSprites.animation == "Fall"):
				animSprites.play("Idle")
	
	move_and_slide(velocity, Vector2.UP)

func _on_Kid_animation_finished():
	if animSprites.animation == "Attack":
		animSprites.play("Idle")
