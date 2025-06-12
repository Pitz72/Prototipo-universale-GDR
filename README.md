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

## Stato Attuale: `v0.1.0 - 'Genesis Core'`

Il progetto ha completato la definizione e l'implementazione delle fondamenta del sistema di gioco:

*   **Modulo 1: Regole Fondamentali (UCS - Universal Core System)**
    *   Definizione di attributi, abilità e meccaniche di risoluzione delle azioni (tiri di dado vs Classe Difficoltà).
    *   Implementazione del singleton `UCS.gd` con la logica per il calcolo dei modificatori e l'esecuzione delle prove di abilità.

*   **Modulo 2: Sistema del Personaggio**
    *   Progettazione di un sistema di creazione del personaggio flessibile (Point Buy / Standard Array).
    *   Definizione delle formule per le statistiche derivate (Punti Ferita, Iniziativa, etc.).
    *   Creazione della risorsa `CharacterSheet.gd` per contenere tutti i dati di un personaggio in modo strutturato e accessibile dall'editor di Godot.

## Come Contribuire

Il progetto è in una fase iniziale. Feedback, idee e suggerimenti sono sempre benvenuti. È possibile aprire una *Issue* su GitHub per discutere di nuove funzionalità o segnalare problemi.

## Roadmap Futura

1.  **Modulo 3: Database Oggetti**: Creazione di un sistema per definire armi, armature ed equipaggiamento.
2.  **Modulo 4: Sistema di Combattimento**: Sviluppo di un sistema di combattimento tattico a turni su griglia.
3.  **Creazione di Contenuti di Prova**: Sviluppo di una scena di test interattiva per validare il core loop di gioco.
