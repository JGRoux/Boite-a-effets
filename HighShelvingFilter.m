function Output=HighShelvingFilter(Input,Fc,GaindB,Q,Fe)
% Highhelving Filter
% Input est le signal entrant
% Q est le facteur qualité, il permet de regler la largeur de bande du filtre, plus Q tend vers 0, et plus la bande est large
% Fc correspond à la fréquence de coupure du filtre en Hz
% GaindB correspond au affectué au filtre, le gain > 0 pour booster les fréquences et gain < 0 pour atténuer. La valeur est en dB.

Quality=1/Q; % on prend l'invere du facteur qualité

V0=10^(GaindB/20); % conversion du gain qui était exprimé en dB

% Si GaindB < 0, on coupe
if GaindB < 0
   V0=10^(-GaindB/20);
end

K=tan((pi*Fc)/Fe); % formule du coef

if GaindB > 0   % Boost
   a0=(V0 + sqrt(V0)*Quality*K + K*K) / (1 + Quality*K + K*K);
   a1=                 (2*(K*K - V0)) / (1 + Quality*K + K*K);
   a2=(V0 - sqrt(V0)*Quality*K + K*K) / (1 + Quality*K + K*K);
   b0=1;
   b1=                   (2*(K*K - 1)) / (1 + Quality*K + K*K);
   b2=           (1 - Quality*K + K*K) / (1 + Quality*K + K*K);
end

if GaindB < 0   % Cut
   a0=            (1 + Quality*K + K*K) / (V0 + sqrt(V0)*Quality*K + K*K);
   a1=                    (2*(K*K - 1)) / (V0 + sqrt(V0)*Quality*K + K*K);
   a2=            (1 - Quality*K + K*K) / (V0 + sqrt(V0)*Quality*K + K*K);
   b0=1;
   b1=                 (2*(K*K/V0 - 1)) / (1 + Quality/sqrt(V0)*K + K*K/V0);
   b2=(1 - Quality/sqrt(V0)*K + K*K/V0) / (1 + Quality/sqrt(V0)*K + K*K/V0);
end

a=[a0 a1 a2];
b=[b0 b1 b2];

Output=filter(a,b,Input'); % on recrée l'équation de récurrence à l'aide de cette fonction.

