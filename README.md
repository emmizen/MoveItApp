# MoveItApp

#### Hämta och prova MoveItApp

För att hämta projektet från command line, stå på destinationen där du vill lägga projektet och kör 
git clone https://github.com/emmizen/MoveItApp.git

Öppna appen i Xcode, kör i iOS simulator iPhone6 (Detta för att jag inte lagt så mycket tid på design...).

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

    Appen är kopplad till Parse, som är min backend. Där sparas prisförslag och beställningar. Uppgifterna kan kommas åt av säljare. Mer om Parse under "Backend"

• Efter att användaren fyllt i prisförslagsuppgifterna ska man kunna komma tillbaka 

prisförslaget igen i samma app. Varje kund ska bara kunna se sina egna offerter.

    Autentisering sker mor Parse. (Mer om Parse under "Backend") Inloggad användare kan se sina sparade prisförslag och beställningar i en lista (OrdersTableViewController), och även se detaljer i en egen vy (ShowSavedViewController).

#### Backend och lokal datamodell

###### Parse

info

###### CoreData
 
info

#### Autentisering

#### CoreLocation

#### AppDelegate

När appen startar kollar den om man är inloggad och har sparade/beställda prisförslag, i så fall startar den i listan (OrdersTableViewController). Annars startar appen i skapa nytt prisförslag (CreateQuotationViewController).

#### DataHandler

#### PriceCalculator

#### Tests

#### De olika vyerna

###### LoginViewController

###### CreateQuotationViewController

###### QuotationViewController

info

###### OrdersTableViewController

###### ShowSavedViewController


