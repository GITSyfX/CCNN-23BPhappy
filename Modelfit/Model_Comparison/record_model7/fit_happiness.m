function [loss,decision_trial]=fit_happiness(decision_trial,params)

w1=params(1);
w2=params(2);
w3=params(3);
w4=params(4);
gamma=params(5);


for trial=1:length(decision_trial)
    
    item1=0;
    for j=1:trial
        thisCR=decision_trial(j).CR ;
        item1=item1+gamma^(trial-j) * thisCR;
    end
    
    item2=0;
    for j=1:trial
        thisEV=decision_trial(j).EV ;
        item2=item2+gamma^(trial-j) * thisEV;
    end
    
    item3=0;
    for j=1:trial
        thisRPE=decision_trial(j).RPE;
        item3=item3+gamma^(trial-j) * thisRPE;
    end

    item4=0;
    for j=1:trial
        thisDIF=decision_trial(j).DIF;
        item4=item4+gamma^(trial-j) * thisDIF;
    end

    
    
    %当前试次结束后的happiness
    decision_trial(trial).fit_happiness=w1*item1+w2*item2+w3*item3+w4*item4; 
    
end

inx=cellfun(@isempty,{decision_trial.happiness});

allfit_happiness=[decision_trial.fit_happiness];
allfit_happiness(inx)=[];

%loss=zscore([allfit_happiness])-zscore([decision_trial.happiness]);
loss=allfit_happiness-zscore([decision_trial.happiness]);






