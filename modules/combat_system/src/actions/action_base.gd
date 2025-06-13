extends Resource
class_name CombatAction

# === Base Class per Azioni di Combattimento ===
# Classe astratta che definisce l'interfaccia per tutte le azioni

# Segnali
signal action_started(action: CombatAction, performer: Node)
signal action_completed(action: CombatAction, success: bool, result: Dictionary)
signal action_failed(action: CombatAction, reason: String)

# Metadati azione
@export var action_name: String = "Base Action"
@export var action_description: String = "Azione base di combattimento"
@export var action_icon: Texture2D
@export var action_points_cost: int = 1
@export var cooldown_turns: int = 0
@export var range_min: int = 0
@export var range_max: int = 1

# Prerequisiti
@export var requires_target: bool = false
@export var requires_line_of_sight: bool = false
@export var requires_movement: bool = false
@export var can_target_self: bool = false
@export var can_target_allies: bool = false
@export var can_target_enemies: bool = true

# Categorie azione
enum ActionCategory {
	MOVEMENT,
	ATTACK,
	DEFENSE,
	SUPPORT,
	SPECIAL,
	ENVIRONMENTAL
}

@export var category: ActionCategory = ActionCategory.ATTACK

# Stato interno
var is_on_cooldown: bool = false
var cooldown_remaining: int = 0

# === INTERFACCIA VIRTUALE ===

func can_perform(performer: Node, target: Node = null, target_position: Vector2i = Vector2i.ZERO) -> bool:
	"""
	Verifica se l'azione può essere eseguita
	Override questa funzione nelle classi derivate per logica specifica
	"""
	
	# Verifica punti azione
	if not _check_action_points(performer):
		return false
	
	# Verifica cooldown
	if is_on_cooldown:
		return false
	
	# Verifica target se richiesto
	if requires_target and not target:
		return false
	
	# Verifica validità target
	if target and not _is_valid_target(performer, target):
		return false
	
	# Verifica range
	if target and not _is_in_range(performer, target):
		return false
	
	# Verifica line of sight
	if requires_line_of_sight and target and not _has_line_of_sight(performer, target):
		return false
	
	return true

func perform(performer: Node, target: Node = null, target_position: Vector2i = Vector2i.ZERO) -> bool:
	"""
	Esegue l'azione
	Override questa funzione nelle classi derivate per implementazione specifica
	"""
	
	# Verifica prerequisiti
	if not can_perform(performer, target, target_position):
		var reason = _get_failure_reason(performer, target, target_position)
		action_failed.emit(self, reason)
		return false
	
	# Emetti segnale inizio
	action_started.emit(self, performer)
	
	# Consuma punti azione
	_consume_action_points(performer)
	
	# Avvia cooldown se necessario
	if cooldown_turns > 0:
		_start_cooldown()
	
	# Esegui logica specifica (da override)
	var success = _execute_action(performer, target, target_position)
	var result = _get_action_result(performer, target, target_position, success)
	
	# Emetti segnale completamento
	action_completed.emit(self, success, result)
	
	return success

func _execute_action(performer: Node, target: Node, target_position: Vector2i) -> bool:
	"""
	Logica specifica dell'azione - DA OVERRIDE
	"""
	push_warning("_execute_action non implementato per: " + action_name)
	return false

func _get_action_result(performer: Node, target: Node, target_position: Vector2i, success: bool) -> Dictionary:
	"""
	Restituisce i risultati dell'azione - DA OVERRIDE se necessario
	"""
	return {
		"action_name": action_name,
		"performer": performer,
		"target": target,
		"target_position": target_position,
		"success": success,
		"timestamp": Time.get_unix_time_from_system()
	}

# === VERIFICA PREREQUISITI ===

func _check_action_points(performer: Node) -> bool:
	"""Verifica se il performer ha abbastanza punti azione"""
	if not performer.has_method("get_remaining_action_points"):
		return false
	return performer.get_remaining_action_points() >= action_points_cost

func _consume_action_points(performer: Node) -> void:
	"""Consuma i punti azione necessari"""
	if performer.has_method("consume_action_points"):
		performer.consume_action_points(action_points_cost)

func _is_valid_target(performer: Node, target: Node) -> bool:
	"""Verifica se il target è valido per questa azione"""
	if target == performer:
		return can_target_self
	
	# Verifica alleanze (questo richiede un sistema di fazioni)
	# Per ora usiamo una logica semplificata
	var is_ally = _are_allies(performer, target)
	var is_enemy = not is_ally and performer != target
	
	if is_ally and not can_target_allies:
		return false
	
	if is_enemy and not can_target_enemies:
		return false
	
	return true

