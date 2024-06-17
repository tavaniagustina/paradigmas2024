module Library where
import PdePreludat
import Data.Char (isUpper)

-- 1)

data Plomero = Plomero{
    nombre :: String,
    herramientas :: [Herramienta],
    reparaciones :: [Reparacion],
    dinero :: Number
}

data Herramienta = Herramienta{
    denominacion :: String,
    material :: String,
    precio :: Number
}deriving (Show, Eq)

mario :: Plomero
mario = Plomero "Mario" [llaveInglesa, martillo] [] 1200

llaveInglesa :: Herramienta
llaveInglesa = Herramienta "Llave Inglesa" "hierro" 200

martillo :: Herramienta
martillo = Herramienta "Martillo" "madera" 20

wario :: Plomero
wario = Plomero "Wario" (map (Herramienta "Llave Francesa" "hierro") [1..]) [] 0.5

-- llaveFrancesa :: Herramienta
-- llaveFrancesa = Herramienta "Llave Francesa" "hierro" 1

-- 2)

tieneHerramientaConDenominacion :: String -> Plomero -> Bool
tieneHerramientaConDenominacion unaDenominacion = any ((== unaDenominacion) . denominacion) . herramientas

esMalvado :: Plomero -> Bool
esMalvado = (== "Wa") . take 2 . nombre

puedeComprar :: Herramienta -> Plomero -> Bool
-- puedeComprar herramienta plomero = dinero plomero >= precio herramienta
puedeComprar herramienta = (>= precio herramienta) . dinero

-- 3

esBuena :: Herramienta -> Bool
esBuena herramienta = tieneUnBuenPrecioYMaterial herramienta || martilloDeMaderaOGoma herramienta

tieneUnBuenPrecioYMaterial :: Herramienta -> Bool
tieneUnBuenPrecioYMaterial herramienta = ((== "hierro") . material) herramienta && ((> 10000) . precio) herramienta

martilloDeMaderaOGoma :: Herramienta -> Bool
martilloDeMaderaOGoma herramienta = ((== "martillo") . denominacion) herramienta && ( ((== "madera") . material) herramienta || ((== "goma") . material) herramienta)

-- 4)

comprarHerramienta :: Herramienta -> Plomero -> Plomero
comprarHerramienta herramienta plomero
    | puedeComprar herramienta plomero = modificarHerramientas (herramienta :) . modificarDinero (- precio herramienta) $ plomero
    | otherwise                        = plomero

modificarHerramientas :: ([Herramienta] -> [Herramienta]) -> Plomero -> Plomero
modificarHerramientas funcion plomero = plomero {herramientas = funcion (herramientas plomero)}

modificarDinero :: Number -> Plomero -> Plomero
modificarDinero valor plomero = plomero {dinero = dinero plomero + valor}

-- 5)

data Reparacion = Reparacion{
    descripcion :: String,
    requerimiento :: Plomero -> Bool
}

filtracionDeAgua :: Reparacion
filtracionDeAgua = Reparacion "Filtracion de agua" (tieneHerramientaConDenominacion "llaveInglesa")

esDificil :: Reparacion -> Bool
esDificil reparacion = ((> 100) . length . descripcion) reparacion && esUnGrito (descripcion reparacion)

esUnGrito :: String -> Bool
esUnGrito = all isUpper

presupuesto :: Reparacion -> Number
presupuesto = (* 3) . length . descripcion

-- 6)

hacerReparacion :: Reparacion -> Plomero -> Plomero
hacerReparacion reparacion plomero
    | puedeHacerReparacion reparacion plomero = modificarHerramientasSegun reparacion . modificarDinero (presupuesto reparacion) $ plomero {reparaciones = reparaciones plomero ++ [reparacion]}
    | otherwise                               = modificarDinero 100 plomero

puedeHacerReparacion :: Reparacion -> Plomero -> Bool
puedeHacerReparacion reparacion plomero = requerimiento reparacion plomero || tieneHerramientaConDenominacion "martillo" plomero && esMalvado plomero

modificarHerramientasSegun :: Reparacion -> Plomero -> Plomero
modificarHerramientasSegun reparacion plomero
    | esMalvado plomero    = modificarHerramientas (Herramienta "Destornillador" "plastico" 0 :) plomero
    | esDificil reparacion = modificarHerramientas (filter esBuena) plomero
    | otherwise            = modificarHerramientas (drop 1) plomero

-- 7)

type JornadaDeTrabajo = [Reparacion]

diaDeTrabajo :: JornadaDeTrabajo -> Plomero -> Plomero
diaDeTrabajo jornadaDeTrabajo plomero = foldl (flip hacerReparacion) plomero jornadaDeTrabajo

-- 8)

empleadoMasReparador :: JornadaDeTrabajo -> [Plomero] -> Plomero
empleadoMasReparador = empleadoMas (length . reparaciones) 

empleadoMasAdinerado :: JornadaDeTrabajo -> [Plomero] -> Plomero
empleadoMasAdinerado = empleadoMas dinero

empleadoMasInvertidor :: JornadaDeTrabajo -> [Plomero] -> Plomero
empleadoMasInvertidor = empleadoMas (sum . map precio . herramientas)

empleadoMas :: Ord b => (Plomero -> b) -> JornadaDeTrabajo -> [Plomero] -> Plomero
empleadoMas criterio unaJornada = maximumBy (criterio . diaDeTrabajo unaJornada)

maximumBy :: Ord b => (a -> b) -> [a] -> a
maximumBy funcion = foldl1 (maxBy funcion)

maxBy :: Ord b => (a -> b) -> a -> a -> a
maxBy f x y
    | f x > f y  = x
    | otherwise  = y

-- empleadoMas :: Ord b => (Plomero -> b) -> JornadaDeTrabajo -> [Plomero] -> Plomero
-- empleadoMas criterio jornadaDeTrabajo = foldr1 (maxSegun criterio jornadaDeTrabajo) 

-- maxSegun :: Ord b => (Plomero -> b) -> JornadaDeTrabajo -> Plomero -> Plomero -> Plomero
-- maxSegun criterio jornadaDeTrabajo p1 p2
--     | criterio (diaDeTrabajo jornadaDeTrabajo p1) >= criterio (diaDeTrabajo jornadaDeTrabajo p2) = p1
--     | otherwise = p2
