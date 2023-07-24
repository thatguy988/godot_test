extends "res://components/enemy.gd"


const JUMP_VELOCITY = -400.0

func _physics_process(delta):

	if not is_on_floor():
		velocity.y += gravity * delta

#
	move_and_slide()
