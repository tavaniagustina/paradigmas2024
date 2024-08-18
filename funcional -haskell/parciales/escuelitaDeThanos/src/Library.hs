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

guanteleteDeGoma :: Guantelete
guanteleteDeGoma = Guantelete "Goma" [tiempo, alma "usar Mjolnir", gemaLoca (alma "propagacion en haskell")]

-- 5)

utilizar :: [Gema] -> Personaje -> Personaje
utilizar gemas personaje = foldr ($) personaje gemas

-- 6)

gemaMasPoderosa :: Guantelete -> Personaje -> Gema
gemaMasPoderosa guantelete = gemaMasPoderosaDe (gemas guantelete)   

gemaMasPoderosaDe :: [Gema] -> Personaje -> Gema
gemaMasPoderosaDe [gema] _ = gema
gemaMasPoderosaDe (gema1 : gema2 : gemas) personaje 
    | (energia . gema1) personaje < (energia . gema2) personaje = gemaMasPoderosaDe (gema1 : gemas) personaje
    | otherwise                                                 = gemaMasPoderosaDe (gema2 : gemas) personaje

-- 7)

infinitasGemas :: Gema -> [Gema]
infinitasGemas gema = gema : infinitasGemas gema

guanteleteDeLocos :: Guantelete
guanteleteDeLocos = Guantelete "vesconite" (infinitasGemas tiempo)

usoLasTresPrimerasGemas :: Guantelete -> Personaje -> Personaje
usoLasTresPrimerasGemas = utilizar . take 3. gemas

punisher :: Personaje
punisher = Personaje {
    edad = 30,
    energia = 100, 
    habilidades = ["Castiga"],
    nombre = "Frank Castle",
    planetaDondeVive = "Tierra"
}

-- gemaMasPoderosa punisher guanteleteDeLocos
-- Diverge porque va a querer mostrar la lista infinita. No hay una instancia Show para una lista infinita.

-- usoLasTresPrimerasGemas guanteleteDeLocos punisher
-- Haskell trabaja con lazy evaluation, evalua lo que necesita en el momento que lo necesita. En este caso solo 
-- le interesan 3 gemas de la lista. Cuando las obtenga, va a dejar de evaluar, por lo tanto esta funcion se 
-- puede ejecutar.

-- > usoLasTresPrimerasGemas guanteleteDeLocos punisher 
-- Personaje
--     { edad = 18
--     , energia = -50
--     , habilidades = [ "Castiga" ]
--     , nombre = "Frank Castle"
--     , planeta = "Tierra"
--     }