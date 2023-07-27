extends Control

@export var enemy: Resource
@export var character: Resource


signal text_box_closed


func _ready():
	set_health($"Player_Character/Player1 healthbar", 
				character.health, 
				character.max_health)
	set_health($"Enemy/Enemy_healthbar", 
				enemy.health, 
				enemy.max_health)
	$Enemy.texture = enemy.texture
	#$Player_character.texture = character.texture
	$TextBox.hide()
	$ActionSelection.hide()
	$MagicSelection.hide()
	display_text("Battle Start")
	await self.text_box_closed
	$ActionSelection.show()
	
func _input(event):
	if Input.is_key_pressed(KEY_F) and $TextBox.visible:
		$TextBox.hide()
		emit_signal("text_box_closed")
		
func set_health(progressbar, health, max_health):
	progressbar.value = health
	progressbar.max_value = max_health
	progressbar.get_node("Health Numbers").text = "HP: %d / %d" % [health,max_health]

func display_text(new_text):
	$TextBox.show()
	$TextBox/Information.text = new_text
	
	
func enemy_turn():
	display_text("%s attacks" % enemy.name)
	await self.text_box_closed
	
	character.health = max(0, character.health - enemy.attack_power)
	set_health($"Player_Character/Player1 healthbar", 
				character.health, 
				character.max_health)
	display_text("%s does damage %d" % [enemy.name,enemy.attack_power])
	await self.text_box_closed
				
				
func _on_flee_pressed():
	display_text("Ran away")
	await self.text_box_closed
	get_tree().change_scene_to_file("res://camera/camera.tscn")
	


func _on_magic_pressed():
	$ActionSelection.hide()
	$MagicSelection.show()


func _on_attack_pressed():
	display_text("Attack")
	await self.text_box_closed
	enemy.health = max(0, enemy.health - character.attack_power)
	set_health($"Enemy/Enemy_healthbar", 
				enemy.health, 
				enemy.max_health)
	display_text("Damage %d" % character.attack_power)
	await self.text_box_closed
	if enemy.health == 0:
		display_text("%s is dead" % enemy.name)
		await self.text_box_closed#
		get_tree().change_scene_to_file("res://camera/camera.tscn")
	
	enemy_turn()
	
func _on_back_pressed():
	$ActionSelection.show()
	$MagicSelection.hide()


func _on_fire_pressed():
	if enemy.weakness == "Fire":
		enemy.health = max(0, enemy.health - (2 * character.magic_attack_power))
		display_text("Hit Weakness Damage %d" % (2 * character.magic_attack_power))
		await self.text_box_closed
	elif enemy.strength == "Fire":
		enemy.health = max(0, enemy.health - (0.5 * character.magic_attack_power))
		display_text("Enemy is resist to fire Damage %d" % (0.5 * character.magic_attack_power))
		await self.text_box_closed
	else:
		enemy.health = max(0,enemy.health - character.magic_attack_power)
		display_text("Fire Attack")
		await self.text_box_closed
	set_health($"Enemy/Enemy_healthbar", 
				enemy.health, 
				enemy.max_health)
	$ActionSelection.show()
	$MagicSelection.hide() 
	if enemy.health == 0:
		display_text("%s is dead" % enemy.name)
		await self.text_box_closed#
		get_tree().change_scene_to_file("res://camera/camera.tscn")
	
	enemy_turn()


func _on_water_pressed():
	if enemy.weakness == "Water":
		enemy.health = max(0, enemy.health - (2 * character.magic_attack_power))
		display_text("Hit Weakness Damage %d" % (2 * character.magic_attack_power))
		await self.text_box_closed
	elif enemy.strength == "Water":
		enemy.health = max(0,enemy.health - (0.5 * character.magic_attack_power))
		display_text("Enemy is resist to Water Damage %d" % (0.5 * character.magic_attack_power))
		await self.text_box_closed
	else:
		enemy.health = max(0,enemy.health - character.magic_attack_power)
		display_text("Water Attack")
		await self.text_box_closed
	set_health($"Enemy/Enemy_healthbar", 
				enemy.health, 
				enemy.max_health)
	$ActionSelection.show()
	$MagicSelection.hide() 
	if enemy.health == 0:
		display_text("%s is dead" % enemy.name)
		await self.text_box_closed
		get_tree().change_scene_to_file("res://camera/camera.tscn")
	
	enemy_turn()


func _on_healing_pressed():
	character.health = min(character.max_health, character.health + character.healing_power)
	display_text("Healing %d" % character.healing_power)
	await self.text_box_closed
	set_health($"Player_Character/Player1 healthbar", 
				character.health, 
				character.max_health)
	$ActionSelection.show()
	$MagicSelection.hide()
	enemy_turn()


func _on_scan_pressed():
	display_text("HP: %d, MP: %d, Strength: %s, Weakness %s" % [enemy.health, enemy.magic_points, enemy.strength, enemy.weakness])
	await self.text_box_closed
