extends "res://addons/remote_caller/network/remote_caller_network.gd"

var _peer_id: int

func _ready() -> void:
	# Should only run in the Editor
	add_to_group("RemoteCallerServer")
	custom_multiplayer.connect("network_peer_connected", self, "_on_network_peer_connected")
	if _error(_peer.create_server(PORT, MAXCLIENTS)) == OK:
		custom_multiplayer.network_peer = _peer
		
func _on_network_peer_connected(_id: int) -> void:
	_peer_id = _id
	
master func make_call(object_id: int, callable: String) -> void:
	instance_from_id(object_id).call(callable)
