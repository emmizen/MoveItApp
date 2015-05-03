# MoveItApp

#### Uppdraget  
  Att bygga en mobilapplikation för den fiktiva flyttfirman MoveIT. Du får själv välja teknik och ramverk, och ska kunna motivera dina val.  
  Bakgrund: MoveIT har utfört bohagsflytt i flera år och har på sistone insett att de förlorar många potentiella kunder på grund av att det är så svårt att få en offert. MoveIT har därför bestämt sig för att utveckla en mobilapp för prisförfrågan, där kunden direkt kan få en känsla för priset.
Appen är första steget i MoveITs långsiktiga plan att bli det självklara valet när man ska flytta. Företaget vill ha en lösning som i framtiden kan säljas som en produktifierad tjänst, och ser framför sig en arkitektur som är lätt att bygga ut. Exempel på saker som kan bli aktuella är integration mot företagets egen webbplats, mobilappar för flera plattformar eller integrationer mot andra webbplatser.  
Uppgiften består i att bygga en första version av lösningen, där kunder kan få se prisförslag direkt i telefonen och även lägga en beställning. MoveIT har därför tagit fram ett antal affärsregler för prisuträkning. Några designskisser existerar inte, däremot en konceptuell skiss för webbversionen av tjänsten.T.

#### Hämta och börja använda MoveItApp

För att hämta projektet från command line, stå på destinationen där du vill lägga projektet och kör 

    git clone https://github.com/emmizen/MoveItApp.git

Öppna appen i Xcode, kör i iOS simulator iPhone6 (Detta för att jag inte lagt tid på design...).

Skapa nytt konto, eller logga in med testkonto.

###### Testkonto:

email: test@google.com  
 password: password

#### Min lösning av MoveItApp

Jag har arbetat utifrån uppdragsbeskrivningen. Jag har tittat lite extra på "Acceptanskriterier".

**Acceptanskriterier för att lösa uppgiften:**

• Prisberäkning ska ske enligt specifikationen under Affärsregler nedan  
Klassen "PriceCalculator" räknar ur priset enligt beskrivning. Klassen har även tests för att validera att resultatet blir rätt.

• Lösningen ska baseras på ändamålsenlig interaktionsdesign  
Appen är en fungerande första version. Det finns mycket att förbättra för att göra den mer användarvänlig och snyggare.

• I en förlängnings ska offertförslagen kunna sparas, för att en säljare ska kunna följa upp de potentiella kunderna.  
Appen är kopplad till Parse, som är min backend. Där sparas prisförslag och beställningar. Uppgifterna kan hämtas av säljare. Mer om Parse under "Backend"

• Efter att användaren fyllt i prisförslagsuppgifterna ska man kunna komma tillbaka prisförslaget igen i samma app. Varje kund ska bara kunna se sina egna offerter.  
Autentisering sker mot Parse. Inloggad användare kan se sina sparade prisförslag och beställningar i en lista (OrdersTableViewController), och även se detaljer i en egen vy (ShowSavedViewController).

#### Autentisering

Autentisering sker mot Parse. I appen sparas email och password säkert i keychain för att automatiskt logga in och hämta data, om man inte aktivt valt att logga ut. (Flera användare kan logga in från samma device).
 "A0SimpleKeychain" används för att lätt spara i keychain.

#### Backend och lokal datamodell

###### Parse  
För att se sparad data i Parse:  
https://www.parse.com/apps/moveit--4/collections
 
email: emma@schenkman.info  
 password: password
 
När användaren loggar in hämtas data från parse, min backend tjänst. När användaren vill spara, eller göra en beställning sparas objekten på Parse.

###### CoreData  
Core data används för att spara data lokalt.  
I "QuotationViewController" viewDidLoad, finns en bortkommenterad rad för att logga path till lokal sql db. Logga om du vill hitta objekten i sql.

#### CoreLocation & MapKit

Används för att söka efter adresser och räkna ut körsträckan mellan två destinationer.

#### Fel och förbättringsförslag

• Errorhantering  
I en version som ska släppas till kund måste errorhanreting läggas till. Nu loggas error, men hanteras inte.

• Design och olika storlekar på telefon  
Denna version är inte fungerande på olika storlekar (rekommenderad iphone6). Design behöver beslutas och hantering av olika storlekar.

• Tests    
Tests finns endast för en klass. Det skulle vara bra att lägga till mer test.

#### AppDelegate

När appen startar kollar den om man är inloggad och har sparade/beställda prisförslag, i så fall startar den i listan (OrdersTableViewController). Annars startar appen i skapa nytt prisförslag (CreateQuotationViewController).

#### DataHandler

Hela appen kommunicerar med Datahandler, som i sin tur står för logiken och arbetet mot Parse. 
 DataHandler sköter authentisering, skapande av object, hämtar och sparar på Parse.

#### PriceCalculator

Klassen räknar ut pris utifrån givna affärsregler.

#### Tests

Tests finns på PriceCalculator för att kunna validera att uträkningen sker korrekt. Inga andra tests tillagda.

#### De olika vyerna

###### LoginViewController
 Här kan man skapa nytt konto, eller logga in med befintligt.

###### CreateQuotationViewController
 Här kan man fylla i uppgifter och skapa ett prisförslag både inloggad och inte.

###### QuotationViewController
 Här kan man se sitt prisförslag både inloggad och inte.

###### OrdersTableViewController
 Här kan man som inloggad se en lista på sparade prisförslag och beställningar.

###### ShowSavedViewController
 Här kan man som inloggad se en detaljvy på sparat prisförslag eller beställning.
