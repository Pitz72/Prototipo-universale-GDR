extends RefCounted
class_name CombatGrid

## CombatGrid v2 - Approccio Incrementale Sicuro
## Versione minimale per evitare crash sistema classi

# Costanti base
const GRID_WIDTH = 20
const GRID_HEIGHT = 15
const CELL_SIZE = 1.5  # metri per cella

# Enum per coperture
enum CoverType {
	NONE = 0,
	LOW = 1,
	HIGH = 2
}

# Struttura base CellData
class CellData:
	var is_walkable: bool = true
	var cover_north: int = CoverType.NONE
	var cover_south: int = CoverType.NONE  
	var cover_east: int = CoverType.NONE
	var cover_west: int = CoverType.NONE
	var occupant_id: String = ""  # ID invece di riferimento diretto
	
	func _init():
		is_walkable = true

# Griglia principale
var grid_data: Array[Array] = []

# Inizializzazione
func _init():
	_initialize_grid()

func _initialize_grid():
	grid_data = []
	for x in range(GRID_WIDTH):
		var column: Array[CellData] = []
		for y in range(GRID_HEIGHT):
			column.append(CellData.new())
		grid_data.append(column)

# Funzioni base di accesso
func is_valid_position(pos: Vector2i) -> bool:
	return pos.x >= 0 and pos.x < GRID_WIDTH and pos.y >= 0 and pos.y < GRID_HEIGHT

func get_cell_data(pos: Vector2i) -> CellData:
	if not is_valid_position(pos):
		return null
	return grid_data[pos.x][pos.y]

func set_cell_walkable(pos: Vector2i, walkable: bool):
	var cell = get_cell_data(pos)
	if cell:
		cell.is_walkable = walkable

func set_cover(pos: Vector2i, direction: String, cover_value: int):
	var cell = get_cell_data(pos)
	if not cell:
		return
		
	match direction.to_lower():
		"north":
			cell.cover_north = cover_value
		"south":
			cell.cover_south = cover_value
		"east":
			cell.cover_east = cover_value
		"west":
			cell.cover_west = cover_value

# Funzione per ottenere copertura da una direzione
func get_cover_from(pos: Vector2i, from_direction: String) -> int:
	var cell = get_cell_data(pos)
	if not cell:
		return CoverType.NONE
		
	match from_direction.to_lower():
		"north":
			return cell.cover_north
		"south":
			return cell.cover_south
		"east":
			return cell.cover_east
		"west":
			return cell.cover_west
		_:
			return CoverType.NONE

# Funzione placeholder per pathfinding (da implementare)
func find_path(start: Vector2i, end: Vector2i) -> Array[Vector2i]:
	# TODO: Implementare A* 
	return [start, end]

# Debug utilities
func print_grid_info():
	print("CombatGrid v2 - Dimensioni: ", GRID_WIDTH, "x", GRID_HEIGHT)
	print("Celle totali: ", GRID_WIDTH * GRID_HEIGHT)
	print("Celle walkable: ", count_walkable_cells())

func count_walkable_cells() -> int:
	var count = 0
	for x in range(GRID_WIDTH):
		for y in range(GRID_HEIGHT):
			if grid_data[x][y].is_walkable:
				count += 1
	return count 