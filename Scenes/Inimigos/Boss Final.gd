extends CharacterBody2D

signal shoot

#const bullet_path = preload("res://Scenes/Player_e_misc/Particulas e projéteis/Heartbreak projectile.tscn")
const spike_path = preload("res://Scenes/Inimigos/Spike.tscn")
const needle_path = preload("res://Scenes/Inimigos/Agulha do além.tscn")
const scythe_path = preload("res://Scenes/Inimigos/Scythe.tscn")
const energy_ball_path = preload("res://Scenes/Inimigos/Energy ball.tscn")
const explosion_path = preload("res://Scenes/Player_e_misc/Particulas e projéteis/Explosão morte inimigo.tscn")
#const slash_vfx_path = preload("res://Scenes/Inimigos/Slash effect.tscn")

@export var player := Node2D
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D

@export var life = 120
@export var dano = 5
@export var speed = 80
@export var phase = 1

@onready var animation_tree : AnimationTree = $AnimationTree

@export var intro_over = false

var player_colliding = false

var player_too_close
var mirrored = false
#var colliding_with_player = false

var last_used = "" # controls what the last attack was

var player_close = false
@export var melee_attack = false
var melee_last_3s = false

var spike
var spike_active = false
var spike_spinning_time = false
var spike_on_cooldown = true

var needle
var needle_active = false
var needle_on_cooldown = false
var needle_follow_player = false

var shot_recently = false
var shoot_on_cooldown = false
@export var death_anim_started = false
#var death_anim_over = false

var on_dash = false
@export var dash_on_cooldown = false

var dead_2 = false

func _ready():
	speed = 80
	phase = 1
	intro_over = false
	melee_attack = false
	death_anim_started = false
	
	animation_tree.active = true
	$"Melee effect".visible = false
	$"Spike cooldown".start()
	
	
func _process(delta):
	if !death_anim_started && !on_dash:
		if player.position.x <= global_position.x:
			$Sprite.flip_h = false
			#$"Melee trigger/CollisionShape2D".rotation = deg_to_rad(0)
			mirrored = false
		else:
			$Sprite.flip_h = true
			#$"Melee trigger/CollisionShape2D".rotation = deg_to_rad(180)
			mirrored = true
	if death_anim_started:
		$Sprite.flip_h = false
		mirrored = false
	#
	if intro_over:
		update_animation_parameters()
		attacks()
		
	if !on_dash:
		$Sprite.position = Vector2(0,0)
	
	if spike_active && spike != null:
		spike.global_position = global_position
		
	if needle_follow_player && needle != null:
		needle.global_position = player.global_position
		needle.global_position.y -= 125

func _physics_process(_delta: float) -> void:
	var dir = to_local(nav_agent.get_next_path_position()).normalized()
	
	velocity = dir * speed
	
	if on_dash:
		if !mirrored:
			dir.x = -1
		else:
			dir.x = 1
		velocity = dir * speed
		velocity.y = 0
		
	#print("dir: " + str(dir))
	
	move_and_slide()

func makepath() -> void:
	#pass
	if !player_too_close:
		nav_agent.target_position = player.global_position

func start_phase_2():
	phase = 2
	speed = 100
	life = 120
	death_anim_started = false
	dash_on_cooldown = false
	
func attacks():
	randomize()
	var random_float = randf()
	if phase == 1:
		if random_float > 0.5:
			if !spike_active && !spike_on_cooldown && last_used != "spike":
				use_spike()
				#last_used = "spike"
		else:
			if !needle_active && !needle_on_cooldown:
				use_needle()
				#last_used = "needle"
		
		if player_close && melee_attack:
			get_tree().call_group("player", "take_damage", "inimigo")
			
	if player_colliding:
		get_tree().call_group("player", "take_damage", "inimigo")

func use_spike():
	spike = spike_path.instantiate()
	get_parent().add_child(spike)
	spike.scale = Vector2(4,4)
	#spike.global_position = global_position
	#spike.visibility_layer = 1
	spike_active = true
	$"Spike active time".start()
	
func use_needle():
	needle = needle_path.instantiate()
	get_parent().add_child(needle)
	needle.global_position = player.global_position
	needle.global_position.y -= 125
	needle_active = true
	needle_follow_player = true
	$"Needle active time".start()
	$"Needle follow player".start()
	
func dash():
	on_dash = true
	speed = 500
	await get_tree().create_timer(0.833).timeout
	speed = 20
	on_dash = false
	await get_tree().create_timer(1).timeout
	speed = 100

