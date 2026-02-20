extends CharacterBody2D

#script for controlling player character sprite

#Get a reference to the animated sprite node attached to the Player root node
@onready var player_sprite: AnimatedSprite2D = $AnimatedSprite2D
var hud_controller

#Changed player variables here to show them in editor for easier gameplay modifications.
@export var SPEED = 300.0
@export var JUMP_VELOCITY = -650.0
@export_range(0,1) var deceleration := 0.05
@export_range(0,1) var acceleration := 0.2
var decelerating := false

#Variables for terrain gun, input controller
@export var build_controller: Node2D 
var terrain_gun_ammo:int = 0
var terrain_gun_ammo_max:int = 3

var player_hp = 6
var player_max_hp = 6

# Hold jump longer to jump higher. Release early to jump shorter.
@export_range(0,1) var decelerate_on_jump_release := 0.5

# Magnifier for gravity on the way down for a snappier jump feel
@export var fall_gravity := 2.0

func _ready() -> void:
	# Only attach the hud_controller to a HUD node if
	# it can be found. This will require the root node of
	# every level to be named Main.
	if has_node("/root/Main/UICanvas/HUD"):
		hud_controller = get_node("/root/Main/UICanvas/HUD")
	else:
		print("WARNING: UICanvas/HUD not found!")


#collect inputs here, pass them to various scripts as needed
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		if terrain_gun_ammo > 0:
			if build_controller.draw_tile(get_global_mouse_position()):
				terrain_gun_ammo -= 1
				hud_controller.update_ammo_text(terrain_gun_ammo)

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
		velocity.x = move_toward(velocity.x, direction*SPEED, SPEED*acceleration)
		player_sprite.flip_h = velocity.x < 0
		decelerating = false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED*deceleration)
		decelerating = true
	
	#Pick sprite animation based on velocity
	if is_on_floor() && velocity.x != 0:
		if decelerating:
			player_sprite.play("decelerate")
		else:
			player_sprite.play("walk")
	elif velocity.y > 0:
		player_sprite.play("falling")
	elif velocity.y < 0:
		player_sprite.play("jump")
	else:
		player_sprite.play("idle")
	
	move_and_slide()

func add_terrain_gun_ammo(_quantity:int) -> void:
	terrain_gun_ammo += _quantity
	if terrain_gun_ammo > terrain_gun_ammo_max:
		terrain_gun_ammo = terrain_gun_ammo_max
	
	hud_controller.update_ammo_text(terrain_gun_ammo)
