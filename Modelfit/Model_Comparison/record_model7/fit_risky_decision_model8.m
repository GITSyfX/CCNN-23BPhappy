clear;clc;rng('Shuffle');

% CR %固定回报
% EV %回报期望值
% RPE %回报期望和真实回报的差异

%%
delete(gcp('nocreate'));
parpool(8);

%% 初步整理数据
allmat=dir('D:\CCNN\Projects\23BPHappy\Analysis\Modelfit\First_Level\*risky_decision.mat');
for i=1:length(allmat)
    thisname=allmat(i).name;
    inx=strfind(thisname,'-');
    allmat(i).subID=thisname(inx+1:inx+4);
end
allsub=unique({allmat.subID});

%%
for sub=1:length(allsub)

    thissub=allsub{1,sub};
    
    inx=strcmp({allmat.subID},thissub);
    
    part_names={allmat(inx).name};
    
    
    part1=load(['D:\CCNN\Projects\23BPHappy\Analysis\Modelfit\First_Level\',part_names{1}],'result');
    part2=load(['D:\CCNN\Projects\23BPHappy\Analysis\Modelfit\First_Level\',part_names{2}],'result');
    
    %删去每个part的第一个trial的happiness评分
    part1.result(1)=[];
    part2.result(1)=[];
    result=[part1.result,part2.result];
    
    for i=1:length(result)
        if result(i).trial_type==2
            result(i-1).happiness= result(i).rating;
        end
    end
    decision_trial=result([result.trial_type]==1);
    
    for i=1:length(decision_trial)
        if decision_trial(i).subres==1 %选择确定
            decision_trial(i).CR=decision_trial(i).certainty;
            decision_trial(i).EV=0;
            decision_trial(i).RPE=0;
            decision_trial(i).DIF=diff([decision_trial(i).certainty, mean(decision_trial(i).uncertainty)]);
        else %选择不确定
            decision_trial(i).CR=0;
            EV=mean(decision_trial(i).uncertainty);
            decision_trial(i).EV=EV;
            decision_trial(i).RPE=decision_trial(i).this_score-EV;
            decision_trial(i).DIF=diff([decision_trial(i).certainty, EV]);
        end
    end
    
    %% 开始拟合
    data=decision_trial;
    fitfun=@(params) fit_happiness(data,params);
    bounds=[-10,-10,-10,-10,0;10,10,10,10,1];
    %w0 w1 w2 w3 gamma
    record=[];
    parfor i=1:80
        range=bounds(2,:)-bounds(1,:);
        params=rand(1,length(range)).*range+bounds(1,:);
        [x,resnorm,residual,exitflag] = lsqnonlin(fitfun,params,bounds(1,:),bounds(2,:));
        fval = sum(residual.*residual, 2);
        record(i,:)=[params,x,fval,exitflag];
    end
    
    params_n=(size(record,2)-2)/2;
    record=sortrows(record,size(record,2)-1);

    x1=record(1,params_n+1:params_n*2);
    [residual,fit_decision_trial]=fitfun(x1);

    SSE = sum(residual.*residual, 2); 
    datasize_n = size(residual,2);
    
    AIC = datasize_n*log(SSE/datasize_n) + 2 * params_n;
    BIC = datasize_n*log(var(residual)) + params_n*log(datasize_n); % https://pmc.ncbi.nlm.nih.gov/articles/PMC7516921/

    IC = [AIC,BIC];

    allsub{2,sub}=record;
    allsub{3,sub}=decision_trial;
    allsub{4,sub}=SSE;
    allsub{5,sub}=fit_decision_trial;
    allsub{6,sub}=IC;
    
end


save('fit_result_z.mat','allsub');









