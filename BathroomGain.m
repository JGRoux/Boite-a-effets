function g=BathroomGain(Tr,d,m)

t=d/340; %temps correspondant à la distance de l'utilisateur avec l'endroit où est joué le son.

for i=1:20

    y(i)=10.^(-3*m(i)*t*5.7/Tr); %formule pour recuperer les différents gains.
	
end

g=y;