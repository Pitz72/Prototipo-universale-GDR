# Piano di Implementazione per Alleati e Nemici

## Sezione 1: Creazione dei CharacterSheet

### Struttura Base
Ogni unità (alleata o nemica) sarà basata sul sistema `CharacterSheet` esistente, con estensioni specifiche per il combattimento tattico.

### Alleati
Verranno creati tre file `.tres` permanenti:

1. **`ally_security_officer.tres`**
   ```gdscript
   extends CharacterSheet
   
   # Attributi Base
   var base_strength = 8
   var base_dexterity = 6
   var base_constitution = 7
   var base_intelligence = 5
   var base_wisdom = 6
   var base_charisma = 5
   
   # Abilità Specialistiche
   var heavy_weapons_rank = 3
   var combat_tactics_rank = 3
   var command_rank = 2
   var survival_rank = 2
   
   # Abilità Uniche
   var suppression_fire = true
   var tactical_command = true
   var veteran = true
   ```

2. **`ally_science_officer.tres`**
   ```gdscript
   extends CharacterSheet
   
   # Attributi Base
   var base_strength = 4
   var base_dexterity = 5
   var base_constitution = 5
   var base_intelligence = 8
   var base_wisdom = 7
   var base_charisma = 6
   
   # Abilità Specialistiche
   var medicine_rank = 3
   var xenobiology_rank = 3
   var science_rank = 3
   var medical_support_rank = 2
   
   # Abilità Uniche
   var rapid_stabilization = true
   var enemy_analysis = true
   var advanced_medkit = true
   ```

3. **`ally_tech_specialist.tres`**
   ```gdscript
   extends CharacterSheet
   
   # Attributi Base
   var base_strength = 4
   var base_dexterity = 6
   var base_constitution = 5
   var base_intelligence = 8
   var base_wisdom = 7
   var base_charisma = 5
   
   # Abilità Specialistiche
   var hacking_rank = 3
   var engineering_rank = 3
   var alien_tech_rank = 3
   var tech_support_rank = 2
   
   # Abilità Uniche
   var remote_hack = true
   var psionic_shield = true
   var tech_analysis = true
   ```

### Nemici
Per ogni archetipo di nemico, verrà creato un template base:

1. **`enemy_warrior_assault.tres`**
   ```gdscript
   extends CharacterSheet
   
   # Attributi Base
   var base_strength = 7
   var base_dexterity = 6
   var base_constitution = 7
   var base_intelligence = 4
   var base_wisdom = 4
   var base_charisma = 4
   
   # Abilità Specialistiche
   var combat_rank = 2
   var tactics_rank = 1
   var survival_rank = 1
   
   # Abilità Uniche
   var charge = true
   var resistance = true
   var discipline = true
   ```

## Sezione 2: Sistema di Evoluzione

### Companion Progression
```gdscript
class_name CompanionProgression
extends Node

# Costanti
const XP_PER_MISSION = 100
const LEVEL_UP_THRESHOLD = 1000

# Variabili
var current_xp = 0
var level = 1
var character_sheet: CharacterSheet

# Funzioni
func add_mission_xp(mission_difficulty: float) -> void:
    var xp_gained = XP_PER_MISSION * mission_difficulty
    current_xp += xp_gained
    check_level_up()

func check_level_up() -> void:
    if current_xp >= LEVEL_UP_THRESHOLD * level:
        level_up()

func level_up() -> void:
    level += 1
    current_xp = 0
    apply_level_up_bonuses()

func apply_level_up_bonuses() -> void:
    # Bonus automatici basati sull'archetipo
    match character_sheet.archetype:
        "security":
            character_sheet.base_strength += 1
            character_sheet.heavy_weapons_rank += 1
        "science":
            character_sheet.base_intelligence += 1
            character_sheet.medicine_rank += 1
        "tech":
            character_sheet.base_intelligence += 1
            character_sheet.hacking_rank += 1
```

## Sezione 3: Integrazione con CombatManager

### Gestione delle Unità
```gdscript
class_name CombatManager
extends Node

# Gruppi di unità
var player_units: Array = []
var ally_units: Array = []
var enemy_units: Array = []

# Fasi del turno
enum TurnPhase {
    PLAYER_PHASE,
    ENEMY_PHASE,
    NEUTRAL_PHASE
}

var current_phase: int = TurnPhase.PLAYER_PHASE

# Funzioni
func start_player_turn() -> void:
    current_phase = TurnPhase.PLAYER_PHASE
    for unit in player_units + ally_units:
        unit.reset_action_points()
        unit.on_turn_start()

func start_enemy_turn() -> void:
    current_phase = TurnPhase.ENEMY_PHASE
    for unit in enemy_units:
        unit.reset_action_points()
        unit.on_turn_start()

func process_enemy_ai() -> void:
    for unit in enemy_units:
        if unit.has_action_points():
            var action = unit.decide_next_action()
            execute_action(unit, action)

func execute_action(unit, action) -> void:
    match action.type:
        "move":
            move_unit(unit, action.target_position)
        "attack":
            attack_target(unit, action.target)
        "ability":
            use_ability(unit, action.ability, action.target)
```

## Sezione 4: Implementazione delle Abilità

### Sistema di Abilità
```gdscript
class_name AbilitySystem
extends Node

# Struttura base per le abilità
class Ability:
    var name: String
    var cost: int
    var cooldown: int
    var range: int
    var target_type: String
    var effect: Callable

# Registro delle abilità
var ability_registry: Dictionary = {}

func register_ability(ability: Ability) -> void:
    ability_registry[ability.name] = ability

func use_ability(unit, ability_name: String, target) -> bool:
    if ability_name in ability_registry:
        var ability = ability_registry[ability_name]
        if can_use_ability(unit, ability):
            ability.effect.call(unit, target)
            return true
    return false

func can_use_ability(unit, ability: Ability) -> bool:
    return unit.action_points >= ability.cost and unit.cooldowns[ability.name] <= 0
```

## Sezione 5: Test e Validazione

### Test Unitari
```gdscript
class_name TestCombatSystem
extends Node

func test_character_sheet_creation() -> void:
    var security_officer = load("res://resources/characters/ally_security_officer.tres")
    assert(security_officer != null, "Security officer sheet should load")
    assert(security_officer.base_strength == 8, "Base strength should be 8")

func test_ability_system() -> void:
    var ability_system = AbilitySystem.new()
    var test_ability = Ability.new()
    test_ability.name = "Test Ability"
    ability_system.register_ability(test_ability)
    assert(ability_system.ability_registry.has("Test Ability"), "Ability should be registered")

func test_combat_manager() -> void:
    var combat_manager = CombatManager.new()
    combat_manager.start_player_turn()
    assert(combat_manager.current_phase == TurnPhase.PLAYER_PHASE, "Should be player phase")
```

## Sezione 6: Prossimi Passi

1. **Implementazione Base**
   - Creare i file `.tres` per gli alleati
   - Implementare il sistema di progressione
   - Integrare con CombatManager

2. **Sviluppo delle Abilità**
   - Implementare le abilità uniche per ogni unità
   - Creare il sistema di effetti
   - Aggiungere animazioni e feedback visivi

3. **Testing e Bilanciamento**
   - Eseguire test unitari
   - Bilanciare le statistiche
   - Verificare l'integrazione con il sistema di combattimento esistente

4. **Documentazione**
   - Aggiornare la documentazione tecnica
   - Creare guide per l'implementazione di nuove unità
   - Documentare le API pubbliche 