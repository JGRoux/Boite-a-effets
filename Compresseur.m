function Output=Compresseur(Input,Fe,Threshold,Ratio,Attaque,Release)
% compresseur audio qui permet le control de la dynamique
% Threshold, seuil à partir duquel se déclenche le compresseur, lorsque
% l'entrée dépasse ce seuil, le compresseur va compresseur après le temps
% d'attaque et se relachera après le temps de release

Nmax=length(Input);     % longueur de l'entrée
ch=size(Input,1);     %nb de channels => mono,stereo

Output=zeros(ch,Nmax);
for i=1:ch
    GaindB=20*log10(max(abs(Input(i,:)),1e-6)); % formule du gain
    GainBrute1=GainBrute(GaindB,Threshold,Ratio); % on recupere une premiere enveloppe du son non lisser
    GainLisser=-LissageGain(-GainBrute1,Fe,Attaque,Release); % on recupere une enveloppe lisser par le filtre pas bas d'ordre 1
    
    GainLisser=10.^(GainLisser./20); % on recupere notre gain en amplitude
    
    Output(i,:)=Input(i,:).*GainLisser; % on multiplie notre enveloppe de gain avec l'entrée
    
    % MakeUp Gain
    VmaxI=max(Input(i,:));
    VmaxO=max(Output(i,:));
    GainAuto=VmaxI/VmaxO;
    Output(i,:)=Output(i,:)*GainAuto;
end
end