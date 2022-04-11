tool
extends "res://addons/remote_caller/network/remote_caller_network.gd"

func _ready() -> void:
	if not Engine.is_editor_hint():
		custom_multiplayer.connect("connection_failed", self, "_on_connection_failed")
	
func _connect_to_server() -> void:
	if not Engine.is_editor_hint():
		push_warning("Remote Caller Client is Engine Only")
		return
	if _error(_peer.create_client(IPAddress, PORT)) == OK:
		custom_multiplayer.network_peer = _peer
		yield(custom_multiplayer, "connected_to_server")
		
func _on_connection_failed() -> void:
	push_warning("TestClient could not connect to TestServer")
	
func _is_connected_to_server() -> bool:
	return _peer.get_connection_status() == NetworkedMultiplayerPeer.CONNECTION_CONNECTED

func make_call(remote_object_id: int, callable: String) -> void:
	if not Engine.is_editor_hint():
		push_warning("Remote Caller Client is Engine Only")
		return
	if not _is_connected_to_server():
		print("Remote Caller: Connecting to Game Server. Please wait")
		yield(_connect_to_server(), "completed")
	rpc_id(1, "make_call", remote_object_id, callable)
