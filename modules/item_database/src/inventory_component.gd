@tool
class_name InventoryComponent extends Node

# === CONFIGURAZIONE INVENTARIO ===
@export_group("Configurazione Inventario")
@export var max_weight: float = 50.0  # Peso massimo trasportabile in kg
@export var auto_stack: bool = true   # Se raggruppare automaticamente oggetti uguali

# Struttura: Array di Dictionary contenenti {"item_resource": ItemDefinition, "quantity": int}
var items: Array = []

# Segnali per eventi dell'inventario
signal item_added(item: ItemDefinition, quantity: int, total_quantity: int)
signal item_removed(item: ItemDefinition, quantity: int, remaining_quantity: int)
signal weight_limit_exceeded(current_weight: float, max_weight: float)
signal inventory_full()

# Aggiunge un oggetto all'inventario
func add_item(item_def: ItemDefinition, amount: int = 1) -> bool:
	if not item_def or amount <= 0:
		print("Errore: oggetto non valido o quantità non valida")
		return false
	
	# Verifica il limite di peso
	var additional_weight = item_def.weight * amount
	if get_current_weight() + additional_weight > max_weight:
		weight_limit_exceeded.emit(get_current_weight() + additional_weight, max_weight)
		print("Inventario: peso limite superato! (%.1f/%.1f kg)" % [get_current_weight() + additional_weight, max_weight])
		return false
	
	# Se l'oggetto è stackable e auto_stack è attivo, cerca uno slot esistente
	if auto_stack and item_def.stackable:
		for item_stack in items:
			var existing_item = item_stack["item_resource"] as ItemDefinition
			if existing_item and existing_item.can_stack_with(item_def):
				# Verifica se non supera il max_stack_size
				var new_quantity = item_stack["quantity"] + amount
				if new_quantity <= item_def.max_stack_size:
					item_stack["quantity"] = new_quantity
					item_added.emit(item_def, amount, new_quantity)
					print("Aggiunto %dx %s all'inventario (totale: %d)" % [amount, item_def.item_name, new_quantity])
					return true
				else:
					# Riempi fino al massimo questo stack e crea un nuovo stack per il resto
					var space_in_stack = item_def.max_stack_size - item_stack["quantity"]
					if space_in_stack > 0:
						item_stack["quantity"] = item_def.max_stack_size
						amount -= space_in_stack
						item_added.emit(item_def, space_in_stack, item_def.max_stack_size)
					# Il resto andrà in un nuovo stack (continua sotto)
	
	# Se arriviamo qui, dobbiamo creare un nuovo stack
	if item_def.stackable and amount > item_def.max_stack_size:
		# Crea più stack se necessario
		while amount > 0:
			var stack_amount = min(amount, item_def.max_stack_size)
			var new_stack = {
				"item_resource": item_def,
				"quantity": stack_amount
			}
			items.append(new_stack)
			item_added.emit(item_def, stack_amount, stack_amount)
			amount -= stack_amount
	else:
		# Crea un singolo stack
		var new_stack = {
			"item_resource": item_def,
			"quantity": amount
		}
		items.append(new_stack)
		item_added.emit(item_def, amount, amount)
	
	print("Aggiunto %dx %s all'inventario" % [amount, item_def.item_name])
	return true

