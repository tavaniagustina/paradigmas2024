module Library where
import PdePreludat

-- 1)

data Chofer = Chofer {
    nombreChofer :: String,
    kilometrajeAuto :: Number,
    viajes :: [Viaje],
    condicionDeViaje :: Condicion
}

data Viaje = Viaje {
    fecha :: (Number, Number, Number),
    cliente :: Cliente,
    costo :: Number
}

data Cliente = Cliente {
    nombreCliente :: String,
    dondeVive :: String
}

-- 2)

type Condicion = Viaje -> Bool

cualquierViaje :: Condicion
cualquierViaje viaje = True

viajeMayorA200 :: Condicion
viajeMayorA200 = (> 200) . costo

nombreConMasDeNLetras :: Number -> Condicion
nombreConMasDeNLetras cantLetras = (> cantLetras) . length . nombreCliente . cliente

noVivaEn :: String -> Condicion
noVivaEn zona = (/= zona) . dondeVive . cliente

-- 3)

lucas :: Cliente
lucas = Cliente "Lucas" "Victoria"

daniel :: Chofer
daniel = Chofer "Daniel" 23500 [viajeDanielLucas] (noVivaEn "Olivos")

viajeDanielLucas :: Viaje
viajeDanielLucas = Viaje (20, 04, 2017) lucas 150

alejandra :: Chofer
alejandra = Chofer "Alejandra" 180000 [] cualquierViaje

-- 4)

puedeTomarUnViaje :: Viaje -> Chofer -> Bool
puedeTomarUnViaje viaje chofer = condicionDeViaje chofer viaje

-- 5)

liquidacion :: Chofer -> Number
liquidacion = sum . map costo . viajes

-- 6)

realizarUnViaje :: Viaje -> [Chofer] -> Chofer
realizarUnViaje viaje = hacerViaje viaje . choferConMenosViajes . filter (puedeTomarUnViaje viaje)

choferConMenosViajes :: [Chofer] -> Chofer
choferConMenosViajes [chofer] = chofer
choferConMenosViajes (chofer1 : chofer2 : choferes) = choferConMenosViajes (elQueMenosViajesHizo chofer1 chofer2 : choferes)

elQueMenosViajesHizo :: Chofer -> Chofer -> Chofer
elQueMenosViajesHizo chofer1 chofer2
    | cantidadDeViajes chofer1 < cantidadDeViajes chofer2 = chofer1
    | otherwise                                           = chofer2

cantidadDeViajes :: Chofer -> Number
cantidadDeViajes = length . viajes

hacerViaje :: Viaje -> Chofer -> Chofer
hacerViaje viaje chofer = chofer {viajes = viajes chofer ++ [viaje]}

-- 7)

nito :: Chofer
nito = Chofer "Nito Infy" 70000 viajeInfinito (nombreConMasDeNLetras 3)

repetirViaje :: Viaje -> [Viaje]
repetirViaje viaje = viaje : repetirViaje viaje

viajeInfinito :: [Viaje]
viajeInfinito = repetirViaje (Viaje (11, 03, 2017) lucas 50)

-- b. ¿Puede calcular la liquidación de Nito? 
-- No, porque no termina nunca de calcularla, diverge. 

-- c. ¿Y saber si Nito puede tomar un viaje de Lucas de $ 500 el 2/5/2017? 
-- >puedeTomarUnViaje (Viaje (2, 5, 2017) lucas 500) nito
-- True

-- 8)

gongNeng :: Ord c => c -> (c -> Bool) -> (a -> c) -> [a] -> c
gongNeng arg1 arg2 arg3 = max arg1 . head . filter arg2 . map arg3
-- gongNeng arg1 arg2 arg3 arg4 = max arg1 . head . filter arg2 . map arg3 $ arg4

-- Sabemos que hay 4 parametros | -> -> -> ->
-- filter devuelve una lista, de la cual queremos el primer elemento que se va a comparar con arg1 | c -> -> -> -> c
-- arg4 seria la lista que despues se mapea | c -> -> -> [a] -> c
-- arg3 es una funcion | c -> -> (a -> c) -> [a] -> c
-- arg2 es otra funcion que entra en filter | c -> (c -> Bool) -> (a -> c) -> [a] -> c