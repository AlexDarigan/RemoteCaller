extends "res://addons/remote_caller/network/remote_caller_network.gd"

var _peer_id: int

func _enter_tree() -> void:
	get_tree().connect("node_added", self, "_on_node_added")

func _ready() -> void:
	# Should only run in the Editor
	custom_multiplayer.connect("network_peer_connected", self, "_on_network_peer_connected")
	if _error(_peer.create_server(PORT, MAXCLIENTS)) == OK:
		custom_multiplayer.network_peer = _peer
		
func _on_network_peer_connected(_id: int) -> void:
	_peer_id = _id
	
master func make_call(object_id: int, callable: String) -> void:
	var instance = instance_from_id(object_id)
	instance.callv(callable, instance._REMOTE_CALL_PARAMS)
	

func _on_node_added(node: Node) -> void:
	if "RemoteCaller" in node.name:
		# Avoiding editing ourselves during run time
		return
	if node.get_script() and node.get("_REMOTE_CALL_PARAMS") == null:
		# Inject a list of exported parameters we can modify in the Inspector
		node.get_script().source_code += "\nexport(Array) var _REMOTE_CALL_PARAMS = []"
		node.get_script().reload(true)
		
func _exit_tree() -> void:
	if custom_multiplayer.network_peer != null:
		custom_multiplayer.network_peer.close_connection()
