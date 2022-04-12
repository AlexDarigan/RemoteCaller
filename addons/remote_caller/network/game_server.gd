extends "res://addons/remote_caller/network/remote_caller_network.gd"

var _peer_id: int

func _ready() -> void:
	# Should only run in the Editor
	custom_multiplayer.connect("network_peer_connected", self, "_on_network_peer_connected")
	if _error(_peer.create_server(PORT, MAXCLIENTS)) == OK:
		custom_multiplayer.network_peer = _peer
		
func _on_network_peer_connected(_id: int) -> void:
	_peer_id = _id
	
master func make_call(object_id: int, call_type: String, callable: String) -> void:
	var instance = instance_from_id(object_id)
	if call_type == "function":
		instance.callv(callable, instance._REMOTE_CALL_PARAMS)
	else:
		var x = [callable]
		x += instance._REMOTE_CALL_PARAMS
		# Emit Signal can read empty arrays as arguments so we curry..
		# ..it through callv with a merged array
		instance.callv("emit_signal", x)
			
var _processed_script_paths = []

master func _add_parameters(object_id: int) -> void:
	# We handle this automatically via nodes but needed to use a button for anything else
	var obj = instance_from_id(object_id)
	if obj.get_script():
		_inject_param_array(obj)
		
func _inject_param_array(object):
	if "RemoteCaller" in object.name:
		return
	if _processed_script_paths.has(object.get_script().resource_path):
		return
	var scripts = _travel_inheritance_chain(object)
	# At this point we could have scripts that have already inherited the thing
	if not _already_chained:
	# Set source code of uber-parent
		var s = scripts.pop_back()
		s.source_code += "\nexport(Array) var _REMOTE_CALL_PARAMS: Array = []"
		s.reload(true)
	
	for script in scripts:
		script.reload(true)
	_already_chained = false

var _already_chained = false # Have we been here before
func _travel_inheritance_chain(object) -> Array:
	var scripts: Array = []
	var next: GDScript = object.get_script()
	var prev
	while next != null:
		if _processed_script_paths.has(next.resource_path):
			_already_chained = true
			return scripts
		_processed_script_paths.append(next.resource_path)
		scripts.append(next)
		prev = next
		next = next.get_base_script()
	return scripts

func _exit_tree() -> void:
	rpc_id(_peer_id, "_get_kicked")
	if custom_multiplayer.network_peer != null:
		custom_multiplayer.network_peer.close_connection(200)
