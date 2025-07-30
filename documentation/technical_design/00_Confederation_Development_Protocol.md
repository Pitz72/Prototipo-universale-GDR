# Protocollo di Sviluppo "Confederation" - La Direttiva Primaria del Progetto

**Versione**: 1.0  
**Data**: Dicembre 2024  
**Status**: ✅ **ATTIVO**  
**Codename**: "La Direttiva Primaria"

---

## 🎯 **Missione della Direttiva**

Questo documento stabilisce i principi fondamentali, i protocolli operativi e le responsabilità per lo sviluppo del progetto "Confederation". Come la Direttiva Primaria della Confederazione Terrestre guida l'esplorazione spaziale nel nostro universo narrativo, questa Direttiva guida il nostro processo di sviluppo verso l'eccellenza, la sostenibilità e l'innovazione.

---

## 📜 **PRINCIPIO 1: L'Archivio Centrale come Fonte Unica della Verità**

### **La Regola dell'Archivio Centrale**
La cartella `documentation/` rappresenta l'**unica fonte di verità** per tutto il progetto Confederation. Ogni decisione di design, specifica tecnica, stato di sviluppo e pianificazione futura deve essere documentata e mantenuta in questo archivio.

### **Responsabilità dell'Equipaggio**

#### **Il Capitano (Umano)**
- **Mantenimento dell'Archivio**: Responsabile dell'aggiornamento tempestivo della documentazione
- **Controllo di Qualità**: Verifica che la documentazione rifletta accuratamente lo stato del progetto
- **Decisioni Strategiche**: Approva modifiche architetturali e di design
- **Sincronizzazione**: Assicura che README.md rifletta sempre la versione stabile più recente

#### **L'Ufficiale Operativo (LLM)**
- **Consultazione Obbligatoria**: Deve basarsi esclusivamente sui documenti nell'archivio
- **Segnalazione Incongruenze**: Obbligo di evidenziare discrepanze tra documentazione e codice
- **Aggiornamento su Richiesta**: Aggiorna la documentazione solo su istruzione esplicita del Capitano
- **Validazione Continua**: Verifica che le implementazioni rispettino le specifiche documentate

### **Protocollo di Consultazione**
```
1. SEMPRE leggere la documentazione pertinente prima di iniziare qualsiasi task
2. SEMPRE segnalare incongruenze tra documentazione e stato reale
3. MAI assumere informazioni non documentate
4. MAI procedere senza conferma della comprensione del contesto
```

---

## ⚡ **PRINCIPIO 2: Sviluppo Modulare e Incrementale ("A Piccoli Salti Curvatura")**

### **La Filosofia dei Piccoli Salti**
Come le navi della Confederation utilizzano piccoli salti curvatura per navigare sicuramente attraverso lo spazio, il nostro sviluppo procede con incrementi piccoli, sicuri e validabili.

### **Regola "Un Modulo, Una Sessione"**
- **Atomicità**: Ogni sessione di sviluppo deve completare un modulo o componente specifico
- **Commit Singolo**: Ogni task completato corrisponde a un commit Git significativo
- **Validazione Immediata**: Ogni incremento deve essere testato prima di procedere

### **Sequenza Obbligatoria: "Prima il Design, Poi il Codice"**
```
1. DESIGN: Documentare specifiche, architettura, interfacce
2. PLANNING: Definire test e criteri di validazione
3. IMPLEMENTATION: Scrivere il codice seguendo le specifiche
4. VALIDATION: Eseguire test e validazione
5. DOCUMENTATION: Aggiornare documentazione con risultati reali
```

### **Dimensionamento dei Task**
- **Massimo 4 ore** di sviluppo continuo per task
- **Massimo 500 righe** di codice nuovo per sessione
- **Minimo 3 test** per ogni nuova funzionalità
- **100% coverage** della documentazione per nuovi moduli

---

## 🔄 **PRINCIPIO 3: Il Rituale di Sincronizzazione del Contesto**

### **Protocollo di Inizio Sessione**
Ogni sessione di sviluppo deve iniziare con il seguente rituale di sincronizzazione:

```
CAPITANO: "Ciao, oggi lavoriamo al [Modulo/Task specifico]. 
          Fai riferimento a [Lista documenti specifici].
          Il nostro obiettivo è [Obiettivo specifico e misurabile]."

UFFICIALE OPERATIVO: "Confermo la comprensione:
                     - Modulo target: [Ripete il modulo]
                     - Documenti di riferimento: [Lista i documenti]
                     - Obiettivo: [Ripete l'obiettivo]
                     - Stato attuale compreso: [Riassume lo stato]
                     - Prossimi step identificati: [Lista i task]
                     Procedo con l'implementazione?"

CAPITANO: "Confermato" / "Correzioni: [...]"
```

