class_name Leaderboard
extends Node

var leaderboard_http: HTTPRequest
var submit_score_http: HTTPRequest

var score: int

signal upload_score_completed(value: Dictionary)
signal get_leadboard_completed(value: Dictionary)


func _process(_delta):
	if(Input.is_action_just_pressed("ui_up")):
		score += 1
		print("CurrentScore:"+str(score))
	
	if(Input.is_action_just_pressed("ui_down")):
		score -= 1
		print("CurrentScore:"+str(score))
	
	# Upload score when pressing enter
	if(Input.is_action_just_pressed("ui_accept")):
		_upload_score(score)
	
	# Get score when pressing spacebar
	if(Input.is_action_just_pressed("ui_select")):
		_get_leaderboards()


func _get_leaderboards() -> Dictionary:
	print("Getting leaderboards")
	var url = "https://api.lootlocker.io/game/leaderboards/" + Credentials.LEADERBOARD_KEY + "/list?count=10"
	var headers = ["Content-Type: application/json", "x-session-token:" + Credentials.session_token]
	
	# Create a request node for getting the highscore
	leaderboard_http = HTTPRequest.new()
	add_child(leaderboard_http)
	leaderboard_http.request_completed.connect(_on_leaderboard_request_completed)
	
	# Send request
	leaderboard_http.request(url, headers, HTTPClient.METHOD_GET, "")

	return await get_leadboard_completed


func _on_leaderboard_request_completed(result, response_code, headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	
	# Print data
	print(json.get_data())
	# WHAT WE DO OF THE LEADER BOARD ?

	get_leadboard_completed.emit(json.get_data())


func _upload_score(score: int) -> Dictionary:
	var data = { "score": str(score) }
	var headers = ["Content-Type: application/json", "x-session-token:" + Credentials.session_token]
	submit_score_http = HTTPRequest.new()
	add_child(submit_score_http)
	submit_score_http.request_completed.connect(_on_upload_score_request_completed)
	# Send request
	submit_score_http.request("https://api.lootlocker.io/game/leaderboards/" + Credentials.LEADERBOARD_KEY + "/submit", headers, HTTPClient.METHOD_POST, JSON.stringify(data))
	# Print what we're sending, for debugging purposes:
	print(data)

	return await upload_score_completed


func _on_upload_score_request_completed(result, response_code, headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	
	# Print data
	print(json.get_data())
	
	# Clear node
	submit_score_http.queue_free()

	upload_score_completed.emit(json.get_data())
