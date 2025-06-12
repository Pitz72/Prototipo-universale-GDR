@tool
class_name CharacterSheet extends Resource

# --- Identificativi di Base ---
@export var character_name: String = "Nuovo Personaggio"
# In futuro qui potremmo aggiungere risorse per specie e background
# @export var species: SpeciesDefinition
# @export var background: BackgroundDefinition

# --- Attributi Primari ---
@export_group("Attributi Primari")
@export_range(1, 30) var strength: int = 10
@export_range(1, 30) var dexterity: int = 10
@export_range(1, 30) var constitution: int = 10
@export_range(1, 30) var intelligence: int = 10
@export_range(1, 30) var wisdom: int = 10
@export_range(1, 30) var charisma: int = 10

# --- Abilità (Skills) ---
# La chiave è il path della risorsa SkillDefinition (es. "res://.../informatica.tres")
# Il valore è il grado (rank) nell'abilità.
@export var skill_ranks: Dictionary = {}

# --- Progressione ---
@export_group("Progressione")
@export var level: int = 1
@export var experience_points: int = 0

# --- Statistiche Derivate/Vitali ---
# Queste verranno calcolate da UCS o da funzioni interne
@export_group("Statistiche Vitali")
@export var max_health: int = 0
@export var current_health: int = 0

# --- Funzioni di utilità ---

# Restituisce il valore di un attributo usando l'enum da SkillDefinition
func get_attribute_value(attribute_enum: SkillDefinition.PrimaryAttribute) -> int:
    match attribute_enum:
        SkillDefinition.PrimaryAttribute.FOR: return strength
        SkillDefinition.PrimaryAttribute.DES: return dexterity
        SkillDefinition.PrimaryAttribute.COS: return constitution
        SkillDefinition.PrimaryAttribute.INT: return intelligence
        SkillDefinition.PrimaryAttribute.SAG: return wisdom
        SkillDefinition.PrimaryAttribute.CAR: return charisma
    return 10 # Default fallback

# Restituisce il grado in una specifica abilità
func get_skill_rank(skill_definition: SkillDefinition) -> int:
    if skill_ranks.has(skill_definition.resource_path):
        return skill_ranks[skill_definition.resource_path]
    return 0