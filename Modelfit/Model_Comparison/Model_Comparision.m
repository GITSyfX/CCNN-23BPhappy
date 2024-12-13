clear;clc;rng('Shuffle');
load('D:\CCNN\Projects\23BPHappy\Analysis\Modelfit\Group_Level\clidata.mat')
raw = clidata;
%% 提取每种model的AIC BIC数据
AllIC = {};
AllAIC = [];
AllBIC = [];
for i = 1:11  
    load(['D:\CCNN\Projects\23BPHappy\Analysis\Modelfit\Model_Comparison\record_model',num2str(i),'\fit_result.mat'])
    subIC = [];
    for subnum = 1:size(raw,1)
    subname = raw{subnum,1};
    colOfsub = strcmp(allsub(1,:), subname);%判断是否在被试的诊断学数据
        if any(colOfsub)
            subClidata = raw(subnum, :);
            if cell2mat(subClidata(10))==0 && cell2mat(subClidata(11)) == 0
                continue
            end
            IC = allsub(6,colOfsub);
            IC = IC{1,1};
            subIC = [subIC;IC];
            modelname = sprintf('Model%d', i); 
        end
    end
    AllIC.(modelname) = subIC;
    AllAIC = [AllAIC,subIC(:,1)];AllBIC = [AllBIC,subIC(:,2)];
end

%% 准备数据
All_color = [169/255, 169/255, 169/255];
MDD_color = [126/255, 155/255, 183/255];
BD_color = [238/255, 165/255, 153/255];

Modellabel = {'Model 1','Model 2','Model 3', 'Model 4','Model 5','Model 6','Model 7','Model 8','Model 9','Model 10','Model 11'};

clilabel = cell2mat(raw(:,11));
MDDAIC = AllAIC(clilabel == 0,:);MDDBIC = AllBIC(clilabel == 0,:);
BDAIC = AllAIC(clilabel == 1,:);BDBIC = AllBIC(clilabel == 1,:);

mean_AllAIC = mean(AllAIC); mean_MDDAIC = mean(MDDAIC); mean_BDAIC = mean(BDAIC); 
mean_AllBIC = mean(AllBIC); mean_MDDBIC = mean(MDDBIC); mean_BDBIC = mean(BDBIC); 
Std_AllAIC = std(AllAIC); Std_MDDAIC = std(MDDAIC); Std_BDAIC = std(BDAIC); 
Std_AllBIC = std(AllBIC); Std_MDDBIC = std(MDDBIC); Std_BDBIC = std(BDBIC); 

[~,~,~,AllPXP,~] = spm_BMS(-.5*AllBIC);[~,~,~,MDDPXP,~] = spm_BMS(-.5*MDDBIC);[~,~,~,BDPXP,~] = spm_BMS(-.5*BDBIC);
%% 对数据惊醒自动排序
[sMean_AllAIC, sInd_AllAIC] = sort(mean_AllAIC);[sMean_AllBIC, sInd_AllBIC] = sort(mean_AllBIC);
[sMean_MDDAIC, sInd_MDDAIC] = sort(mean_MDDAIC);[sMean_MDDBIC, sInd_MDDBIC] = sort(mean_MDDBIC);
[sMean_BDAIC, sInd_BDAIC] = sort(mean_BDAIC);[sMean_BDBIC, sInd_BDBIC] = sort(mean_BDBIC);
sStd_AllAIC = Std_AllAIC(sInd_AllAIC);sStd_AllBIC = Std_AllBIC(sInd_AllBIC);
sStd_MDDAIC = Std_MDDAIC(sInd_MDDAIC);sStd_MDDBIC = Std_MDDBIC(sInd_MDDBIC);
sStd_BDAIC = Std_BDAIC(sInd_BDAIC);sStd_BDBIC = Std_BDBIC(sInd_BDBIC);

[s_AllPXP, sInd_AllPXP] = sort(AllPXP,'descend');
[s_MDDPXP, sInd_MDDPXP] = sort(MDDPXP,'descend');
[s_BDPXP, sInd_BDPXP] = sort(BDPXP,'descend');
%% 绘制组总体bar图
set(groot,'defaultFigurePosition',[200, 200, 1800,  400]);
figure; set(gcf,'Color','white');
t1 = tiledlayout(1,3,'TileSpacing','tight');

