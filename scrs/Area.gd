extends Area2D

var child


func _on_Area2D_body_shape_entered(_body_id, body, _body_shape, _local_shape):
	child = body.get_child(0)
	if body.name != get_parent().name and (child.name == "warer" or child.name == "acher") and get_parent().name in st.pl_status_array:
		body.transforma = true
		
