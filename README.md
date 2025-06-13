# Confederation - Prototipo GDR Sci-Fi

![Godot Engine](https://img.shields.io/badge/Godot%20Engine-4.x-blue?style=for-the-badge&logo=godot-engine)
![GDScript](https://img.shields.io/badge/GDScript-Custom-orange?style=for-the-badge&logo=gdscript)
![Status](https://img.shields.io/badge/Status-In%20Sviluppo-green?style=for-the-badge)

**Confederation** è un prototipo per un gioco di ruolo narrativo sci-fi, sviluppato in Godot 4. Il progetto mira a costruire un sistema di regole flessibile e modulare, ispirato ai classici del genere (come il d20 System) ma con un'identità propria, pensato per avventure tattiche e una forte componente narrativa.

## Genesi e Obiettivi

Questo progetto nasce dalla passione per i giochi di ruolo classici e le grandi saghe fantascientifiche (come Star Trek), unite alla volontà di esplorare un processo di sviluppo innovativo.

**Confederation** non è solo un prototipo di gioco, ma anche un esperimento di **sviluppo assistito da IA**. L'intero processo, dalla progettazione alla scrittura del codice, è realizzato in stretta collaborazione con un Large Language Model (LLM), con l'obiettivo di testare i limiti e le potenzialità di questa sinergia.

L'obiettivo finale è duplice:
1.  Creare un **core system GDR solido e riutilizzabile**, che possa servire da base per future avventure narrative.
2.  **Documentare un caso di studio** sullo sviluppo di software complesso in coppia con un'intelligenza artificiale, condividendone metodologia, sfide e risultati.

## Filosofia del Progetto

*   **Modularità**: Ogni componente del gioco (regole base, sistema del personaggio, combattimento, etc.) è sviluppato come un modulo indipendente per garantire manutenibilità e scalabilità.
*   **Documentazione First**: Ogni modulo viene prima progettato e documentato nel dettaglio, per poi essere implementato in codice. Questo assicura una visione chiara e coesa.
*   **Prototipazione Rapida**: L'obiettivo è creare un *core loop* di gioco funzionante, concentrandosi sulle meccaniche fondamentali prima di passare agli aspetti grafici e narrativi estesi.
*   **Open Source**: Il codice e la documentazione di questo prototipo sono aperti, con l'intento di condividere il processo di sviluppo e raccogliere feedback.

## Stato Attuale: `v0.2.3 - 'Combat Foundation'` ⚠️

Il progetto ha implementato il sistema di combattimento tattico completo, attualmente in fase di validazione:

*   **Modulo 1: Regole Fondamentali (UCS - Universal Core System)** ✅
    *   Definizione di attributi, abilità e meccaniche di risoluzione delle azioni (tiri di dado vs Classe Difficoltà).
    *   Implementazione del singleton `UCS.gd` con la logica per il calcolo dei modificatori e l'esecuzione delle prove di abilità.

*   **Modulo 2: Sistema del Personaggio** ✅
    *   Progettazione di un sistema di creazione del personaggio flessibile (Point Buy / Standard Array).
    *   Definizione delle formule per le statistiche derivate (Punti Ferita, Iniziativa, etc.).
    *   Creazione della risorsa `CharacterSheet.gd` per contenere tutti i dati di un personaggio in modo strutturato e accessibile dall'editor di Godot.

*   **Modulo 3: Item Database - "Starbound Arsenal"** ✅
    *   Sistema completo gestione oggetti sci-fi con 8 categorie tematiche (150+ oggetti catalogati).
    *   Classi specializzate: ItemDefinition, UsableItem, TechEquipment, WeaponItem, ProtectionItem.
    *   Sistema inventario avanzato con gestione peso, stacking automatico e segnali eventi.
    *   Integrazione seamless con CharacterSheet e SkillDefinition per bonus abilità.
    *   Filosofia Confederation: focus su esplorazione, diplomazia e collaborazione scientifica.

*   **Modulo 4: Combat System - "Combat Foundation"** 🟡
    *   **CombatGrid v2.0**: Griglia tattica 20x15 con sistema coperture direzionali (95 righe) ✅
    *   **Unit System v1.0**: Integrazione CharacterSheet, 2 PA per turno, posizionamento grid (175 righe) ✅
    *   **CombatManager v1.0**: Gestione turni, iniziativa DES+1d20, player/ally/enemy arrays (267 righe) ✅
    *   **Actions Framework**: Base class per azioni combattimento, prerequisiti, cooldown (198 righe) ✅
    *   **Test Suite**: 34 test implementati ma non validati (blockers environment) ⚠️
    *   **Status**: Implementazione completa (1237 righe), validazione bloccata per conflitti naming/cache

*   **Sistema di Test e Validazione** ⚠️
    *   Test suite comprehensive: 34 test anti-regressione implementati.
    *   Environment issues: Class name conflicts + cache Godot corrotta bloccano execution.
    *   Recovery plan documentato per v0.2.4 "Validated Foundation".
    *   Scena di test interattiva UCS funzionante (conflitto con test combat).

*   **Metodologia di Sviluppo Modulare Indipendente**
    *   Framework completo per sviluppo assistito da IA **validato con successo**.
    *   Principio "Un Modulo, Una Sessione" applicato con successo a Moduli 3 e 4.
    *   Procedure anti-regressione e recovery crisis **testate in produzione**.
    *   Template riproducibile e linee guida operative **consolidate**.

## Come Contribuire

Il progetto è in una fase iniziale. Feedback, idee e suggerimenti sono sempre benvenuti. È possibile aprire una *Issue* su GitHub per discutere di nuove funzionalità o segnalare problemi.

## Roadmap Futura

### 🚨 **v0.2.4 - "Validated Foundation"** (Priorità Immediata)
*   **Environment Cleanup**: Risoluzione class_name conflicts e cache Godot corrotta.
*   **Test Validation**: Esecuzione e validazione completa 34 test implementati.
*   **Documentation Finalization**: Stato definitivo v0.2.3 e procedure recovery.
*   **Stable Foundation**: Base solida e testata per sviluppi futuri.

### 🎯 **v0.3.0 - "Tactical Actions"** (Prossima Release)
*   **Specific Actions**: Implementazione Move, Attack, Tech actions concrete.
*   **A* Pathfinding**: Algoritmo completo per movement su CombatGrid.
*   **Combat Demo**: Scene giocabile con basic AI e full combat loop.
*   **Performance Optimization**: Benchmarks e ottimizzazioni sistema.

### 🔮 **Versioni Future**
*   **v0.4.0 - "Confederation Style"**: Azioni sci-fi, ambiente interattivo, sistema non-letale.
*   **v0.5.0 - "Narrative Engine"**: Modulo 5 - AI Director (Sistema narrativo procedurale).
*   **v0.6.0 - "Galactic Unity"**: Integration Release (Integrazione completa moduli e demo giocabile).
*   **v1.0.0 - "Confederation Rising"**: Prima release stabile con campagna completa.
