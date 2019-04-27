extends Area2D

signal hit

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_node("KinematicBody2D").velocity.length() > 0:
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
		
	position += get_node("KinematicBody2D").velocity 
	
	if get_node("KinematicBody2D").velocity.x != 0:
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = get_node("KinematicBody2D").velocity.x < 0
	elif get_node("KinematicBody2D").velocity.y != 0:
		$AnimatedSprite.flip_v = get_node("KinematicBody2D").velocity.y > 0
		
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func _on_Player_body_entered(body):
	if body.is_in_group("enemy"):
		hide()  # Player disappears after being hit.
		emit_signal("hit")
		$CollisionShape2D.call_deferred("set_disabled", true)
		queue_free()


func _on_Player_hit():
	pass # Replace with function body.
