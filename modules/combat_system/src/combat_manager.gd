extends Node

# === Combat Manager Singleton ===
# Gestisce il ciclo di combattimento tattico a turni
# Player Turn → Enemy Turn → Neutral Turn

# Segnali per comunicazione UI e sistema
signal turn_started(phase: TurnPhase, current_unit: Node)
signal turn_ended(phase: TurnPhase)
signal combat_started()
signal combat_ended(victory: bool)
signal unit_initiative_calculated(unit: Node, initiative: int)
signal action_performed(unit: Node, action_name: String, success: bool)

# Enumerazioni
enum TurnPhase {
	PLAYER,
	ENEMY,
	NEUTRAL,
	END_COMBAT
}

enum CombatState {
	INACTIVE,
	SETUP,
	ACTIVE,
	PAUSED,
	COMPLETED
}

# Variabili pubbliche
@export var combat_grid: Node
@export var turn_time_limit: float = 30.0  # Secondi per turno (opzionale)

# Gruppi di unità
var player_units: Array[Node] = []
var ally_units: Array[Node] = []
var enemy_units: Array[Node] = []
var neutral_units: Array[Node] = []

# Stato combattimento
var current_phase: TurnPhase = TurnPhase.PLAYER
var current_state: CombatState = CombatState.INACTIVE
var current_unit_index: int = 0
var turn_number: int = 0
var initiative_order: Array[Node] = []

# Timer per turni (opzionale)
var turn_timer: Timer

func _ready() -> void:
	# Setup timer per turni
	turn_timer = Timer.new()
	turn_timer.wait_time = turn_time_limit
	turn_timer.timeout.connect(_on_turn_timeout)
	add_child(turn_timer)
	
	# Debug info
	print("CombatManager inizializzato")

# === GESTIONE COMBATTIMENTO ===

func start_combat() -> void:
	"""Inizia un nuovo combattimento"""
	if current_state != CombatState.INACTIVE:
		push_warning("Tentativo di iniziare combattimento già attivo")
		return
	
	print("=== INIZIO COMBATTIMENTO ===")
	current_state = CombatState.SETUP
	turn_number = 1
	
	# Calcola iniziativa per tutte le unità
	_calculate_all_initiatives()
	
	# Ordina per iniziativa
	_sort_initiative_order()
	
	# Inizia il primo turno
	current_state = CombatState.ACTIVE
	current_phase = TurnPhase.PLAYER
	current_unit_index = 0
	
	combat_started.emit()
	_start_next_turn()

func end_combat(victory: bool = true) -> void:
	"""Termina il combattimento"""
	print("=== FINE COMBATTIMENTO ===")
	print("Risultato: ", "VITTORIA" if victory else "SCONFITTA")
	
	current_state = CombatState.COMPLETED
	current_phase = TurnPhase.END_COMBAT
	
	# Ferma timer se attivo
	if turn_timer.time_left > 0:
		turn_timer.stop()
	
	# Reset stati unità
	_reset_all_units()
	
	combat_ended.emit(victory)

func pause_combat() -> void:
	"""Mette in pausa il combattimento"""
	if current_state == CombatState.ACTIVE:
		current_state = CombatState.PAUSED
		turn_timer.paused = true
		print("Combattimento in pausa")

func resume_combat() -> void:
	"""Riprende il combattimento"""
	if current_state == CombatState.PAUSED:
		current_state = CombatState.ACTIVE
		turn_timer.paused = false
		print("Combattimento ripreso")

# === GESTIONE TURNI ===

func _start_next_turn() -> void:
	"""Inizia il prossimo turno nella sequenza"""
	if current_state != CombatState.ACTIVE:
		return
	
	# Verifica condizioni di vittoria/sconfitta
	if _check_combat_end_conditions():
		return
	
	# Determina fase corrente
	var units_in_phase = _get_units_for_current_phase()
	
	if units_in_phase.is_empty():
		_advance_to_next_phase()
		return
	
	# Inizia turno per unità corrente
	var current_unit = units_in_phase[current_unit_index] if current_unit_index < units_in_phase.size() else null
	
	if current_unit and is_instance_valid(current_unit) and not current_unit.is_dead:
		print("Turno: ", _get_phase_name(current_phase), " - Unità: ", current_unit.character_sheet.character_name if current_unit.character_sheet else "Sconosciuta")
		
		# Reset punti azione e stati
		current_unit.start_turn()
		
		# Avvia timer se necessario
		if turn_time_limit > 0 and current_phase == TurnPhase.PLAYER:
			turn_timer.start()
		
		turn_started.emit(current_phase, current_unit)
	else:
		# Unità non valida, passa alla prossima
		_advance_to_next_unit()

