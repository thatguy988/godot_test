extends Control


@export var enemy: Resource
@export var character: Resource

signal text_box_closed

var playerturns = 1
var maxplayerturns = playerturns
var enemyturns = 1
var maxenemyturns = enemyturns

func _ready():
	$Player_Character/Player_AnimationPlayer.queue("idle")
	set_health($"Player_Character/Player1 healthbar", 
				character.health, 
				character.max_health)
	set_health($"Enemy/Enemy_healthbar", 
				enemy.health, 
				enemy.max_health)
	set_magic_points($"Player_Character/Player1 magicbar",
				character.magic_points,
				character.max_magic_points)
	$Enemy.texture = enemy.texture
	display_counter("john",playerturns)
	
	$InfoTextbox.hide()
	$ActionSelection.hide()
	$MagicSelection.hide()
	display_text("Battle Start")
	$TextboxTimer.start(3)
	await self.text_box_closed
	$ActionSelection.show()
	
func _input(event):
	if Input.is_key_pressed(KEY_F) and $InfoTextbox.visible:
		$InfoTextbox.hide()
		emit_signal("text_box_closed")
		
func set_health(progressbar, health, max_health):
	progressbar.value = health
	progressbar.max_value = max_health
	progressbar.get_node("Health Numbers").text = "HP: %d / %d" % [health,max_health]

func set_magic_points(progressbar, magic_points, max_magic_points):
	progressbar.value = magic_points
	progressbar.max_value = max_magic_points
	progressbar.get_node("Magic Numbers").text = "MP: %d / %d" % [magic_points,max_magic_points]
	
func display_counter(new_name,turn):
	$TurnCounter/TextBoxContainer/MarginContainer/HBoxContainer/CharacterName.text = new_name
	$TurnCounter/TextBoxContainer/MarginContainer/HBoxContainer/NumberofTurns.text = "%f" % playerturns
	
func display_text(new_text):
	$InfoTextbox/TextBoxContainer/MarginContainer/HBoxContainer/Text.text = new_text
	$InfoTextbox.show()
	

	
func enemy_turn():
	display_text("%s attacks" % enemy.name)
	await self.text_box_closed
	$PlayerDamage.play("player_damaged")
	character.health = max(0, character.health - enemy.attack_power)
	set_health($"Player_Character/Player1 healthbar", 
				character.health, 
				character.max_health)
	display_text("%s does damage %d" % [enemy.name,enemy.attack_power])
	await self.text_box_closed
	enemyturns -= 1
	check_for_player_turn()
	
				
				
func _on_flee_pressed():
	display_text("Ran away")
	await self.text_box_closed
	get_tree().change_scene_to_file("res://camera/camera.tscn")
	


func _on_magic_pressed():
	$ActionSelection.hide()
	$MagicSelection.show()


func _on_attack_pressed():
	$ActionSelection.hide()
	var critical_chance = 0.3
	var is_critical = randf() <= critical_chance
	if is_critical:
		display_text("Critical Attack")
		await self.text_box_closed
		
		enemy.health = max(0, enemy.health - (1.5 * character.attack_power))
		display_text("Critical %d" % (1.5 * character.attack_power))
		playerturns -= 0.5
	else:	
		display_text("Attack")
		await self.text_box_closed
		$Player_Character/Player_AnimationPlayer.play("attack")
		$Player_Character/Player_AnimationPlayer.queue("idle")
		display_text("Damage %d" % character.attack_power)
		enemy.health = max(0, enemy.health - character.attack_power)
		playerturns -= 1
	display_counter("john",playerturns)
	set_health($"Enemy/Enemy_healthbar", 
					enemy.health, 
					enemy.max_health)

	$EnemyDamage.play("enemy_attack_damage")
	await self.text_box_closed
	if enemy.health == 0:
		display_text("%s is dead" % enemy.name)
		await self.text_box_closed#
		get_tree().change_scene_to_file("res://camera/camera.tscn")
		
	check_for_enemy_turn()
	
	
func check_for_enemy_turn():
	if playerturns <= 0:
		enemyturns=maxenemyturns	
		enemy_turn()
	else:
		$ActionSelection.show()

