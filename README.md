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

## Stato Attuale: `v0.2.1 - 'Grid Guardian'` ✨

Il progetto ha implementato con successo il core del sistema di combattimento tattico:

*   **Modulo 1: Regole Fondamentali (UCS - Universal Core System)**
    *   Definizione di attributi, abilità e meccaniche di risoluzione delle azioni (tiri di dado vs Classe Difficoltà).
    *   Implementazione del singleton `UCS.gd` con la logica per il calcolo dei modificatori e l'esecuzione delle prove di abilità.

*   **Modulo 2: Sistema del Personaggio**
    *   Progettazione di un sistema di creazione del personaggio flessibile (Point Buy / Standard Array).
    *   Definizione delle formule per le statistiche derivate (Punti Ferita, Iniziativa, etc.).
    *   Creazione della risorsa `CharacterSheet.gd` per contenere tutti i dati di un personaggio in modo strutturato e accessibile dall'editor di Godot.

*   **Sistema di Test e Validazione**
    *   Scena di test interattiva con interfaccia grafica per validare tutte le meccaniche implementate.
    *   Risorse di test complete (personaggi e abilità) per dimostrare il funzionamento del sistema.
    *   Suite di test anti-regressione per mantenere la qualità del codice durante lo sviluppo.
    *   File di configurazione Godot completo con autoload configurati.

*   **Modulo 3: Item Database - "Starbound Arsenal"** 🌟
    *   Sistema completo gestione oggetti sci-fi con 8 categorie tematiche (150+ oggetti catalogati).
    *   Classi specializzate: ItemDefinition, UsableItem, TechEquipment, WeaponItem, ProtectionItem.
    *   Sistema inventario avanzato con gestione peso, stacking automatico e segnali eventi.
    *   Integrazione seamless con CharacterSheet e SkillDefinition per bonus abilità.
    *   Filosofia Confederation: focus su esplorazione, diplomazia e collaborazione scientifica.

*   **Modulo 4: Combat System - "Grid Guardian"** 🛡️
    *   CombatGrid v2: Griglia tattica 20x15 con sistema coperture direzionali.
    *   Test suite completa: 22/22 test anti-regressione superati.
    *   Metodologia incrementale sicura validata: zero regressioni moduli esistenti.
    *   Foundation solida per pathfinding A*, Unit.gd e CombatManager.

*   **Metodologia di Sviluppo Modulare Indipendente**
    *   Framework completo per sviluppo assistito da IA **validato con successo**.
    *   Principio "Un Modulo, Una Sessione" applicato con successo a Moduli 3 e 4.
    *   Procedure anti-regressione e recovery crisis **testate in produzione**.
    *   Template riproducibile e linee guida operative **consolidate**.

## Come Contribuire

Il progetto è in una fase iniziale. Feedback, idee e suggerimenti sono sempre benvenuti. È possibile aprire una *Issue* su GitHub per discutere di nuove funzionalità o segnalare problemi.

## Roadmap Futura

### 🎯 **v0.3.0 - "Tactical Nexus"** (Prossima Release)
*   **Modulo 4: Combat System**: Sistema combattimento tattico a turni su griglia.
*   **Integrazione Item System**: Uso armi, armature e oggetti nel combattimento.
*   **Sistema Stress e Fatigue**: Meccaniche avanzate per missioni prolungate.

### 🔮 **Versioni Future**
*   **v0.4.0 - "Narrative Engine"**: Modulo 5 - AI Director (Sistema narrativo procedurale).
*   **v0.5.0 - "Galactic Unity"**: Integration Release (Integrazione completa moduli e demo giocabile).
*   **v1.0.0 - "Confederation Rising"**: Prima release stabile con campagna completa.
