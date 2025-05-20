function [loss,decision_trial]=fit_happiness(decision_trial,params)

for p = 1:6
    eval(['w',num2str(p),'=', 'params','(',num2str(p),');'])
end
    

for trial=1:length(decision_trial) 
    %初始化各个event
    CRitem = w1*decision_trial(trial).CR;
    EVitem = w2*decision_trial(trial).EV;
    RPEitem = w3*decision_trial(trial).RPE;
    %trial - 1 <= 0 会导致索引错误
    if trial-1 == 0
        decision_trial(trial).fit_happiness=CRitem + EVitem + RPEitem; 
        continue
    else
        %CR
        for j = 1
            eval(['CRitem', '=', 'w', num2str(1+3*j),'*', 'decision_trial','(', num2str(trial-j), ').CR', '+', 'CRitem;']);
        end
            %EV
        for j = 1
            eval(['EVitem', '=', 'w', num2str(2+3*j),'*', 'decision_trial','(', num2str(trial-j), ').EV', '+', 'EVitem;']);
        end 
    
        %RPE
        for j = 1
            eval(['RPEitem', '=', 'w', num2str(3+3*j),'*', 'decision_trial','(', num2str(trial-j), ').RPE', '+', 'RPEitem;']);
        end 
        
        %当前试次结束后的happiness
        decision_trial(trial).fit_happiness=CRitem + EVitem + RPEitem; 
    end
end

inx=cellfun(@isempty,{decision_trial.happiness});

allfit_happiness=[decision_trial.fit_happiness];
allfit_happiness(inx)=[];

%loss=zscore([allfit_happiness])-zscore([decision_trial.happiness]);
loss=allfit_happiness-zscore([decision_trial.happiness]);






