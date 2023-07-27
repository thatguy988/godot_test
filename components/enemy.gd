extends CharacterBody2D

const SPEED = 50.0
var MOVE_DISTANCE = 100.0  # The distance the enemy will move left and right before changing direction.
var remaining_distance = MOVE_DISTANCE
var direction = 1  # 1 for moving right, -1 for moving left.

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
# Reference to the SceneTree

	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		


	
	# Update the remaining distance to move.
	remaining_distance -= abs(velocity.x) * delta

	# If the enemy has moved the desired distance in the current direction, change direction.
	if remaining_distance <= 0:
		direction = -direction
		remaining_distance = MOVE_DISTANCE

	# Set the movement velocity based on the current direction.
	velocity.x = SPEED * direction

#	# Check for collisions in the desired direction (velocity).
#	var collision = move_and_collide(velocity * delta)
#	velocity.x = SPEED * modifier
#
#	# If there is a collision, reverse the enemy's direction.
#	if collision:
#		print("Collision")
#		modifier = -modifier

	# Move the enemy.
	move_and_slide()


	
func _on_top_collision_body_entered(body):
	queue_free()
	
func _on_bottom_collision_body_entered(body):
	load_battle_scene()
	queue_free()


func _on_left_collision_body_entered(body):
 
	load_battle_scene()
	#queue_free()


func _on_right_collision_body_entered(body):
	load_battle_scene()
	#queue_free()
	
func load_battle_scene():
	# Load the battle scene using preload.


	get_tree().change_scene_to_file("res://Battle_Scene.tscn")


