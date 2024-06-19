module Library where
import PdePreludat

doble :: Number -> Number
doble numero = numero + numero

data Autor = Autor {
    nombre :: String,
    obras :: [Obra]
} deriving (Show)

data Obra = Obra {
    titulo :: String,
    anioDePublicacion :: Number
} deriving (Show, Eq)

-- Punto 1

habiaUnaVezUnPato :: Obra
habiaUnaVezUnPato = Obra "Había una vez un pato." 1997

habiaUnaVezUnPato' :: Obra
habiaUnaVezUnPato' = Obra "¡Había una vez un pato!" 1996

mirthaSusanaYMoria :: Obra
mirthaSusanaYMoria = Obra "Mirtha, Susana y Moria." 2010

laSemanticaFuncionalDelAmoblamientoVertebralEsRiboficiente :: Obra
laSemanticaFuncionalDelAmoblamientoVertebralEsRiboficiente = Obra "La semántica funcional del amoblamiento vertebral es riboficiente." 2020

laSemanticaFuncionalDeMirthaSusanaYMoria :: Obra
laSemanticaFuncionalDeMirthaSusanaYMoria = Obra "La semántica funcional de Mirtha, Susana y Moria." 2022

joey :: Autor
joey = Autor "Joey" [habiaUnaVezUnPato, habiaUnaVezUnPato']

rachel :: Autor
rachel = Autor "Rachel" [mirthaSusanaYMoria, laSemanticaFuncionalDeMirthaSusanaYMoria]

ross :: Autor
ross = Autor "Ross" [laSemanticaFuncionalDelAmoblamientoVertebralEsRiboficiente]

-- Punto 2

versionCruda :: String -> String
versionCruda texto = filter letras texto

letras :: Char -> Bool
letras letra = letra >= 'a' && letra <= 'z' || letra >= 'A' && letra <= 'Z' || letra == ' '

-- Punto 3

type Plagio = Obra -> Obra -> Bool

publicacion :: Plagio
publicacion unaObra otraObra = anioDePublicacion unaObra > anioDePublicacion otraObra

copiaLiteral :: Plagio
copiaLiteral unaObra otraObra = compararTitulos versionCruda unaObra otraObra && publicacion unaObra otraObra

empiezaIgual :: Number -> Plagio
empiezaIgual cantidad unaObra otraObra = compararTitulos (take cantidad) unaObra otraObra && length (titulo unaObra) < length (titulo otraObra) && publicacion unaObra otraObra

compararTitulos :: Eq a => (String -> a) -> Obra -> Obra -> Bool
compararTitulos funcion unaObra otraObra = funcion (titulo unaObra) == funcion (titulo otraObra) && publicacion unaObra otraObra

-- 4)