# Rimuove un oggetto dall'inventario
func remove_item(item_def: ItemDefinition, amount: int = 1) -> bool:
	if not item_def or amount <= 0:
		return false
	
	var remaining_to_remove = amount
	
	# Cerca negli stack esistenti
	for i in range(items.size() - 1, -1, -1):  # Rimuovi dall'ultimo al primo
		var item_stack = items[i]
		var existing_item = item_stack["item_resource"] as ItemDefinition
		
		if existing_item and existing_item.item_id == item_def.item_id:
			var available_quantity = item_stack["quantity"]
			var to_remove = min(remaining_to_remove, available_quantity)
			
			item_stack["quantity"] -= to_remove
			remaining_to_remove -= to_remove
			
			var remaining_in_stack = item_stack["quantity"]
			item_removed.emit(item_def, to_remove, remaining_in_stack)
			
			# Se lo stack è vuoto, rimuovilo
			if item_stack["quantity"] <= 0:
				items.remove_at(i)
			
			# Se abbiamo rimosso tutto quello che serviva, esci
			if remaining_to_remove <= 0:
				print("Rimosso %dx %s dall'inventario" % [amount, item_def.item_name])
				return true
	
	# Se arriviamo qui, non avevamo abbastanza oggetti
	if remaining_to_remove < amount:
		print("Rimosso parzialmente %dx %s dall'inventario (mancavano %d)" % [amount - remaining_to_remove, item_def.item_name, remaining_to_remove])
	else:
		print("Impossibile rimuovere %dx %s: oggetto non trovato" % [amount, item_def.item_name])
	
	return remaining_to_remove == 0

# Calcola il peso totale degli oggetti nell'inventario
func get_current_weight() -> float:
	var total_weight: float = 0.0
	for item_stack in items:
		var item_def = item_stack["item_resource"] as ItemDefinition
		if item_def:
			total_weight += item_def.weight * item_stack["quantity"]
	return total_weight

# Ottiene la quantità totale di un oggetto specifico
func get_item_quantity(item_def: ItemDefinition) -> int:
	var total_quantity = 0
	for item_stack in items:
		var existing_item = item_stack["item_resource"] as ItemDefinition
		if existing_item and existing_item.item_id == item_def.item_id:
			total_quantity += item_stack["quantity"]
	return total_quantity

# Verifica se contiene una quantità specifica di un oggetto
func has_item(item_def: ItemDefinition, required_quantity: int = 1) -> bool:
	return get_item_quantity(item_def) >= required_quantity

# Ottiene tutti gli oggetti unici nell'inventario (senza quantità)
func get_unique_items() -> Array[ItemDefinition]:
	var unique_items: Array[ItemDefinition] = []
	var item_ids: Array[String] = []
	
	for item_stack in items:
		var item_def = item_stack["item_resource"] as ItemDefinition
		if item_def and not item_def.item_id in item_ids:
			unique_items.append(item_def)
			item_ids.append(item_def.item_id)
	
	return unique_items

# Ottiene tutti gli stack dell'inventario (copia)
func get_all_stacks() -> Array:
	return items.duplicate(true)

# Svuota completamente l'inventario
func clear_inventory() -> void:
	var removed_items: Array = items.duplicate()
	items.clear()
	print("Inventario svuotato")
	
	# Emette segnali per tutti gli oggetti rimossi
	for item_stack in removed_items:
		var item_def = item_stack["item_resource"] as ItemDefinition
		if item_def:
			item_removed.emit(item_def, item_stack["quantity"], 0)

# Verifica se l'inventario è pieno (peso massimo raggiunto)
func is_weight_full() -> bool:
	return get_current_weight() >= max_weight

# Ottiene spazio libero in peso
func get_available_weight() -> float:
	return max(0.0, max_weight - get_current_weight())

# Calcola quanti oggetti di un tipo possono essere ancora aggiunti
func get_max_addable_quantity(item_def: ItemDefinition) -> int:
	if not item_def:
		return 0
	
	var available_weight = get_available_weight()
	return int(available_weight / item_def.weight)

# Ottiene un riassunto dell'inventario
func get_inventory_summary() -> String:
	var summary = "=== INVENTARIO ===\n"
	summary += "Peso: %.1f/%.1f kg\n" % [get_current_weight(), max_weight]
	summary += "Oggetti unici: %d\n" % get_unique_items().size()
	summary += "Stack totali: %d\n\n" % items.size()
	
	for item_stack in items:
		var item_def = item_stack["item_resource"] as ItemDefinition
		if item_def:
			summary += "• %dx %s (%.1f kg)\n" % [item_stack["quantity"], item_def.item_name, item_def.weight * item_stack["quantity"]]
	
	return summary 