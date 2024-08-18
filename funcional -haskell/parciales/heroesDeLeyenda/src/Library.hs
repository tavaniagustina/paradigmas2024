module Library where
import PdePreludat

-- 1)

data Heroe = Heroe{
    epiteto :: String,
    reconocimiento :: Number,
    artefactos :: [Artefacto],
    tareas :: [Tarea]
}

data Artefacto = Artefacto{
    nombre :: String,
    rareza :: Number
}

-- 2)

pasarALaHistoria :: Heroe -> Heroe
pasarALaHistoria heroe
    | ((> 1000) . reconocimiento) heroe = cambiarEpiteto "El mitico" heroe
    | ((> 500) . reconocimiento) heroe  = cambiarEpiteto "El magnifico" . modificarArtefactos (lanzaDelOlimpo :) $ heroe
    | ((> 100) . reconocimiento) heroe  = cambiarEpiteto "Hoplita" . modificarArtefactos (xiphos :) $ heroe
    | otherwise                         = heroe

cambiarEpiteto :: String -> Heroe -> Heroe
cambiarEpiteto unNombre heroe = heroe {epiteto = unNombre}

modificarArtefactos :: ([Artefacto] -> [Artefacto]) -> Heroe -> Heroe
modificarArtefactos funcion heroe = heroe {artefactos = funcion (artefactos heroe)}

lanzaDelOlimpo :: Artefacto
lanzaDelOlimpo = Artefacto "Lanza del Olimpo" 100

xiphos :: Artefacto
xiphos = Artefacto "Xiphos" 50

-- 3)

type Tarea = Heroe -> Heroe

encontrarUnArtefacto :: Artefacto -> Tarea
encontrarUnArtefacto artefacto = modificarArtefactos (artefacto :) . modificarReconocimiento (rareza artefacto)

modificarReconocimiento :: Number -> Heroe -> Heroe
modificarReconocimiento unReconocimiento heroe = heroe {reconocimiento = reconocimiento heroe + unReconocimiento}

escalarElOlimpo :: Tarea
escalarElOlimpo = modificarArtefactos (relampagoDeZeus :) . modificarArtefactos (filter ((> 1000) . rareza)) . triplicarRarezas . modificarReconocimiento 500

triplicarRarezas :: Heroe -> Heroe
triplicarRarezas = modificarArtefactos (map triplicarRareza)

triplicarRareza :: Artefacto -> Artefacto
triplicarRareza artefacto = artefacto {rareza = rareza artefacto * 3}

relampagoDeZeus :: Artefacto
relampagoDeZeus = Artefacto "Relampago de Zeus" 500

ayudarACruzarLaCalle :: Number -> Tarea
ayudarACruzarLaCalle cantidadCuadras = cambiarEpiteto ("Gros" ++ replicate cantidadCuadras 'o')

data Bestia = Bestia{
    nombreBestia :: String,
    debilidad :: Heroe -> Bool
}

matarAUnaBestia :: Bestia -> Tarea
matarAUnaBestia bestia heroe 
    | debilidad bestia heroe = cambiarEpiteto ("El asesino de la " ++ nombreBestia bestia) heroe
    | otherwise              = cambiarEpiteto "El cobarde" . modificarArtefactos (drop 1) $ heroe

-- 4)

heracles :: Heroe
heracles = Heroe "Guardián del Olimpo" 700 [Artefacto "Pistola" 10000, relampagoDeZeus] [matarAlLeonDeNemea]

-- 5)

leonDeNemea :: Bestia
leonDeNemea = Bestia "Leon de Nemea" ((>= 20) . length . epiteto)

matarAlLeonDeNemea :: Tarea
matarAlLeonDeNemea = matarAUnaBestia leonDeNemea

-- 6)

-- primero aplico la tarea al heroe y luego actualizo las tareas con la tarea recien completada
hacerTarea :: Tarea -> Heroe -> Heroe
hacerTarea tarea heroe = (tarea heroe) {tareas = tarea : tareas heroe}

-- 7)

presumir :: Heroe -> Heroe -> (Heroe, Heroe)
presumir heroe1 heroe2 
    | leGana heroe1 heroe2 = (heroe1, heroe2)
    | leGana heroe2 heroe1 = (heroe2, heroe1)
    | otherwise            = presumir (hacerTareas (tareas heroe1) heroe2) (hacerTareas (tareas heroe2) heroe1)

leGana :: Heroe -> Heroe -> Bool
leGana heroe1 heroe2 = 
    (reconocimiento heroe1 > reconocimiento heroe2) ||
    (reconocimiento heroe1 == reconocimiento heroe2 && sumatoriaDeRarezas heroe1 > sumatoriaDeRarezas heroe2)

hacerTareas :: [Tarea] -> Heroe -> Heroe
hacerTareas tareas heroe = foldr ($) heroe tareas

sumatoriaDeRarezas :: Heroe -> Number
sumatoriaDeRarezas = sum . map rareza  . artefactos

-- 8)

-- ¿Cuál es el resultado de hacer que presuman dos héroes con reconocimiento 100, ningún artefacto y ninguna tarea realizada? 

-- Loopea, nunca se va a poder obtener un valor (diverge)

-- 9)

type Labor = [Tarea]

hacerLabor :: Labor -> Heroe -> Heroe
hacerLabor = hacerTareas

-- 10)

-- Si invocamos la función anterior con una labor infinita, ¿se podrá conocer el estado final del héroe? ¿Por qué?

-- No, nunca se podra conocer, por lo que el valor diverge.