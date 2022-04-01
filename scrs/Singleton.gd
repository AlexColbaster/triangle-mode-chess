extends Node
# OBJECTS
var warning_points = []
var figures = []
var figure_index = {}
var points = []
var kings = {}

# PLAYER INFO
var admin = false
var players = {"red":"ИИ" , "green":"ИИ" , "blue":"ИИ"} #какие команды под чьим управлением
var user_color = []#команды, которыми может управлять игрок
var pl_status = "red"#цвет ходящей сейчас команды
var score = {"king": {"red":0,"green":0,"blue":0}, "figure": {"red":0,"green":0,"blue":0}, "survive": {"red":0,"green":0,"blue":0}}
var camness = true
var pl_status_array = ["red", "green", "blue"]
var id_dict = {}
var first_killed_command
var first_killer_command
var turn = 1

# MOVING
var moving = false

var chose_figure_go = Vector2(99999, 99999)
var chose_figure

var past_chose_figure_pos = Vector2(99999, 99999)
var past_chose_figure
var past_colled_figure_pos = Vector2(99999, 99999)
var past_colled_figure
var may_backup = false
var base_chose_figure
var chose_figure_type
var chose_figure_number
var a = 0


func change(data): #data: namefig,type,number,posx,posy#
	chose_figure = figure_index[data[0]+data[1]+data[2]]
	chose_figure_type = chose_figure.get_child(0).name
	chose_figure_number = chose_figure.get_parent().name
	past_chose_figure = chose_figure
	past_chose_figure_pos = Vector2(round(past_chose_figure.global_position.x), round(past_chose_figure.global_position.y))
	moving = true
	chose_figure_go = Vector2(data[3],data[4])
	turn += 1
	last_data = data

#ONLINE

var my_server = "http://colbaster.cu.ma/"
var server_number = 1
var last_data = []




#BACK UP

func back_up():
	a -= 1
	turn -= 1
	chose_figure_go = Vector2(99999, 99999)
	chose_figure = base_chose_figure
	past_chose_figure.global_position = past_chose_figure_pos
	if past_colled_figure is Object:
		past_colled_figure.global_position = past_colled_figure_pos
	may_backup = false
	warning_points = []
	AI.clean()
	last_data = ["-1"]

		
		
