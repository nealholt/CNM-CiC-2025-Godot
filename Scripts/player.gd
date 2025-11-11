extends CharacterBody2D

#script for controlling player character sprite

#Get a reference to the animated sprite node attached to the Player root node
@onready var player_sprite: AnimatedSprite2D = $AnimatedSprite2D

#Changed player variables here to show them in editor for easier gameplay modifications.
@export var SPEED = 300.0
@export var JUMP_VELOCITY = -650.0

# Hold jump longer to jump higher. Release early to jump shorter.
@export_range(0,1) var decelerate_on_jump_release := 0.5

# Magnifier for gravity on the way down for a snappier jump feel
@export var fall_gravity := 2.0


#For physics processing I changed all inputs away from UI input events
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		if velocity.y > 0: # If falling
			velocity += get_gravity() * delta * fall_gravity
		else:
			velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= decelerate_on_jump_release

	# Get the input direction and handle the movement/deceleration.
	#Replaced ui_left and ui_right with player controller actions not associated with the UI
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		player_sprite.flip_h = velocity.x < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	#Pick sprite animation based on velocity
	if is_on_floor() && velocity.x != 0:
		player_sprite.play("walk")
	elif velocity.y > 0:
		player_sprite.play("falling")
	elif velocity.y < 0:
		player_sprite.play("jump")
	else:
		player_sprite.play("idle")

	move_and_slide()
