function Output=Equalizer(Input,data,Fe)
Output=Input;

for i=1:length(data)
    if data(2,i)~=0
        if  data(1,i)<=300
            Output=LowShelvingFilter(Output,data(1,i),data(2,i),data(3,i),Fe);
        elseif data(1,i) <=6000
            Output=PeakFilter(Output,data(1,i),data(2,i),data(3,i),Fe);
        else
            Output=HighShelvingFilter(Output,data(1,i),data(2,i),data(3,i),Fe);
        end
    end
end
Output=Output';
end

