[CmdletBinding()]
Param (
[parameter()]  
[string]
$UrlKortstokk = "http://nav-deckofcards.herokuapp.com/shuffle"
)

$ErrorActionPreference = 'Stop'





$webRequest = Invoke-WebRequest -Uri $UrlKortstokk

$kortstokk = $webRequest.Content | ConvertFrom-Json



function kortstokkTilStreng {
    [OutputType([string])]
    param (
        [object[]]
        $kortstokk
    )
    $streng = ''
    foreach ($kort in $kortstokk) {
        $streng = $streng + "$($kort.suit[0])" + $($kort.value) + ','
    }
    return $streng
}

Write-Output "Kortstokk: $(kortstokkTilStreng -kortstokk $kortstokk)"
#OK
function sumPoengKortstokk {
    [OutputType([int])]
    param (
        [object[]]
        $kortstokk
    )
    
$poengKortstokk = 0

foreach ($kort in $kortstokk) {
    $poengKortstokk += switch ($kort.value) {
        'J' { 10 }
        'Q' { 10 }
        'K' { 10 }
        'A' { 11 }
        default { $kort.value }
    }
}
return $poengKortstokk
}
Write-Output "Poengsum: $(sumPoengKortstokk -kortstokk $kortstokk)"
#OK
$meg = $kortstokk[0..1]
$kortstokk = $kortstokk[2..$kortstokk.Count]
$magnus = $kortstokk[0..1]
$kortstokk = $kortstokk[2..$kortstokk.Count]

Write-Output "Meg: $(kortstokkTilStreng -kortstokk $meg)"
Write-Output "Magnus: $(kortstokkTilStreng -kortstokk $magnus)"
Write-Output "Kortstokk: $(kortstokkTilStreng -kortstokk $kortstokk)"

function skrivUtResultat {
    param (
        [string]
        $vinner,
        [object[]]
        $kortStokkMagnus,
        [object[]]
        $kortStokkMeg
    )
    Write-Output "Vinner $vinner"
    Write-Output "Magnus | $(sumPoengKortstokk -kortstokk $kortStokkMagnus) | $(kortstokkTilStreng -kortstokk $kortStokkMagnus)"
    Write-Output "Meg | $(sumPoengKortstokk -kortstokk $kortStokkMeg) | $(kortstokkTilStreng -kortstokk $kortStokkMeg)"
    
}

$blackjack = 21

if (((sumPoengKortstokk -kortstokk $meg) -eq $blackjack) -and ((sumPoengKortstokk -kortstokk $magnus) -eq $blackjack)) {
    skrivUtResultat -vinner "draw" -kortStokkMagnus $magnus -kortStokkMeg $meg
    exit
}

elseif ((sumPoengKortstokk -kortstokk $meg) -eq $blackjack) {
    skrivUtResultat -vinner "meg" -kortStokkMagnus $magnus -kortStokkMeg $meg
    exit
}
elseif ((sumPoengKortstokk -kortstokk $magnus) -eq $blackjack) {
    skrivUtResultat -vinner "magnus" -kortStokkMagnus $magnus -kortStokkMeg $meg
    exit
}
