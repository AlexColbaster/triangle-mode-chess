extends Sprite

func _ready():
	st.points += [self]

remote var stream = false
var colors = {"red":Color(0.752941, 0.376471, 0.188235), "green":Color(0.188235, 0.752941, 0.376471), "blue":Color(0.376471, 0.188235, 0.752941)}
onready var pos = Vector2(round(global_position.x), round(global_position.y))
func _on_button_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed() and st.camness:
		var data = [st.chose_figure.name,st.chose_figure.get_child(0).name,st.chose_figure.get_child(1).name,pos.x,pos.y]
		req.info["move"] = data
		send.send(req.info)
		st.change(data)


var pl_status_array = ["red", "green", "blue"]
var good_for_rook = [0, 60, 120, 180,  -60, -120]
var good_for_elef = [30, 90, 150,  -30, -90, -150]

func direct(good_for):
	var deg = stepify(rad2deg(st.chose_figure.global_position.direction_to(pos).angle()), 15)
	if deg in good_for:
		return true
	else:
		return false
func dist(a, b):
	var state = get_world_2d().direct_space_state
	var ray = state.intersect_ray(pos, st.chose_figure.global_position)
	var point = state.intersect_point(pos)

	if ray and ray["collider"] != st.chose_figure and ray["collider"].name != st.pl_status:
		return false
	if point and point[0]["collider"] and point[0]["collider"] in st.figures and point[0]["collider"].name == st.pl_status:
		return false
	if st.chose_figure.global_position.distance_to(global_position) > a and st.chose_figure.global_position.distance_to(global_position) < b:
		return true
	else:
		return false

func calc():
	var type = st.chose_figure_type
	var mage = type == "mage" and dist(500, 510)
	var rook = type == "rook" and dist(0, 390) and direct(good_for_rook)
	var elef = type == "elef" and dist(0, 390) and direct(good_for_elef)
	var warer = type == "warer" and dist(0, 150)
	var acher = type == "acher" and dist(150, 201)
	var queen = type == "queen" and dist(0, 390) and (direct(good_for_rook) or direct(good_for_elef))
	var king = type == "king" and dist(0, 201)
	if rook or elef or warer or acher or mage or queen or king: 
		return true
	else:
		return false

func _process(_delta):
	modulate = colors[st.pl_status]
	if st.pl_status in AI.player_commands:
		if st.pl_status in st.user_color:
			if calc():
				visible = true
			else:
				visible = false
		else:
			visible = false

	if pos in st.warning_points:
		get_parent().get_child(1).visible = true
	else:
		get_parent().get_child(1).visible = false



func AI():
	if st.camness:
		for i in range(len(st.figures)):
			st.chose_figure = st.figures[i]
			st.chose_figure_type = st.chose_figure.get_child(0).name
			#если подобранной фигурой можно походить в эту точку
			if st.chose_figure.name == st.pl_status and calc():
				var pos_figure = Vector2(round(st.chose_figure.global_position.x), round(st.chose_figure.global_position.y))
				var priority = 0

				#4 safe figure
				if pos_figure in st.warning_points:
					priority += 40
					#1 safe king
					if st.chose_figure_type == "king":
						priority += 100
				for j in range(len(st.figures)):
					if st.figures[j].global_position.distance_to(pos)<1:
						
						#2 kill king
						if st.figures[j].get_child(0).name == "king":
							priority += 50
							
						#3 kill figure
						else:
							priority += 10
				
				#5
				var to_my_king = pos_figure.distance_to(st.kings[st.pl_status].global_position) - pos.distance_to(st.kings[st.pl_status].global_position)
				priority += to_my_king * 0.01
					
				if priority > AI.best_priority:
					AI.best_priority = priority
					AI.best_figure = st.chose_figure
					AI.best_go = pos


