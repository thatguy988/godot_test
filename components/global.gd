
extends Node

var position_x = 100
var position_y = 100

# Create a dictionary to store enemy states for each level.
# The keys are the level numbers, and the values are the arrays representing the enemy states.
var level_enemy_states = {
	1: [true, true, true],  
	2: [true, true, true, true],  
	# Add more levels and their respective enemy states arrays here.
}

# Function to check if an enemy at a specific index is alive for a given level.
func is_enemy_alive(level, index):
	if level in level_enemy_states and index >= 0 and index < level_enemy_states[level].size():
		return level_enemy_states[level][index]
	return false

# Method to switch the state of an enemy at a given index from true to false for a given level.
func kill_enemy(level, index):
	if level in level_enemy_states and index >= 0 and index < level_enemy_states[level].size():
		level_enemy_states[level][index] = false

# Example usage:
# To check if enemy 1 is alive in Level 1, call is_enemy_alive(1, 0).
# To check if enemy 2 is alive in Level 2, call is_enemy_alive(2, 1).
# To switch the state of enemy 1 to false in Level 1, call kill_enemy(1, 0).
# To switch the state of enemy 2 to false in Level 2, call kill_enemy(2, 1).
