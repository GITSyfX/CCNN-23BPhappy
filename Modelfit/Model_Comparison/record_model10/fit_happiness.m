function [loss,decision_trial]=fit_happiness(decision_trial,params)

w0=params(1);
w1=params(2);
w2=params(3);
w3=params(4);
lambda=params(5);
alpha=params(6);
gamma=params(7);


for trial=1:length(decision_trial)
    
    item1=0;
    for j=1:trial
        thisCR=decision_trial(j).CR ;
        if thisCR > 0
            item1=item1+gamma^(trial-j) * thisCR^alpha;
        else
            item1=item1+gamma^(trial-j) * (-lambda) * (-thisCR)^alpha;
        end
    end
    
    item2=0;
    for j=1:trial
        thisEV=decision_trial(j).EV ;
        if thisEV > 0  
            item2=item2+gamma^(trial-j) * thisEV^alpha;
        else
            item2=item2+gamma^(trial-j) * (-lambda) * (-thisEV)^alpha; 
        end
    end
    
    item3=0;
    for j=1:trial
        thisGR=decision_trial(j).GR;
        if thisGR > 0 && thisEV > 0 
            item3=item3+gamma^(trial-j) * (thisGR^alpha-thisEV^alpha);
        elseif thisGR > 0 && thisEV <= 0
            item3=item2+gamma^(trial-j) * (thisGR^alpha-(-lambda) * (-thisEV)^alpha);
        elseif thisGR < 0 && thisEV > 0
            item3=item2+gamma^(trial-j) * ((-lambda) * (-thisGR)^alpha-thisEV^alpha);
        elseif thisGR < 0 && thisEV <= 0
            item3=item2+gamma^(trial-j) * ((-lambda) * (-thisGR)^alpha-(-lambda) * (-thisEV)^alpha);
        end
    end
    
    
    %当前试次结束后的happiness
    decision_trial(trial).fit_happiness=w0+w1*item1+w2*item2+w3*item3; 
    
end

inx=cellfun(@isempty,{decision_trial.happiness});

allfit_happiness=[decision_trial.fit_happiness];
allfit_happiness(inx)=[];

loss=allfit_happiness-[decision_trial.happiness];






