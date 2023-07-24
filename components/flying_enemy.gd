extends "res://components/enemy.gd"



func _physics_process(delta):
	MOVE_DISTANCE = 300
	# Update the remaining distance to move.
	remaining_distance -= abs(velocity.x) * delta

	# If the enemy has moved the desired distance in the current direction, change direction.
	if remaining_distance <= 0:
		direction = -direction
		remaining_distance = MOVE_DISTANCE

	# Set the movement velocity based on the current direction.
	velocity.x = SPEED * direction

	move_and_slide()
