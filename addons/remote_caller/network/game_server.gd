extends "res://addons/remote_caller/network/remote_caller_network.gd"

var _peer_id: int
var _regex: RegEx

func _enter_tree() -> void:
	_regex = RegEx.new()
	_regex.compile("^extends .*")
	get_tree().connect("node_added", self, "_on_node_added")

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
	
var _processed_classes = []


func _on_node_added(node: Node) -> void:
	if "RemoteCaller" in node.name:
		# Avoiding editing ourselves during run time
		return
	if node.get_script():
		var klass = _get_class(node.get_script().source_code)
		var script: GDScript = _seek_base_user_defined_type(node)
		if script != null:
			script.source_code += "\nexport(Array) var _REMOTE_CALL_PARAMS = []"
			script.reload(true)
			node._REMOTE_CALL_PARAMS = []
		
func _exit_tree() -> void:
	if custom_multiplayer.network_peer != null:
		custom_multiplayer.network_peer.close_connection()
		
# if we hit a class that already exists, return an empty string, else return the class once we hit base
func _seek_base_user_defined_type(node: Node) -> Script:
	# Process all user defined types in the inheritance chain and adds them to a list of..
	# ..processed nodes, we can then check this list on new nodes and see if it inherits the..
	# ..remote call parameters
	var seeking: bool = true
	var next = node.get_script()
	var prev: Script
	while seeking and next != null:
		var klass = _get_class(next.source_code)
		if ClassDB.class_exists(klass):
			seeking = false	# We've hit Engine-defined types
		elif _processed_classes.has(klass):
			return null # We've already processed this chain before
		else:
			_processed_classes.append(klass) # Add our current class to processed classes
			prev = next	# Store our last class
			next = next.get_base_script()
	# We hit an engine defined type, so we return one class before that for the base user-type
	return prev
			
func _get_class(source: String) -> String:
	return _regex.search(source).get_string().replace("extends ", "").replace('"', "")
