herramientasRequeridas(ordenarCuarto, [aspiradora(100), trapeador, plumero]).
herramientasRequeridas(limpiarTecho, [escoba, pala]).
herramientasRequeridas(cortarPasto, [bordedadora]).
herramientasRequeridas(limpiarBanio, [sopapa, trapeador]).
herramientasRequeridas(encerarPisos, [lustradpesora, cera, aspiradora(300)]).

% 6)
herramientasRequeridas(limpiarCuarto, [trapeador, plumero, [aspiradora(100), escoba]]).

% 1)

tiene(egon, aspiradora(200)).
tiene(egon, trapeador).
tiene(egon, escoba).
tiene(egon, pala).
tiene(peter, trapeador).
tiene(winston, varitaDeNeutrones).

% Ray y Winston no tienen un trapeador, por principio de universo cerrado todo lo que no se encuentra en la base de conocimiento es considerado falso. 
% Nadie tiene una bordeadora, idem anterior.

% 2)

satisfaceNecesidad(Persona, Herramienta) :-
    tiene(Persona, Herramienta).

satisfaceNecesidad(Persona, aspiradora(PotenciaRequerida)) :-  
    tiene(Persona, aspiradora(Potencia)),
    between(0, Potencia, PotenciaRequerida). % Inversible
	% Potencia >= PotenciaRequerida. -- No inversible hacia PotenciaRequerida

% 6)
satisfaceNecesidad(Persona, ListaReemplazable) :-  
    member(Herramienta, ListaReemplazable),
    satisfaceNecesidad(Persona, Herramienta).

% Para el punto 6 agregamos una definición de satisfaceNecesidad que contemplara la posibilidad de listas de herramientas remplazables
% aprovechando el predicado para hacer uso de polimorfismo, y evitando tener que modificar el resto de la solución ya planteada para
% contemplar este nuevo caso. Mayor explicación al final.

% 3)

puedeHacerTarea(Persona, Tarea) :-
    tarea(Tarea),
    tiene(Persona, varitaDeNeutrones).

puedeHacerTarea(Persona, Tarea) :-
    persona(Persona),
    % tarea(Tarea), En la solucion no hace esto. Es redundante ya que en requiereHerramienta uso herramientasRequeridas que busca en la base de conocimiento.
    requiereHerramienta(Tarea, _),
    forall(requiereHerramienta(Tarea, Herramienta), satisfaceNecesidad(Persona, Herramienta)).
    
requiereHerramienta(Tarea, Herramienta) :-
    herramientasRequeridas(Tarea, ListaDeHerramientas),
    member(Herramienta, ListaDeHerramientas).

persona(Persona) :-
    distinct(Persona, tiene(Persona, _)).

tarea(Tarea) :-
    distinct(Tarea, herramientasRequeridas(Tarea, _)).

% 4)

% tareaPedida(Tarea, Cliente, metrosCuadrados).
tareaPedida(ordenarCuarto, dana, 20).
tareaPedida(cortarPasto, walter, 50).
tareaPedida(limpiarTecho, walter, 70).
tareaPedida(limpiarBanio, louis, 15).

% precio(Tarea, precioPorMetroCuadrado).
precio(ordenarCuarto, 13).
precio(limpiarTecho, 20).
precio(limpiarBanio, 55).
precio(cortarPasto, 10).
precio(encerarPisos, 7).

precioACobrar(Cliente, PrecioTotal) :-
    cliente(Cliente),
    findall(Precio, precioTarea(Cliente, _, Precio), Precios),
    sum_list(Precios, PrecioTotal).
    
precioTarea(Cliente, Tarea, Precio) :-
    % cliente(Cliente), No es necesario segun resolucion
    tareaPedida(Tarea, Cliente, MetrosCuadrados),
    precio(Tarea, PrecioPorMetroCuadrado), 
    Precio is MetrosCuadrados * PrecioPorMetroCuadrado.

% 5)

