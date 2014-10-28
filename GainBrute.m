function Gain=GainBrute(Input,Threshold,Ratio)
% fonction qui calcule le gain logarithmique de la fonction d'entrée et des
% paramètres de seuil et de ratio
% threshold - seuil à partir duquel la compression va opérer
% ratio - niveau de compression, de combien le signal sera divisé en
% dépassant le seuil

% Gain = Threshold + ( Input - Threshold) / R

a=1/Ratio-1;
o=Input-Threshold;
b=max(o,0);

Gain=a*b;
