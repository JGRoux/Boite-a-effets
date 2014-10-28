function pass=Allpass(Input,Fe)

% allpass

Nmax=length(Input);
m=ceil(5*0.001*Fe);
g=0.7;

for n=1:Nmax
    if n-m<1
        pass(n)=0;
    else
        pass(n)=g*Input(n)+Input(n-m)-g*pass(n-m);
    end
end


