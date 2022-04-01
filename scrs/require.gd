extends Node
func _ready():
	for i in range(get_child_count()-1):
		i+=1
		completed[i] = true
		get_node(str(i)).connect("request_completed", self, "do")
	
	
var data = {}
var info = {}
var new_message = false
var completed = {1:true,2:true,3:true,4:true,5:true}
func require():
	for i in range(get_child_count()-1):
		i+=1
		if completed[i] and not send.loading:
			completed[i] = false
			get_node(str(i)).request(st.my_server+'?type=get&server='+str(st.server_number))
			break


func do(_result, response_code, _headers, body):
	if response_code == 200:
		data = parse_json(body.get_string_from_utf8())
		if data and not send.loading:
			info = data.duplicate()
			new_message = true
	else:
		print(response_code)


func _on_1_request_completed(_result, _response_code, _headers, _body):
	completed[1] = true
func _on_2_request_completed(_result, _response_code, _headers, _body):
	completed[2] = true
func _on_3_request_completed(_result, _response_code, _headers, _body):
	completed[3] = true
func _on_4_request_completed(_result, _response_code, _headers, _body):
	completed[4] = true
func _on_5_request_completed(_result, _response_code, _headers, _body):
	completed[5] = true
func _on_6_request_completed(_result, _response_code, _headers, _body):
	completed[6] = true
func _on_7_request_completed(_result, _response_code, _headers, _body):
	completed[7] = true
func _on_8_request_completed(_result, _response_code, _headers, _body):
	completed[8] = true
func _on_9_request_completed(_result, _response_code, _headers, _body):
	completed[9] = true
func _on_10_request_completed(_result, _response_code, _headers, _body):
	completed[10] = true
