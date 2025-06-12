# Confederation - Modulo 4: Sistema di Combattimento Tattico (SCT)

## 1. Introduzione

Questo documento descrive il design e l'analisi di fattibilità del Sistema di Combattimento Tattico (SCT) per "Confederation". Il modulo rappresenta il quarto pilastro del sistema di gioco, integrando perfettamente con l'Universal Core System (UCS), il Sistema del Personaggio e l'Item Database per creare un'esperienza di combattimento tattica immersiva e strategica.

Il SCT si ispira ai migliori sistemi di combattimento tattico a turni (X-COM, Phoenix Point) ma è progettato specificamente per l'universo della Confederation, dove l'ingegno e la tecnologia spesso prevalgono sulla forza bruta.

### Obiettivi del Modulo

*   **Combattimento come Ultima Risorsa**: Il sistema deve premiare l'approccio tattico e l'uso intelligente della tecnologia
*   **Integrazione Perfetta**: Sfruttare completamente gli attributi UCS, le abilità dei personaggi e gli oggetti dell'Item Database
*   **Varietà Tattica**: Ogni personaggio deve avere un ruolo distinto e utile in combattimento
*   **Ambiente Interattivo**: La mappa non è solo uno sfondo, ma uno strumento tattico

## 2. Filosofia di Design del Combat System

### Principi Fondamentali

*   **Il Confronto è l'Ultima Risorsa**: L'obiettivo spesso non sarà l'annientamento totale, ma il raggiungimento di un obiettivo specifico (disattivare un dispositivo, soccorrere un PNG, raggiungere una zona di estrazione, neutralizzare pacificamente il leader nemico).

*   **Ruoli e Sinergie**: Ogni personaggio, con le sue abilità e il suo equipaggiamento, deve avere un ruolo tattico preciso. L'ingegnere che sabota le coperture nemiche è importante quanto l'ufficiale della sicurezza che fornisce fuoco di soppressione.

*   **Ambiente Interattivo**: La mappa non è solo uno sfondo ma uno strumento. Le console possono essere hackerate per creare distrazioni, le porte possono essere sigillate, i generatori possono essere sovraccaricati per creare esplosioni EMP.

*   **Filosofia Confederation**: Riflette i valori dell'alleanza galattica - diplomazia, scienza e cooperazione anche nei momenti di conflitto.

## 3. Struttura Fondamentale del Combattimento

### 3.1 Griglia di Gioco

*   **Tipo**: Griglia quadrata (più semplice da implementare in 2D/isometrica rispetto a quella esagonale)
*   **Dimensione Cella**: Ogni cella rappresenta circa 1.5x1.5 metri
*   **Dati per Cella**:
    *   `is_walkable`: `bool` - se un personaggio può occuparla
    *   `cover_value_north/south/east/west`: `int` (0=nessuna, 1=bassa, 2=alta)
    *   `occupant`: Riferimento all'unità che occupa la cella
    *   `environment_effect`: Es. "in fiamme", "elettrificata", "campo forza"
    *   `interactive_object`: Riferimento a console, porte, generatori, etc.

### 3.2 Gestione dei Turni

**Sistema a Fasi**:
1.  **Fase Giocatore**: Il giocatore muove e fa agire tutte le sue unità, nell'ordine che preferisce
2.  **Fase Nemico (IA)**: L'IA muove e fa agire tutte le sue unità
3.  **(Opzionale) Fase Alleati/Civili**: Eventuali PNG neutrali o alleati agiscono

**Iniziativa**: All'inizio del combattimento, l'**Iniziativa** (calcolata dal Modulo 2: `Mod DES`) determina chi agisce per primo in caso di azioni speciali come l'Overwatch.

### 3.3 Sistema Punti Azione (PA) - Stile X-COM Moderno

*   **PA per Turno**: Ogni unità ha **2 Punti Azione** per turno
*   **Costi Azioni**:
    *   **Movimento Standard (Azione Blu)**: Muoversi fino a metà velocità massima. Costa 1 PA
    *   **Scatto (Azione Gialla)**: Muoversi fino alla velocità massima. Costa 2 PA e termina il turno
    *   **Azione Standard**: Attacco, uso abilità/oggetto. Costa 1-2 PA a seconda dell'azione

