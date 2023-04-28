function [loss,decision_trial]=fit_happiness(decision_trial,params)

w0=params(1);
w1=params(2);
w2=params(3);
gamma=params(4);


for trial=1:length(decision_trial)
    
    item1=0;
    for j=1:trial
        thisCR=decision_trial(j).CR ;
        item1=item1+gamma^(trial-j) * thisCR;
    end
   
    
    item2=0;
    for j=1:trial
        thisGR=decision_trial(j).GR;
        item2=item2+gamma^(trial-j) * thisGR;
    end
    
    
    %当前试次结束后的happiness
    decision_trial(trial).fit_happiness=w0+w1*item1+w2*item2; 
    
end

inx=cellfun(@isempty,{decision_trial.happiness});

allfit_happiness=[decision_trial.fit_happiness];
allfit_happiness(inx)=[];

loss=zscore([allfit_happiness])-zscore([decision_trial.happiness]);






