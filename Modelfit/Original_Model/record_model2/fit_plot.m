%% 加载数据
clear;clc;rng('Shuffle');
load('fit_result.mat');

%%
all_AIC = [];
all_BIC = [];
for subnum = 1:size(allsub,2)
    trials = 1;
    hap = [];
    fit_hap = [];
    all_AIC = [all_AIC,allsub{6,subnum}(1)];
    all_BIC = [all_BIC,allsub{6,subnum}(2)];
    for trialnum = 1:size(allsub{5,subnum},2)
        if isempty(allsub{5,subnum}(trialnum).happiness) == 1
            continue
        else
            hap = [hap, allsub{5,subnum}(trialnum).happiness];
            fit_hap = [fit_hap, allsub{5,subnum}(trialnum).fit_happiness];
            trials = [trials,max(trials)+1];
        end
    end
    trials(:,length(trials)) = [];
    subplot(4,6,subnum)
    plot(trials,zscore(hap),trials,zscore(fit_hap))
    title(['AIC:',num2str(allsub{6,subnum}(1)),'  BIC:',num2str(allsub{6,subnum}(2))]);
end
sum(all_AIC)
sum(all_BIC)
