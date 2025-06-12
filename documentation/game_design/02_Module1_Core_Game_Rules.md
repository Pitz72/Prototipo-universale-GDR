# Confederation - Modulo 1: Regole Fondamentali del Gioco (Universal Core System - UCS)

## 1. Introduzione

Questo documento descrive l'Universal Core System (UCS), il set di regole fondamentali che governeranno la risoluzione delle azioni, le capacità dei personaggi e le interazioni con il mondo di gioco nel prototipo "Confederation" e, potenzialmente, in futuri progetti. L'UCS è ispirato ai classici giochi di ruolo cartacei (come Dungeons & Dragons), ma è progettato per essere flessibile, adattabile e indipendente da licenze specifiche.

L'obiettivo principale dell'UCS è supportare un gameplay dove l'ingegno, l'osservazione e l'uso strategico delle diverse capacità del personaggio sono centrali, con il combattimento come una delle tante opzioni disponibili.

## 2. Attributi Primari

I personaggi sono definiti da sei Attributi Primari. Ogni attributo rappresenta un aspetto fondamentale delle capacità innate e apprese di un individuo. Un valore tipico per un essere umano medio potrebbe essere 10, con un range che può variare significativamente.

*   **Forza (FOR)**: Potenza fisica, capacità di sollevare pesi, danno in corpo a corpo.
*   **Destrezza (DES)**: Agilità, coordinazione, mira, furtività, riflessi.
*   **Costituzione (COS)**: Resistenza fisica, salute, capacità di sopportare fatica e avversità.
*   **Intelligenza (INT)**: Capacità di ragionamento, memoria, conoscenza, abilità tecnologiche e scientifiche.
*   **Saggezza (SAG)**: Intuizione, percezione, forza di volontà, capacità di giudizio.
*   **Carisma (CAR)**: Forza della personalità, capacità di persuasione, leadership, influenza sociale.

Ogni attributo avrà un **Modificatore di Attributo** derivato dal suo valore. La formula standard utilizzata è:

`Modificatore = floor((Valore Attributo - 10) / 2.0)`

Questo significa, ad esempio:
*   Attributo 8-9: Mod -1
*   Attributo 10-11: Mod +0
*   Attributo 12-13: Mod +1
*   E così via.

Questo modificatore sarà aggiunto ai tiri di dado rilevanti.

## 3. Abilità (Skills)

Le Abilità rappresentano competenze specifiche che un personaggio può sviluppare. Ogni abilità è tipicamente associata a un Attributo Primario.

La lista di abilità concordata per il prototipo, suddivisa per Attributo Primario di riferimento, è la seguente:

*   **FOR (Forza)**
    *   `Atletica`: Movimento fisico generale, saltare, arrampicarsi, nuotare.
    *   `Mischia`: Competenza con armi bianche o da mischia improvvisate.
    *   `Intimidazione (Fisica)`: Usare la propria stazza e presenza fisica per spaventare.

*   **DES (Destrezza)**
    *   `Armi Leggere`: Competenza con pistole, fucili base e altre armi da fuoco maneggevoli.
    *   `Armi Pesanti`: Competenza con fucili d'assalto, armi di supporto e altre armi da fuoco ingombranti.
    *   `Furtività`: Muoversi non visti, nascondersi, agire silenziosamente.
    *   `Tecnologia Manuale`: Abilità nello scassinare serrature (meccaniche ed elettroniche), disattivare trappole, riparare piccoli congegni al volo, manipolare oggetti tecnologici con precisione.
    *   `Pilotaggio`: Manovrare navette, veicoli terrestri o altri mezzi di trasporto.

*   **INT (Intelligenza)**
    *   `Informatica`: Interagire con computer, programmare, bypassare sicurezza informatica (hacking), analizzare dati digitali.
    *   `Ingegneria`: Comprendere, riparare e modificare macchinari, sistemi di navi/stazioni, e dispositivi complessi.
    *   `Scienze`: Conoscenza teorica di discipline scientifiche rilevanti (fisica, biologia, chimica, astrofisica, xenobiologia, ecc.).
    *   `Indagare`: Capacità di condurre ricerche, analizzare scene del crimine, trovare indizi, collegare informazioni e dedurre conclusioni.

*   **SAG (Saggezza)**
    *   `Percezione`: Notare dettagli nascosti, individuare pericoli imminenti, leggere l'ambiente circostante.
    *   `Sopravvivenza`: Capacità di trovare riparo, cibo, acqua e orientarsi in ambienti ostili o sconosciuti.
    *   `Medicina`: Abilità nel fornire pronto soccorso, stabilizzare feriti, diagnosticare malattie o condizioni mediche basilari.
    *   `Intuizione`: Capacità di leggere le persone, comprendere le loro motivazioni, percepire inganni o verità nascoste, e avere presentimenti.