nexttile
bar(sMean_AllAIC,'LineWidth',3.5, 'Edgecolor',All_color,'Facecolor',All_color,'FaceAlpha',0.5);
hold on;
scatter(repmat(1:length(sMean_AllAIC), size(AllAIC, 1) , 1), AllAIC(:,sInd_AllAIC), 20, 'filled', ...
    'MarkerEdgeColor', All_color, 'MarkerFaceColor', All_color, 'MarkerFaceAlpha', 0.6);
errorbar(1:length(sMean_AllAIC), sMean_AllAIC, sStd_AllAIC, '.', 'LineWidth', 3.5,'CapSize', 12,...
    'Color',[82/255, 82/255, 82/255],'MarkerEdgeColor',[82/255, 82/255, 82/255],'MarkerFaceColor',[82/255, 82/255, 82/255]);
hold off;
ylabel('AIC')
xticklabels(Modellabel(sInd_AllAIC));
set(gca,'box','off', 'linewidth', 3.5, 'fontsize', 16, 'fontname', 'Arial','TickDir','out','TickLength',[0.025 0]);

nexttile
bar(sMean_AllBIC,'LineWidth',3.5, 'Edgecolor',All_color,'Facecolor',All_color,'FaceAlpha',0.5);
hold on;
scatter(repmat(1:length(sMean_AllBIC), size(AllBIC, 1) , 1),  AllBIC(:,sInd_AllBIC), 20,'filled', ...
    'MarkerEdgeColor', All_color, 'MarkerFaceColor', All_color, 'MarkerFaceAlpha', 0.6);
errorbar(1:length(sMean_AllBIC), sMean_AllBIC, sStd_AllAIC, '.', 'LineWidth', 3.5,'CapSize', 12, ...
    'Color',[82/255, 82/255, 82/255],'MarkerEdgeColor',[82/255, 82/255, 82/255],'MarkerFaceColor',[82/255, 82/255, 82/255]);
hold off;
ylabel('BIC');
xticklabels(Modellabel(sInd_AllAIC));
set(gca,'box','off', 'linewidth', 3.5, 'fontsize', 16, 'fontname', 'Arial','TickDir','out','TickLength',[0.025 0]);

nexttile
bar(s_AllPXP,'LineWidth',3.5, 'Edgecolor',All_color,'Facecolor',All_color,'FaceAlpha',0.5,'ShowBaseLine','off');
ylabel('PXP');
xlabel('Model');
xticklabels(Modellabel(sInd_AllPXP));
set(gca,'box','off', 'linewidth', 3.5, 'fontsize', 16, 'fontname', 'Arial','TickDir','out','TickLength',[0.025 0]);
%% 绘制MDD组bar图
set(groot,'defaultFigurePosition',[200, 200, 1800,  400]);
figure; set(gcf,'Color','white');
t2 = tiledlayout(1,3,'TileSpacing','tight');

nexttile
bar(sMean_MDDAIC,'LineWidth',3.5, 'Edgecolor',MDD_color,'Facecolor',MDD_color,'FaceAlpha',0.5);
hold on;
scatter(repmat(1:length(sMean_MDDAIC), size(MDDAIC, 1) , 1), MDDAIC(:,sInd_MDDAIC), 20, 'filled', ...
    'MarkerEdgeColor', MDD_color, 'MarkerFaceColor', MDD_color, 'MarkerFaceAlpha', 0.6);
errorbar(1:length(sMean_MDDAIC), sMean_MDDAIC, sStd_MDDAIC, '.', 'LineWidth', 3.5,'CapSize', 12,...
    'Color',[82/255, 82/255, 82/255],'MarkerEdgeColor',[82/255, 82/255, 82/255],'MarkerFaceColor',[82/255, 82/255, 82/255]);
hold off;
ylabel('AIC')
xticklabels(Modellabel(sInd_MDDAIC));
set(gca,'box','off', 'linewidth', 3.5, 'fontsize', 16, 'fontname', 'Arial','TickDir','out','TickLength',[0.025 0]);

