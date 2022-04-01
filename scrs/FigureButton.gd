extends Area2D
func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed() and st.camness and st.pl_status in st.user_color:
			if st.chose_figure != get_parent().get_parent():
				change()
			else:
				st.chose_figure = st.base_chose_figure
func change():
	st.chose_figure = get_parent().get_parent()
	st.chose_figure_type = st.chose_figure.get_child(0).name
	st.chose_figure_number = st.chose_figure.get_parent().name
	st.chose_figure_go = st.base_chose_figure.global_position
func _process(_delta):
	if get_parent().get_parent().name == st.pl_status and st.pl_status in st.user_color and st.camness:
		visible = true
	else:
		visible = false


