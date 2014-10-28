function Output=EarlyReflection(Input,Fe,ChoixUser,Tr,d)

%Input est le son entrant
%GainUser est le gain final de la piste EarlyReflection
%Choixuser est le choix de l'algo utilisé : bathroom, hall ou cathedrale
%Tr est le TR60 qui correspond au temps de reverberation ( cb de temps elle dure )
%d est la distance à laquelle se trouve l'utilisateur dans la piece par rapport à l'endoit où est joué le son

%fonction qui calcul les tape delay line des early reflections suivant l'algo choisi
Nmax=length(Input);     % longueur de l'entrée
ch=size(Input,1);     %nb de channels => mono,stereo

if ChoixUser==1 % l'algo sera bathroom
    m=[0 2.3 3.5 4.6 6.2 8.1 9.6 11.9 13.5 14.3 14.9 15.9 16.4 17.7 18.6 19.7 20.1 20.8 21.5 21.9];  %on initialise les différents delays
    g=BathroomGain(Tr,d,m); % on initialise les différents gain de chaque early reflection
    
elseif ChoixUser==2 % l'algo sera cath
    m=[0 12.3 23.5 39.7 46.4 62.1 78.6 87.9 96.5 109.4 117.4 120.1 124.7 131.1 135.4 137.6 139.7 145.5 151.8 158.2];  %on initialise les différents delays
    g=CathedralGain(Tr,d,m); % on initialise les différents gain de chaque early reflection
    
elseif ChoixUser==3 % l'algo sera hall
    m=[0 9.3 16.4 23.5 28.8 39.1 43.8 52.8 57.2 63.1 65.1 67.4 74.2 78.7 79.1 80.3 82.1 84.3 90.7 92.2];
    %m=[0 4.3 21.5 22.5 26.8 27 29.8 45.8 48.5 57.2 58.7 59.5 61.2 70.7 70.8 72.6 74.1 75.3 79.7 80]; %on initialise les différents delays
    g=HallGain(Tr,d,m); % on initialise les différents gain de chaque early reflection
end

m=ceil(m*0.001*Fe); % conversion en sample

Output=zeros(ch,Nmax);
y=zeros(1,Nmax);
for j=1:ch
    for i=1:20
        for n=1:Nmax
            if n-m(i)<1
                y(n)=0;
            else
                y(n)=Input(j,n-m(i));  % le son entrant est delayed suivant la valeur des m(i) où on lui affecte un coeff de gain gi
            end
        end
        Output(j,:)=Output(j,:)+(g(i).*y);
    end
    VmaxI=max(Input(j,:));
    VmaxO=max(Output(j,:));
    RatioIntensite=VmaxI/VmaxO;  % rapport entre l'entrée et la sortie pour ajuster un peu le gain
    Output(j,:)=Output(j,:).*RatioIntensite;
end