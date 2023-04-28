%% 加载数据
clear;clc;rng('Shuffle');
load('fit_result.mat');

%%

for subnum = 1:size(allsub,2)
    trials = 1;
    hap = [];
    fit_hap = [];
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
    plot(trials,hap,trials,fit_hap)
    title(['Subject',num2str(subnum)])
end

