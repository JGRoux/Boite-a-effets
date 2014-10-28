function [Input,Output,Fe,Nbit]=Main(file,choice,gain,data)

[Input,Fe,Nbit]=wavread(file);
Input=Input';

if (choice==0) %None
    Output=Input;
else
    if (choice==1) %Compression
        Output=Compresseur(Input,Fe,data(1),data(2),data(3),data(4));
    elseif(choice==2) %Reverberation
        ER=EarlyReflection(Input,Fe,data(1),data(2),data(3));
        LR=CombFilter(Input+ER,data(1),Fe,data(2));
        Output=Input+ER+LR;
        Output=LowShelvingFilter(Output,1000,3,1,Fe); % On augmente un peu les basses fréquences
        Output=HighShelvingFilter(Output,3200,-2,1,Fe); % On atténue un peu les hautes fréquences
    elseif (choice==3) %Equalizer
        Output=Equalizer(Input,data,Fe);
    end
    
    for i=1:size(Input,1)
        VmaxX=max(max(Input(i,:)));
        VmaxOutput=max(max(Output(i,:)));
        RatioIntensite=VmaxX/VmaxOutput;
        Output(i,:)=Output(i,:).*RatioIntensite*gain/100;
    end
end


