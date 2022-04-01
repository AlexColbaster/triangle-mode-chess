extends KinematicBody2D
func _ready():
	st.figures += [self]
	st.figure_index[name + get_child(0).name + get_child(1).name] = self
	if get_child(0).name == "king":
		st.kings[name] = self
var speed = 0
var min_speed = 50
var max_speed = 2000
var vel
var old_turn = st.turn
var transforma = false
func _physics_process(_delta):
	if global_position < Vector2(7777, 7777):
		#движение всех фигур кроме мага
		if st.chose_figure_type != "mage":
			if global_position.distance_to(st.chose_figure_go) > 1 and st.chose_figure_go != Vector2(99999, 99999) and name == st.pl_status and st.chose_figure_number == get_parent().name and st.camness == false:
				vel = global_position.direction_to(st.chose_figure_go)
				var col = move_and_collide(vel*_delta*speed)
				if col:
					if col.collider is KinematicBody2D:
						st.chose_figure_go = col.collider.global_position
						st.past_colled_figure = col.collider
						st.past_colled_figure_pos = col.collider.global_position
						if col.collider.name == st.pl_status:
							col.collider.set_global_position(st.past_chose_figure_pos)
						else:
							killing(col)
		#маг
		elif st.chose_figure_type == "mage":
			
			if global_position.distance_to(st.chose_figure_go) > 1 and st.chose_figure_go != Vector2(99999, 99999) and name == st.pl_status and st.chose_figure_number == get_parent().name and st.camness == false:
				if scale >= Vector2(0.02, 0.02):
					scale -= Vector2(0.02, 0.02)
				if scale < Vector2(0.01, 0.01):
					global_position = st.chose_figure_go
			elif scale < Vector2(1, 1):
				scale += Vector2(0.03, 0.03)
				if scale > Vector2(1, 1):
					st.camness = true
					var col = move_and_collide(Vector2())
					if col:
						st.past_colled_figure = col.collider
						st.past_colled_figure_pos = col.collider.global_position
						killing(col)
						

		#если фигура дошла до цели
		if global_position.distance_to(st.chose_figure_go) <= 1 and name == st.pl_status and st.chose_figure_number == get_parent().name:
			set_global_position(st.chose_figure_go)
			if st.chose_figure_type != "mage":
				st.camness = true
			st.a+=1
			st.turn += 1
			st.may_backup = true
			st.warning_points = []
			if transforma and (get_child(0).name == "warer" or get_child(0).name == "acher"):
				var q = load("res://scns/for GAME/queens/"+name+".tscn").instance()
				get_parent().add_child(q)
				var old_name = name
				q.global_position = global_position
				name = "0"
				q.name = old_name
				queue_free()
				st.may_backup = false
			
		
		old_turn = st.turn
	else:
		#уничтожение уже убитой фигуры
		if st.turn - old_turn == 2:
			queue_free()
			st.figures.erase(self)
	#плавная скорость
	if name == st.pl_status:
		speed = global_position.distance_to(st.chose_figure_go) * 10
		if speed > max_speed:
			speed = max_speed
		if speed < min_speed:
			speed = min_speed
	else:
		speed = 0
	#смерть если король мёртв
	if not name in st.pl_status_array:
		st.warning_points = []
		queue_free()
		st.figures.erase(self)
	#обнаружение
	detecting()

func killing(col):
	st.score["figure"][st.pl_status] += 1
	st.chose_figure_go = col.collider.global_position
	if col.collider.get_child(0).name == "king":
		st.score["king"][st.pl_status] += 1
		var old_name = st.pl_status
		st.first_killed_command = col.collider.name
		st.first_killer_command = name
		st.pl_status_array.erase(col.collider.name)
		for i in range(len(st.pl_status_array)):
			st.score["survive"][st.pl_status_array[i]] += 1
		st.pl_status = st.pl_status_array[st.a%len(st.pl_status_array)]
		if st.pl_status == old_name:
			st.a += 1
		st.may_backup = false
		st.warning_points = []
	st.camness = true
	set_global_position(col.collider.global_position)
	col.collider.set_global_position(Vector2(9999, 9999))
	get_parent().get_parent().get_parent().get_node("music/colide").play()


#  INDICATORS  ##################################

var mage = [Vector2(-96,-492), Vector2(96,-492), Vector2(384, -328), Vector2(480, -164), Vector2(480, 164), Vector2(384,328), 
			Vector2(96, 492), Vector2(-96, 492), Vector2(-384, 328), Vector2(-480, 164), Vector2(-480, -164), Vector2(-384,-328)]
var warer = [Vector2(-96,-54), Vector2(96,-54), Vector2(0,110), Vector2(-96,54), Vector2(96,54), Vector2(0,-110)]
var acher = [Vector2(-96,-164), Vector2(96,-164), Vector2(192,0), Vector2(96,164), Vector2(-96,164), Vector2(-192,0)]
var elef = [Vector2(0,-328), Vector2(288,-164), Vector2(288,164), Vector2(0,328), Vector2(-288,164), Vector2(-288,-164)]
var rook = [Vector2(192,-328), Vector2(-192,-328), Vector2(384,0), Vector2(192,328), Vector2(-192,328), Vector2(-384,0)]

var rays = {
	"mage":mage,
	"warer":warer,
	"acher":acher,
	"king":warer+acher,
	"elef":elef,
	"rook":rook,
	"queen":elef+rook
}
func detecting():
	if st.camness:
		var state = get_world_2d().direct_space_state
		var type = get_child(0).name
		var pos = Vector2(round(global_position.x), round(global_position.y))
		for i in range(len(rays[type])):
			var ray = state.intersect_ray(pos, pos + rays[type][i], [self])
			if ray:
				var col_pos = Vector2(round(ray["collider"].global_position.x), round(ray["collider"].global_position.y))
				if not col_pos in st.warning_points and ray["collider"].name != name:
					st.warning_points += [Vector2(round(ray["collider"].global_position.x), round(ray["collider"].global_position.y))]

	
	
	
