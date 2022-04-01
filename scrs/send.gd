extends Node

var completed = {1:true,2:true,3:true,4:true,5:true}
var loading = false
func send(data):
	for i in range(get_child_count()-1):
		i+=1
		if completed[i]:
			completed[i] = false
			loading = true
			get_node(str(i)).request(st.my_server+'?type=set&server='+str(st.server_number)+'&data='+JSON.print(data))
			break

func _process(delta):
	if not false in completed.values():
		loading = false

func _on_1_request_completed(result, response_code, headers, body):
	completed[1] = true
func _on_2_request_completed(result, response_code, headers, body):
	completed[2] = true
func _on_3_request_completed(result, response_code, headers, body):
	completed[3] = true
func _on_4_request_completed(result, response_code, headers, body):
	completed[4] = true
func _on_5_request_completed(result, response_code, headers, body):
	completed[5] = true
