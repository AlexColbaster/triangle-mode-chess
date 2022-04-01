extends Control

func _on_update_timeout():
	req.require()

var my_login
var game_start = false
var loading = false
var login_text

func _ready():
	$AnimationPlayer.play("loading")

func _process(delta):
	if ' ' in $login.text:
		login_text = $login.text
		login_text.erase(login_text.find(' '), 1)
		$login.text = login_text
	if Input.is_action_just_pressed("KEY_ENTER") and $login.visible:
		_on_next_pressed()
	if Input.is_action_just_pressed("KEY_ENTER") and $online_JH.visible:
		_on_to_lobby_pressed()
	if Input.is_action_just_pressed("KEY_LEFT") and $online_JH.visible:
		_on_minus_pressed()
	if Input.is_action_just_pressed("KEY_RIGHT") and $online_JH.visible:
		_on_plus_pressed()

	if len(req.info) > 5:
		change_command("red", req.info["red"])
		change_command("green", req.info["green"])
		change_command("blue", req.info["blue"])

		if not req.info["activity"] and req.info["admin"] == my_login and not send.loading:
			req.info["activity"] = true
			send.send(req.info)
		if req.info["game_start"] and not game_start and $lobby/red.modulate.a > 0.99:
			game_start = true
			start()
		if req.info["admin"] == my_login:
			$lobby/GO.visible = true
		else:
			$lobby/GO.visible = false

	$Loading1.rotation_degrees -= 10
	$Loading2.rotation_degrees += 10
	if send.loading or loading:
		$Loading1.visible = true
		$Loading2.visible = true
	else:
		$Loading1.visible = false
		$Loading2.visible = false


func _on_next_pressed():
	if $login.text:
		my_login = $login.text
		$Panel/user.text = $login.text
		$AnimationPlayer.play("login_to_JH")
		


func _on_minus_pressed():
	if int($online_JH/num.text) > 1:
		$online_JH/num.text = str(int($online_JH/num.text)-1)
		$online_JH/error.visible = false
		st.server_number = int($online_JH/num.text)
func _on_plus_pressed():
	if int($online_JH/num.text) < 5:
		$online_JH/num.text = str(int($online_JH/num.text)+1)
		$online_JH/error.visible = false
		st.server_number = int($online_JH/num.text)


func _on_to_lobby_pressed():
	req.info["activity"] = false
	send.send(req.info)
	$online_JH/Control/to_lobby/Timer.start(10)
	loading = true
	$online_JH/Control.visible = false
func _on_Timer_timeout():
	if not "game_start" in req.info.keys():
		req.info = {"move": [], "activity": false, "game_start": false, "admin": my_login, "red": "ИИ", "green": "ИИ", "blue": "ИИ"}
		send.send(req.info)
		to_lobby()
	elif not req.info["activity"]:
		print('host')
		req.info = {"move": [], "activity": false, "game_start": false, "admin": my_login, "red": "ИИ", "green": "ИИ", "blue": "ИИ"}
		send.send(req.info)
		to_lobby()
	elif req.info["game_start"]:
		print("error")
		$online_JH/error.visible = true
		$online_JH/Control.visible = true
	elif not req.info["game_start"]:
		print('join')
		to_lobby()
	loading = false

func to_lobby():
	$AnimationPlayer.play("JH_to_lobby")
	



# LOBBY ########################
func change_command(color, login):
	if req.new_message and get_node("lobby/"+color+"/choose").text != login:
		req.new_message = false
		if login != "ИИ":
			AI.player_commands.append(color)
		else:
			AI.player_commands.erase(color)
		get_node("lobby/"+color+"/choose").text = login
		st.players[color] = login


func send_commands(color):
	var info = req.info.duplicate(false)
	if get_node("lobby/"+color+"/choose").text == "ИИ":
		info[color] = my_login
	else:
		info[color] = "ИИ"
	send.send(info)

func _on_r_pressed():
	send_commands("red")
func _on_g_pressed():
	send_commands("green")
func _on_b_pressed():
	send_commands("blue")


func _on_GO_pressed():
	req.info["game_start"] = true
	req.info["GO"] = true
	send.send(req.info)


func start():
	if my_login == st.players["red"]:
		st.user_color.append("red")
	if my_login == st.players["green"]:
		st.user_color.append("green")
	if my_login == st.players["blue"]:
		st.user_color.append("blue")
	if req.info["admin"] == my_login:
		st.admin = true
	var game = preload("res://scns/GAME.tscn").instance()
	get_tree().get_root().add_child(game)
	queue_free()

func _on_dis_pressed():
	OS.shell_open("https://discord.gg/F6UMZTrC")
func _on_vk_pressed():
	OS.shell_open("https://vk.com/public210443461")

func _on_where_pressed():
	if $where/RichTextLabel.visible:
		$where/RichTextLabel.visible = false
	else:
		$where/RichTextLabel.visible = true

func _on_dis_mouse_entered():
	$Panel/dis.modulate = Color(0.5,0.5,0.5)
func _on_dis_mouse_exited():
	$Panel/dis.modulate = Color(1,1,1)
func _on_vk_mouse_entered():
	$Panel/vk.modulate = Color(0.5,0.5,0.5)
func _on_vk_mouse_exited():
	$Panel/vk.modulate = Color(1,1,1)
