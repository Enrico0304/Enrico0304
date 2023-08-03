program Adressbuch;
    
    // Programm zu Adressverwaltung; erstellt im Rahmen des Fernlehrgangs "Grundlagen der Informatik" der Fernschule Weber (https://www.fernschule-weber.de/lehrgaenge/technisches-lehrinstitut/grundlagen-der-informatik/)
    // Autor: Enrico Schliwa, Herleshäuser Str.8, 99834 Gerstungen
    // erstellt mit: Charm Pascal 2.5 (https://charm-pacal.sourceforge.net/) im März 2023

    
    // *****************************************************************************  
    // Deklarationsteil
    // hier werden die Konstanten, neue Typvariablen und Variablen deklariert 
    // (also nur dem Programm "bekannt" gemacht)
    // *****************************************************************************  
    
  const
    MAX_ANZAHL_ADRESSEN = 100;        // Festlegung der maximalen Anzahl der Adressdatensätze

  type                                 // Deklaration des Records (Datensatz) für die Adressdaten sowie der Inhalte des Records
    Adresse = record
    Vorname: string[20];
    Nachname: string[20];
    Strasse: string[30];
    PLZ: string[10];
    Ort: string[30];
    end;

  var
  Adressen: array[0..MAX_ANZAHL_ADRESSEN - 1] of Adresse;       // Deklaration eines Arrays mit der maximalen Anzahl von Records des Typs Adressen
    AnzahlAdressen: integer;
  
  
  // Prozedur zur Überprüfung ob eine Datei vorhanden ist und diese zum Schreiben geöffnet werden kann  
  procedure PruefenObDateiVorhanden();      
    var
    Datei: file of Adresse;             // Deklaration der lokalen Variablen
    begin
        Assign(Datei, 'adressen.dat');  // Der Dateivariablen "Datei" wird die physische Datei "adressen.dat" zugeordnet. Es handelt sich um eine Binärdatei.
        {$I-}                           // Fehlermeldung des Compilers wird ausgeschaltet
        reset(Datei);                   // Die Datei wird zum Lesen geöffnet.
        {$I+}                           // Fehlermeldung des Compilers wird wieder eingeschaltet
        
        if IOResult <> 0 then           // Wenn es (intern) zu einer Fehlermeldung dann:
        begin
            //writeln('Die Datei existiert nicht.');
            rewrite(Datei);             // ... eine neue leere Datei des oben genannten Namens erstellen
            //writeln('Die Datei wurde erstellt');
            close(Datei);               // die neu erstellte Datei wird geschlossen
        end
    else
            //writeln('Die Datei existiert.');
        close(Datei);                   // Wenn es keine Fehlermeldung gibt (IOResult also "0" ist) wird die vorhandene Datei geschlossen
    end;
  
  // Prozedure zur Speicherung der Adressen  
  procedure AdressenSpeichern();        
    var
    Datei: file of Adresse;             // Deklaration der lokalen Variablen
        i: integer;
    begin
        Assign(Datei, 'adressen.dat');          // Definition der Variablen "Datei" mit der physischen Datei "adressen.dat"
        Rewrite(Datei);                         // o.g. Datei wird zum Schreiben geöffnet 
        for i := 0 to AnzahlAdressen - 1 do     
        begin
            Write(Datei, Adressen[i]);
        end;
        Close(Datei);                   // Datei wird geschlossen
        writeln();
        writeln('  >> Speichern abgeschlossen');
        writeln('----------------------------------------------------');
    end;
    
     // Prozedur zum Einlesen von Adressen aus einer Binärdatei in ein Array
    procedure AdressenEinlesen();          
    var
    Datei: file of Adresse;
        AdresseNeu: Adresse;
    begin
        PruefenObDateiVorhanden();          // Prüfung ob Datei vorhanden ist (sonst gäbe es eine Fehlermeldung / Abbruch)
        AnzahlAdressen := 0;
        Assign(Datei, 'adressen.dat');
        Reset(Datei);
        while not EOF(Datei) do             // mit einer Schleife wird nacheinander jeder Datensatz/Record aus der Datei in ein Array geschrieben
        begin
            Read(Datei, AdresseNeu);
            Adressen[AnzahlAdressen] := AdresseNeu;
            Inc(AnzahlAdressen);
        end;
        Close(Datei);
    end;
    
    // Prozedur zum sortieren der Records alphabetisch nach dem Nachnamen (Verfahren: Bubblesort)
    procedure AdressenSortieren();           
    var
    i, j: integer;
    Temp: Adresse;
    begin
        for i := 0 to AnzahlAdressen - 2 do     // äussere Schleife um das größte Element zu finden
        begin
            for j := i + 1 to AnzahlAdressen - 1 do     // innere Schleife alle restlichen Elemente
            begin
                if Adressen[i].Nachname > Adressen[j].Nachname then    // Vergleich der benachbarten Elemente, ggfs. Tausch 
                begin
                    Temp := Adressen[i];
                    Adressen[i] := Adressen[j];
                    Adressen[j] := Temp;
                end;
            end;
        end;
        writeln();
        writeln('  >> Sortieren abgeschlossen');
        writeln('----------------------------------------------------');
    end;

    
    // Prozedur zur Ausgabe der Adressrecords des Arrays "Adressen" mit Hilfe einer Schleife
    procedure AdressenAusgeben();       
    var
    i: integer;
    begin
        writeln('-------------------------------------------------------------------------------------------------------------------');
        writeln(' ID','Nachname' :20,'Vorname' :20,'Strasse' :30,'PLZ' :10,'Ort' :30);
        writeln('-------------------------------------------------------------------------------------------------------------------');
        for i := 0 to AnzahlAdressen - 1 do
        begin
            WriteLn;
            write('  ',i);
            Write(Adressen[i].Nachname :20);
            Write(Adressen[i].Vorname :20);
            Write(Adressen[i].Strasse :30);
            Write(Adressen[i].PLZ :10);
            Write(Adressen[i].Ort :30);
            WriteLn;
        end;
    end;

    // Prozedur zum Eingeben von Adressen
    procedure AdresseEingeben();        
    var
    AdresseNeu: Adresse;                // Deklaration einer lokalen Variable vom Typ Record 
    begin                               // Einlesen der Daten in den Record "AdresseNeu"
        Write('Vorname:      ');
        ReadLn(AdresseNeu.Vorname);
        Write('Nachname:     ');
        ReadLn(AdresseNeu.Nachname);
        Write('Straße:       ');
        ReadLn(AdresseNeu.Strasse);
        Write('PLZ:          ');
        ReadLn(AdresseNeu.PLZ);
        Write('Ort:          ');
        ReadLn(AdresseNeu.Ort);
        Adressen[AnzahlAdressen] := AdresseNeu;     // Übergabe des Records in das Array der Adressen auf dem höchsten/letzten Platz
        Inc(AnzahlAdressen);                        // Zähler der Adressen um eins erhöhen
    end;

    // Prozedur zum Durchsuchen des Adress-Arrays nach einem bestimmten / übergebenem Nachnamen
    procedure NachnameSuchen(NachName: string);   
    var
    i: integer;
    Found: boolean;
    begin
        Found := false;                         // Initialisierung der Variable auf "falsch "
        for i := 0 to AnzahlAdressen do         // in einer Schleife werden alle Datensätze / Records des Arrays nach dem betreffendem Nachnamen durchsucht
        if Adressen[i].Nachname = NachName then begin
            WriteLn;
            Write(Adressen[i].Nachname :20);        // bei einem Treffer wird der komplette Datensatz ausgegeben
            Write(Adressen[i].Vorname :20);
            Write(Adressen[i].Strasse :30);
            Write(Adressen[i].PLZ :10);
            Write(Adressen[i].Ort :30);
            WriteLn;
            Found := true;                      // Variable auf "wahr" gesetzt
    end;
        if not Found then                       // wenn nichts gefunden wurde (Found = false) wird entsprechende Info ausgegeben
        writeln('Keinen Datensatz mit dem Nachnamen ',NachName,' gefunden.');
        writeln('--------------------------------------------------------------------------------------------------------------------');
    end;
    
    
   // Prozedur zur Adressänderung 
   procedure IDAdresseAendern();
     var                         //Variablendeklaration
     x : integer;                // ganze Zahl für Position im Array
     Auswahl: char;              // erfasst die Eingabe des Nutzers (wird für case-Auswahl gebraucht)
     Aenderung: string;          // Text zum zwischenspeichern der Änderung
     begin
            writeln();
            AdressenAusgeben();     // Alle Adressen anzeigen (mit ID)
            writeln();
            write('Bitte die ID der zu ändernden Adresse angeben:  ');
            readln(x);              // gewünschter Datensatz wird eingelesen und noch einmal angezeigt
            writeln();
            Write(Adressen[x].Nachname :20);
            Write(Adressen[x].Vorname :20);
            Write(Adressen[x].Strasse :30);
            Write(Adressen[x].PLZ :10);
            Write(Adressen[x].Ort :30);
            writeln();
            // Adressen[x].Vorname := Adressen[x].Nachname;
            // Adressen[x].Vorname := 'Baerbel';
           repeat 
            writeln();
            writeln(' Bitte die Position auswählen, die Sie ändern möchten: ');
            writeln();
            writeln(' Nachnamen_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _[ 1 ]');
            writeln(' Vorname_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _[ 2 ]');
            writeln(' Strasse_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _[ 3 ]');
            writeln(' PLZ_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _[ 4 ]');
            writeln(' Ort_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _[ 5 ]');
            writeln(' Änderungen abschließen bzw. keine Änderung_ _ _ [ 0 ]');
            writeln();
            write('Ihre Auswahl: ');
            readln(Auswahl);                    // der Nutzer gibt das zu ändernde Feld an; welches dann über die case-Anweisung aufgerufen wird
            case Auswahl of 
            '1': begin
                    write('Bitte neuen Nachnamen eingeben: ');      // Nutzer wird nach neuem Text/String gefragt
                    readln(Aenderung);
                    Adressen[x].Nachname := Aenderung;              // ausgewähltes Feld des gewählten Records wird überschrieben
                    end;
            '2': begin
                    write('Bitte neuen Vornamen eingeben: ');
                    readln(Aenderung);
                    Adressen[x].Vorname := Aenderung;
                    end;
            '3': begin
                    write('Bitte neue Strasse eingeben: ');
                    readln(Aenderung);
                    Adressen[x].Strasse := Aenderung;
                    end;
             '4': begin
                    write('Bitte die neue PLZ eingeben: ');
                    readln(Aenderung);
                    Adressen[x].PLZ := Aenderung;
                    end;
             '5': begin
                    write('Bitte den neuen Ort eingeben: ');
                    readln(Aenderung);
                    Adressen[x].Ort := Aenderung;
                end; 
            end;   
            
            writeln('neue Adresse: ');
            writeln();
            Write(Adressen[x].Nachname :20);
            Write(Adressen[x].Vorname :20);
            Write(Adressen[x].Strasse :30);
            Write(Adressen[x].PLZ :10);
            Write(Adressen[x].Ort :30);
            writeln();
        until Auswahl = '0' ;
        AdressenSpeichern();        // Änderung wird automatisch in Datei gespeichert ! 
    end;   
    
    
    // *****************************************************************************  
    // Hier beginnte der Hauptteil des Programms, der Anweisungsteil
    // *****************************************************************************  
        
    var
    Auswahl: char;
    NachName: string;
    
    begin
        AdressenEinlesen();     // Aufruf der Prozedur zum Einlesen von Adressen aus einer Datei
        // Hauptmenü mit Auswahlmöglichkeiten der Aktionen
        writeln();
        writeln('----------------------------------------------------');
        writeln('|        PROGRAMM ZUR ADRESSDATENVERWALTUNG        |');
        writeln('----------------------------------------------------');
        repeat
            writeln();
            writeln('  H a u p t m e n ü');
            writeln();
            writeLn('  Adresse eingeben _ _ _ _ _ _ _ _ _ _ _ _ _ _ [ 1 ]');
            writeLn('  Adressen anzeigen_ _ _ _ _ _ _ _ _ _ _ _ _ _ [ 2 ]');
            writeln('  Adresse ändern _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ [ 3 ]');
            writeln('  Eingaben oder Änderungen speichern (!) _ _ _ [ 4 ]');
            writeLn('  Adressen nach Nachnamen sortieren  _ _ _ _ _ [ 5 ]');
            writeln('  Adressen nach Nachnamen suchen _ _ _ _ _ _ _ [ 6 ]');
            writeLn('  Beenden_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ [ 0 ]');
            writeln();
            write('Ihre Auswahl: ');
            ReadLn(Auswahl);                
            // der Nutzer kann ein Zeichen eingeben
            // je nach Eingabe wird eine der unten stehenden Prozeduren aufgerufen oder das Programm beendet
            // unzulässige Eingaben (alles andere als unten defniert) ruft das Hauptmenü wieder auf    
            case Auswahl of
                '1': AdresseEingeben();
                '2': AdressenAusgeben();
                '3': IDAdresseAendern();
                '4': AdressenSpeichern();
                '5': AdressenSortieren();
                '6':    begin
                            begin
                                write('Bitte den gesuchten Nachnamen eingeben: ');
                                readln(NachName);
                                NachnameSuchen(NachName);
                            end;
                        end;
                 
                    end;
    until Auswahl = '0';
    
    writeln();  
    writeln('* Programmende *');
    writeln('* Drücken Sie eine beliebige Taste zum Schließen dises Fensters. *');
    readln;
end.