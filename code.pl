%Base de conocimiento
viveEn(remy,gusteaus).
viveEn(emile, barMalabar).
viveEn(django, pizzeriaJeSuis).

cocina(linguini,ratatouille, 3).
cocina(linguini,sopa, 5).
cocina(colette,salmonAsado, 9).
cocina(horst,ensaladaRusa, 8).

trabajaEn(linguini,gusteaus).
trabajaEn(colette,gusteaus).
trabajaEn(horst,gusteaus).
trabajaEn(amelie,cafeDes2Moulins).

%Punto 1:
inspeccionSatisfactoria(Restaurant):-
    trabajaEn(_,Restaurant),
    not(viveDondeAlguienTrabaja(_,_,Restaurant)).

%Punto 2:
chef(Empleado, Restaurant):-
    trabajaEn(Empleado, Restaurant),
    cocina(Empleado,_,_).


%Punto 3:
chefcito(Rata):-
    viveDondeAlguienTrabaja(Rata, linguini,_).

viveDondeAlguienTrabaja(Rata, Persona, Restaurant):-
    viveEn(Rata, Restaurant),
    trabajaEn(Persona, Restaurant).

%Punto 4:
cocinaBien(Persona, Plato):-
    experienciaCocinando(Persona, Plato, Experiencia),
    Experiencia > 7.
cocinaBien(remy, Plato):-
    cocina(_,Plato,_).

experienciaCocinando(Persona, Plato, Experiencia):-
    cocina(Persona, Plato, Experiencia).

%Punto 5:
encargadoDe(Persona, Plato, Restaurant):-
    experienciaDeChefDe(Persona, Restaurant, Plato, Experiencia),
    forall(experienciaDeChefDe(_, Restaurant, Plato, UnaExperiencia), Experiencia >= UnaExperiencia).

experienciaDeChefDe(Chef, Restaurant,Plato, Experiencia):-
    chef(Chef,Restaurant),
    experienciaCocinando(Chef, Plato, Experiencia).

%Punto 6:
plato(ensaladaRusa, entrada([papa, zanahoria, arvejas, huevo, mayonesa])).
plato(bifeDeChorizo, principal(pure, 25)).
plato(frutillasConCrema, postre(265)).

saludable(Plato):-
    plato(Plato,Tipo),
    calorias(Tipo,Calorias),
    Calorias < 75.

calorias(entrada(Ingredientes), Calorias):-
    length(Ingredientes, Cantidad),
    Calorias is Cantidad * 15.
calorias(principal(Guarnicion, TiempoDeCoccion), Calorias):-
    calorias(Guarnicion, CaloriasGuarnicion),
    Calorias is (TiempoDeCoccion * 5) + CaloriasGuarnicion.
calorias(pure, 20).
calorias(papasFritas, 50).
calorias(postre(Calorias),Calorias).

%Punto 7:
criticaPositiva(Restaurant, Critico):-
    inspeccionSatisfactoria(Restaurant),
    esAceptableSegun(Restaurant, Critico).

esAceptableSegun(Restaurant,antonEgo):-
    especialistasEn(Restaurant, ratatouille).
esAceptableSegun(Restaurant, christophe):-
    findall(Persona, trabajaEn(Persona, Restaurant), Personas),
    length(Personas, Cantidad),
    Cantidad>3.
esAceptableSegun(Restaurant, cormillot):-
    forall(experienciaDeChefDe(_,Restaurant,Plato,_), saludable(Plato)),
    todasEntradasTienenZanahorias(Restaurant).

especialistasEn(Restaurant,Plato):-
    forall(experienciaDeChefDe(Chef,Restaurant,_,_), cocinaBien(Chef, Plato)).

todasEntradasTienenZanahorias(Restaurante) :-
    forall(entradasDe(Restaurante, Ingredientes), tieneZanahoria(Ingredientes)).

entradasDe(Restaurante, Ingredientes):-
    plato(Plato, entrada(Ingredientes)),
    experienciaDeChefDe(_, Restaurante, Plato, _).

tieneZanahoria(Ingredientes):-
    member(zanahoria, Ingredientes).