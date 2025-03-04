extends Area3D

@export var projectileSpeed = 10

func _process(delta):
	position += transform.basis * Vector3(0, 0, -projectileSpeed) * delta
	
#	var dir = get_tree().get_first_node_in_group("player").global_transform.basis.z.normalized()
#	global_position += -dir * projectileSpeed * delta


func _on_body_entered(body: Node3D) -> void:
	if body.has_method("hurt"):
		body.hurt()
