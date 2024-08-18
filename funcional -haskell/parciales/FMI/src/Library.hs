module Library where
import PdePreludat

-- 1)

data Pais = Pais{
    ingresoPerCapita :: Number, -- Es el promedio de lo que cada habitante necesita para subsistir
    poblacionActivaSectorPublico :: Number,
    poblacionActivaSectorPrivado :: Number,
    recursosNaturales :: [RecursosNaturales],
    deudaConFMI :: Number -- En millones de dolares
}deriving (Show, Eq, Ord)

type RecursosNaturales = String

namibia :: Pais
namibia = Pais 4140 400000 650000 ["mineria", "ecoturismo"] 50

-- 2)

type Estrategia = Pais -> Pais

prestarMillones :: Number -> Estrategia
prestarMillones cantidad = modificarDeuda (1.5 * cantidad)

modificarDeuda :: Number -> Estrategia
modificarDeuda cantidad pais = pais {deudaConFMI = deudaConFMI pais + cantidad}

reducirUnaCantidadDePuestos :: Number -> Estrategia
reducirUnaCantidadDePuestos puestos pais = pais{
    poblacionActivaSectorPublico = poblacionActivaSectorPublico pais - puestos,
    ingresoPerCapita = ingresoPerCapita pais * (1 - disminuirIngresoPerCapita puestos)
}

disminuirIngresoPerCapita :: Number -> Number
disminuirIngresoPerCapita puestos 
    | (> 100) puestos = 0.2
    | otherwise       = 0.15

explotar :: String -> Estrategia
explotar recurso pais = modificarDeuda (- 2) pais {recursosNaturales = quitarRecurso recurso (recursosNaturales pais)} 

quitarRecurso :: String -> [RecursosNaturales] -> [RecursosNaturales]
quitarRecurso recurso = filter (/= recurso)

blindaje :: Estrategia 
blindaje pais = reducirUnaCantidadDePuestos 500 . prestarMillones (calcularPBIPais pais * 0.5) $ pais

calcularPBIPais :: Pais -> Number
calcularPBIPais pais = (poblacionActivaSectorPrivado pais + poblacionActivaSectorPublico pais) * ingresoPerCapita pais

-- 3)

type Receta = [Estrategia]

receta :: Receta
receta = [prestarMillones 200, explotar "mineria"]

aplicarReceta :: Receta -> Pais -> Pais
aplicarReceta receta pais = foldr ($) pais receta

-- > aplicarReceta receta namibia
-- Pais
--     { ingresoPerCapita = 4140
--     , poblacionActivaEnSectorPublico = 400000
--     , poblacionActivaEnSectorPrivado = 650000
--     , recursosNaturales = [ "Ecoturismo" ]
--     , deuda = 348
--     }

-- No hay efecto colateral, simplemente retorna un nuevo pais con propiedades diferentes

-- 4)

puedenZafar :: [Pais] -> [Pais]
puedenZafar = filter (elem "petroleo" . recursosNaturales)

-- puedenZafar = filter ((== "petroleo") . recursosNaturales) 
-- Esto no funcionaría porque recursosNaturales devuelve una lista de String y == "petroleo" 
-- espera comparar un solo String con otro String, no una lista de String con un String.

deudaAFavor :: [Pais] -> Number
deudaAFavor = sum . map deudaConFMI

-- 5)

estaOrdenada :: Pais -> [Receta] -> Bool
estaOrdenada _ [receta] = True
estaOrdenada pais (receta1 : receta2 : recetas) = revisarPBI receta1 pais < revisarPBI receta2 pais && estaOrdenada pais recetas

revisarPBI :: Receta -> Pais -> Number
revisarPBI receta = calcularPBIPais . aplicarReceta receta

-- 6)

recursosNaturalesInfinitos :: [String]
recursosNaturalesInfinitos = "Energia" : recursosNaturalesInfinitos

namibia' :: Pais
namibia' = Pais 4140 400000 650000 recursosNaturalesInfinitos 50

prueba1 :: [Pais]
prueba1 = puedenZafar [namibia']

-- Diverge porque va a estar buscando petroleo y solo va a encontrar energia, entonces no va a terminar nunca

prueba2 :: Number
prueba2 = deudaAFavor [namibia']

-- Debido a que Haskell trabaja con evaluacion diferida, solo evalua lo que necesita en el momento que lo necesita. 
-- No le importa la lista infinita de recursos, solo la deuda de los paises, por lo tanto converge.