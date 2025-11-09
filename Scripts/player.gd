extends CharacterBody2D

#script for controlling player character sprite

#Get a reference to the animated sprite node attached to the Player root node
@onready var player_sprite: AnimatedSprite2D = $AnimatedSprite2D

#Changed player variables here to show them in editor for easier gameplay modifications.
@export var SPEED = 300.0
@export var JUMP_VELOCITY = -650.0


#For physics processing I changed all inputs away from UI input events
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

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
