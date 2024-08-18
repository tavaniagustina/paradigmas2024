module Library where
import PdePreludat

-- 1)

data Ladron = Ladron{
    nombreLadron :: String,
    habilidades :: [Habilidad],
    armas :: [Arma]
}

data Rehen = Rehen{
    nombreRehen :: String,
    complot :: Number,
    miedo :: Number,
    plan :: Plan 
}

type Habilidad = String

tokio :: Ladron
tokio = Ladron "Tokio" ["trabajo psicológico", "entrar en moto"] [pistola 9, ametralladora 30]

type Calibre = Number
type Arma = Rehen -> Rehen

pistola :: Calibre -> Arma
pistola calibre rehen = modificarMiedo (((* 3) . length . nombreRehen) rehen) . modificarComplot (- (5 * calibre)) $ rehen

modificarMiedo :: Number -> Rehen -> Rehen
modificarMiedo valor rehen = rehen {miedo = miedo rehen + valor}

modificarComplot :: Number -> Rehen -> Rehen
modificarComplot valor rehen = rehen {complot = complot rehen + valor}

type Balas = Number

ametralladora :: Balas -> Arma
ametralladora balas rehen = modificarMiedo balas . modificarComplot (((/ 2) . complot) rehen) $ rehen

profesor :: Ladron 
profesor = Ladron "Profesor" ["disfrazarse de linyera", "disfrazarse de payaso", "estar siempre un paso adelante"] []

pablo :: Rehen
pablo = Rehen "Pablo" 40 30 esconderse

arturito :: Rehen
arturito = Rehen "Arturo" 70 50 (esconderse . atacarCon pablo)

type Plan = Ladron -> Ladron

esconderse :: Plan
esconderse ladron = modificarArmas (drop (((/ 3) . length . habilidades) ladron)) ladron

modificarArmas :: ([Arma] -> [Arma]) -> Ladron -> Ladron
modificarArmas funcion ladron = ladron {armas = funcion (armas ladron)}

atacarCon :: Rehen -> Plan
atacarCon companiero = modificarArmas (drop (((/ 10) . length . nombreRehen) companiero))

-- 2)

esInteligente :: Ladron -> Bool
esInteligente unLadron = ((== "profesor") . nombreLadron) unLadron || ((> 2) . length . habilidades) unLadron

-- 3) 

nuevaArma :: Arma -> Ladron -> Ladron
nuevaArma arma = modificarArmas (arma :)

-- 4)

dispararAlTecho :: Rehen -> Ladron -> Rehen 
dispararAlTecho rehen = ($ rehen) . armaMasMiedosaPara rehen

armaMasMiedosaPara :: Rehen -> Ladron -> Arma
armaMasMiedosaPara rehen = maximumBy (miedo . ($ rehen)) . armas

maximumBy :: Ord b => (a -> b) -> [a] -> a
maximumBy funcion = foldl1 (maxBy funcion)

maxBy :: Ord b => (a -> b) -> a -> a -> a
maxBy f x y
    | f x > f y = x
    | otherwise = y

hacerseElMalo :: Ladron -> Rehen -> Rehen
hacerseElMalo ladron rehen 
    | es "Berlin" ladron = modificarMiedo ((sum . map length . habilidades) ladron) rehen
    | es "Rio" ladron    = modificarComplot 20 rehen
    | otherwise          = modificarMiedo 10 rehen

es :: String -> Ladron -> Bool
es nombre = (== nombre) . nombreLadron 

-- 5)

calmarLasAguas :: Ladron -> [Rehen] -> [Rehen]
calmarLasAguas ladron = filter ((> 60) . complot) . map (flip dispararAlTecho ladron)

-- 6)

puedeEscaparse :: Ladron -> Bool
puedeEscaparse = any ((== "disfrazarse de") . take (length "disfrazarse de")) . habilidades

-- 7)

pintaMal :: [Ladron] -> [Rehen] -> Bool
pintaMal ladrones rehenes = nivelDeComplotPromedio rehenes > nivelDeMiedoPromedio rehenes * cantidadTotalDeArmas ladrones

nivelDeComplotPromedio :: [Rehen] -> Number
nivelDeComplotPromedio = promedioSegun complot

nivelDeMiedoPromedio :: [Rehen] -> Number
nivelDeMiedoPromedio = promedioSegun miedo

promedioSegun :: (a -> Number) -> [a] -> Number
promedioSegun funcion lista = sum (map funcion lista) / length lista

cantidadTotalDeArmas :: [Ladron] -> Number
cantidadTotalDeArmas = sum . map (length . armas) 

-- 8)

rebelarseContra :: [Rehen] -> Ladron -> Ladron
rebelarseContra rehenes ladron = foldl rebelarse ladron . map (modificarComplot (- 10)) $ rehenes 

rebelarse :: Ladron -> Rehen -> Ladron
rebelarse ladron rehen 
    | complot rehen > miedo rehen = (plan rehen) ladron
    | otherwise                   = ladron

-- 9)

planValencia :: [Rehen] -> [Ladron] -> Number
planValencia rehenes ladrones = (* 1000000) . cantidadTotalDeArmas . map (rebelarseContra rehenes . modificarArmas (ametralladora 45 :) ) $ ladrones

-- 10)

-- ¿Se puede ejecutar el plan valencia si uno de los ladrones tiene una cantidad infinita de armas?                                 
-- No, no se puede. Diverge. 

-- 11) 

-- ¿Se puede ejecutar el plan valencia si uno de los ladrones tiene una cantidad infinita de habilidades? Justifique
-- Depende del plan del rehen. Si su plan es esconderse no se va a poder porque necesita la cantidad total de habilidades. 