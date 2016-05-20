Introducción
------------

Esto es código para boludear con lo visto en la charla del grupo de lectura sobre cálculo lambda del 19 de Mayo de 2016.
Sepan disculpar la poca prolijidad, no usé ningun parser combinatorio de Haskell, lo hice todo a mano.

_Importante_: No chequea tipado ni nada, solamente intenta parsear la fórmula y ejecutarla.

Link al sitio: https://sites.google.com/site/labandalambda/


Como usar
---------

Primero hay que tener instalado ghc (compilador de Haskell). Para chequearlo:

    ghci --version

Despues, se puede correr

    make && ./comb

Se va a abrir un prompt en el que se pueden ingresar términos del cálculo combinatorio, y estos serán evaluados. Por ejemplo:

    > KSS
    S
    > SKKx
    Var 'x'
    > SKK
    App (App S K) K
    > S(KK)
    App S (App K K)
    > quit

Otra forma equivalente es usar ghci (yo prefiero esta porque el prompt es más amigable):

    ghci comb.hs

Y luego,

    *Main> run "KSS"
    S
    *Main> run "SKKx"
    Var 'x'
    *Main> run "SKK"
    App (App S K) K
    *Main> run "S(KK)"
    App S (App K K)






