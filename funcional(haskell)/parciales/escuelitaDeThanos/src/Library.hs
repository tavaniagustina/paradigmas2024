module Library where
import PdePreludat

-- 1)

data Personaje = Personaje{
    edad :: Number,
    energia :: Number,
    habilidades :: [Habilidad],
    nombre :: String,
    planetaDondeVive :: String
}

data Guantelete = Guantelete{
    material :: String,
    gemas :: [Gema]
}

type Gema = Personaje -> Personaje

type Universo = [Personaje]
type Habilidad = String

chasquidoDeUnUniverso :: Guantelete -> Universo -> Universo
chasquidoDeUnUniverso guantelete universo
  | guanteleCompleto guantelete = take (length universo / 2) universo
  | otherwise                   = universo

guanteleCompleto :: Guantelete -> Bool
guanteleCompleto guantelete = ((== 6) . length . gemas) guantelete && ((== "uru") . material) guantelete

-- 2)

aptoParaPendex :: Universo -> Bool
aptoParaPendex = any ((< 45) . edad)

energiaTotal :: Universo -> Number
energiaTotal =  sum . map energia . filter ((> 1) . length . habilidades)

-- 3)

mente :: Number -> Gema
mente = modificarEnergia

modificarEnergia :: Number -> Personaje -> Personaje
modificarEnergia valor personaje = personaje {energia = energia personaje - valor}

alma :: Habilidad -> Gema
alma habilidad personaje = modificarEnergia 10 personaje {
    habilidades = filter (/= habilidad) $ habilidades personaje
}

type Planeta = String

espacio :: Planeta -> Gema
espacio nuevoPlaneta personaje = modificarEnergia (- 20) personaje{
    planetaDondeVive =  nuevoPlaneta
}

poder :: Gema
poder personaje = modificarEnergia (energia personaje) . atacarHabilidades $ personaje

atacarHabilidades :: Personaje -> Personaje
atacarHabilidades personaje
    | (<= 2) . length . habilidades $ personaje = personaje {habilidades = []}
    | otherwise                                 = personaje

tiempo :: Gema
tiempo personaje = modificarEnergia 50 personaje{
    edad = (max 18 . (/ 2) . edad) personaje
}

gemaLoca :: Gema -> Gema
gemaLoca gema = gema . gema

-- 4)

-- 5)

utilizar :: [Gema] -> Personaje -> Personaje
utilizar gemas personaje = foldr ($) personaje gemas

-- 6)

gemaMasPoderosa :: Guantelete -> Personaje -> Gema
gemaMasPoderosa guantelete = gemaMasPoderosaDe (gemas guantelete)   

gemaMasPoderosaDe :: [Gema] -> Personaje -> Gema
gemaMasPoderosaDe [gema] _ =  gema
gemaMasPoderosaDe (gema1 : gema2 : gemas) personaje 
    | (energia . gema1) personaje < (energia . gema2) personaje = gemaMasPoderosaDe (gema1 : gemas) personaje
    | otherwise      = gemaMasPoderosaDe (gema2 : gemas) personaje

-- 7)