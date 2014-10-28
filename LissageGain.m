function GainFinal=LissageGain(Input,Fe,Attaque,Release)
% fonction qui va lisser le gain brute en fonction des paramètres d'attaque
% et de release.
% Input est le gain brute calculé precedemment
% attaque en ms, valeur à partir duquel le compresseur va se mettre en
% marche
% release en ms, valeur à partir duquel le compresseur va arreter de
% compresser
% le compresseur marche évidemment uniquement si l'entrée dépasse le
% threshold.
% c'est un filtre passe bas du premier ordre calculer avec l'équation de
% récurrence

%conversion en sample de l'attaque et release
Attaque=Attaque/1000*Fe;
Release=Release/1000*Fe;

% calcul des poles du filtre 1er ordre : exp(-1/tau)
alphaA=exp(-1/Attaque);
alphaR=exp(-1/Release);

GainFinal=Input;
Compteur=0;

for n=1:length(Input)
    if GainFinal(n)>Compteur
        Compteur=alphaA*Compteur + (1-alphaA)*GainFinal(n);
    else
        Compteur=alphaR*Compteur + (1-alphaR)*GainFinal(n);
    end
    GainFinal(n)=Compteur;
end