func check_for_player_turn():
	if enemyturns <= 0:
		playerturns = maxplayerturns
		display_counter("john",playerturns)
		$ActionSelection.show()
	else:
		enemy_turn()
		
	
func _on_back_pressed():
	$ActionSelection.show()
	$MagicSelection.hide()


func _on_fire_pressed():
	$ActionSelection.hide()
	$MagicSelection.hide()
	if character.magic_points >= 5:
		if enemy.weakness == "Fire":
			enemy.health = max(0, enemy.health - (2 * character.magic_attack_power))
			display_text("Hit Weakness Damage %d" % (2 * character.magic_attack_power))
			await self.text_box_closed
			playerturns -= 0.5
		elif enemy.strength == "Fire":
			enemy.health = max(0, enemy.health - (0.5 * character.magic_attack_power))
			display_text("Enemy is resist to fire Damage %d" % (0.5 * character.magic_attack_power))
			await self.text_box_closed
			playerturns -= 1
		else:
			enemy.health = max(0,enemy.health - character.magic_attack_power)
			display_text("Fire Attack")
			await self.text_box_closed
			playerturns -= 1
		display_counter("john", playerturns)
		$Player_Character/Player_AnimationPlayer.play("magic_attack")
		$Player_Character/Player_AnimationPlayer.queue("idle")
		$EnemyDamage.play("enemy_fire_damage")
		character.magic_points -= 10
		set_magic_points($"Player_Character/Player1 magicbar",
				character.magic_points,
				character.max_magic_points)
		set_health($"Enemy/Enemy_healthbar", 
					enemy.health, 
					enemy.max_health)
		if enemy.health == 0:
			display_text("%s is dead" % enemy.name)
			await self.text_box_closed#
			get_tree().change_scene_to_file("res://camera/camera.tscn")
		check_for_enemy_turn()
	else:
		display_text("Not enough MP")
		await self.text_box_closed

	


func _on_water_pressed():
	$ActionSelection.hide()
	$MagicSelection.hide()
	if character.magic_points >= 5:
		if enemy.weakness == "Water":
			enemy.health = max(0, enemy.health - (2 * character.magic_attack_power))
			display_text("Hit Weakness Damage %d" % (2 * character.magic_attack_power))
			await self.text_box_closed
			playerturns -= 0.5
		elif enemy.strength == "Water":
			enemy.health = max(0,enemy.health - (0.5 * character.magic_attack_power))
			display_text("Enemy is resist to Water Damage %d" % (0.5 * character.magic_attack_power))
			await self.text_box_closed
			playerturns -= 1
		else:
			enemy.health = max(0,enemy.health - character.magic_attack_power)
			display_text("Water Attack")
			await self.text_box_closed
			playerturns -= 1
		display_counter("john", playerturns)
		$Player_Character/Player_AnimationPlayer.play("magic_attack")
		$Player_Character/Player_AnimationPlayer.queue("idle")
		$EnemyDamage.play("enemy_water_damage")
		character.magic_points -= 10
		set_magic_points($"Player_Character/Player1 magicbar",
				character.magic_points,
				character.max_magic_points)
		set_health($"Enemy/Enemy_healthbar", 
					enemy.health, 
					enemy.max_health) 
		if enemy.health == 0:
			display_text("%s is dead" % enemy.name)
			await self.text_box_closed
			get_tree().change_scene_to_file("res://camera/camera.tscn")
		check_for_enemy_turn()
	else:
		display_text("Not enough MP")
		await self.text_box_closed
	


func _on_healing_pressed():
	$ActionSelection.hide()
	$MagicSelection.hide()
	if character.magic_points >= 10 and character.health != character.max_health:
		character.health = min(character.max_health, character.health + character.healing_power)
		display_text("Healing %d" % character.healing_power)
		await self.text_box_closed
		$PlayerDamage.play("player_heal")
		character.magic_points -= 10
		playerturns -= 1
		set_magic_points($"Player_Character/Player1 magicbar",
				character.magic_points,
				character.max_magic_points)
		set_health($"Player_Character/Player1 healthbar", 
					character.health, 
					character.max_health)
		display_counter("john", playerturns)
		check_for_enemy_turn()
	elif character.health == character.max_health:
		display_text("Full health")
		await self.text_box_closed
		$ActionSelection.show()
	else:
		display_text("Not enough MP")
		await self.text_box_closed
		$ActionSelection.show()
		
	


