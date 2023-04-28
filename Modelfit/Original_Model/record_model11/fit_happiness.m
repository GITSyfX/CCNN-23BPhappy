function [loss,decision_trial]=fit_happiness(decision_trial,params)

w1=params(1);
w2=params(2);
w3=params(3);
lambda=params(4);
alpha=params(5);
beta=params(6);
gamma=params(7);


for trial=1:length(decision_trial)
    
    item1=0;
    for j=1:trial
        thisCR=decision_trial(j).CR ;
        if thisCR > 0
            item1=item1+gamma^(trial-j) * thisCR^alpha;
        else
            item1=item1+gamma^(trial-j) * (-lambda) * (-thisCR)^beta;
        end
    end
    
    item2=0;
    for j=1:trial
        thisEV=decision_trial(j).EV ;
        if thisEV > 0  
            item2=item2+gamma^(trial-j) * thisEV^alpha;
        else
            item2=item2+gamma^(trial-j) * (-lambda) * (-thisEV)^beta; 
        end
    end
    
    item3=0;
    for j=1:trial
        thisGR=decision_trial(j).GR;
        if thisGR > 0 && thisEV > 0 
            item3=item3+gamma^(trial-j) * (thisGR^alpha-thisEV^alpha);
        elseif thisGR > 0 && thisEV <= 0
            item3=item2+gamma^(trial-j) * (thisGR^alpha-(-lambda) * (-thisEV)^beta);
        elseif thisGR < 0 && thisEV > 0
            item3=item2+gamma^(trial-j) * ((-lambda) * (-thisGR)^beta-thisEV^alpha);
        elseif thisGR < 0 && thisEV <= 0
            item3=item2+gamma^(trial-j) * ((-lambda) * (-thisGR)^beta-(-lambda) * (-thisEV)^beta);
        end
    end
    
    
    %��ǰ�Դν������happiness
    decision_trial(trial).fit_happiness=w1*item1+w2*item2+w3*item3; 
    
end

inx=cellfun(@isempty,{decision_trial.happiness});

allfit_happiness=[decision_trial.fit_happiness];
allfit_happiness(inx)=[];

loss=zscore([allfit_happiness])-zscore([decision_trial.happiness]);






