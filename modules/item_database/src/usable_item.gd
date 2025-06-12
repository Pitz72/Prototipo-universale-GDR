@tool
class_name UsableItem extends ItemDefinition

# Segnale emesso quando l'oggetto viene utilizzato
signal used(target: CharacterSheet, source_item: UsableItem)

# === EFFETTI D'USO ===
@export_group("Effetti d'Uso")
@export var charges: int = -1  # Numero di utilizzi (-1 = infinito)

# Funzione virtuale per l'utilizzo dell'oggetto
# Questa può essere sovrascritta dalle classi derivate per implementare effetti specifici
func _use(target: CharacterSheet) -> void:
	# Controlla se ci sono cariche disponibili
	if charges == 0:
		print("L'oggetto %s non ha più cariche disponibili" % item_name)
		return
	
	# Decrementa le cariche se non sono infinite
	if charges > 0:
		charges -= 1
		print("Oggetto %s utilizzato. Cariche rimanenti: %d" % [item_name, charges])
	else:
		print("Oggetto %s utilizzato (cariche infinite)" % item_name)
	
	# Emette il segnale per notificare l'utilizzo
	used.emit(target, self)

# Funzione pubblica per utilizzare l'oggetto
func use_on(target: CharacterSheet) -> void:
	_use(target)

# Verifica se l'oggetto può essere utilizzato
func can_be_used() -> bool:
	return charges != 0

# Ricarica l'oggetto (se applicabile)
func recharge(amount: int = -1) -> void:
	if amount == -1:
		charges = -1  # Cariche infinite
		print("Oggetto %s ricaricato completamente" % item_name)
	else:
		charges += amount
		print("Oggetto %s ricaricato di %d cariche. Totale: %d" % [item_name, amount, charges]) 