## 4. Azioni di Combattimento Fondamentali

### 4.1 Movimento

*   Click su cella valida mostra il percorso
*   Visualizzazione chiara del raggio di movimento standard (blu) e scatto (giallo)
*   Terreno difficile costa più "punti movimento" per cella
*   Integrazione con la velocità base calcolata da UCS (`UCS.get_base_speed()`)

### 4.2 Attacco

**Formula di Successo Colpo (To-Hit)**:
```
% Successo = MiraBase - MalusCopertura + BonusDistanza + AltriMod
```

Dove:
*   `MiraBase`: `65 (base) + (GradoAbilità * 3) + ModificatoreDES`
*   `MalusCopertura`: Bassa -20%, Alta -40%
*   `Bonus/Malus Distanza`: Basato sulla gittata ottimale dell'arma
*   `AltriMod`: Mira stabilizzata +10%, fuoco soppressione -15%, etc.

**Danno**: Se colpo a segno, danno calcolato dall'arma (integrazione `WeaponItem`) ridotto dalle protezioni (`ProtectionItem`)

**Critici**: Probabilità base 10% + bonus flanking, infligge danno extra

### 4.3 Guardia (Overwatch)

*   **Costo**: 2 PA, termina il turno
*   **Funzionamento**: Attacco automatico al primo nemico che si muove/agisce nella linea di vista
*   **Malus Mira**: -15% (attacco di reazione)
*   **Interruzione**: Termina dopo il primo attacco

### 4.4 Ricarica

*   **Costo**: 1 PA
*   **Funzionamento**: Ricarica l'arma del personaggio usando munizioni/cariche dall'inventario
*   **Integrazione**: Con il sistema di inventario del `CharacterSheet`

### 4.5 Rannicchiarsi (Hunker Down)

*   **Costo**: 2 PA, termina il turno
*   **Funzionamento**: Raddoppia bonus difensivo, immunità ai critici dalla direzione di copertura
*   **Limitazione**: Non può compiere azioni di reazione

## 5. Meccaniche Tattiche Avanzate (Stile Sci-Fi "Confederation")

### 5.1 Scansionare (Scanner Multifunzione)

*   **Costo**: 1 PA
*   **Su Nemico**: 
    *   Rivela statistiche (PF, armatura, armi)
    *   Applica malus difesa per un turno ("analizzato")
    *   Aumenta probabilità critico
    *   Richiede prova `Indagare` o `Scienze`
*   **Su Oggetto Interattivo**: Rivela opzioni di interazione ("Sovraccarica", "Disattiva Torretta")

### 5.2 Hacking/Ingegneria Remota (Strumento Multifunzione)

*   **Costo**: 1-2 PA
*   **Funzionamento**: Interazione a distanza con oggetti ambientali scansionati
*   **Esempi**: 
    *   Disattivare copertura energetica nemica
    *   Far esplodere condotto plasma
    *   Spegnere luci per favorire furtività
*   **Richiede**: Prova `Informatica` o `Ingegneria` vs CD

### 5.3 Supporto Medico (Kit Medico)

*   **Costo**: 1 PA
*   **Funzionamento**: 
    *   Usa carica kit medico per curare alleato adiacente
    *   Stabilizza compagno a 0 PF
*   **Richiede**: Prova `Medicina`
*   **Integrazione**: Con `UsableItem` del sistema oggetti

### 5.4 Fuoco di Soppressione (Arma Pesante)

*   **Costo**: 2 PA, consuma più munizioni
*   **Funzionamento**: 
    *   Non punta a colpire ma a bloccare
    *   Tiro automatico senza danno
    *   Bersaglio riceve stato "Soppresso": non può muoversi, forte malus mira
    *   Se tenta movimento, subisce attacco di reazione

## 6. Implementazione Tecnica in Godot

### 6.1 Architettura delle Classi

**`CombatManager.gd` (Singleton o Nodo di Scena)**:
```gdscript
extends Node

enum CombatPhase { PLAYER_TURN, ENEMY_TURN, ALLY_TURN, COMBAT_END }

var current_phase: CombatPhase = CombatPhase.PLAYER_TURN
var player_units: Array[Unit] = []
var enemy_units: Array[Unit] = []
var ally_units: Array[Unit] = []
var current_unit: Unit = null

func start_combat() -> void
func end_turn() -> void
func switch_to_next_phase() -> void
```

