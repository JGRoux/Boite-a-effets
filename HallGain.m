function g=HallGain(Tr,d,m)

t=d/340; %temps correspondant à la distance de l'utilisateur avec l'endroit où est joué le son.
%g=[0 1 0.841 0.504 0.491 0.379 0.380 0.346 0.289 0.272 0.192 0.193 0.217 0.181 0.180 0.181 0.176 0.142 0.167 0.134 0.125];
for i=1:20

    y(i)=10.^(-3*m(i)*t*0.41/Tr); %formule pour recuperer les différents gains.
	
end

g=y;