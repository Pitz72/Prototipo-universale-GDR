@tool
class_name WeaponItem extends ItemDefinition

# Tipi di danno disponibili nella Confederation
enum DamageType {
	STUN,       # Danno da stordimento - non letale
	KINETIC,    # Danno cinetico tradizionale (proiettili, impatti)
	ENERGY,     # Danno energetico (laser, plasma, particelle)
	ION,        # Danno ionico - interferisce con elettronica
	SONIC,      # Danno sonico - onde d'urto
	NEURAL      # Danno neurale - interferisce con sistema nervoso
}

# === STATISTICHE ARMA ===
@export_group("Statistiche Arma")
@export var damage_type: DamageType = DamageType.ENERGY
@export var base_damage: int = 10
@export var range: int = 50  # Raggio d'azione in metri
@export var energy_per_shot: int = 5  # Costo energetico per colpo

# === MODALITÀ ARMA ===
@export_group("Modalità di Fuoco")
@export var has_stun_mode: bool = true  # Se l'arma ha modalità stordimento
@export var has_lethal_mode: bool = true  # Se l'arma ha modalità letale
@export var current_mode: DamageType = DamageType.STUN

# === MUNIZIONI E ENERGIA ===
@export_group("Alimentazione")
@export var uses_energy: bool = true  # Se l'arma usa celle energetiche
@export var uses_ammo: bool = false   # Se l'arma usa munizioni fisiche
@export var max_ammo: int = 0         # Capacità massima munizioni
@export var current_ammo: int = 0     # Munizioni attuali

# Segnali per eventi dell'arma
signal weapon_fired(weapon: WeaponItem, damage: int, type: DamageType)
signal weapon_mode_changed(weapon: WeaponItem, new_mode: DamageType)
signal weapon_reloaded(weapon: WeaponItem, ammo_count: int)

func _ready():
	# Imposta la categoria come ARMI_DIFESA
	category = ItemCategory.ARMI_DIFESA
	
	# Inizializza le munizioni se necessario
	if uses_ammo and current_ammo == 0:
		current_ammo = max_ammo

# Spara con l'arma
func fire(target_character: CharacterSheet = null) -> Dictionary:
	var result = {
		"success": false,
		"damage": 0,
		"damage_type": current_mode,
		"energy_cost": energy_per_shot,
		"message": ""
	}
	
	# Verifica disponibilità munizioni/energia
	if uses_ammo and current_ammo <= 0:
		result.message = "Arma %s scarica!" % item_name
		return result
	
	if uses_energy and energy_per_shot > 0:
		# Qui si dovrebbe verificare se il personaggio ha abbastanza energia
		# Per ora assumiamo che ce l'abbia
		result.message += "Consumata energia: %d. " % energy_per_shot
	
	# Calcola il danno
	result.damage = _calculate_damage()
	result.success = true
	
	# Consuma munizioni se necessario
	if uses_ammo:
		current_ammo -= 1
		result.message += "Munizioni rimanenti: %d. " % current_ammo
	
	result.message += "Colpo sparato con %s!" % item_name
	
	# Emette il segnale
	weapon_fired.emit(self, result.damage, current_mode)
	
	return result

# Calcola il danno basato sulla modalità corrente
func _calculate_damage() -> int:
	var damage = base_damage
	
	# Modifica il danno in base alla modalità
	match current_mode:
		DamageType.STUN:
			damage = int(base_damage * 0.75)  # Danno ridotto per stordimento
		DamageType.ENERGY:
			damage = base_damage
		DamageType.KINETIC:
			damage = int(base_damage * 1.1)   # Leggermente più potente
		DamageType.ION:
			damage = int(base_damage * 0.5)   # Basso danno fisico, alto contro elettronica
		DamageType.SONIC:
			damage = int(base_damage * 0.8)   # Danno moderato, effetti speciali
		DamageType.NEURAL:
			damage = int(base_damage * 0.6)   # Basso danno, effetti mentali
	
	return damage

# Cambia modalità di fuoco
func switch_mode(new_mode: DamageType) -> bool:
	# Verifica se la modalità è disponibile
	if new_mode == DamageType.STUN and not has_stun_mode:
		print("Modalità stordimento non disponibile per %s" % item_name)
		return false
	
	if new_mode != DamageType.STUN and not has_lethal_mode:
		print("Modalità letale non disponibile per %s" % item_name)
		return false
	
	current_mode = new_mode
	weapon_mode_changed.emit(self, new_mode)
	print("Arma %s impostata su modalità: %s" % [item_name, DamageType.keys()[new_mode]])
	return true

# Ricarica l'arma
func reload(ammo_amount: int = -1) -> bool:
	if not uses_ammo:
		print("L'arma %s non usa munizioni" % item_name)
		return false
	
	if ammo_amount == -1:
		ammo_amount = max_ammo
	
	current_ammo = min(current_ammo + ammo_amount, max_ammo)
	weapon_reloaded.emit(self, current_ammo)
	print("Arma %s ricaricata. Munizioni: %d/%d" % [item_name, current_ammo, max_ammo])
	return true

# Verifica se l'arma può sparare
func can_fire() -> bool:
	if uses_ammo and current_ammo <= 0:
		return false
	# Qui si potrebbe aggiungere controllo energia
	return true

# Ottiene informazioni complete sull'arma
func get_weapon_info() -> String:
	var info = get_full_description() + "\n"
	info += "Danno: %d (%s)\n" % [base_damage, DamageType.keys()[damage_type]]
	info += "Raggio: %d metri\n" % range
	info += "Energia per colpo: %d\n" % energy_per_shot
	
	if uses_ammo:
		info += "Munizioni: %d/%d\n" % [current_ammo, max_ammo]
	
	info += "Modalità corrente: %s" % DamageType.keys()[current_mode]
	
	return info 