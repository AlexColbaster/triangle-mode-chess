extends Node

var player_commands = []

#перебор точек
var cycle = 0

func  _physics_process(_delta):
	if st.admin and len(st.points) == 117 and not st.pl_status in player_commands and st.camness and len(st.pl_status_array) != 1:
		if cycle < 117:
			st.points[cycle].AI()
			cycle+=1
		else:
			cycle = 0
			calc(best_figure, best_go)
			clean()


#    ФИГУРЫ И КУДА МОГУТ ПОЙТИ
#если этот ход спасёт своего короля +100
#если этот ход  убьёт чужого короля +50
#если этот ход спасёт свою фигуру +40
#если этот ход  убьёт чужую фигуру +10
#если этот ход максимально приближает фигуру к своему королю +0.1/м
var best_priority = -100.0
var best_figure
var best_go = Vector2()



func calc(a,b):
	var data = [a.name,a.get_child(0).name,a.get_child(1).name,b.x,b.y]
	req.info["move"] = data
	send.send(req.info)
	st.change(data)

func clean():
	best_priority = -100.0
	best_figure = st.base_chose_figure
	best_go = Vector2()
	cycle = 0