func _on_scan_pressed():
	$ActionSelection.hide()
	$TextboxTimer.start(10)
	display_text("HP: %d, MP: %d, Strength: %s, Weakness %s" % [enemy.health, enemy.magic_points, enemy.strength, enemy.weakness])
	await self.text_box_closed
	$ActionSelection.show()
	$TextboxTimer.start(3)


func _on_lightning_pressed():
	$ActionSelection.hide()
	$MagicSelection.hide()
	if character.magic_points >= 5:
		if enemy.weakness == "Lightning":
			enemy.health = max(0, enemy.health - (2 * character.magic_attack_power))
			display_text("Hit Weakness Damage %d" % (2 * character.magic_attack_power))
			await self.text_box_closed
			playerturns -= 0.5
		elif enemy.strength == "Lightning":
			enemy.health = max(0, enemy.health - (0.5 * character.magic_attack_power))
			display_text("Enemy is resist to Lightning Damage %d" % (0.5 * character.magic_attack_power))
			await self.text_box_closed
			playerturns -= 1
		else:
			enemy.health = max(0,enemy.health - character.magic_attack_power)
			display_text("Lightning Attack")
			await self.text_box_closed
			playerturns -= 1

		$Player_Character/Player_AnimationPlayer.play("magic_attack")
		$Player_Character/Player_AnimationPlayer.queue("idle")
		$EnemyDamage.play("enemy_lightning_damage")
		character.magic_points -= 10
		display_counter("john", playerturns)
		set_magic_points($"Player_Character/Player1 magicbar",
				character.magic_points,
				character.max_magic_points)
		set_health($"Enemy/Enemy_healthbar", 
					enemy.health, 
					enemy.max_health)
		if enemy.health == 0:
			display_text("%s is dead" % enemy.name)
			await self.text_box_closed#
			get_tree().change_scene_to_file("res://camera/camera.tscn")
		check_for_enemy_turn()
	else:
		display_text("Not enough MP")
		await self.text_box_closed
	
	

func _on_earth_pressed():
	$ActionSelection.hide()
	$MagicSelection.hide()
	if character.magic_points >= 5:
		if enemy.weakness == "Earth":
			enemy.health = max(0, enemy.health - (2 * character.magic_attack_power))
			display_text("Hit Weakness Damage %d" % (2 * character.magic_attack_power))
			await self.text_box_closed
			playerturns -= 0.5
		elif enemy.strength == "Earth":
			enemy.health = max(0, enemy.health - (0.5 * character.magic_attack_power))
			display_text("Enemy is resist to Earth Damage %d" % (0.5 * character.magic_attack_power))
			await self.text_box_closed
			playerturns -= 1
		else:
			enemy.health = max(0,enemy.health - character.magic_attack_power)
			display_text("Earth Attack")
			await self.text_box_closed
			playerturns -= 1
		$Player_Character/Player_AnimationPlayer.play("magic_attack")
		$Player_Character/Player_AnimationPlayer.queue("idle")
		$EnemyDamage.play("enemy_earth_damage")
		character.magic_points -= 10
		display_counter("john",playerturns)
		set_magic_points($"Player_Character/Player1 magicbar",
				character.magic_points,
				character.max_magic_points)
		set_health($"Enemy/Enemy_healthbar", 
					enemy.health, 
					enemy.max_health)
		
		if enemy.health == 0:
			display_text("%s is dead" % enemy.name)
			await self.text_box_closed#
			get_tree().change_scene_to_file("res://camera/camera.tscn")
		check_for_enemy_turn()
	else:
		
		display_text("Not enough MP")
		await self.text_box_closed
	


func _on_textbox_timer_timeout():
	$InfoTextbox.hide()
	emit_signal("text_box_closed")
