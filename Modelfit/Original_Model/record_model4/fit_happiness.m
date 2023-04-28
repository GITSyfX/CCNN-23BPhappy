function [loss,decision_trial]=fit_happiness(decision_trial,params)

w0=params(1);
w1=params(2);
w2=params(3);
w3=params(4);
gamma1=params(5);
gamma2=params(6);
gamma3=params(7);


for trial=1:length(decision_trial)
    
    item1=0;
    for j=1:trial
        thisCR=decision_trial(j).CR ;
        item1=item1+gamma1^(trial-j) * thisCR;
    end
    
    item2=0;
    for j=1:trial
        thisEV=decision_trial(j).EV ;
        item2=item2+gamma2^(trial-j) * thisEV;
    end
    
    item3=0;
    for j=1:trial
        thisRPE=decision_trial(j).RPE;
        item3=item3+gamma3^(trial-j) * thisRPE;
    end
    
    
    %当前试次结束后的happiness
    decision_trial(trial).fit_happiness=w0+w1*item1+w2*item2+w3*item3; 
    
end

inx=cellfun(@isempty,{decision_trial.happiness});

allfit_happiness=[decision_trial.fit_happiness];
allfit_happiness(inx)=[];

loss=allfit_happiness-[decision_trial.happiness];






