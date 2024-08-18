module Library where
import PdePreludat
import Control.Monad.ST.Lazy.Unsafe (unsafeInterleaveST)
import GHC.Num (Num)

data Investigador = Investigador{
    nombre :: String,
    experiencia :: Number,
    companiero :: Pokemon,
    mochila :: [Item],
    pokemons :: [Pokemon]
} 

data Pokemon = Pokemon{
    nombrePokemon :: String,
    nivel :: Number,
    puntosQueOtorga :: Number,
    descripcion :: String
} 

-- 1)

akari :: Investigador
akari = Investigador "Akari" (2000 - 501) oshawott [] [oshawott]

oshawott :: Pokemon
oshawott = Pokemon "Oshawott" 5 3 "Una nutria..."

-- 2)

data Rango = Cielo | Estrella | Constelacion | Galaxia deriving (Show, Eq)

rango :: Investigador -> Rango
rango unInvestigador
  | experiencia unInvestigador < 100  = Cielo
  | experiencia unInvestigador < 500  = Estrella
  | experiencia unInvestigador < 2000 = Constelacion
  | otherwise                         = Galaxia

-- 3)

type Item = Number -> Number

type Actividad = Investigador -> Investigador

obtenerUnItem :: Item -> Actividad
obtenerUnItem unItem = modificarMochila (unItem :) . modificarExperiencia unItem

bayas :: Item
bayas = (^ 2) . (-) 1

apricorns :: Item
apricorns = (* 1.5)

guijarros :: Item
guijarros = (+ 2)

fragmentosDeHierro :: Number -> Item
fragmentosDeHierro cantidadDeFragmentos = (/ cantidadDeFragmentos)

modificarMochila :: ([Item] -> [Item]) -> Investigador -> Investigador
-- agregarItemAMochila unItem unInvestigador = unInvestigador{ mochila = mochila unInvestigador ++ [unItem]}
modificarMochila unaFuncion unInvestigador = unInvestigador{ mochila = unaFuncion (mochila unInvestigador)}

modificarExperiencia :: Item -> Investigador -> Investigador
-- modificarExperiencia unaFuncion unInvestigador = unInvestigador{ experiencia = unaFuncion (experiencia unInvestigador) }
modificarExperiencia unItem unInvestigador = unInvestigador{ experiencia = unItem (experiencia unInvestigador) }

-------------

admirarElPaisaje :: Actividad
admirarElPaisaje = modificarMochila (drop 3) . modificarExperiencia (* 0.95)

-------------

capturarPokemon :: Pokemon -> Actividad
capturarPokemon unPokemon = agregarPokemon unPokemon . modificarExperiencia (+ verificarTipoDePokemon unPokemon)

agregarPokemon :: Pokemon -> Investigador -> Investigador
agregarPokemon unPokemon unInvestigador = unInvestigador{
    pokemons = unPokemon : pokemons unInvestigador,
    companiero = mejorCompaniero unPokemon (companiero unInvestigador)
}

mejorCompaniero :: Pokemon -> Pokemon -> Pokemon
mejorCompaniero companiero nuevoCompaniero
 | puntosQueOtorga nuevoCompaniero > 20 = nuevoCompaniero
 | otherwise                            = companiero

verificarTipoDePokemon :: Pokemon -> Number
verificarTipoDePokemon unPokemon 
  | esAlfa unPokemon = puntosQueOtorga unPokemon * 2
  | otherwise        = puntosQueOtorga unPokemon

esAlfa :: Pokemon -> Bool
esAlfa unPokemon = empiezaConAlfa (nombrePokemon unPokemon) || tieneTodasLasVocales (nombrePokemon unPokemon)

empiezaConAlfa :: String -> Bool
empiezaConAlfa = (== "Alfa"). take 4

tieneTodasLasVocales :: String -> Bool
tieneTodasLasVocales unNombre = all (flip elem unNombre) "aeiou"

-------------

combatirPokemons :: Pokemon -> Actividad
combatirPokemons unPokemon unInvestigador 
  | leGana unPokemon (companiero unInvestigador) = modificarExperiencia (+ (puntosQueOtorga unPokemon * 0.5)) unInvestigador
  | otherwise                                    = unInvestigador

leGana :: Pokemon -> Pokemon -> Bool
leGana unGanador unPerdedor = nivel unGanador > nivel unPerdedor

-- 4)

type Expedicion = [Actividad]

investigadoresConMasDeTresAlfa :: [Investigador] -> Expedicion -> [String]
-- investigadoresConMasDeTresAlfa investigadores unaExpedicion = map nombre (filter ((> 3) . cantidadDePokemonesAlfa) (map (hacerExpedicion unaExpedicion) investigadores))
investigadoresConMasDeTresAlfa investigadores unaExpedicion = reporte nombre ((> 3) . cantidadDePokemonesAlfa) unaExpedicion investigadores

experienciaDeInvestigadoresGalactivos :: [Investigador] -> Expedicion -> [Number]
-- experienciaDeInvestigadoresGalactivos investigadores unaExpedicion = map experiencia (filter ((== Galaxia) . rango) (map (hacerExpedicion unaExpedicion) investigadores))
experienciaDeInvestigadoresGalactivos investigadores unaExpedicion = reporte experiencia ((== Galaxia) . rango) unaExpedicion investigadores

pokemonsConAlMenosNivel10 :: [Investigador] -> Expedicion -> [Pokemon]
-- pokemonsConAlMenosNivel10 investigadores unaExpedicion = map companiero (filter ((>= 10) . nivel . companiero) (map (hacerExpedicion unaExpedicion) investigadores))
pokemonsConAlMenosNivel10 investigadores unaExpedicion = reporte companiero ((>= 10) . nivel . companiero) unaExpedicion investigadores

pokemonsConNivelPar :: [Investigador] -> Expedicion -> [[Pokemon]]
-- pokemonsConNivelPar investigadores unaExpedicion = map pokemons (filter ((take 3) . (all (even . nivel)) . pokemons) (map (hacerExpedicion unaExpedicion) investigadores))
pokemonsConNivelPar investigadores unaExpedicion = reporte (take 3 . filter (even . nivel) . pokemons) (const True) unaExpedicion investigadores

reporte :: (Investigador -> a) -> (Investigador -> Bool) -> Expedicion -> [Investigador] -> [a]
reporte transformacion condicion expedicion = map transformacion . filter condicion . map (hacerExpedicion expedicion) 

cantidadDePokemonesAlfa :: Investigador -> Number
cantidadDePokemonesAlfa = length . filter esAlfa . pokemons

hacerExpedicion :: Expedicion -> Investigador -> Investigador
hacerExpedicion unaExpedicion unInvestigador = foldr ($) unInvestigador unaExpedicion