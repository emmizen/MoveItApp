# MoveItApp

#### Hämta och prova MoveItApp

För att hämta projektet från command line, stå på destinationen där du vill lägga projektet och kör 

    git clone https://github.com/emmizen/MoveItApp.git

Öppna appen i Xcode, kör i iOS simulator iPhone6 (Detta för att jag inte lagt tid på design...).

###### Testkonto:

email: test@google.com
 password: password

#### Caset och min lösning av MoveItApp

Jag har arbetat utifrån beskrivningen "Case MobileApplication". Jag har tittat lite extra på "Acceptanskriterier".

**Acceptanskriterier för att lösa uppgiften:**

• Prisberäkning ska ske enligt specifikationen under Affärsregler nedan 

Klassen "PriceCalculator" räknar ur priset enligt beskrivning. Klassen har även tests för att validera att resultatet blir rätt.

• Lösningen ska baseras på ändamålsenlig interaktionsdesign

Appen är fungerande, och gör det den ska. Det finns mycket att förbättra för att göra den mer användarvänlig och snyggare, men inte med given tid.

• I en förlängnings ska offertförslagen kunna sparas, för att en säljare ska kunna följa upp 

de potentiella kunderna. 

Appen är kopplad till Parse, som är min backend. Där sparas prisförslag och beställningar. Uppgifterna kan hämtas av säljare. Mer om Parse under "Backend"

• Efter att användaren fyllt i prisförslagsuppgifterna ska man kunna komma tillbaka 

prisförslaget igen i samma app. Varje kund ska bara kunna se sina egna offerter.

Autentisering sker mot Parse. Inloggad användare kan se sina sparade prisförslag och beställningar i en lista (OrdersTableViewController), och även se detaljer i en egen vy (ShowSavedViewController).

#### Autentisering

Autentisering sker mot Parse. I appen sparas email och password säkert i keychain för att automatiskt logga in och hämta data, om man inte aktivt valt att logga ut. (Flera användare kan logga in från samma device).
 "A0SimpleKeychain" används för att lätt spara i keychain.

#### Backend och lokal datamodell

###### Parse

https://www.parse.com/apps/moveit--4/collections
 
email: emma@schenkman.info  
 password: password

###### CoreData
 
Core data används för att spara data lokalt.

#### CoreLocation & MapKit

Används för att söka efter adresser och räkna ut körsträckan mellan två destinationer

#### AppDelegate

När appen startar kollar den om man är inloggad och har sparade/beställda prisförslag, i så fall startar den i listan (OrdersTableViewController). Annars startar appen i skapa nytt prisförslag (CreateQuotationViewController).

#### DataHandler

Hela appen kommunicerar med Datahandler, som i sin tur sköter står för logiken och arbetet mot Parse. 
 DataHandler sköter authentisering, skapande av object, hämtar och sparar på Parse.

#### PriceCalculator

Klassen räknar ut pris utifrån givna affärsregler

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


