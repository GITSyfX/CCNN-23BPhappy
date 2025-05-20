function [loss,decision_trial]=fit_happiness(decision_trial,params)

w1=params(1);
w2=params(2);
w3=params(3);



for trial=1:length(decision_trial)
    
    item1=0;
    for j = trial
        thisCR=decision_trial(j).CR ;
        item1=thisCR;
    end
    
    item2=0;
    for j = trial
        thisEV=decision_trial(j).EV ;
        item2=thisEV;
    end
    
    item3=0;
    for j = trial
        thisRPE=decision_trial(j).RPE;
        item3=thisRPE;
    end
    
    
    %当前试次结束后的happiness
    decision_trial(trial).fit_happiness=w1*item1+w2*item2+w3*item3; 
    
end

inx=cellfun(@isempty,{decision_trial.happiness});

allfit_happiness=[decision_trial.fit_happiness];
allfit_happiness(inx)=[];

%loss=zscore([allfit_happiness])-zscore([decision_trial.happiness]);
loss=allfit_happiness-zscore([decision_trial.happiness]);






