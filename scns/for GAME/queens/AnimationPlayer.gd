extends AnimationPlayer


func _physics_process(_delta):
	if st.chose_figure_number == get_parent().get_parent().get_parent().name:
		stop(false)
		play("Новая анимация")
	elif int(get_parent().get_child(0).rotation_degrees) % 180 == 0:
		stop(true)