func end_current_turn() -> void:
	"""Termina il turno corrente e passa al prossimo"""
	if current_state != CombatState.ACTIVE:
		return
	
	# Ferma timer
	turn_timer.stop()
	
	# Emetti segnale fine turno
	turn_ended.emit(current_phase)
	
	# Passa alla prossima unità
	_advance_to_next_unit()

func _advance_to_next_unit() -> void:
	"""Avanza alla prossima unità nella fase corrente"""
	var units_in_phase = _get_units_for_current_phase()
	current_unit_index += 1
	
	if current_unit_index >= units_in_phase.size():
		# Fine fase, passa alla prossima
		_advance_to_next_phase()
	else:
		# Prossima unità nella stessa fase
		_start_next_turn()

func _advance_to_next_phase() -> void:
	"""Avanza alla prossima fase del turno"""
	current_unit_index = 0
	
	match current_phase:
		TurnPhase.PLAYER:
			current_phase = TurnPhase.ENEMY
		TurnPhase.ENEMY:
			current_phase = TurnPhase.NEUTRAL
		TurnPhase.NEUTRAL:
			# Nuovo round
			turn_number += 1
			current_phase = TurnPhase.PLAYER
			print("=== ROUND ", turn_number, " ===")
	
	_start_next_turn()

# === GESTIONE UNITÀ ===

func add_player_unit(unit: Node) -> void:
	"""Aggiunge un'unità del giocatore"""
	if unit and unit not in player_units:
		player_units.append(unit)
		_connect_unit_signals(unit)
		print("Aggiunta unità giocatore: ", unit.character_sheet.character_name if unit.character_sheet else "Sconosciuta")

func add_ally_unit(unit: Node) -> void:
	"""Aggiunge un'unità alleata"""
	if unit and unit not in ally_units:
		ally_units.append(unit)
		_connect_unit_signals(unit)
		print("Aggiunta unità alleata: ", unit.character_sheet.character_name if unit.character_sheet else "Sconosciuta")

func add_enemy_unit(unit: Node) -> void:
	"""Aggiunge un'unità nemica"""
	if unit and unit not in enemy_units:
		enemy_units.append(unit)
		_connect_unit_signals(unit)
		print("Aggiunta unità nemica: ", unit.character_sheet.character_name if unit.character_sheet else "Sconosciuta")

func remove_unit(unit: Node) -> void:
	"""Rimuove un'unità da tutti i gruppi"""
	player_units.erase(unit)
	ally_units.erase(unit)
	enemy_units.erase(unit)
	neutral_units.erase(unit)
	initiative_order.erase(unit)
	
	_disconnect_unit_signals(unit)
	print("Rimossa unità: ", unit.character_sheet.character_name if unit.character_sheet else "Sconosciuta")

func _connect_unit_signals(unit: Node) -> void:
	"""Collega i segnali dell'unità al combat manager"""
	if unit.has_signal("unit_died"):
		unit.unit_died.connect(_on_unit_died)
	if unit.has_signal("action_performed"):
		unit.action_performed.connect(_on_unit_action_performed)

func _disconnect_unit_signals(unit: Node) -> void:
	"""Scollega i segnali dell'unità"""
	if unit.has_signal("unit_died") and unit.unit_died.is_connected(_on_unit_died):
		unit.unit_died.disconnect(_on_unit_died)
	if unit.has_signal("action_performed") and unit.action_performed.is_connected(_on_unit_action_performed):
		unit.action_performed.disconnect(_on_unit_action_performed)

# === SISTEMA INIZIATIVA ===

func _calculate_all_initiatives() -> void:
	"""Calcola l'iniziativa per tutte le unità"""
	var all_units = player_units + ally_units + enemy_units + neutral_units
	
	for unit in all_units:
		if is_instance_valid(unit) and unit.character_sheet:
			var initiative = _calculate_unit_initiative(unit)
			unit.initiative = initiative
			unit_initiative_calculated.emit(unit, initiative)