*   **CAR (Carisma)**
    *   `Persuasione`: Abilità nel convincere altri tramite diplomazia, eloquenza, logica, appello emotivo o negoziazione.
    *   `Comando`: Capacità di ispirare fiducia, guidare un gruppo, dare ordini efficaci e mantenere il morale.
    *   `Raggiro`: Abilità nel mentire credibilmente, ingannare, creare diversivi o manipolare socialmente.
    *   `Etichetta`: Conoscenza dei protocolli sociali, culturali e diplomatici di varie specie o fazioni, utile per evitare gaffe e facilitare interazioni positive.

I personaggi potranno avere dei **gradi** o livelli di competenza in ciascuna abilità, che forniranno un bonus ai tiri relativi.

## 4. Risoluzione delle Azioni (Prove di Abilità/Attributo)

Quando un personaggio tenta un'azione il cui esito è incerto, si effettua una **Prova**.

*   **Valutazione Preliminare**:
    *   **Successo Automatico**: Se l'azione è banale per un personaggio con determinate capacità (es. un ingegnere esperto che riavvia un sistema standard non danneggiato).
    *   **Fallimento Automatico**: Se l'azione è palesemente impossibile per il personaggio o nelle circostanze date (es. tentare di hackerare un supercomputer alieno senza alcuna conoscenza di informatica).
    *   **Prova Necessaria**: In tutti gli altri casi.

*   **Meccanica della Prova**:
    *   Si tira un **dado a 20 facce (d20)**.
    *   Si aggiunge il **Modificatore dell'Attributo Primario** rilevante.
    *   Si aggiunge il **Grado/Bonus dell'Abilità** rilevante (se applicabile).
    *   Si applicano eventuali **Modificatori Circostanziali** (bonus per vantaggi, malus per svantaggi, equipaggiamento, stato del personaggio).
    *   Il risultato totale viene confrontato con una **Classe Difficoltà (CD)** o **Numero Bersaglio (NB)** stabilito dal Game Master (o dal sistema di gioco).
        *   CD 5: Molto Facile
        *   CD 10: Media Difficoltà
        *   CD 15: Difficile
        *   CD 20: Molto Difficile
        *   CD 25+: Estremamente Difficile

*   **Esito della Prova**:
    *   **Successo**: Risultato del tiro ≥ CD.
    *   **Fallimento**: Risultato del tiro < CD.
    *   **(Opzionale) Successo Critico**: Un 20 naturale sul d20 può comportare un esito eccezionalmente positivo.
    *   **(Opzionale) Fallimento Critico**: Un 1 naturale sul d20 può comportare un esito particolarmente negativo o complicazioni.
    *   **(Opzionale) Gradi di Successo/Fallimento**: Superare la CD di molto (es. +5, +10) può portare a risultati migliori; fallire di poco o di molto può avere conseguenze diverse.

## 5. Tiri Salvezza

I Tiri Salvezza sono prove speciali effettuate per resistere o mitigare effetti negativi, trappole, poteri speciali o pericoli ambientali. Ogni Tiro Salvezza è associato a un Attributo Primario.

*   **Salvezza su Tempra (basato su COS)**: Per resistere a veleni, malattie, fatica estrema, effetti che minano la vitalità.
*   **Salvezza su Riflessi (basato su DES)**: Per evitare pericoli improvvisi, schivare attacchi ad area, reagire rapidamente.
*   **Salvezza su Volontà (basato su SAG o INT/CAR a seconda della natura)**: Per resistere a controllo mentale, illusioni, paura, inganni psicologici.

La meccanica è simile a una Prova di Abilità: d20 + Modificatore Attributo + eventuali bonus vs CD dell'effetto.

## 6. Stato del Personaggio

Lo stato fisico e mentale del personaggio può influenzare le sue capacità.

*   **Punti Ferita (PF)**: Rappresentano la salute e la capacità di sopportare danni. Derivano principalmente dalla Costituzione e dal livello/esperienza del personaggio. Raggiungere 0 PF di solito implica essere fuori combattimento o in condizioni critiche.
*   **Stanchezza/Fatica**: Attività prolungate, mancanza di riposo o sforzi intensi possono indurre livelli di stanchezza, che applicano malus progressivi alle prove e alle capacità.
*   **Fame/Sete**: In ambientazioni dove la sopravvivenza è un fattore, la mancanza di cibo e acqua può portare a debilitazione e malus, fino a conseguenze più gravi.

Meccaniche specifiche per la gestione di questi stati verranno dettagliate in base alle necessità dell'ambientazione.

## 7. Universalità e Adattabilità

L'UCS è concepito per essere un framework. Specifiche liste di abilità, talenti, equipaggiamento, e le CD precise saranno definite e bilanciate per ogni specifica ambientazione di gioco (come "Confederation"). L'obiettivo è avere un nucleo solido e coerente che possa essere espanso e personalizzato.

## 8. Prossimi Passi

1.  Definire la formula esatta per i Modificatori di Attributo.
2.  Stilare una lista preliminare di Abilità specifiche per l'ambientazione Sci-Fi di "Confederation".
3.  Dettagliare le meccaniche di base per la progressione del personaggio (se rilevante per i primi moduli).
4.  Considerare come implementare tecnicamente queste regole in Godot (es. script per tiri di dado, gestione degli attributi).
