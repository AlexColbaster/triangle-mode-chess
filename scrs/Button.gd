extends TextureButton

func _ready():
	connect("mouse_entered", self, "_mouse_entered")
	connect("mouse_exited", self, "_mouse_exited")

onready var pos = rect_global_position.y
var sdvig = 20
var timing = 0
func _process(_delta):
	if pressed:
		rect_global_position.y = pos + sdvig*rect_scale.x*0.25
		rect_global_position.y = pos + sdvig*rect_scale.x*0.5
		rect_global_position.y = pos + sdvig*rect_scale.x*0.75
		rect_global_position.y = pos + sdvig*rect_scale.x
	else:
		rect_global_position.y = pos + sdvig*rect_scale.x
		rect_global_position.y = pos + sdvig*rect_scale.x*0.75
		rect_global_position.y = pos + sdvig*rect_scale.x*0.5
		rect_global_position.y = pos + sdvig*rect_scale.x*0.25

	
func _mouse_entered():
	get_child(0).modulate = Color(0.8, 0.8, 0.8)
func _mouse_exited():
	get_child(0).modulate = Color(1, 1, 1)
