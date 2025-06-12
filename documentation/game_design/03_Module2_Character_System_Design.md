# Confederation - Modulo 2: Sistema del Personaggio

## 1. Introduzione

Questo documento descrive il design del sistema del personaggio per "Confederation". Si basa sulle regole fondamentali definite nell'Universal Core System (UCS) e dettaglia come i personaggi giocanti (PG) e non giocanti (PNG) sono strutturati, come progrediscono e come le loro capacità sono rappresentate a livello di dati.

## 2. Struttura Dati del Personaggio (CharacterSheet)

La "scheda del personaggio" (CharacterSheet) sarà la principale struttura dati per ogni entità capace di agire nel gioco. Proponiamo di implementarla come una `Resource` personalizzata in Godot per facilitarne la gestione, il salvataggio e la modifica.

### Componenti Chiave del CharacterSheet:

*   **Identificativi di Base:**
    *   `id_personaggio`: Stringa unica.
    *   `nome_personaggio`: Stringa visualizzata.
    *   `(Opzionale) specie_razza`: Stringa o Enum (es. Umano, Vulcaniano, Andoriano - da definire).
    *   `(Opzionale) background_origine`: Stringa o Enum.

*   **Attributi Primari (definiti in UCS):**
    *   `forza`: int
    *   `destrezza`: int
    *   `costituzione`: int
    *   `intelligenza`: int
    *   `saggezza`: int
    *   `carisma`: int

*   **Abilità (Skills - definite in UCS):**
    *   Una struttura dati (Dizionario Godot) per memorizzare i gradi/livelli di competenza. La chiave del dizionario sarà il path della risorsa della `SkillDefinition` (es. `"res://modules/core_rules/skills/informatica.tres"`), e il valore sarà il grado del personaggio in quell'abilità (es. `2`). Questo approccio è robusto e si integra bene con l'editor di Godot.

*   **Statistiche Derivate/Vitali:**
    *   `punti_ferita_massimi (PF_max)`: int (calcolati da COS, livello, specie, etc.)
    *   `punti_ferita_attuali (PF_att)`: int
    *   `iniziativa_base`: int (calcolata da DES, eventuali talenti)
    *   `capacita_di_carico`: float (calcolata da FOR)
    *   `velocita_movimento`: float (standard, modificata da specie, armature, effetti)
    *   `(Opzionale) punti_stanchezza_massimi`
    *   `(Opzionale) punti_stanchezza_attuali`

*   **Altre Informazioni:**
    *   `livello_personaggio`: int (se si usa un sistema a livelli)
    *   `punti_esperienza (PX)`: int
    *   `inventario`: Array o Dizionario di oggetti.
    *   `equipaggiamento_indossato`: Dizionario che mappa slot corporei a oggetti.
    *   `stati_attuali`: Array di stati (es. avvelenato, stordito, affamato).
    *   `(Opzionale) talenti_feats`: Array di risorse Talento.

## 3. Assegnazione Punti Attributo e Abilità

### Creazione del Personaggio

Per la creazione del personaggio, saranno disponibili due metodi bilanciati:

*   **Metodo Primario: Point Buy**
    *   Tutti e 6 gli attributi partono da un valore base di 8.
    *   Il giocatore ha un budget di **27 punti** da spendere.
    *   Il costo per aumentare un attributo è progressivo:
        *   Da 8 a 13: 1 punto per ogni livello di attributo.
        *   Da 14 a 15: 2 punti per ogni livello di attributo.
    *   Questo metodo offre massima personalizzazione e controllo al giocatore.

*   **Metodo Alternativo: Standard Array**
    *   Il giocatore riceve un set di valori predefiniti: **15, 14, 13, 12, 10, 8**.
    *   Questi valori possono essere assegnati liberamente ai sei attributi primari.
    *   Questo metodo è veloce, garantisce personaggi bilanciati ed è ideale per un avvio rapido.

### Progressione e Punti Abilità

*   **Punti Abilità per Livello**: Ad ogni aumento di livello, un personaggio guadagna un numero di punti abilità pari a **2 + Modificatore di Intelligenza** (con un minimo garantito di 1 punto per livello).
*   **Costo Abilità**: Aumentare un'abilità di un grado costa 1 punto abilità.
*   **Limite Grado Abilità**: Un personaggio non può avere un grado in un'abilità superiore al proprio **livello + 3**. Questo previene un'eccessiva specializzazione nelle fasi iniziali del gioco.

## 4. Calcolo Statistiche Derivate

Le seguenti formule verranno utilizzate per calcolare le statistiche derivate dei personaggi.

*   **Punti Ferita (PF)**
    *   **A Livello 1**: `PF Massimi = 10 + Valore di Costituzione` (l'intero punteggio, non il modificatore). Questo garantisce personaggi iniziali robusti.
    *   **Per ogni livello successivo**: Il personaggio guadagna `1d6 + Modificatore di Costituzione` ai PF Massimi. Questo introduce una leggera variabilità ma premia costantemente un'alta Costituzione.

*   **Iniziativa**
    *   **Formula**: `Iniziativa = Modificatore di Destrezza`. Semplice, diretto e intuitivo.

*   **Capacità di Carico**
    *   **Formula**: `Capacità di Carico (in kg) = Valore di Forza * 10`. Facile da ricordare e rende la Forza utile anche a personaggi non combattenti.

*   **Velocità di Movimento**
    *   **Formula**: `Velocità Base = 6 metri` (o 6 unità sulla griglia di gioco). Questo valore standard potrà essere modificato da specie, armature, talenti o effetti di stato.

## 5. Prossimi Passi

1.  Definire in dettaglio i metodi di assegnazione punti per attributi e abilità.
2.  Stabilire le formule esatte per tutte le statistiche derivate.
3.  Creare la risorsa `CharacterSheet.gd` in Godot.
4.  Iniziare a implementare le funzioni in `UCS.gd` che interagiscono con `CharacterSheet` (es. `get_attribute`, `get_skill_rank`).
