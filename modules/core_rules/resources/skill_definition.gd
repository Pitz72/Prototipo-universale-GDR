@tool
class_name SkillDefinition extends Resource

enum PrimaryAttribute { FOR, DES, COS, INT, SAG, CAR }

@export var skill_name: String = "Nuova Abilità"
@export_multiline var description: String = ""
@export var base_attribute: PrimaryAttribute = PrimaryAttribute.INT