### **Prevenzione della Deriva del Contesto**
- **Checkpoint ogni 30 minuti**: L'LLM deve riassumere il progresso
- **Validazione incrementale**: Ogni modifica deve essere confermata prima di procedere
- **Stop su incongruenze**: Fermare immediatamente se si rilevano discrepanze
- **Re-sincronizzazione**: Richiedere nuova sincronizzazione se il contesto si perde

---

## 🛡️ **PRINCIPIO 4: Il Protocollo Anti-Regressione e Validazione Continua**

### **Il Guardiano Anti-Regressione**
Il file `documentation/technical_design/test_suite_anti_regression.md` è il **Guardiano** del progetto. Ogni funzionalità esistente deve rimanere funzionante.

### **Gerarchia di Validazione**

#### **Livello 1: Validazione Statica**
- **Analisi del codice** senza esecuzione
- **Controllo sintassi** e struttura
- **Verifica interfacce** e dipendenze
- **Validazione architetturale**

#### **Livello 2: Test di Esecuzione**
- **Test unitari** per singole funzioni
- **Test di integrazione** tra moduli
- **Test di regressione** per funzionalità esistenti
- **Test di performance** per operazioni critiche

#### **Livello 3: Validazione Utente**
- **Test manuali** con scenari reali
- **Validazione gameplay** per meccaniche
- **Test di usabilità** per interfacce
- **Acceptance test** per requisiti

### **Protocollo di Aggiornamento Test**
```
PER OGNI NUOVA FUNZIONALITÀ:
1. Definire criteri di test PRIMA dell'implementazione
2. Implementare test insieme al codice
3. Aggiornare test_suite_anti_regression.md
4. Validare che test esistenti continuino a passare
5. Documentare eventuali breaking changes
```

---

## 👥 **PRINCIPIO 5: Definizione dei Ruoli dell'Equipaggio**

### **Il Capitano (Umano)**
**Ruolo**: Architetto del Progetto, Game Designer, Quality Assurance

**Responsabilità Strategiche**:
- Definisce la visione e gli obiettivi del progetto
- Prende tutte le decisioni di design e architettura
- Approva modifiche che impattano l'esperienza utente
- Gestisce la roadmap e le priorità di sviluppo

**Responsabilità Operative**:
- Mantiene aggiornata la documentazione strategica
- Valida che l'implementazione rispetti il design
- Esegue quality assurance finale
- Gestisce il versioning e i rilasci

### **L'Ufficiale Operativo (LLM)**
**Ruolo**: Programmatore, Scrittore Tecnico, Pair Programmer

**Responsabilità Tecniche**:
- Implementa il codice seguendo le specifiche fornite
- Scrive documentazione tecnica su istruzioni
- Identifica e segnala problemi tecnici a basso livello
- Esegue refactoring e ottimizzazioni guidate

**Limitazioni Operative**:
- **NON prende iniziative di design** senza approvazione
- **NON modifica l'architettura** senza istruzioni esplicite
- **NON cambia l'esperienza utente** senza consenso
- **NON assume requisiti** non documentati

### **Protocollo di Collaborazione**
```
DECISIONI DI DESIGN: Solo il Capitano
IMPLEMENTAZIONE TECNICA: Collaborazione Capitano-Ufficiale
OTTIMIZZAZIONI: Proposte dell'Ufficiale, approvate dal Capitano
DOCUMENTAZIONE: Scritta dall'Ufficiale, validata dal Capitano
```

---

## 🗄️ **PRINCIPIO 6: Architettura Dati a Risorse (Resource-Based Architecture)**

### **La Filosofia delle Risorse**
Il progetto Confederation adotta un'architettura basata sulle **Resource di Godot** (.tres) come fondamento per tutti i sistemi di dati. Questa scelta garantisce:
- **Serializzazione automatica** e persistenza
- **Integrazione nativa** con l'editor Godot
- **Type safety** e validazione strutturale
- **Modularità** e riusabilità dei dati

### **Struttura Standard**
```
modules/[nome_modulo]/
├── src/                    # Classi base (.gd scripts)
│   └── [class_name].gd    # Definisce la struttura dati
├── resources/             # Istanze concrete (.tres files)
│   └── [instance_name].tres # Contiene i dati specifici
├── tests/                 # Test per il modulo
└── README_MODULO.md       # Documentazione del modulo
```

### **Convenzioni di Implementazione**

#### **Classi Base (.gd)**
- Definiscono la **struttura** e i **metodi**
- Utilizzano `@export` per proprietà editabili
- Implementano validazione e logica di business
- Forniscono interfacce pubbliche consistenti

#### **Risorse (.tres)**
- Contengono **dati concreti** e configurazioni
- Sono istanze delle classi base
- Permettono editing visuale nell'editor Godot
- Supportano versionamento e merge

