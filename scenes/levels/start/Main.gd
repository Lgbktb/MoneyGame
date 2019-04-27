extends Node2D

export (PackedScene) var Mob
var score

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	new_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_EnemyTimer_timeout():
	$MobPath/MobSpawnLocation.set_offset(randi())
	var mob = Mob.instance()
	add_child(mob)
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
	mob.position = $MobPath/MobSpawnLocation.position
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)
	mob.add_to_group("enemy")
	

func _on_ScoreTimer_timeout():
	score += 1


func _on_StartTimer_timeout():
	$EnemyTimer.start()
	$ScoreTimer.start()

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func game_over():
	$ScoreTimer.stop()
	$EnemyTimer.stop()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()

func _on_Player_body_entered(body):
	pass # Replace with function body.
