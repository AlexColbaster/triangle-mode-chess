extends Node2D


func _on_update_timeout():
	req.require()


var colors = {"red":Color(0.752941, 0.376471, 0.188235), "green":Color(0.188235, 0.752941, 0.376471), "blue":Color(0.376471, 0.188235, 0.752941)}

func _ready():
	st.chose_figure = $desk/useless
	st.base_chose_figure = $desk/useless
	st.past_chose_figure = $desk/useless
	$players.text = st.players["blue"]+" vs "+st.players["red"]+" vs "+st.players["green"]

func _process(_delta):
	$cancel/Label.add_color_override("font_color", colors[st.pl_status])
	$support/Label.add_color_override("font_color", colors[st.pl_status])
	
	if st.camness and st.last_data != req.info["move"] and req.info["move"] != []:
		if req.info["move"][0] == "-1":
			st.back_up()
		if req.info["move"][0] == st.pl_status:
			st.change(req.info["move"])

	if st.moving:
		st.camness = false
		st.chose_figure = st.base_chose_figure
		st.past_colled_figure = 0
		AI.clean()

		$music/go.play()
	
		st.moving = false

	if len(st.pl_status_array) == 1 and not $end.visible:
		$end.visible = true
		$end/king/red.text = str(st.score["king"]["red"])
		$end/king/green.text = str(st.score["king"]["green"])
		$end/king/blue.text = str(st.score["king"]["blue"])
		$end/figure/red.text = str(st.score["figure"]["red"])
		$end/figure/green.text = str(st.score["figure"]["green"])
		$end/figure/blue.text = str(st.score["figure"]["blue"])
		$end/survive/red.text = str(st.score["survive"]["red"])
		$end/survive/green.text = str(st.score["survive"]["green"])
		$end/survive/blue.text = str(st.score["survive"]["blue"])

	st.pl_status = st.pl_status_array[st.a%len(st.pl_status_array)]



func _on_support_pressed():
	if $Support.visible:
		$Support.visible = false
	else:
		$Support.visible = true

func _on_cancel_pressed():
	if st.pl_status in st.user_color:
		if st.camness and len(st.pl_status_array) > 1 and st.may_backup:
			req.info["move"] = ["-1"]
			send.send(req.info)
	else:
		$desk/warning_cancel_move.visible = true

func _on_ok_pressed():
	$desk/warning_cancel_move.visible = false


func _on_new_game_pressed():
	OS.shell_open("http://colbaster.site")