### **Esempi di Applicazione**
- **Abilità**: `SkillDefinition.gd` + `atletica.tres`, `informatica.tres`
- **Personaggi**: `CharacterSheet.gd` + `ufficiale_sicurezza.tres`
- **Oggetti**: `ItemDefinition.gd` + `plasma_rifle.tres`, `med_kit.tres`
- **Azioni**: `CombatAction.gd` + `move_action.tres`, `attack_action.tres`

---

## 📝 **PRINCIPIO 7: Aggiornamento Continuo dei Log di Sviluppo**

### **Il Sistema di Cronache**
La cartella `documentation/development_logs/` mantiene la **cronaca completa** dello sviluppo del progetto. Ogni milestone significativa deve essere documentata con precisione storica.

### **Protocollo di Aggiornamento**

#### **Al Completamento di Milestone**
```
1. Creare nuovo file: v[X.Y.Z]-[codename].md
2. Documentare obiettivi raggiunti e metriche
3. Registrare problemi incontrati e soluzioni
4. Aggiornare README.md principale con nuovo stato
5. Archiviare log precedenti se superati
```

#### **Struttura Standard dei Log**
```markdown
# Development Log v[X.Y.Z] "[Codename]"
**Data Release**: [Data]
**Status**: [Status Badge]
**Codename**: "[Nome Versione]"

## 🎯 Obiettivi Release
## ✅ Implementazioni Completate  
## 📊 Metriche Implementazione
## 🔄 Lessons Learned
## 🚀 Next Steps
```

### **Responsabilità di Mantenimento**

#### **Il Capitano**
- Approva il contenuto dei log di sviluppo
- Decide quando una milestone è completa
- Aggiorna il README.md principale
- Mantiene la coerenza della cronaca

#### **L'Ufficiale Operativo**
- Scrive i log su istruzioni del Capitano
- Raccoglie metriche e dati tecnici
- Documenta problemi e soluzioni tecniche
- Mantiene la formattazione standard

---

## 🚀 **IMPLEMENTAZIONE DELLA DIRETTIVA**

### **Checklist di Attivazione**
- [ ] Tutti i membri dell'equipaggio hanno letto e compreso la Direttiva
- [ ] La documentazione esistente è stata validata per conformità
- [ ] I tool e processi sono configurati secondo i protocolli
- [ ] Il primo progetto pilota è stato identificato per l'applicazione

### **Metriche di Successo**
- **Tempo di onboarding**: < 30 minuti per nuovi collaboratori
- **Deriva del contesto**: 0 episodi per sessione di sviluppo
- **Regressioni**: < 1% per release
- **Documentazione accuracy**: > 95% allineamento con codice reale

### **Processo di Evoluzione**
Questa Direttiva è un **documento vivente**. Può essere aggiornata attraverso:
1. **Proposta di modifica** documentata
2. **Discussione** con tutto l'equipaggio
3. **Test pilota** della modifica proposta
4. **Approvazione formale** e aggiornamento versione

---

## 🎖️ **GIURAMENTO DELL'EQUIPAGGIO**

> *"Noi, equipaggio del progetto Confederation, giuriamo di seguire la Direttiva Primaria nello spirito di esplorazione, eccellenza e collaborazione che definisce la Confederazione Terrestre. Ci impegniamo a mantenere gli standard più elevati di qualità, trasparenza e innovazione, guidando il nostro progetto verso nuove frontiere del game development."*

---

**🎯 La Direttiva Primaria: Il Nostro Codice, La Nostra Bussola, Il Nostro Futuro**

---

## 📋 **Appendice: Quick Reference**

### **Comandi Rapidi di Sincronizzazione**
```
SYNC_START: "Oggi lavoriamo a [X], riferimento [Y], obiettivo [Z]"
SYNC_CONFIRM: "Confermo comprensione: [riassunto]"
SYNC_CHECK: "Stato attuale e prossimi step?"
SYNC_STOP: "Fermiamo qui, sincronizziamo la documentazione"
```

### **File Critici da Consultare**
- `README.md` - Stato generale del progetto
- `documentation/technical_design/modular_development_methodology.md` - Metodologia
- `documentation/technical_design/test_suite_anti_regression.md` - Test e validazione
- `context_temp.txt` - Priorità immediate e stato corrente

### **Protocolli di Emergenza**
- **Deriva del Contesto**: Stop immediato, re-sincronizzazione
- **Regressione Critica**: Rollback, analisi root cause, fix, test
- **Documentazione Obsoleta**: Update immediato, validazione consistency
- **Conflitto di Design**: Escalation al Capitano, decisione documentata

---

**Versione 1.0 - "La Direttiva Primaria" - Attiva dal Dicembre 2024** 