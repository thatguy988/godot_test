extends Node2D

# Add this variable to store the Player scene.

func _on_quit_pressed():
	get_tree().quit()


func _on_play_pressed():
	


	get_tree().change_scene_to_file("res://node_2d.tscn")