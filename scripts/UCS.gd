extends Node

# --- Modificatori e Tiri ---

# Formula per il modificatore di attributo
static func get_attribute_modifier(attribute_value: int) -> int:
    return int(floor((attribute_value - 10) / 2.0))

# Funzione centrale per tutte le prove di abilità
static func perform_skill_check(character: CharacterSheet, skill: SkillDefinition, difficulty_class: int, circumstantial_modifier: int = 0) -> bool:
    if not character or not skill:
        printerr("UCS.perform_skill_check: CharacterSheet o SkillDefinition non validi.")
        return false

    var attribute_value = character.get_attribute_value(skill.base_attribute)
    var attribute_mod = get_attribute_modifier(attribute_value)
    var skill_rank = character.get_skill_rank(skill)

    # Tiro del d20
    var dice_roll = randi_range(1, 20)

    # Calcolo finale
    var total_result = dice_roll + attribute_mod + skill_rank + circumstantial_modifier

    # Debugging
    print("Prova di ", skill.skill_name, " per ", character.character_name, ": Risultato ", total_result, " (d20: ", dice_roll, ", ModAttr: ", attribute_mod, ", Rank: ", skill_rank, ") vs CD ", difficulty_class)

    # Esito
    return total_result >= difficulty_class

# --- Calcolo Statistiche Derivate ---

# Calcola i PF massimi totali per un dato livello
static func calculate_max_health(character: CharacterSheet) -> int:
    if character.level == 1:
        return 10 + character.constitution
    else:
        # Per i livelli successivi, si dovrebbe memorizzare i tiri precedenti
        # o usare una formula media per semplicità nel prototipo.
        # Usiamo una media per ora: (1d6 -> 3.5) arrotondato a 4
        var health_from_levels = (character.level - 1) * (4 + get_attribute_modifier(character.constitution))
        var base_health_lvl1 = 10 + character.constitution
        return base_health_lvl1 + health_from_levels

# Calcola l'iniziativa
static func calculate_initiative(character: CharacterSheet) -> int:
    return get_attribute_modifier(character.dexterity)

# Calcola la capacità di carico
static func calculate_carrying_capacity(character: CharacterSheet) -> float:
    return float(character.strength * 10)

# Restituisce la velocità di movimento base
static func get_base_speed() -> float:
    return 6.0