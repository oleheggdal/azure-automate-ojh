$Url = "http://nav-deckofcards.herokuapp.com/shuffle"

#lese inn i PWSH - invoke web req
$response = Invoke-WebRequest -Uri $Url
#kjør scriptet og se hvilke parametere, content er en parameter
#Leser inn fra URL og konverterer kort/content til Json og lagrer i variabel cards
$cards = $response.Content | ConvertFrom-Json
#lage ny liste og legge til hver av disse i listen
$kortstokk =  @()
#Hente ut første bokstav i suit: Write-Output ($cards[0].suit)[0]
#Skrive ut alle kort med for-løkke, for-each, $card iterasjon
#legger til kort i lista/kortstokken med $kortstokk +, ellers slettes det for hver gang. + legger til elementer i listen
foreach ($card in $cards) {
    $kortstokk = $kortstokk + ($card.suit[0] + $card.value)
}
Write-Host "Kortstokk: $kortstokk"
