# 🧪 Test Suite - Combat System Module

## Test Disponibili

### test_combat_grid.gd
**Test completo per CombatGrid v2**
- ✅ Creazione e inizializzazione griglia
- ✅ Validazione posizioni
- ✅ Accesso e modifica dati celle  
- ✅ Sistema coperture direzionali
- ✅ Pathfinding placeholder
- ✅ Utility debug

**Come eseguire:**
1. Apri scene: `modules/combat_system/scenes/test_combat_grid.tscn`
2. Premi F6 (Run Current Scene)
3. Controlla output console per risultati

**Output atteso:**
- Tutti i test dovrebbero passare (✅)
- Nessun errore critico (❌)
- Resoconto finale con statistiche

## Test Anti-Regressione

### TR-017: Caricamento CombatGrid
- **Test**: Istanziare CombatGrid.gd
- **Atteso**: Griglia inizializzata senza errori

### TR-018: Pathfinding Base  
- **Test**: find_path() tra due punti
- **Atteso**: Restituisce array Vector2i valido

### TR-019: Dati Cella
- **Test**: get_cell_data() per posizione
- **Atteso**: Restituisce CellData con valori default

### TR-020: Coperture Direzionali
- **Test**: get_cover_from() per direzioni  
- **Atteso**: Valori copertura corretti per direzione

## Note di Sicurezza

⚠️ **NON creare file temporanei nella root del progetto**
⚠️ **Backup .godot prima di test importanti**
⚠️ **Cache cleanup dopo modifica/eliminazione script** 