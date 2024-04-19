module Library where
import PdePreludat

data NivelesDelRio = NivelesDelRio{
    dia1 :: Number,
    dia2 :: Number,
    dia3 :: Number
} deriving (Show)

rioParana :: NivelesDelRio
rioParana = rioParana{
    dia1 = 322,
    dia2 = 283,
    dia3 = 294
} 
 
dispersion :: NivelesDelRio -> Number
dispersion nivelesRio = encontrarNumeroMayor nivelesRio - encontrarNumeroMenor nivelesRio

encontrarNumeroMayor :: NivelesDelRio -> Number
encontrarNumeroMayor (NivelesDelRio dia1 dia2 dia3) = max dia3 (max dia2 dia1) 

encontrarNumeroMenor :: NivelesDelRio -> Number
encontrarNumeroMenor (NivelesDelRio dia1 dia2 dia3) = min dia3 (min dia2 dia1)

diasParejos :: NivelesDelRio -> Bool
diasParejos nivelesDelRio = dispersion nivelesDelRio < 30

diasLocos :: NivelesDelRio -> Bool
diasLocos nivelesDelRio = dispersion nivelesDelRio > 1000

diasNormales :: NivelesDelRio -> Bool
diasNormales nivelesDelRio = not (diasParejos nivelesDelRio) && not (diasLocos nivelesDelRio)