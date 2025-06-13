@tool
extends CharacterBody2D
class_name Unit

# --- Segnali ---
signal unit_moved(unit: Unit, new_position: Vector2i)
signal action_performed(unit: Unit, action: String)
signal turn_ended(unit: Unit)
signal health_changed(unit: Unit, current_health: int, max_health: int)
signal action_points_changed(unit: Unit, current_ap: int, max_ap: int)
signal unit_died(unit: Unit)

# --- Proprietà Esportate ---
@export var character_sheet: CharacterSheet
@export var max_action_points: int = 2
@export var grid_position: Vector2i = Vector2i.ZERO

# --- Proprietà Private ---
var _current_action_points: int = 2
var _current_health: int = 0
var _max_health: int = 0
var _is_in_overwatch: bool = false
var _is_hunkered_down: bool = false
var _is_dead: bool = false
var initiative: int = 0

# --- Inizializzazione ---
func _ready() -> void:
	if not character_sheet:
		push_error("Unit: character_sheet non assegnato!")
		return
	
	# Inizializza statistiche
	_max_health = UCS.calculate_max_health(character_sheet)
	_current_health = _max_health
	_current_action_points = max_action_points
	
	# Emetti segnali iniziali
	health_changed.emit(self, _current_health, _max_health)
	action_points_changed.emit(self, _current_action_points, max_action_points)

# --- Gestione Movimento ---
func move_to(path: Array[Vector2i]) -> bool:
	if path.is_empty():
		return false
	
	# Verifica se ha abbastanza PA
	if _current_action_points < 1:
		return false
	
	# Aggiorna posizione
	grid_position = path[-1]
	_current_action_points -= 1
	
	# Emetti segnali
	unit_moved.emit(self, grid_position)
	action_points_changed.emit(self, _current_action_points, max_action_points)
	
	return true

# --- Gestione Azioni ---
func attack(target: Unit) -> bool:
	if not target or _current_action_points < 1:
		return false
	
	# TODO: Implementare calcolo danno
	var damage = 1
	target.take_damage(damage)
	
	_current_action_points -= 1
	action_points_changed.emit(self, _current_action_points, max_action_points)
	action_performed.emit(self, "attack")
	
	return true

func enter_overwatch() -> bool:
	if _current_action_points < 1:
		return false
	
	_is_in_overwatch = true
	_current_action_points -= 1
	
	action_points_changed.emit(self, _current_action_points, max_action_points)
	action_performed.emit(self, "overwatch")
	
	return true

func hunker_down() -> bool:
	if _current_action_points < 1:
		return false
	
	_is_hunkered_down = true
	_current_action_points -= 1
	
	action_points_changed.emit(self, _current_action_points, max_action_points)
	action_performed.emit(self, "hunker_down")
	
	return true

# --- Gestione Danno ---
func take_damage(amount: int) -> void:
	_current_health = max(0, _current_health - amount)
	health_changed.emit(self, _current_health, _max_health)
	
	if _current_health <= 0:
		die()

func heal(amount: int) -> void:
	_current_health = min(_max_health, _current_health + amount)
	health_changed.emit(self, _current_health, _max_health)

func die() -> void:
	_is_dead = true
	unit_died.emit(self)
	# Non chiamiamo queue_free() immediatamente per permettere al CombatManager di gestire la rimozione

# --- Gestione Turno ---
func start_turn() -> void:
	_current_action_points = max_action_points
	_is_in_overwatch = false
	_is_hunkered_down = false
	
	action_points_changed.emit(self, _current_action_points, max_action_points)

func end_turn() -> void:
	turn_ended.emit(self)

# --- Utility ---
func has_action_points() -> bool:
	return _current_action_points > 0

func get_remaining_action_points() -> int:
	return _current_action_points

func is_in_overwatch() -> bool:
	return _is_in_overwatch

func is_hunkered_down() -> bool:
	return _is_hunkered_down

func get_grid_position() -> Vector2i:
	return grid_position

func is_dead() -> bool:
	return _is_dead

func consume_action_points(amount: int) -> void:
	_current_action_points = max(0, _current_action_points - amount)
	action_points_changed.emit(self, _current_action_points, max_action_points)

# Proprietà per compatibilità con CombatManager
var current_action_points: int:
	get: return _current_action_points
	set(value): _current_action_points = value

var current_health: int:
	get: return _current_health
	set(value): _current_health = value

var is_overwatching: bool:
	get: return _is_in_overwatch
	set(value): _is_in_overwatch = value

var hunkered_down_state: bool:
	get: return _is_hunkered_down
	set(value): _is_hunkered_down = value

var dead_state: bool:
	get: return _is_dead
	set(value): _is_dead = value

# --- Debug ---
func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	
	if not character_sheet:
		warnings.append("CharacterSheet non assegnato!")
	
	return warnings 