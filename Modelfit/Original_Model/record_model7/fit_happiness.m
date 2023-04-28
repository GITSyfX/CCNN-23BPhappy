function [loss,decision_trial]=fit_happiness(decision_trial,params)

for p = 0:21
    eval(['w',num2str(p),'=', 'params','(',num2str(p+1),');'])
end
    

for trial=1:length(decision_trial) 
    %初始化各个event
    CRitem = w1*decision_trial(trial).CR;
    EVitem = w2*decision_trial(trial).EV;
    RPEitem = w3*decision_trial(trial).RPE;
    %trial - 1 <= 0 会导致索引错误
    if trial-1 == 0
        decision_trial(trial).fit_happiness=w0 + CRitem + EVitem + RPEitem; 
        continue
    else
        %CR
        for j = 1:6
            if  trial-j > 0 
                eval(['CRitem', '=', 'w', num2str(1+3*j),'*', 'decision_trial','(', num2str(trial-j), ').CR', '+', 'CRitem;']);
            end
        end
        %EV
        for j = 1:6
            if  trial-j > 0 
                eval(['EVitem', '=', 'w', num2str(2+3*j),'*', 'decision_trial','(', num2str(trial-j), ').EV', '+', 'EVitem;']);
            end
        end 
        %RPE
        for j = 1:6
            if trial-j > 0 
                eval(['RPEitem', '=', 'w', num2str(3+3*j),'*', 'decision_trial','(', num2str(trial-j), ').RPE', '+', 'RPEitem;']);
            end
        end 
        
        %当前试次结束后的happiness
        decision_trial(trial).fit_happiness=w0 + CRitem + EVitem + RPEitem; 
    end
end

inx=cellfun(@isempty,{decision_trial.happiness});

allfit_happiness=[decision_trial.fit_happiness];
allfit_happiness(inx)=[];

loss=allfit_happiness-[decision_trial.happiness];






