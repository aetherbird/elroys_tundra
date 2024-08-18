extends CharacterBody2D

const SPEED = 340.0
const JUMP_VELOCITY = -750.0
var current_direction = "right"
@onready var sprite_2d = $ElroySprite
@export var particle : PackedScene
@onready var audio_stream_jump = $Audio/AudioStreamJump
@onready var audio_stream_double_jump = $Audio/AudioStreamDoubleJump

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jump_count = 0

func _ready():
	if (current_direction == "left"):
		sprite_2d.flip_h = true
		sprite_2d.play("idle")
	elif (current_direction == "right"):
		sprite_2d.flip_h = false
		sprite_2d.play("idle")

func jump():
	velocity.y = JUMP_VELOCITY
	#spawn_particle()
	#$AudioStreamBounce.play()
	
func jump_side(x):
	#$AudioStreamCFHurt.play()
	#$AnimationPlayerFlashRed.play("red_strobe")
	# Set the knockback velocities
	velocity.y = -440  # Knock upward
	velocity.x = (x) # Knockback direction based on input x
	move_and_slide()

func _physics_process(delta):
	# Add the gravity.
	if is_on_floor():
		jump_count = 0
		# Animations
		if (velocity.x > 1 || velocity.x < -1):
			sprite_2d.animation = "run"
		else:
			if (current_direction == "left"):
				sprite_2d.play("idle")
				sprite_2d.flip_h = true
			elif (current_direction == "right"):
				sprite_2d.play("idle")
		
	else:
		velocity.y += gravity * delta
		if (jump_count == 2):
			sprite_2d.animation = "double_jump"
		else:
			sprite_2d.animation = "jump"

	# Handle jump.
	if Input.is_action_just_pressed("jump") and jump_count < 2:
		velocity.y = JUMP_VELOCITY
		jump_count += 1
		if (jump_count == 1):
			audio_stream_jump.play()
		if (jump_count == 2):
			audio_stream_double_jump.play()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction < 0:  # Moving left
		current_direction = "left"
	elif direction > 0:  # Moving right
		current_direction = "right"
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, 114)

	move_and_slide()
	
	var isLeft = velocity.x < 0
	sprite_2d.flip_h = isLeft