func _are_allies(unit1: Node, unit2: Node) -> bool:
	"""Determina se due unità sono alleate"""
	# Logica semplificata - migliorabile con sistema fazioni
	if unit1.has_method("get_faction") and unit2.has_method("get_faction"):
		return unit1.get_faction() == unit2.get_faction()
	
	# Fallback: controlla se sono entrambi nel gruppo giocatore o nemici
	var combat_manager = get_combat_manager()
	if combat_manager:
		var unit1_is_player = unit1 in combat_manager.player_units or unit1 in combat_manager.ally_units
		var unit2_is_player = unit2 in combat_manager.player_units or unit2 in combat_manager.ally_units
		return unit1_is_player == unit2_is_player
	
	return false

func _is_in_range(performer: Node, target: Node) -> bool:
	"""Verifica se il target è nel range dell'azione"""
	if not performer.has_method("get_grid_position") or not target.has_method("get_grid_position"):
		return true  # Se non possiamo verificare, assumiamo sia valido
	
	var distance = _calculate_distance(performer.get_grid_position(), target.get_grid_position())
	return distance >= range_min and distance <= range_max

func _has_line_of_sight(performer: Node, target: Node) -> bool:
	"""Verifica line of sight tra performer e target"""
	# Implementazione semplificata - può essere migliorata con raycast sulla griglia
	if not requires_line_of_sight:
		return true
	
	var combat_manager = get_combat_manager()
	if combat_manager and combat_manager.combat_grid:
		# TODO: Implementare controllo LOS sulla griglia
		return true
	
	return true

func _calculate_distance(pos1: Vector2i, pos2: Vector2i) -> int:
	"""Calcola distanza Manhattan tra due posizioni"""
	return abs(pos1.x - pos2.x) + abs(pos1.y - pos2.y)

# === GESTIONE COOLDOWN ===

func _start_cooldown() -> void:
	"""Avvia il cooldown dell'azione"""
	is_on_cooldown = true
	cooldown_remaining = cooldown_turns

func reduce_cooldown() -> void:
	"""Riduce il cooldown di 1 turno (chiamato dal combat manager)"""
	if cooldown_remaining > 0:
		cooldown_remaining -= 1
		if cooldown_remaining <= 0:
			is_on_cooldown = false

func reset_cooldown() -> void:
	"""Reset immediato del cooldown"""
	is_on_cooldown = false
	cooldown_remaining = 0

# === UTILITY ===

func get_combat_manager() -> Node:
	"""Ottiene il combat manager singleton"""
	# Assume che CombatManager sia registrato come autoload
	if Engine.has_singleton("CombatManager"):
		return Engine.get_singleton("CombatManager")
	
	# Fallback: cerca nel tree
	var tree = Engine.get_main_loop() as SceneTree
	if tree:
		var cm = tree.get_nodes_in_group("combat_manager")
		if not cm.is_empty():
			return cm[0]
	
	return null

func _get_failure_reason(performer: Node, target: Node, target_position: Vector2i) -> String:
	"""Restituisce la ragione del fallimento per debug"""
	if not _check_action_points(performer):
		return "Punti azione insufficienti"
	
	if is_on_cooldown:
		return "Azione in cooldown (" + str(cooldown_remaining) + " turni)"
	
	if requires_target and not target:
		return "Target richiesto ma non fornito"
	
	if target and not _is_valid_target(performer, target):
		return "Target non valido"
	
	if target and not _is_in_range(performer, target):
		return "Target fuori range"
	
	if requires_line_of_sight and target and not _has_line_of_sight(performer, target):
		return "Linea di vista bloccata"
	
	return "Motivo sconosciuto"

# === FUNZIONI INFORMATIVE ===

func get_action_info() -> Dictionary:
	"""Restituisce informazioni complete sull'azione"""
	return {
		"name": action_name,
		"description": action_description,
		"cost": action_points_cost,
		"cooldown": cooldown_turns,
		"range": {"min": range_min, "max": range_max},
		"category": ActionCategory.keys()[category],
		"requires_target": requires_target,
		"requires_los": requires_line_of_sight,
		"on_cooldown": is_on_cooldown,
		"cooldown_remaining": cooldown_remaining
	}

func get_display_name() -> String:
	"""Nome per display UI"""
	var display = action_name
	if is_on_cooldown:
		display += " (" + str(cooldown_remaining) + ")"
	return display 