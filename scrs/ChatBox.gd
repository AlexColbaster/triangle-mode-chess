extends Control

onready var chatLog = get_node("RichTextLabel")
onready var inputField = get_node("LineEdit")

var groups = {
	'red':'#640000',
	'green':'#006400',
	'blue':'#000064'
}

func _ready():
	inputField.connect("text_entered", self,'text_entered')


func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ENTER:
			inputField.grab_focus()


remotesync func add_message(text, group):

	chatLog.bbcode_text += '\n'
	chatLog.bbcode_text += '[color=' + groups[group] + ']'
	chatLog.bbcode_text += text


func text_entered(text):
	if text != '':
		rpc("add_message",text, st.user_color[0])
		inputField.text = ''

