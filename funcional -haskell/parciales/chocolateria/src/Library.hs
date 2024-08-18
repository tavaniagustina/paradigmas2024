module Library where
import PdePreludat

-- 1)

data Chocolate = Chocolate{
    ingredientes :: [Ingrediente],
    nombreChocolate :: String,
    gramaje :: Number, -- Yo no lo haria asi, el la funcion de precio ingresaria los gramos a comprar
    precioPremium :: Number,
    porcentajeDeAzucar :: Number,
    porcentajeDeCacao :: Number
}

data Ingrediente = Ingrediente{
    nombreIngrediente :: String,
    calorias :: Number
}

precio :: Chocolate -> Number
precio chocolate 
    | ((> 60) . porcentajeDeCacao) chocolate     = gramaje chocolate * calcularPrecioPremium chocolate
    | ((> 4) . cantidadDeIngredientes) chocolate = 8 * cantidadDeIngredientes chocolate
    | otherwise                                  = 1.5 * gramaje chocolate 

cantidadDeIngredientes :: Chocolate -> Number
cantidadDeIngredientes = length . ingredientes

calcularPrecioPremium :: Chocolate -> Number
calcularPrecioPremium chocolate 
    | ((== 0) . porcentajeDeAzucar) chocolate = 8 * gramaje chocolate 
    | otherwise                               = 5 * gramaje chocolate

-- 2)

esBombonAsesino :: Chocolate -> Bool
esBombonAsesino = any ((> 200) . calorias) . ingredientes

totalCalorias :: Chocolate -> Number
totalCalorias = sum . map calorias . ingredientes

type Caja = [Chocolate]

aptoParaNinios :: Caja -> Caja
aptoParaNinios = take 3 . filter (not . esBombonAsesino)

-- 3)

type Proceso = Chocolate -> Chocolate

frutalizado :: Ingrediente -> Proceso
frutalizado = agregarIngrediente 

agregarIngrediente :: Ingrediente -> Proceso
agregarIngrediente ingrediente chocolate = chocolate {ingredientes = ingredientes chocolate ++ [ingrediente]}

dulceDeLeche :: Proceso
dulceDeLeche chocolate = agregarIngrediente (Ingrediente "Dulce de leche" 220) chocolate {nombreChocolate = nombreChocolate chocolate ++ "tentacion"}

celiaCrucera :: Number -> Proceso
celiaCrucera porcAzucar chocolate = chocolate {porcentajeDeAzucar = porcentajeDeAzucar chocolate + porcAzucar}

embriagadora :: Number -> Proceso
embriagadora grado = celiaCrucera 20 . agregarIngrediente (Ingrediente "Licor" (min 30 grado))

-- 4)

type Receta = [Proceso]

recetaPunto4 :: Receta
recetaPunto4 = [frutalizado (Ingrediente "naranja" 10), dulceDeLeche, embriagadora 32]

-- 5)

prepararChocolate :: Chocolate -> Receta -> Chocolate
prepararChocolate = foldr ($)

-- 6)

data Persona = Persona{
    limiteDeCalorias :: Number,
    noLeGusta :: Ingrediente -> Bool
}

hastaAcaLlegue :: Persona -> Caja -> Caja
hastaAcaLlegue _ [] = []
hastaAcaLlegue persona (chocolate : chocolates) 
    | (any (noLeGusta persona) . ingredientes) chocolate = hastaAcaLlegue persona chocolates
    | ((<= 0) . limiteDeCalorias) persona                = [] -- verifica si una persona alcanzo o excedio su límite de calorías
    | otherwise                                          = chocolate : hastaAcaLlegue (come persona chocolate) chocolates

come :: Persona -> Chocolate -> Persona
come persona chocolate = persona {limiteDeCalorias = limiteDeCalorias persona - totalCalorias chocolate}

-- Punto 7
-- aptosParaNinios puede terminar porque toma los 3 primeros bombones, mientras cumpla está todo bien
-- totalCalorias' no converge porque queremos obtener la sumatoria de la lista infinita