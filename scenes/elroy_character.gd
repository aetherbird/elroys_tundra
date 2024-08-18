extends CharacterBody2D

const SPEED = 400.0
const JUMP_VELOCITY = -750.0
@onready var sprite_2d = $ElroySprite
@export var particle : PackedScene

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jump_count = 0

func _ready():
	sprite_2d.animation = "idle"

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
			sprite_2d.animation = "idle"
		
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
			pass
			#$AudioStreamJump.play()
		if (jump_count == 2):
			pass
			#$AudioStreamDoubleJump.play()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, 114)

	move_and_slide()
	
	var isLeft = velocity.x < 0
	sprite_2d.flip_h = isLeft
