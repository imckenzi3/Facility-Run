extends TileMap

func world_to_map(w_pos):
	# godot does not handle world_to_map transformation correctly when
	# the tilemap's position is not at (0, 0). We must offset our point
	# by the position of the tilemap
	return world_to_map(w_pos - position)
	
func map_to_world(m_pos, ignore_half_ofs=false):
	# godot does not handle map_to_world transformation correctly when
	# the tilemap's position is not at (0, 0). We must offset our point
	# by the position of the tilemap
	return map_to_world(m_pos, ignore_half_ofs) + position
