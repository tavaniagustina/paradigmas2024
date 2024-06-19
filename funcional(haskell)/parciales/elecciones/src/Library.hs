module Library where
import PdePreludat

-- 1)

data Persona = Persona{
    nombre :: String,
    deuda :: Number,
    felicidad :: Number,
    tieneEsperanza :: Bool,
    estrategia :: String -- Criterio de eleccion a candidato
}

type Pais = [Persona]

paradigmia :: Pais
paradigmia = [silvia, lara, manuel, victor]

silvia :: Persona
silvia = Persona "silvia" 10000 5 False "conformista"

lara :: Persona
lara = Persona "lara" 800 5 True "esperanzado"

manuel :: Persona
manuel = Persona "manuel" 60000 5 False "economico"

victor :: Persona
victor = Persona "victor" 513400 5 True "combinado"

type Criterio = Persona -> Bool

conformista :: Criterio
conformista persona = True

esperanzado :: Bool -> Criterio
esperanzado valor persona = ((|| (> 50) (felicidad persona)) . tieneEsperanza) (persona {tieneEsperanza = valor})

modificarEsperanza :: Bool -> Persona -> Persona
modificarEsperanza tieneEsperanza persona = persona {tieneEsperanza = tieneEsperanza}

economico :: Number -> Criterio
economico valor = (< valor) . deuda

modificarDeudaConValorMinimo :: Number -> Persona -> Persona
modificarDeudaConValorMinimo valor persona = persona {deuda = min valor (deuda persona)}

combinado :: Criterio
combinado persona = esperanzado True persona || economico 500 persona

-- 2)

tieneNombreConMasDeDosVocales :: Pais -> Bool
tieneNombreConMasDeDosVocales = any ((> 2) . cantidadDeVocales . nombre)

cantidadDeVocales :: String -> Number
cantidadDeVocales = length . filter isVowel

isVowel :: Char -> Bool
isVowel character = character `elem` "aeiou"

deudaTotalConValorDeDeudaPar :: Pais -> Number
deudaTotalConValorDeDeudaPar = sum . map deuda . filter (even . deuda)

-- 3)

type Candidato = Persona -> Persona

yrigoyen :: Candidato
yrigoyen persona = modificarDeuda (- (deuda persona / 2)) persona -- Disminuye deuda

modificarDeuda :: Number -> Persona -> Persona
modificarDeuda valor persona = persona {deuda = deuda persona + valor}

-- alende :: Candidato
-- alende persona = esperanzado True persona{
--     felicidad = felicidad persona + 10
-- }

-- alsogaray :: Candidato
-- alsogaray persona = esperanzado False persona . modificarDeuda 100 persona -- Aumenta deuda

-- martinezRaymonda :: Candidato
-- martinezRaymonda = yrigoyen . alende

-- 4)

-- candidatoAVotar :: Persona -> [Candidato]
-- candidatoAVotar _ [] = True -- Caso base, si la lista esta vacia o solo me dan un candidato presupongo q es True
-- candidatoAVotar persona (candidato1 : candidato2 : candidatos)
--   | (== "Conformista") . criterio . persona = candidatoAVotar persona candidatos
--   | (== "esperanzado") . criterio . persona =  esperanzado True (candidato1 . persona) < esperanzado (candidato2 . persona)

--   deuda (candidato1 . persona) <  deuda (candidato2 . persona) && candidatoAVotar persona (candidato2 : candidatos)
--   | aumenteSuFelicidad && suEsperanzaEs True 
--   | suEsperanzaEs False && 