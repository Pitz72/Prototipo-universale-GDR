# Suite di Test Anti-Regressione - Confederation Project

**Versione:** v0.2.0 - "Starbound Arsenal"  
**Data Creazione:** 12 Giugno 2025  
**Ultimo Aggiornamento:** Dicembre 2024 - v0.2.0 "Starbound Arsenal"

## Scopo del Documento

Questa suite di test anti-regressione definisce i controlli necessari per validare che le funzionalità core del sistema UCS continuino a funzionare correttamente dopo modifiche al codice.

## Test Manuali - Lista di Controllo

### 🧪 **TEST GROUP 1: Caricamento Risorse**

**Pre-requisiti:** Godot 4.5+ aperto con il progetto caricato

| Test ID | Descrizione | Procedura | Risultato Atteso | Status |
|---------|-------------|-----------|------------------|---------|
| TR-001 | Caricamento SkillDefinition | Aprire `informatica.tres` nell'editor | Risorsa si apre senza errori, campi popolati | ⏳ |
| TR-002 | Caricamento CharacterSheet | Aprire `ufficiale_sicurezza.tres` nell'editor | Risorsa si apre senza errori, attributi visibili | ⏳ |
| TR-003 | Autoload UCS | Verificare Progetto > Impostazioni Progetto > Autoload | UCS presente e abilitato | ⏳ |

### 🧪 **TEST GROUP 2: Calcoli Matematici UCS**

**Pre-requisiti:** Accesso alla console di debug di Godot

| Test ID | Descrizione | Input | Output Atteso | Status |
|---------|-------------|-------|---------------|---------|
| TR-004 | Modificatore Attributo 8 | `UCS.get_attribute_modifier(8)` | `-1` | ⏳ |
| TR-005 | Modificatore Attributo 10 | `UCS.get_attribute_modifier(10)` | `0` | ⏳ |
| TR-006 | Modificatore Attributo 16 | `UCS.get_attribute_modifier(16)` | `+3` | ⏳ |
| TR-007 | PF Livello 1 (COS 15) | Character con COS 15, Liv 1 | `25 PF` (10+15) | ⏳ |
| TR-008 | Iniziativa (DES 14) | Character con DES 14 | `+2` | ⏳ |

### 🧪 **TEST GROUP 3: Sistema Prove Abilità**

**Pre-requisiti:** Scena `test_integration_scene.tscn` in esecuzione

| Test ID | Descrizione | Procedura | Controlli | Status |
|---------|-------------|-----------|-----------|---------|
| TR-009 | Prova Atletica - Visualizzazione | Premere "Esegui Prova di Atletica" | Risultato mostra: personaggio, abilità, calcoli, esito | ⏳ |
| TR-010 | Prova Informatica - Visualizzazione | Premere "Esegui Prova di Informatica" | Risultato mostra: personaggio, abilità, calcoli, esito | ⏳ |
| TR-011 | Calcoli Atletica | Verificare calcoli nella prova | d20 + 3 (mod FOR) + 3 (grado) vs CD 15 | ⏳ |
| TR-012 | Calcoli Informatica | Verificare calcoli nella prova | d20 + 1 (mod INT) + 1 (grado) vs CD 12 | ⏳ |

### 🧪 **TEST GROUP 4: Interfaccia Utente**

**Pre-requisiti:** Scena di test in esecuzione

| Test ID | Descrizione | Procedura | Risultato Atteso | Status |
|---------|-------------|-----------|------------------|---------|
| TR-013 | Caricamento Scheda Iniziale | Avviare scena di test | Mostra info complete del personaggio | ⏳ |
| TR-014 | Pulsanti Funzionali | Cliccare entrambi i pulsanti di test | Entrambi rispondono e mostrano risultati | ⏳ |
| TR-015 | Formattazione BBCode | Verificare output dei test | Testo colorato, grassetto, separatori visibili | ⏳ |
| TR-016 | Scroll dei Risultati | Eseguire più test consecutivi | ScrollContainer permette di vedere tutti i risultati | ⏳ |

## Test Automatizzati (Futuri)

### 📝 **Promemoria per Implementazione Futura**

Quando si implementerà un sistema di test automatizzati, includere:

1. **Unit Test per UCS.gd:**
   - Test di tutti i metodi statici con valori noti
   - Test di edge cases (valori estremi, null, etc.)

2. **Integration Test:**
   - Caricamento e validazione risorse .tres
   - Test complete workflow prove di abilità

3. **Performance Test:**
   - Test di carico con molte prove di abilità consecutive
   - Misurazione tempi di caricamento risorse

## Validazione Manuale Rapida (5 Minuti)

### ✅ **Checklist Rapida per Release**

Prima di ogni commit importante, eseguire questa checklist rapida:

- [ ] Progetto si apre in Godot senza errori
- [ ] Scena di test si avvia correttamente
- [ ] Entrambi i pulsanti di test funzionano
- [ ] Calcoli matematici sono visibili e corretti
- [ ] Nessun errore nella console di debug

### 🎯 **Valori di Riferimento Critici**

**Ufficiale di Sicurezza (FOR 16, DES 14, COS 15, INT 12):**
- Mod. Forza: +3
- Mod. Destrezza: +2  
- Mod. Costituzione: +2
- Mod. Intelligenza: +1
- PF Massimi: 25 (10+15)
- Iniziativa: +2
- Capacità Carico: 160 kg
- Atletica (3 gradi): +6 totale vs CD 15
- Informatica (1 grado): +2 totale vs CD 12

## Log dei Test Eseguiti

| Data | Versione | Tester | Risultato | Note |
|------|----------|--------|-----------|------|
| 2025-06-12 | v0.1.1 | AI Assistant | ✅ Tutti test implementati | Setup iniziale suite test |
| 2025-06-12 | v0.1.1 | Utente + AI | ✅ **TUTTI TEST SUPERATI** | Sistema UCS completamente funzionale, fallback hardcoded attivo |
| 2025-06-12 | v0.1.2 | Consolidamento | ✅ **VERSIONE STABILE** | Foundation completa, metodologia definita, pronta per scaling |
| 2024-12 | v0.2.0 | Starbound Arsenal | ✅ **MODULO 3 COMPLETATO** | Item Database implementato, tutti test passano, zero regressioni |

## Note per Sviluppatori

1. **Frequenza Test:** Eseguire prima di ogni commit al main branch
2. **Aggiornamento Suite:** Aggiornare questa suite quando si aggiungono nuove funzionalità
3. **Documentazione Errori:** Registrare qualsiasi fallimento con dettagli di riproduzione
4. **Regressioni:** Se un test precedentemente passato ora fallisce, identificare e documentare la causa

---

**Mantenere questo documento aggiornato ad ogni modifica del core system!** 