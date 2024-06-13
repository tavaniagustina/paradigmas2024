module Library where
import PdePreludat

-- Funciones -> esta es la opcion que tenemos que usar en el parcial

type Kilos = Number
type Ingrediente = String

data Persona = Persona {
  colesterol :: Number,
  peso :: Kilos
} deriving (Show)

pesoPar :: Persona -> Bool
pesoPar persona = (even . peso) persona

jon :: Persona
jon = Persona {colesterol = 80, peso = 90}

daenerys :: Persona
daenerys = Persona {colesterol = 60, peso = 55}

-- Modelar una lista de comidas para permitir que una persona las ingiera. Cada comida es una funcion en la que 
-- entra una persona y sale la persona modificada, con distinto peso y colesterol

type Comida = Persona -> Persona

-- Queremos que la persona pueda comer distintas comidas: existen las ensaladas, las hamburguesas y las paltas, 
-- cada alimento aporta diferentes cosas a la persona que la come.

-- Ensalada de x kilos aporta la mitad de ese peso x para la persona y no agrega colesterol. 
-- Por ejemplo: una ensalada de 6 kilos le aporta 3 kg. extra de peso a una persona.

ensalada :: Number -> Comida -- Comida ya modifica la persona
-- ensalada kilos persona = persona {peso = peso persona + (kilos / 2)}
ensalada kilos persona = aumentarPeso (kilos / 2) persona

-- Cada hamburguesa tiene una cantidad de ingredientes: el colesterol aumenta un 50% para la persona y lo hace 
-- engordar en (3 * la cantidad de ingredientes) kilos

hamburguesa :: [Ingrediente] -> Comida
-- hamburguesa ingredientes persona = persona {
--     colesterol = colesterol persona * 1.5,
--     peso = peso persona + ((* 3) . length) ingredientes
-- }
hamburguesa ingredientes persona = aumentarPeso (length ingredientes * 3) (persona {colesterol = colesterol persona * 1.5})

-- La palta aumenta 2 kilos a quien la consume (el colesterol que aporta es despreciable)

palta :: Comida
-- palta persona = persona {peso = peso persona + 2}
palta persona = aumentarPeso 2 persona

-- Almuerzo

almuerzo :: [Comida]
almuerzo = [ensalada 1, hamburguesa ["Cherry", "Provoleta", "Pesto"], palta, ensalada 3] -- Aplicacion parcial

-- Persona come almuerzo

almorzar :: Persona -> [Comida] -> Persona
-- almorzar persona almuerzo = foldr ($) persona almuerzo
almorzar = foldr ($) 

-- Repetir una comida para una persona devuelve la persona afectada

repetir :: Comida -> Persona -> Persona
repetir comida = comida . comida

-- Una ensalada es sabrosa cuando pesa mas de 1 kilo
-- Una hamburguesa es sabrosa cuando contiene pesto
-- Las paltas son sabrosas

-- Una comida es disfrutada si la persona tiene peso par y la comida es sabrosa

disfrutarEnsalada :: Kilos -> Persona -> Bool
disfrutarEnsalada kilos persona = pesoPar persona && kilos > 1

disfrutarHamburguesa :: [Ingrediente] -> Persona -> Bool
disfrutarHamburguesa ingredientes persona = pesoPar persona && elem "Pesto" ingredientes

disfrutarPalta :: Persona -> Bool
disfrutarPalta _ = True

-- Se puede abstraer la modificacion del peso en una funcion para evitar la repeticion de codigo

aumentarPeso :: Number -> Persona -> Persona
aumentarPeso numero persona = persona {peso = peso persona + numero}

-- Si queremos modelar al locro, donde me importa si tiene o no panceta habria que hacer una funcion
-- locro :: Bool -> Comida

-- No se puede saber si un almuerzo contiene cierta comida porque las comidas no son Eq
-- No se puede saber si una comida es sabrosa, las funciones no se pueden comparar ni ordenar