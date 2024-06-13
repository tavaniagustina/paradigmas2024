module Library where
import PdePreludat

data Animal = Animal{
  nombre :: String,
  tipoDeAnimal :: String,
  peso :: Number,
  edad :: Number,
  estaEnfermo :: Bool,
  visitasMedicas :: [VisitaMedica]
} deriving (Show)

data VisitaMedica = VisitaMedica{
  diasDeRecuperacion :: Number,
  costoDeAtencion :: Number
} deriving (Show)

-- 1)

laPasoMal :: Animal -> Bool
laPasoMal = any ((> 30) . diasDeRecuperacion) . visitasMedicas -- any func de orden sup 

nombreFalopa :: Animal -> Bool
nombreFalopa = (== 'i') . last . nombre

-- 2)

type Actividad = Animal -> Animal

engorde :: Number -> Actividad
-- engorde kgBalanceado = modificarPeso (+ min (kgBalanceado/2) 5) -- si me da 12kg -> max 6 5, me quedo con el min
engorde kgBalanceado = modificarPeso (min (kgBalanceado/2) 5)

-- modificarPeso :: (Number -> Number) -> Animal -> Animal
-- modificarPeso unaFuncion unAnimal = unAnimal { peso = unaFuncion (peso unAnimal)}

modificarPeso :: Number -> Animal -> Animal
modificarPeso unNumero unAnimal = unAnimal { peso = peso unAnimal + unNumero}

revisacion :: VisitaMedica -> Actividad
revisacion visita unAnimal
  | estaEnfermo unAnimal = modificarPeso 2 unAnimal {visitasMedicas = visitasMedicas unAnimal ++ [visita]}
  | otherwise            = unAnimal

festejoCumple :: Actividad
festejoCumple animal = modificarPeso (- 1) animal {
  edad = edad animal + 1
}

chequeoDePeso :: Number -> Actividad
chequeoDePeso unPeso unAnimal = unAnimal {estaEnfermo = peso unAnimal <= unPeso}
-- chequeoDePeso unPeso unAnimal
--   | peso unAnimal > unPeso = unAnimal
--   | otherwise              = unAnimal { estaEnfermo = True}

-- Si un if retorna un bool MAL -> redundante

-- 3)

type Proceso = [Actividad]

aplicarProceso :: Proceso ->  Animal -> Animal
aplicarProceso actividades animal = foldr ($) animal actividades

-- aplicarProceso [engorde 4 . revisacion(VisitaMedica 6 600) . festejoCumple . chequeoDePeso 15] meme
-- aplicarProceso [engorde 4, revisacion(VisitaMedica 6 600), festejoCumple, chequeoDePeso 15] meme

meme :: Animal
meme = Animal "Mecha" "Perro" 15 16 False [uno]

uno :: VisitaMedica
uno = VisitaMedica 40 100

-- 4)

mejoraONoMejora :: Proceso -> Animal -> Bool
mejoraONoMejora [] _ = True 
-- mejoraONoMejora [_] _ = True  => mejoraONoMejora [engorde 2] _ => (engorde 2 : [])
mejoraONoMejora (actividad : actividades) animal = mejoraSustentablementeElPeso actividad animal && mejoraONoMejora actividades animal

mejoraSustentablementeElPeso :: Actividad -> Animal -> Bool
mejoraSustentablementeElPeso unaActividad unAnimal = (peso . unaActividad) unAnimal > peso unAnimal && (peso . unaActividad) unAnimal < ((+ 3) . peso) unAnimal

-- 5)

tresAnimalesConNombreFalopa :: [Animal] -> [Animal]
tresAnimalesConNombreFalopa = take 3 . filter nombreFalopa
 
-- Seria posible obtener un valor si se encuentran tres animales que tengan un nombre falopa, ya que haskell trabaja con 
-- lazy evaluation, en cambio si en la lista no encuentra tres valores que cumplan con lo pedido la funcion va a diverger y no va retornar ningun valor.