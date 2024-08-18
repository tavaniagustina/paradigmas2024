module Library where
import PdePreludat

-- 1)

data Persona = Persona{
    nombre :: String,
    edad :: Number,
    energia :: Number, -- alegria, ansiedad y tareas
    alegria :: Number,
    ansiedad :: Number,
    tareas :: [Tarea]
} 
-- energia = yulius
-- alegria = alegronios
-- ansiedad = nerviofrinas

obtenerNivelDeEnergia :: Persona -> Persona
obtenerNivelDeEnergia persona
    | alegria persona > ansiedad persona                            = modificarEnergia (min (2 * alegria persona) 340) persona
    | ansiedad persona > alegria persona && ((< 40) . edad) persona = modificarEnergia ((300 - nivelDeEstres persona) - energia persona) persona -- Como dice que el valor es directamente 300 - el estres, le resto la energia actual que tiene
    | otherwise                                                     = modificarEnergia (alegria persona + 10) persona

modificarEnergia :: Number -> Persona -> Persona
modificarEnergia valor persona = persona {energia = energia persona + valor} 

nivelDeEstres :: Persona -> Number
nivelDeEstres persona
    | ((> 5) . length . tareas) persona = ansiedad persona * 1.5
    | otherwise                         = ansiedad persona

-- 2)

type GrupoDeAmigos = [Persona]

cuantoDueleVerLasBuenas :: GrupoDeAmigos -> Bool
cuantoDueleVerLasBuenas = all esJovenYVital

esJovenYVital :: Persona -> Bool
esJovenYVital persona = ((< 40) . edad) persona && ((> 100) . energia) persona

nivelTotalDeAnsiedad :: GrupoDeAmigos -> Number
nivelTotalDeAnsiedad = sum . map ansiedad

type Criterio = Persona -> Bool

losMasCriticados :: Criterio -> GrupoDeAmigos -> [String]
losMasCriticados criterio = take 2 . map nombre . filter criterio

losMasAnsiosos :: Criterio -> GrupoDeAmigos -> [String]
losMasAnsiosos = losMasCriticados

ansiedadMayorA50 :: Criterio
ansiedadMayorA50 = (> 50) . ansiedad

losMasEnergeticos :: Criterio -> GrupoDeAmigos -> [String]
losMasEnergeticos = losMasCriticados

nivelDeEnergiaPar :: Criterio
nivelDeEnergiaPar = even . energia

-- 3)

type Tarea = Persona -> Persona

codearUnProyectoNuevo :: Tarea
codearUnProyectoNuevo persona = modificarAnsiedad (max 0 (ansiedad persona - 10)) . modificarAnsiedad 50 . modificarAlegria 110 $ persona

modificarAnsiedad :: Number -> Persona -> Persona
modificarAnsiedad valor persona = persona {ansiedad = ansiedad persona + valor}

modificarAlegria :: Number -> Persona -> Persona
modificarAlegria valor persona = persona {alegria = alegria persona + valor}

hacerTramitesEnAfip :: Number -> Tarea
hacerTramitesEnAfip cantidadDeTramites persona = modificarAnsiedad (max 0 (ansiedad persona - 10)) . modificarAnsiedad (min 300 (ansiedad persona * cantidadDeTramites)) $ persona

andarEnBici :: Number -> Tarea 
andarEnBici kilometros persona = modificarAnsiedad (max 0 (ansiedad persona - 10)) . modificarAlegria (50 * kilometros) . modificarAnsiedad (- ansiedad persona) $ persona 

escucharMusica :: Tarea
escucharMusica persona = modificarAnsiedad (max 0 (ansiedad persona - 10)) . modificarAnsiedad (- 10) $ persona 

-- 4)

-- Entiendo que: Energia = alegria - ansiedad -> en las tareas en ningun momento modifico ni actualizo la energia

energiaResultante :: Persona -> [Tarea] -> Number
energiaResultante persona tareas = energia $ foldr ($) (energiaDespuesDeLaTarea persona) tareas
-- energiaResultante persona tareas = energia $ foldr ($) persona tareas

energiaDespuesDeLaTarea :: Persona -> Persona
energiaDespuesDeLaTarea persona = persona{
    energia = alegria persona - ansiedad persona
}

-- 5)

hiceLoQuePude :: [Tarea] -> Persona -> Persona
hiceLoQuePude [] persona = persona
hiceLoQuePude (tarea : tareas) persona
    | energia (energiaDespuesDeLaTarea (tarea persona)) > 100 = hiceLoQuePude tareas (energiaDespuesDeLaTarea (tarea persona))
    | otherwise                                               = persona

-- 6) 

-- Dada una lista de personas infinitas, ¿podemos determinar el nivelTotalDeAmsiedad o cuantoDueleVerLasBuenas?

-- nivelTotalDeAmsiedad -> Nunca podremos determinar el valor que que al pedir un valor de tipo Number nunca podra terminar de 
-- sumar los valores pedidos, por lo que el valor diverge.

-- cuantoDueleVerLasBuenas -> idem ant. La funcion pide que se retorne un valor de tipo Bool si todas las personas del grupo de amigos 
-- cumplen con una condicion, al ser una lista infinita nunca la va a terminar de recorrer por lo que diverge. 