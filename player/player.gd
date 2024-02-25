extends CharacterBody2D


const speed = 280.0

const jump_velocity = -2200.0
var max_jumps = 2
var jumps = max_jumps
var jump_length = 0.2
var jump_time = 0

var ability_selected = 1
var ability_1 = preload("res://emotions/anger_emotion.tscn")
var ability_2 = preload("res://emotions/envy_emotion.tscn")
var ability_3 = preload("res://emotions/sadness_emotion.tscn")

var instance = get('ability_' + str(ability_selected)).instantiate()

var max_hp = 5
var hp = max_hp

@onready var cam = $"../Camera"
@onready var marker = $"../player_follow"
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 1200

func _ready():
	pass


func _physics_process(delta):
	# Add the gravity.
	if is_on_floor():
		jumps = max_jumps
	else:
		if jumps == max_jumps:
			jumps = max_jumps - 1
		velocity.y += gravity * delta
	
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and jumps > 0:
		velocity.y = clamp(velocity.y, -60000, 0)
		velocity.y += jump_velocity * 2 * delta
		jump_time = jump_length
		jumps -= 1
	
	if jump_time > 0:
		velocity.y += jump_velocity * delta
		jump_time -= 1 * delta
		jump_time = clamp(jump_time, 0, jump_length)
		
		if Input.is_action_just_released("jump"):
			velocity.y -= (jump_velocity / 20)
			jump_time = 0
	
	
	# moving
	var direction = Input.get_axis("left", "right")
	
	if direction and velocity.x < speed and velocity.x > -speed:
		velocity.x +=  speed * direction * 5 * delta
	if (direction == -1 and velocity.x >= 0) or (direction == 1 and velocity.x <= 0) or direction == 0:
		velocity.x = move_toward(velocity.x, 0, speed * 6 * delta)
	
	if direction:
		$Icon.scale.x = direction * 0.25
	
	
	# ability scroll
	if Input.is_action_just_pressed("1"):
		ability_selected = 1
		instance = get('ability_' + str(ability_selected)).instantiate()
		change_emotion()
		
	elif Input.is_action_just_pressed("2"):
		ability_selected = 2
		instance = get('ability_' + str(ability_selected)).instantiate()
		change_emotion()
		
	elif Input.is_action_just_pressed("3"):
		ability_selected = 3
		instance = get('ability_' + str(ability_selected)).instantiate()
		change_emotion()
	
	#if Input.is_action_just_pressed("scroll_down"):
	#	ability_selected -= 1
	#	if ability_selected < 1:
	#		ability_selected = 3
	#	$"Icon/emotion".queue_free()
	
	#if instance:
	#	if get_node_or_null("emotion"):
	#		print("aaa")
	#		change_emotion
	
	
	
	# camera movement
	
	#marker move towards player
	marker.position.x += (position.x - marker.position.x) * 20 * delta
	marker.position.y += (position.y - marker.position.y) * 20 * delta
	
	#cam pos set to opposite side of player 
	cam.position = position + Vector2(position.x - marker.position.x, position.y - marker.position.y)
	
	
	move_and_slide()
#.get_node("emotion")
func change_emotion():
	if get_node_or_null("Icon/emotion"):
		$"Icon/emotion".name = "x"
		$"Icon/x".queue_free()
		print("aaa")
	
	instance.position = Vector2.ZERO
	instance.name = "emotion"
	add_child(instance)
	instance.reparent($Icon)
	instance = null


func _on_area_2d_area_entered(area):
	if area.is_in_group("enemies"):
		hp -= 1
