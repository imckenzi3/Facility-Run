extends NavigationAgent2D

#create three constand arrays
#first for the rooms we want to place at the start of the level
#second for thie middle rooms
#last for the rooms we want to place at the end of the level

const SPAWN_ROOMS: Array = [
	preload("res://scenes/rooms/SpawnRoom0.tscn"),
	preload("res://scenes/rooms/SpawnRoom1.tscn")
	# add more spawn rooms here
	] 
	
const INTERMEDIATE_ROOMS: Array = [
	preload("res://scenes/rooms/room1.tscn"),
	preload("res://scenes/rooms/room2.tscn"),
	# add more rooms here
	]

const END_ROOMS: Array = [
	preload("res://scenes/rooms/EndRoom.tscn")
	# add more end rooms here
	]

const TILE_SIZE: int = 16

#const for walls
const FLOOR_TILE_INDEX: int = 14
const RIGHT_WALL_TILE_INDEX: int = 5
const LEFT_WALL_TILE_INDEX: int = 6

#num of rooms we will add
@export var num_levels: int = 5

@onready var player: CharacterBody2D = get_parent().get_node("Player")

#call func later
func _ready() -> void:
	_spawn_rooms()
	
func _spawn_rooms() -> void:
	var previous_room: Node2D
	
	for i in num_levels:
		var room: Node2D
		
		if i == 0:
			room = SPAWN_ROOMS[randi() % SPAWN_ROOMS.size()].instantiate()
			player.position = room.get_node("PlayerSpawnPos").position
		else:
			if i == num_levels - 1:
				room = END_ROOMS[randi() % END_ROOMS.size()].instantiate()
			else:
				room = INTERMEDIATE_ROOMS[randi() % INTERMEDIATE_ROOMS.size()].instantiate()
				
			var previous_room_tilemap: TileMap = previous_room.get_node("TileMap")
			var previous_room_tilemap2: TileMap = previous_room.get_node("TileMap2")
			var previous_room_door: StaticBody2D = previous_room.get_node("Doors/Door")
			
			## FUCK THIS CODE - Will fix l8tr
			var exit_tile_pos: Vector2 = previous_room_tilemap.local_to_map(previous_room_door.position) + Vector2i.UP * 1
			
			var corridor_height: int = randi() % 5 + 2
			for y in corridor_height:
				#previous_room_tilemap.set_cell(0,exit_tile_pos + Vector2(-2, -y), LEFT_WALL_TILE_INDEX)
				#previous_room_tilemap.set_cell(0,exit_tile_pos + Vector2(-1, -y), FLOOR_TILE_INDEX)
				#previous_room_tilemap.set_cell(0,exit_tile_pos + Vector2(0, -y), FLOOR_TILE_INDEX)
				#previous_room_tilemap.set_cell(0,exit_tile_pos + Vector2(1, -y), RIGHT_WALL_TILE_INDEX)
				#walls.set_cell(0,walls.local_to_map(entry_position.position),0, Vector2i(2,5))
		
				# worked
				#floors
				previous_room_tilemap.set_cell(0, exit_tile_pos + Vector2(0, -y), 0, Vector2(6,2))
				previous_room_tilemap.set_cell(0, exit_tile_pos + Vector2(-1, -y), 0, Vector2(6,2))
				
				#walls
				previous_room_tilemap2.set_cell(0, exit_tile_pos + Vector2(0, -y), 0, Vector2(4,5)) #left wall
				previous_room_tilemap2.set_cell(0, exit_tile_pos + Vector2(-1, -y), 0, Vector2(3,5)) #right wall
			var room_tilemap: TileMap = room.get_node("TileMap")
			room.position = previous_room_door.global_position + Vector2.UP * room_tilemap.get_used_rect().size.y * TILE_SIZE + Vector2.UP * (1 + corridor_height) * TILE_SIZE + Vector2.LEFT * room_tilemap.local_to_map(room.get_node("Entrance/Node2D2").position).x * TILE_SIZE
			
		add_child(room)
		previous_room = room
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		#for i in num_levels:
		#var room: Node2D
		#
		#if i == 0:
			#room = SPAWN_ROOMS[randi() % SPAWN_ROOMS.size()].instantiate()
			#player.position = room.get_node("PlayerSpawnPos").position
		#else:
			#if i == num_levels - 1:
				#room = END_ROOMS[randi() % END_ROOMS.size()].instantiate()
			#else:
				#room = INTERMEDIATE_ROOMS[randi() % INTERMEDIATE_ROOMS.size()].instantiate()
				#
			#var previous_room_tilemap: TileMap = previous_room.get_node("TileMap")
			#var previous_room_door: StaticBody2D = previous_room.get_node("Doors/Door")
			#
			### FUCK THIS CODE - Will fix l8tr
			#var exit_tile_pos: Vector2 = previous_room_tilemap.local_to_map(previous_room_door.position) + Vector2i.UP * 2
			#
			#var corridor_height: int = randi() % 5 + 2
			#for y in corridor_height:
				#previous_room_tilemap.set_cell(0,exit_tile_pos + Vector2(-2, -y), LEFT_WALL_TILE_INDEX)
				#previous_room_tilemap.set_cell(0,exit_tile_pos + Vector2(-1, -y), FLOOR_TILE_INDEX)
				#previous_room_tilemap.set_cell(0,exit_tile_pos + Vector2(0, -y), FLOOR_TILE_INDEX)
				#previous_room_tilemap.set_cell(0,exit_tile_pos + Vector2(1, -y), RIGHT_WALL_TILE_INDEX)
				##walls.set_cell(0,walls.local_to_map(entry_position.position),0, Vector2i(2,5))
				##previous_room_tilemap.set_cell(0,exit_tile_pos + Vector2(-2, -y), LEFT_WALL_TILE_INDEX)
		#
				## worked
				##floors
				#previous_room_tilemap.set_cell(0, (exit_tile_pos + Vector2(0, -y)), 0, Vector2i(6,2))
				#previous_room_tilemap.set_cell(0, (exit_tile_pos + Vector2(-1, -y)), 0, Vector2i(6,2))
				#
				##walls
				#previous_room_tilemap.set_cell(0, (exit_tile_pos + Vector2(-2, -y)), 0, Vector2i(4,5)) #left wall
				#previous_room_tilemap.set_cell(0, (exit_tile_pos + Vector2(1, -y)), 0, Vector2i(3,5)) #right wall
			#var room_tilemap: TileMap = room.get_node("TileMap")
			#room.position = previous_room_door.global_position + Vector2.UP * room_tilemap.get_used_rect().size.y * TILE_SIZE + Vector2.UP * (1 + corridor_height) * TILE_SIZE + Vector2.LEFT * room_tilemap.local_to_map(room.get_node("Entrance/Node2D2").position).x * TILE_SIZE
			#
		#add_child(room)
		#previous_room = room

