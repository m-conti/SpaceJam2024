class_name Authentication
extends Node

const CREDENTIAL_FILE = "user://" + Credentials.COMPANY_NAME + ".data"
const IS_DEVELOPMENT_BUILD = true

var auth_http: HTTPRequest
var get_name_http: HTTPRequest
var set_name_http: HTTPRequest

signal auth_completed(value: Dictionary)
signal change_player_name_completed(value: Dictionary)
signal get_name_completed(value: Dictionary)

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	await _authentication_request()


func _authentication_request():
	# Check if a player session exists
	var player_session_exists := false
	var player_identifier: String
	var file = FileAccess.open(CREDENTIAL_FILE, FileAccess.READ)
	if file != null:
		player_identifier = file.get_as_text()
		print("player ID=" + player_identifier)
		file.close()
 
	if player_identifier != null and player_identifier.length() > 1:
		print("player session exists, id=" + player_identifier)
		player_session_exists = true

	## Convert data to json string:
	var data = { "game_key": Credentials.API_KEY, "game_version": "0.0.0.1", "development_mode": IS_DEVELOPMENT_BUILD }

	# If a player session already exists, send with the player identifier
	if player_session_exists:
		data["player_identifier"] = player_identifier
	
	# Add 'Content-Type' header:
	var headers = ["Content-Type: application/json"]
	
	# Create a HTTPRequest node for authentication
	auth_http = HTTPRequest.new()
	add_child(auth_http)
	# Send request
	auth_http.request_completed.connect(_on_authentication_request_completed)
	auth_http.request("https://api.lootlocker.io/game/v2/session/guest", headers, HTTPClient.METHOD_POST, JSON.stringify(data))
	# Print what we're sending, for debugging purposes:
	print(data)
	return await auth_completed


func _on_authentication_request_completed(result, response_code, headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	
	# Save the player_identifier to file
	var file = FileAccess.open(CREDENTIAL_FILE, FileAccess.WRITE)
	file.store_string(json.get_data().player_identifier)
	file.close()
	
	# Save session_token to memory
	Credentials.session_token = json.get_data().session_token
	
	# Print server response
	print(json.get_data())
	
	# Clear node
	auth_http.queue_free()
	auth_completed.emit(json.get_data())


func _change_player_name(new_player_name: String):
	print("Changing player name")

	var data = { "name": new_player_name }
	var url =  "https://api.lootlocker.io/game/player/name"
	var headers = ["Content-Type: application/json", "x-session-token:" + Credentials.session_token]
	
	# Create a request node for getting the highscore
	set_name_http = HTTPRequest.new()
	add_child(set_name_http)
	set_name_http.request_completed.connect(_on_player_set_name_request_completed)
	# Send request
	set_name_http.request(url, headers, HTTPClient.METHOD_PATCH, JSON.stringify(data))

	return await change_player_name_completed


func _on_player_set_name_request_completed(result, response_code, headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	
	# Print data
	print(json.get_data())
	set_name_http.queue_free()

	change_player_name_completed.emit(json.get_data())


func _get_player_name():
	print("Getting player name")
	var url = "https://api.lootlocker.io/game/player/name"
	var headers = ["Content-Type: application/json", "x-session-token:" + Credentials.session_token]
	
	# Create a request node for getting the highscore
	get_name_http = HTTPRequest.new()
	add_child(get_name_http)
	get_name_http.request_completed.connect(_on_player_get_name_request_completed)
	# Send request
	get_name_http.request(url, headers, HTTPClient.METHOD_GET, "")

	return await get_name_completed


func _on_player_get_name_request_completed(result, response_code, headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	
	# Print data
	print(json.get_data())
	# Print player name
	print(json.get_data().name)
	get_name_http.queue_free()

	get_name_completed.emit(json.get_data())
