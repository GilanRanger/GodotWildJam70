extends Node2D
class_name WorldBoard

var node_relations = {}
var enemies = []

func _ready():
	create_node_relations()
	enemies = get_node("WorldEnemies").get_children()
	
	if not global.fad_felen_alive:
		get_node("WorldEnemies/FadFelen").visible = false

func get_enemy_at(x: int, y: int) -> WorldEnemy:
	for enemy in enemies:
		if (enemy as WorldEnemy).homeNode == [x, y]:
			if enemy.visible == false: return null
			return (enemy as WorldEnemy)
			
	return null

func get_node_position(x: int, y: int) -> Vector2:
	var node_name = str(x) + "," + str(y)
	var node = (get_node("WorldNodes/" + node_name) as Node2D)
	
	if node == null:
		return Vector2(-256, -256)
		
	return node.global_position
	
func get_position_from_node(node: Node2D) -> Array:
	var parts = node.name.split(",")
	if parts.size() != 2:
		print("Invalid node name format.")
		return []
	# Convert the strings to integers
	var y = int(parts[0])
	var x = int(parts[1])
	# Return the result as an array of integers
	return [y, x]

func get_closest_node(global_point: Vector2) -> Node2D:
	var max_distance = 30
	
	for node in get_node("WorldNodes").get_children():
		node = node as Node2D
		if (abs(node.global_position.x - global_point.x) < 30 
			and abs(node.global_position.y - global_point.y) < 30):
				return node
				
	return null
	
func check_connection(node_0: Array, node_1: Array) -> bool:
	if node_relations[node_0].has(node_1):
		return true
	return false
	
func create_node_relations():
	# If unable to move between certain nodes, there is probably a mistake in here
	
	node_relations[[0,0]] = [[0,1],[1,0],[-1,0],[0,-1]]
	
	node_relations[[0,1]] = [[0,0],[0,2],[1,0],[-1,0]]
	node_relations[[1,0]] = [[0,0],[0,1],[0,-1],[2,0]]
	node_relations[[-1,0]] = [[0,0],[0,1],[0,-1],[-2,0]]
	node_relations[[0,-1]] = [[0,0],[0,-2],[1,0],[-1,0]]
	
	node_relations[[-2,0]] = [[-1,0],[-3,0],[-2,2],[-2,-2]]
	node_relations[[-2,2]] = [[0,2],[-2,0],[-3,3]]
	node_relations[[0,2]] = [[0,1],[0,3],[2,2],[-2,2]]
	node_relations[[2,2]] = [[0,2],[2,0],[3,3]]
	node_relations[[2,0]] = [[1,0],[3,0],[2,2],[2,-2]]
	node_relations[[2,-2]] = [[0,-2],[2,0],[3,-3]]
	node_relations[[0,-2]] = [[0,-1],[0,-3],[-2,-2],[2,-2]]
	node_relations[[-2,-2]] = [[0,-2],[-2,0],[-3,-3]]
	
	node_relations[[-3,0]] = [[-2,0],[-3,-1],[-3,1]]
	node_relations[[-3,1]] = [[-3,0],[-3,3]]
	node_relations[[-3,3]] = [[-2,2],[-3,1],[-1,3]]
	node_relations[[-1,3]] = [[0,3],[-3,3]]
	node_relations[[0,3]] = [[0,2],[-1,3],[1,3]]
	node_relations[[1,3]] = [[0,3],[3,3]]
	node_relations[[3,3]] = [[2,2],[3,1],[1,3]]
	node_relations[[3,1]] = [[3,0],[3,3]]
	node_relations[[3,0]] = [[2,0],[3,-1],[3,1]]
	node_relations[[3,-1]] = [[3,0],[3,-3]]
	node_relations[[3,-3]] = [[2,-2],[3,-1],[1,-3]]
	node_relations[[1,-3]] = [[0,-3],[3,-3]]
	node_relations[[0,-3]] = [[0,-2],[-1,-3],[1,-3]]
	node_relations[[-1,-3]] = [[0,-3],[-3,-3]]
	node_relations[[-3,-3]] = [[-2,-2],[-3,1],[-3,-1]]
	node_relations[[-3,-1]] = [[-3,0],[-3,-3]]