**`CombatGrid.gd` (TileMap o GridMap)**:
```gdscript
extends TileMap

class_name CombatGrid

class CellData:
    var is_walkable: bool = true
    var cover_north: int = 0
    var cover_south: int = 0  
    var cover_east: int = 0
    var cover_west: int = 0
    var occupant: Unit = null
    var environment_effect: String = ""
    var interactive_object: InteractiveObject = null

var grid_data: Dictionary = {} # Vector2i -> CellData

func get_cover_from(position: Vector2i, direction: Vector2i) -> int
func find_path(start: Vector2i, end: Vector2i) -> Array[Vector2i]
func get_valid_movement_cells(unit: Unit) -> Array[Vector2i]
```

**`Unit.gd` (CharacterBody2D/3D)**:
```gdscript
extends CharacterBody2D

class_name Unit

@export var character_sheet: CharacterSheet
@export var current_action_points: int = 2
@export var grid_position: Vector2i

signal unit_moved(unit: Unit, new_position: Vector2i)
signal action_performed(unit: Unit, action: CombatAction)
signal turn_ended(unit: Unit)

func move_to(path: Array[Vector2i]) -> void
func attack(target: Unit) -> void
func enter_overwatch() -> void
func use_ability(ability: CombatAction, target = null) -> void
func end_turn() -> void
```

**`CombatAction.gd` (Resource)**:
```gdscript
extends Resource

class_name CombatAction

@export var action_name: String
@export var ap_cost: int = 1
@export var requires_target: bool = false
@export var max_range: int = -1
@export var skill_required: SkillDefinition

func can_perform(user: Unit, target = null) -> bool
func execute(user: Unit, target = null) -> void
func get_description() -> String
```

### 6.2 Integrazione con Moduli Esistenti

**Con Character System**:
```gdscript
# In Unit.gd
func get_to_hit_chance(target: Unit, weapon: WeaponItem) -> int:
    var base_skill = UCS.get_attribute_modifier(character_sheet.dexterity)
    var weapon_skill = character_sheet.get_skill_rank(get_weapon_skill(weapon))
    var base_chance = 65 + (weapon_skill * 3) + base_skill
    
    var cover_penalty = CombatGrid.get_cover_penalty(target.grid_position, grid_position)
    var distance_modifier = weapon.get_distance_modifier(grid_position.distance_to(target.grid_position))
    
    return base_chance - cover_penalty + distance_modifier
```

**Con Item Database**:
```gdscript
# In Unit.gd
func fire_weapon(target: Unit) -> void:
    var equipped_weapon = character_sheet.get_equipped_weapon()
    if equipped_weapon is WeaponItem:
        var hit_chance = get_to_hit_chance(target, equipped_weapon)
        if randf() * 100 <= hit_chance:
            var damage_result = equipped_weapon.fire(target.character_sheet)
            target.take_damage(damage_result)
```

## 7. Analisi di Fattibilità

### 7.1 Complessità Tecnica: **MEDIA**

**Punti di Forza**:
*   Base solida già esistente (UCS, Character System, Item Database)
*   Godot offre strumenti nativi per pathfinding (A*) e gestione griglia
*   Sistema modulare permette sviluppo incrementale

**Sfide Principali**:
*   Integrazione complessa tra i 4 moduli esistenti
*   AI nemica che usa intelligentemente coperture e ambiente
*   Bilanciamento delle meccaniche tattiche avanzate

### 7.2 Tempo di Sviluppo Stimato: **3-4 Settimane**

**Fase 1 (1 settimana)**: Base funzionante
*   Griglia e movimento basato su PA
*   Attacco base con formula To-Hit e coperture
*   CombatManager per ciclo turni base
*   IA nemica semplice (muovi e attacca)

**Fase 2 (1 settimana)**: Profondità tattica
*   Overwatch e Rannicchiarsi
*   Sistema ricarica e gestione munizioni
*   Integrazione completa armi/armature
*   Calcolo accurato danni e protezioni
*   IA nemica base funzionante

**Fase 3 (1-2 settimane)**: Sapore "Confederation"
*   Azioni Scansionare e Hacking
*   Oggetti ambientali interattivi
*   IA nemica intelligente
*   Meccaniche non-letali e obiettivi alternativi

