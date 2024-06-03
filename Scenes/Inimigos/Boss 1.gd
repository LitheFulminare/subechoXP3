extends CharacterBody2D

signal shoot

const bullet_path = preload("res://Scenes/Player_e_misc/Particulas e projéteis/Heartbreak projectile.tscn")
const explosion_path = preload("res://Scenes/Player_e_misc/Particulas e projéteis/Explosão morte inimigo.tscn")

@export var player:= Node2D
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D

@export var life = 1
@export var dano = 5
@export var speed = 80

@onready var animation_tree : AnimationTree = $AnimationTree

@export var intro_over = false
var player_close = false
var melee_last_3s = false
var shot_recently = false
var death_anim_over = false

func _ready():
	animation_tree.active = true
	
	
func _process(delta):
	#if life == 0:
		#dead = true
		#death_anim()
	if intro_over:
		update_animation_parameters()

func _physics_process(_delta: float) -> void:
	var dir = to_local(nav_agent.get_next_path_position()).normalized()
	velocity = dir * speed
	
	move_and_slide()

func makepath() -> void:
	nav_agent.target_position = player.global_position


func _on_timer_timeout():
	pass
	#makepath()
	
func update_animation_parameters():
	if player_close && !melee_last_3s: 
		animation_tree["parameters/conditions/melee"] = true
		await get_tree().create_timer(0.1).timeout
		animation_tree["parameters/conditions/melee"] = false
		melee_last_3s = true
		$"Melee timer".start()
		
	if !player_close && !shot_recently:
		animation_tree["parameters/conditions/shoot"] = true
		await get_tree().create_timer(0.1).timeout
		animation_tree["parameters/conditions/shoot"] = false
		shot_recently = true
		$"Shoot timer".start()
		
	if life <= 0:
		animation_tree["parameters/conditions/dead"] = true
		animation_tree["parameters/conditions/idle"] = false

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
	var targetPosition = player.global_position
	var bullet = bullet_path.instantiate()
	var gun_Position = $"Bullet spawn".global_position
	bullet.position = $"Bullet spawn".global_position
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
	explosion.global_position = $"Explosion position".global_position


func _on_area_2d_area_entered(area):
	if area.is_in_group("tiro"):
		if !area.get_parent().enemy_proj:
			var damage_received = area.get_parent().dano
			#print(damage_received)
			take_damage(damage_received)

func take_damage(damage_received):
	life -= damage_received

func death_anim():
	pass
