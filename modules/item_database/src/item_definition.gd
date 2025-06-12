@tool
class_name ItemDefinition extends Resource

# Categoria dell'oggetto nel mondo della Confederation
enum ItemCategory {
	EQUIP_STANDARD,     # Equipaggiamento standard di servizio
	SCIENTIFICO,        # Strumenti per ricerca e analisi
	TECNICO,           # Equipaggiamento per ingegneria e riparazioni  
	MEDICO,            # Strumenti e medicinali per cure
	ARMI_DIFESA,       # Armi e dispositivi di protezione
	RISORSA_NATURALE,  # Minerali, campioni biologici, materiali
	DATI,              # Banche dati, log, informazioni digitali
	UNICO              # Oggetti unici, reliquie, prototipi
}

# === IDENTIFICATIVI ===
@export_group("Identificativi")
@export var item_name: String = "Nuovo Oggetto"
@export var item_id: String = "conf_item_001"  # Identificatore univoco per la Confederation
@export_multiline var description: String = "Un oggetto standard della Confederation"
@export var category: ItemCategory = ItemCategory.EQUIP_STANDARD

# === INVENTARIO ===
@export_group("Inventario")
@export var stackable: bool = false
@export var max_stack_size: int = 1:
	set(value):
		max_stack_size = value
	get():
		return max_stack_size if stackable else 1
@export var weight: float = 0.5  # Peso in kg

# === VISUALS ===
@export_group("Visuals")
@export var icon: Texture2D

# Funzione di utilità per ottenere una descrizione completa
func get_full_description() -> String:
	var category_name = ItemCategory.keys()[category]
	return "[%s] %s\n%s" % [category_name, item_name, description]

# Funzione per verificare se due oggetti possono essere stackati insieme
func can_stack_with(other: ItemDefinition) -> bool:
	if not stackable or not other.stackable:
		return false
	return item_id == other.item_id 