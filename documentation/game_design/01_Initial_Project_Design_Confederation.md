# Confederation - Prototipo Base GDR SciFi - Documento di Design Iniziale

## 1. Introduzione

*   **Nome del Progetto**: Confederation
*   **Genere**: Gioco di Ruolo (GDR) narrativo Sci-Fi in stile retrò
*   **Piattaforma Target Iniziale**: PC (Windows, Linux, macOS)
*   **Motore di Gioco**: Godot 4.5
*   **Ispirazione Tematica**: Star Trek, space opera classiche
*   **Ispirazione Meccaniche**: GDR cartacei classici, X-Com (per il sistema di combattimento)
*   **Obiettivo del Prototipo**: Sviluppare e testare i moduli di gioco fondamentali (Regole, Personaggio, Oggetti, Combattimento) in modo indipendente prima dell'integrazione finale, della definizione estetica e della stesura narrativa.

## 2. Filosofia di Design

*   **Sviluppo Modulare**: Priorità alla creazione di componenti di gioco indipendenti, ben definiti e testabili singolarmente. Questo approccio mira a mantenere la coerenza, facilitare la collaborazione (anche con IA) e gestire la complessità.
*   **Gameplay First**: Focus iniziale sulle meccaniche di gioco e sulla loro solidità. L'interfaccia utente sarà inizialmente funzionale e basilare, l'estetica e la narrazione dettagliata verranno sviluppate in fasi successive.
*   **Stile Retrò**: L'approccio visivo e sonoro richiamerà i classici del genere, permettendo di concentrarsi sulla sostanza del gameplay e facilitando la prototipazione rapida.
*   **Iterazione e Documentazione**: Sviluppo iterativo con costante documentazione per mantenere traccia delle decisioni, delle meccaniche implementate e per facilitare l'evoluzione del progetto.

## 3. Moduli di Sviluppo Iniziali

L'ordine di sviluppo proposto è il seguente:

### Modulo 1: Regole Fondamentali del Gioco
*   **Obiettivo**: Definire il "sistema operativo" del gioco.
*   **Componenti Chiave**:
    *   Sistema di risoluzione delle azioni (es. basato su attributi + tiri di dado virtuali, percentuali di successo).
    *   Definizione delle statistiche secondarie e come derivano da quelle primarie.
    *   Meccaniche di base per interazioni non di combattimento (es. persuasione, hacking, riparazione).
    *   Eventuale sistema di valuta/risorse base (se necessario per i primi moduli).

### Modulo 2: Personaggio e Attributi
*   **Obiettivo**: Creare la struttura del personaggio giocante e dei PNG.
*   **Componenti Chiave**:
    *   Attributi primari (es. Forza, Destrezza, Costituzione, Intelligenza, Saggezza, Carisma – da definire nel dettaglio).
    *   Abilità (skills) e competenze, e come si legano agli attributi.
    *   Sistema di progressione del personaggio (Punti Esperienza, livelli, miglioramento di attributi/abilità).
    *   Gestione della salute, energia (o scudi/stamina), e altri status rilevanti.
    *   (Opzionale per il prototipo iniziale: razze/specie, background con impatti meccanici).

### Modulo 3: Database Oggetti (Esclusi Oggetti Lore)
*   **Obiettivo**: Definire e strutturare gli oggetti interagibili e utilizzabili nel gioco.
*   **Componenti Chiave**:
    *   Tipologie di oggetti:
        *   Armi (a distanza, corpo a corpo, energetiche, cinetiche).
        *   Armature/Protezioni (scudi personali, tute ambientali).
        *   Consumabili (medikit, stimpack, celle energetiche).
        *   Equipaggiamento tecnologico (scanner, tool multiuso).
    *   Attributi degli oggetti (danno, tipo di danno, rateo di fuoco, capacità munizioni, valori di protezione, effetti speciali, bonus/malus ad attributi/abilità).
    *   Sistema di inventario (capacità, peso/ingombro, organizzazione).
    *   (Opzionale per il prototipo: crafting/modifica base degli oggetti).

### Modulo 4: Sistema di Combattimento Tattico a Turni (Prototipo)
*   **Obiettivo**: Sviluppare un prototipo funzionale del sistema di combattimento.
*   **Ispirazione**: X-Com (2D), giochi tattici a turni.
*   **Componenti Chiave**:
    *   Mappa di combattimento basata su griglia (quadrata o esagonale – da decidere).
    *   Sistema di Punti Azione (PA) per turno.
    *   Azioni di base: Movimento, Attacco (mirato, raffica), Guardia/Overwatch, Ricarica, Uso Oggetti/Abilità.
    *   Sistema di Copertura (es. nessuna, parziale, totale) e i suoi effetti sulla mira e sul danno.
    *   Calcolo del successo del colpo (considerando distanza, mira del personaggio, copertura del bersaglio, tipo di arma).
    *   Gestione del danno e degli effetti di stato in combattimento.
    *   Interfaccia utente basilare per il combattimento.
    *   Condizioni di vittoria/sconfitta per gli scontri.
    *   **Nota**: Inizialmente, questo modulo potrà funzionare con regole di combattimento semplificate, per poi integrare pienamente le definizioni dei Moduli 1, 2 e 3.

## 4. Struttura delle Directory di Progetto (Proposta Iniziale)

```
/ (root del progetto "Prototipo-universale-GDR")
|-- project.godot
|-- README.md
|-- documentation/
|   |-- game_design/
|   |   |-- 01_Initial_Project_Design_Confederation.md  (Questo documento)
|   |   |-- (Altri documenti di game design futuri...)
|   |-- technical_design/
|   |   |-- (Documenti sulle specifiche tecniche dei moduli...)
|   |-- narrative_design/
|   |   |-- (Lore, storia, dialoghi - per fasi future...)
|   |-- assets_prototyping/
|       |-- (Placeholder per grafiche e suoni basilari per il prototipo)
|-- modules/  (Ogni modulo avrà la sua sottocartella con scene, script, risorse specifiche)
|   |-- core_rules/
|   |-- character_system/
|   |-- item_database/
|   |-- combat_system/
|-- scenes/ (Scene Godot globali, menu principali, test di integrazione)
|   |-- main_menu.tscn
|   |-- test_integration_scene.tscn
|-- scripts/ (Script Godot globali, autoload, utility generiche)
|   |-- global.gd
|-- assets/ (Asset grafici, sonori, modelli 3D definitivi - per fasi future)
```

## 5. Prossimi Passi Immediati

1.  Creare la struttura di directory come sopra delineato all'interno della root del progetto.
2.  Salvare questo documento come `01_Initial_Project_Design_Confederation.md` nella sottocartella `documentation/game_design/`.
3.  Iniziare la stesura dettagliata del documento di design per il "Modulo 1: Regole Fondamentali del Gioco".