nexttile
bar(sMean_MDDBIC,'LineWidth',3.5, 'Edgecolor',MDD_color,'Facecolor',MDD_color,'FaceAlpha',0.5);
hold on;
scatter(repmat(1:length(sMean_MDDBIC), size(MDDBIC, 1) , 1),  MDDBIC(:,sInd_MDDBIC), 20,'filled', ...
    'MarkerEdgeColor', MDD_color, 'MarkerFaceColor', MDD_color, 'MarkerFaceAlpha', 0.6);
errorbar(1:length(sMean_MDDBIC), sMean_MDDBIC, sStd_MDDAIC, '.', 'LineWidth', 3.5,'CapSize', 12, ...
    'Color',[82/255, 82/255, 82/255],'MarkerEdgeColor',[82/255, 82/255, 82/255],'MarkerFaceColor',[82/255, 82/255, 82/255]);
hold off;
ylabel('BIC');
xticklabels(Modellabel(sInd_MDDAIC));
set(gca,'box','off', 'linewidth', 3.5, 'fontsize', 16, 'fontname', 'Arial','TickDir','out','TickLength',[0.025 0]);

nexttile
bar(s_MDDPXP,'LineWidth',3.5, 'Edgecolor',MDD_color,'Facecolor',MDD_color,'FaceAlpha',0.5,'ShowBaseLine','off');
ylabel('PXP');
xlabel('Model');
xticklabels(Modellabel(sInd_MDDPXP));
set(gca,'box','off', 'linewidth', 3.5, 'fontsize', 16, 'fontname', 'Arial','TickDir','out','TickLength',[0.025 0]);
%% 绘制BD组bar图
set(groot,'defaultFigurePosition',[200, 200, 1800,  400]);
figure; set(gcf,'Color','white');
t3 = tiledlayout(1,3,'TileSpacing','tight');

nexttile
bar(sMean_BDAIC,'LineWidth',3.5, 'Edgecolor',BD_color,'Facecolor',BD_color,'FaceAlpha',0.5);
hold on;
scatter(repmat(1:length(sMean_BDAIC), size(BDAIC, 1) , 1), BDAIC(:,sInd_BDAIC), 20, 'filled', ...
    'MarkerEdgeColor', BD_color, 'MarkerFaceColor', BD_color, 'MarkerFaceAlpha', 0.6);
errorbar(1:length(sMean_BDAIC), sMean_BDAIC, sStd_BDAIC, '.', 'LineWidth', 3.5,'CapSize', 12,...
    'Color',[82/255, 82/255, 82/255],'MarkerEdgeColor',[82/255, 82/255, 82/255],'MarkerFaceColor',[82/255, 82/255, 82/255]);
hold off;
ylabel('AIC')
xticklabels(Modellabel(sInd_BDAIC));
set(gca,'box','off', 'linewidth', 3.5, 'fontsize', 16, 'fontname', 'Arial','TickDir','out','TickLength',[0.025 0]);

nexttile
bar(sMean_BDBIC,'LineWidth',3.5, 'Edgecolor',BD_color,'Facecolor',BD_color,'FaceAlpha',0.5);
hold on;
scatter(repmat(1:length(sMean_BDBIC), size(BDBIC, 1) , 1),  BDBIC(:,sInd_BDBIC), 20,'filled', ...
    'MarkerEdgeColor', BD_color, 'MarkerFaceColor', BD_color, 'MarkerFaceAlpha', 0.6);
errorbar(1:length(sMean_BDBIC), sMean_BDBIC, sStd_BDAIC, '.', 'LineWidth', 3.5,'CapSize', 12, ...
    'Color',[82/255, 82/255, 82/255],'MarkerEdgeColor',[82/255, 82/255, 82/255],'MarkerFaceColor',[82/255, 82/255, 82/255]);
hold off;
ylabel('BIC');
xticklabels(Modellabel(sInd_BDAIC));
set(gca,'box','off', 'linewidth', 3.5, 'fontsize', 16, 'fontname', 'Arial','TickDir','out','TickLength',[0.025 0]);

nexttile
bar(s_BDPXP,'LineWidth',3.5, 'Edgecolor',BD_color,'Facecolor',BD_color,'FaceAlpha',0.5,'ShowBaseLine','off');
ylabel('PXP');
xlabel('Model');
xticklabels(Modellabel(sInd_BDPXP));
set(gca,'box','off', 'linewidth', 3.5, 'fontsize', 16, 'fontname', 'Arial','TickDir','out','TickLength',[0.025 0]);