### 7.3 Rischi e Mitigazioni

**Rischio Alto**: Complessità dell'integrazione
*   **Mitigazione**: Test continui con scene isolate, sviluppo incrementale

**Rischio Medio**: Bilanciamento gameplay
*   **Mitigazione**: Playtest frequenti, parametri facilmente modificabili

**Rischio Basso**: Performance con molte unità
*   **Mitigazione**: Ottimizzazioni Godot native, pooling oggetti

### 7.4 Dipendenze Critiche

*   **UCS.gd**: Funzioni di calcolo modificatori e prove abilità
*   **CharacterSheet**: Attributi, abilità e inventario
*   **WeaponItem/ProtectionItem**: Statistiche armi e armature
*   **TileMap/GridMap**: Sistema di griglia Godot

Tutte le dipendenze sono già implementate e stabili.

## 8. Compatibilità e Integrazione

### 8.1 Interfacce Required

**Con UCS**:
*   `UCS.perform_skill_check()` per prove di abilità in combattimento
*   `UCS.get_attribute_modifier()` per calcoli bonus/malus
*   `UCS.calculate_initiative()` per ordine di turno

**Con Character System**:
*   `CharacterSheet.get_attribute_value()` per statistiche combattimento
*   `CharacterSheet.get_skill_rank()` per competenze armi/tattiche
*   `CharacterSheet.current_health` per gestione danni

**Con Item Database**:
*   `WeaponItem.fire()` per attacchi
*   `ProtectionItem.take_damage()` per assorbimento danni
*   `TechEquipment.get_passive_skill_bonuses()` per bonus equipaggiamento

### 8.2 Nuove Interfacce Esposte

Il modulo esporrà:
*   `CombatManager.start_combat(units: Array[Unit])` per iniziare combattimenti
*   `Unit.current_action_points` per sistemi esterni
*   Segnali per eventi di combattimento (unità sconfitta, obiettivo raggiunto, etc.)

## 9. Piano di Sviluppo Dettagliato

### Milestone 1: "Combat Foundation" (Settimana 1)
*   Implementare `CombatGrid.gd` con pathfinding
*   Creare `Unit.gd` base con movimento PA
*   `CombatManager.gd` per gestione turni semplice
*   Prototipo attacco con formula base
*   Test scene isolata per validazione

### Milestone 2: "Tactical Depth" (Settimana 2)  
*   Implementare Overwatch e Hunker Down
*   Sistema ricarica e gestione munizioni
*   Integrazione completa armi/armature
*   Calcolo accurato danni e protezioni
*   IA nemica base funzionante

### Milestone 3: "Confederation Style" (Settimana 3-4)
*   Azioni tecnologiche (Scan, Hack)
*   Oggetti ambientali interattivi
*   IA intelligente con uso coperture
*   Obiettivi di missione alternativi
*   Sistema non-letale completo
*   Polish e bilanciamento finale

### Deliverable Finale
*   Modulo combattimento completamente integrato
*   Scene demo con 3-4 scenari di combattimento diversi
*   Documentation tecnica completa
*   Test suite anti-regressione
*   Fondamenta solide per futuri sviluppi (Modulo 5: Narrative Engine)

## 10. Conclusioni

Il Modulo 4 rappresenta un traguardo fondamentale per "Confederation", completando il core system del gioco con un sistema di combattimento che riflette perfettamente la filosofia dell'universo sci-fi. 

La forte integrazione con i moduli esistenti e l'approccio tattico-strategico lo rendono unico nel panorama dei GDR digitali, offrendo un'esperienza dove la diplomazia e la tecnologia sono armi tanto potenti quanto i blaster.

Con una complessità tecnica gestibile e un tempo di sviluppo realistico, questo modulo porterà "Confederation" molto vicino a una demo giocabile completa, preparando il terreno per il Modulo 5 (Narrative Engine) e l'integrazione finale.

**Status**: ⏳ **PRONTO PER SVILUPPO**  
**Priorità**: 🔥 **ALTA** (Modulo Critico per Demo v0.3.0)  
**Rischio Complessivo**: 🟡 **MEDIO-BASSO** (Forte base esistente) 