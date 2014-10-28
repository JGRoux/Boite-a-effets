function Output=CombFilter(Input,ChoixUser,Fe,Tr)

Nmax=length(Input);     % longueur de l'entrée
ch=size(Input,1);    %nb de channels => mono,stereo

% delay en ms

if ChoixUser==1
    m=[50.4 56.2 61.5 68.2 72.35 78.6]; % mieux pour bath
elseif ChoixUser==2
    m=[30.3 33.1 35.4 37.7 41.2 44.5]; % mieux pour hall/cathe
elseif ChoixUser==3
    m=[30.3 33.1 35.4 37.7 41.2 44.5]; % mieux pour hall/cathe
end
%m=[20.3 23.1 25.4 26.4 27.82 29.15];
m=ceil(m*Fe/1000);  % conversion en sample

g = 10.^(-3.*m./(Tr*Fe));

pred=ceil(20/1000*Fe);

Output=zeros(ch,Nmax);
NewInput=zeros(1,Nmax);
y=zeros(1,Nmax);
for j=1:ch
    for i=1:Nmax
        if i-pred<1
            NewInput(i)=0;
        else
            NewInput(i)=Input(j,i-pred);
        end
    end
    
    for i=1:6
        for n=1:Nmax
            if n-m(i)<1
                y(n)=0;
            else
                y(n)=NewInput(n)-g(i).*y(n-m(i));
            end
        end
        Output(j,:)=Output(j,:)+y;
    end
    
    [b,a]=butter(2,2*1500/Fe,'low');
    Output(j,:)=filter(b,a,Output(j,:));
    
    Output(j,:)=Output(j,:)./(max(abs(Output(j,:))));
    Output(j,:)=Output(j,:)*0.98;
    Output(j,:)=Allpass(Output(j,:),Fe);
end