func _calculate_unit_initiative(unit: Node) -> int:
	"""Calcola l'iniziativa per una singola unità"""
	if not unit.character_sheet:
		return 0
	
	# Base: DES modifier + 1d20
	var dex_modifier = unit.character_sheet.get_attribute_modifier(unit.character_sheet.dexterity)
	var roll = randi_range(1, 20)
	var total = dex_modifier + roll
	
	print("Iniziativa ", unit.character_sheet.character_name, ": ", dex_modifier, " + ", roll, " = ", total)
	return total

func _sort_initiative_order() -> void:
	"""Ordina tutte le unità per iniziativa (più alta prima)"""
	var all_units = player_units + ally_units + enemy_units + neutral_units
	all_units.sort_custom(func(a, b): return a.initiative > b.initiative)
	initiative_order = all_units
	
	print("=== ORDINE INIZIATIVA ===")
	for i in range(initiative_order.size()):
		var unit = initiative_order[i]
		print(i + 1, ". ", unit.character_sheet.character_name if unit.character_sheet else "Sconosciuta", " (", unit.initiative, ")")

# === UTILITY ===

func _get_units_for_current_phase() -> Array[Node]:
	"""Restituisce le unità per la fase corrente"""
	match current_phase:
		TurnPhase.PLAYER:
			return player_units + ally_units
		TurnPhase.ENEMY:
			return enemy_units
		TurnPhase.NEUTRAL:
			return neutral_units
		_:
			return []

func _get_phase_name(phase: TurnPhase) -> String:
	"""Restituisce il nome leggibile della fase"""
	match phase:
		TurnPhase.PLAYER:
			return "GIOCATORE"
		TurnPhase.ENEMY:
			return "NEMICI"
		TurnPhase.NEUTRAL:
			return "NEUTRALI"
		TurnPhase.END_COMBAT:
			return "FINE COMBATTIMENTO"
		_:
			return "SCONOSCIUTA"

func _check_combat_end_conditions() -> bool:
	"""Verifica se il combattimento deve terminare"""
	var alive_players = player_units.filter(func(unit): return is_instance_valid(unit) and not unit.is_dead)
	var alive_enemies = enemy_units.filter(func(unit): return is_instance_valid(unit) and not unit.is_dead)
	
	if alive_players.is_empty():
		end_combat(false)  # Sconfitta
		return true
	elif alive_enemies.is_empty():
		end_combat(true)   # Vittoria
		return true
	
	return false

func _reset_all_units() -> void:
	"""Reset stati di tutte le unità"""
	var all_units = player_units + ally_units + enemy_units + neutral_units
	for unit in all_units:
		if is_instance_valid(unit):
			unit.end_turn()

# === SIGNAL HANDLERS ===

func _on_unit_died(unit: Node) -> void:
	"""Gestisce la morte di un'unità"""
	print("Unità morta: ", unit.character_sheet.character_name if unit.character_sheet else "Sconosciuta")
	remove_unit(unit)
	
	# Verifica condizioni fine combattimento
	_check_combat_end_conditions()

func _on_unit_action_performed(unit: Node, action_name: String, success: bool) -> void:
	"""Gestisce azioni eseguite dalle unità"""
	action_performed.emit(unit, action_name, success)

func _on_turn_timeout() -> void:
	"""Gestisce timeout del turno"""
	print("Timeout turno!")
	end_current_turn()

# === FUNZIONI PUBBLICHE ===

func get_current_unit() -> Node:
	"""Restituisce l'unità che sta giocando il turno corrente"""
	var units_in_phase = _get_units_for_current_phase()
	if current_unit_index < units_in_phase.size():
		return units_in_phase[current_unit_index]
	return null

func is_player_turn() -> bool:
	"""Verifica se è il turno del giocatore"""
	return current_phase == TurnPhase.PLAYER

func get_combat_state() -> CombatState:
	"""Restituisce lo stato corrente del combattimento"""
	return current_state

func get_turn_info() -> Dictionary:
	"""Restituisce informazioni sul turno corrente"""
	return {
		"turn_number": turn_number,
		"phase": current_phase,
		"phase_name": _get_phase_name(current_phase),
		"current_unit": get_current_unit(),
		"time_remaining": turn_timer.time_left if turn_timer.time_left > 0 else -1
	} 