aceptaPedido(Cliente, Persona) :-
    puedeHacerTodasLasTareas(Cliente, Persona),
    aceptaTarea(Cliente, Persona).

puedeHacerTodasLasTareas(Cliente, Persona) :-
    cliente(Cliente),
    persona(Persona),
    forall(tareaPedida(Tarea, Cliente, _), puedeHacerTarea(Persona, Tarea)).

aceptaTarea(Cliente, ray) :-
    % cliente(Cliente), No es necesario segun resolucion
    not(tareaPedida(limpiarTecho, Cliente, _)).

aceptaTarea(Cliente, winston) :-
    % cliente(Cliente), No es necesario segun resolucion
    precioACobrar(Cliente, PrecioTotal),
    PrecioTotal >= 500.

aceptaTarea(Cliente, egon) :-
    % cliente(Cliente), No es necesario segun resolucion
    not((tareaPedida(Tarea, Cliente, _), tareaCompleja(Tarea))). % Tener cuidado con esto!!!!!

% aceptaTarea(egon, Cliente):-
%     forall(tareaPedida(Cliente, Tarea, _), not(tareaCompleja(Tarea))).

% Ambas propuestas para estaDispuestoAHacer son válidas. Decir "para todas las tareas que pidio un cliente, ninguna es compleja"
% equivale a decir "no existe una tarea que haya pedido un cliente y que sea compleja".

aceptaTarea(_, peter).

tareaCompleja(Tarea) :-
    % tarea(Tarea), No es necesario segun resolucion
    herramientasRequeridas(Tarea, Herramientas),
    length(Herramientas, Cantidad),
    Cantidad > 2.    

tareaCompleja(limpiarTecho).

cliente(Cliente) :-
    tareaPedida(_, Cliente, _).

% 6)

% Por qué para este punto no bastaba sólo con agregar un nuevo hecho?
% Con nuestra definición de puedeHacerTarea verificabamos con un 
% forall que una persona posea todas las herramientas que requería
% una tarea; pero sólo ligabamos la tarea. Entonces Prolog hubiera
% matcheado con ambos hechos que encontraba, y nos hubiera devuelto
% las herramientas requeridas presentes en ambos hechos.

% Una posible solución era, dentro de puedeHacerTarea, también ligar
% las herramientasRequeridas antes del forall, y así asegurarnos que
% el predicado matcheara con una única tarea a la vez.

% Cual es la desventaja de esto? Para cada nueva herramienta remplazable
% deberíamos contemplar todos los nuevos hechos a generar para que 
% esta solución siga funcionando como queremos.
% Se puede hacer? En este caso sí, pero con el tiempo se volvería costosa.

% La alternativa que planteamos en esta solución es agrupar en una lista
% las herramientas remplazables, y agregar una nueva definición a 
% satisfaceNecesidad, que era el predicado que usabamos para tratar
% directamente con las herramientas, que trate polimorficamente tanto
% a nuestros hechos sin herramientas remplazables, como a aquellos que 
% sí las tienen. También se podría haber planteado con un functor en vez
% de lista.

% Cual es la ventaja? Cada vez que aparezca una nueva herramienta
% remplazable, bastará sólo con agregarla a la lista de herramientas
% remplazables, y no deberá modificarse el resto de la solución.

% Notas importantes:

% I) Este enunciado pedía que todos los predicados fueran inversibles
% Recordemos que un predicado es inversible cuando 
% no necesitás pasar el parámetro resuelto (un individuo concreto), 
% sino que podés pasar una incógnita (variable sin unificar).
% Así podemos hacer tanto consultas individuales como existenciales.

% II) No siempre es conveniente trabajar con listas, no abusar de su uso.
% 	En general las listas son útiles sólo para contar o sumar muchas cosas
% 	que están juntas.

% III) Para usar findall es importante saber que está compuesto por 3 cosas:
% 		1. Qué quiero encontrar
% 		2. Qué predicado voy a usar para encontrarlo
% 		3. Donde voy a poner lo que encontré

% IV) Todo lo que se hace con forall podría también hacerse usando not.