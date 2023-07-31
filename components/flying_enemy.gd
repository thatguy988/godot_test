extends CharacterBody2D


var direction = 1  # 1 for moving right, -1 for moving left.


func left_and_right_movement(delta):
	pass

func _physics_process(delta):
		
	left_and_right_movement(delta)

	move_and_slide()


func _on_left_collision_body_entered(body):
	load_battle_scene()

func _on_right_collision_body_entered(body):
	load_battle_scene()

func _on_bottom_collision_body_entered(body):
	load_battle_scene()

func _on_top_collision_body_entered(body):
	pass
	
	
func load_battle_scene():
	pass
	