func update_animation_parameters():
	if player_close && !melee_last_3s && !spike_active && phase == 1:
		animation_tree["parameters/conditions/melee"] = true
		await get_tree().create_timer(0.1).timeout
		animation_tree["parameters/conditions/melee"] = false
		melee_last_3s = true
		$"Melee timer".start()
		
	if !player_close && !shoot_on_cooldown && phase == 2:
		animation_tree["parameters/conditions/shoot"] = true
		await get_tree().create_timer(0.1).timeout
		animation_tree["parameters/conditions/shoot"] = false
	
	if !player_close && !dash_on_cooldown:
		animation_tree["parameters/conditions/dash"] = true
		await get_tree().create_timer(0.1).timeout
		animation_tree["parameters/conditions/dash"] = false
		#dash_on_cooldown = true
		#$"Dash cooldown".start()
		#dash()
		
	if phase == 2:
		animation_tree["parameters/conditions/idle2"] = true
		animation_tree["parameters/conditions/idle1"] = false
		
	if life <= 0 && phase == 1:
		animation_tree["parameters/conditions/dead1"] = true
		animation_tree["parameters/conditions/idle1"] = false
		spike_active = false
		spike_on_cooldown = true
		if spike != null:
			spike.queue_free()
		if needle != null:
			needle.queue_free()
		$"Spike active time".stop()
		$"Needle active time".stop()
		
	if life <= 0 && phase == 2:
		animation_tree["parameters/conditions/death2"] = true
		animation_tree["parameters/conditions/idle2"] = false
		
func _on_melee_trigger_area_entered(area):
	if area.is_in_group("player"):
		player_close = true


func _on_melee_trigger_area_exited(area):
	if area.is_in_group("player"):
		player_close = false


func _on_melee_timer_timeout():
	melee_last_3s = false


func _on_shoot_timeout():
	shot_recently = false


func _on_shoot():
	randomize()
	var bullet
	shoot_on_cooldown = true
	$"Shoot cooldown".start()
	var targetPosition = player.global_position
	var random_float = randf()
	if random_float > 0.5:
		bullet = scythe_path.instantiate()
	else:
		bullet = energy_ball_path.instantiate()
	var gun_Position = $"Bullet spawn".global_position
	bullet.position = $"Bullet spawn".global_position
	#if mirrored:
		#bullet.flip()
	#var shootDirection = (targetPosition - gun_Position).normalized()
	bullet.set_bullet(gun_Position, targetPosition)
	bullet.tipo_tiro_boss(10)
	get_parent().add_child(bullet)
	
func spawn_explosion():
	var explosion = explosion_path.instantiate()
	add_child(explosion)
	explosion.anim("morte inimigo")
	explosion.get_node("luz").energy = 1.5
	explosion.scale = Vector2(1.5,1.5)
	explosion.global_position = $"Explosion spawn".global_position

#func slash_vfx():
	#var slash = slash_vfx_path.instantiate()
	#add_child(slash)
	##slash.scale = Vector2(2,2)
	#if !mirrored:
		#slash.global_position = $"Slash position".global_position
	#else:
		#slash.global_position = $"Slash position mirror".global_position
		#slash.scale.x = -slash.scale.x
#
	#if player_close:
		#get_tree().call_group("player", "take_damage", "inimigo")
		##player.take_damage("inimigo")

func take_damage(damage_received):
	life -= damage_received


func _on_main_hitbox_area_entered(area):
	if area.is_in_group("tiro"):
		if !area.get_parent().enemy_proj:
			var damage_received = area.get_parent().dano
			take_damage(damage_received)
	if area.is_in_group("player"):
		player_colliding = true
	#if area.is


func _on_spike_active_time_timeout():
	spike_active = false
	spike_on_cooldown = true
	spike.queue_free()
	$"Spike cooldown".start()

func _on_spike_cooldown_timeout():
	spike_on_cooldown = false

func _on_needle_cooldown_timeout():
	needle_on_cooldown = false

func _on_nav_timer_timeout():
	if intro_over:
		makepath()


func _on_needle_active_time_timeout():
	needle_active = false
	needle_on_cooldown = true
	if needle != null:
		needle.queue_free()
	$"Needle Cooldown".start()


func _on_needle_follow_player_timeout():
	needle_follow_player = false


func _on_dash_cooldown_timeout():
	dash_on_cooldown = false


func _on_slowdown_area_area_entered(area):
	if area.is_in_group("player") && !death_anim_started:
		speed = 30
		player_too_close = true
		player_colliding = true


func _on_slowdown_area_area_exited(area):
	if area.is_in_group("player") && !death_anim_started:
		player_too_close = false
		player_colliding = false
		speed = 100


func _on_shoot_cooldown_timeout():
	shoot_on_cooldown = false


func _on_main_hitbox_area_exited(area):
	if area.is_in_group("player"):
		player_colliding = false
