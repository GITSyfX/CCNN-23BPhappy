clear;clc;rng('Shuffle');close all
load('D:\CCNN\Projects\23BPHappy\Analysis\Modelfit\Group_Level\clidata.mat')
raw = clidata;
%% 提取每种model的AIC,BIC数据
AllIC = {};
AllAIC = [];
AllBIC = [];
for i = 1:11 
    if ismember(i,[7])
        continue
    end
    load(['D:\CCNN\Projects\23BPHappy\Analysis\Modelfit\Model_Comparison\record_model',num2str(i),'\fit_result_z','.mat'])
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
    AllAICdiff = AllAIC-AllAIC(:,1);AllBICdiff = AllBIC-AllBIC(:,1);
end

%% 准备数据
All_color = [169/255, 169/255, 169/255];
MDD_color = [126/255, 155/255, 183/255];
BD_color = [238/255, 165/255, 153/255];

Modellabel = {'1','2','3', '4','5','6','7','8','9','10','11'};

clilabel = cell2mat(raw(:,11));


MDDAIC = AllAIC(clilabel == 0,:);MDDAICdiff = AllAICdiff(clilabel == 0,:);MDDBIC = AllAIC(clilabel == 0,:);MDDBICdiff = AllBICdiff(clilabel == 0,:);
BDAIC = AllAIC(clilabel == 1,:);BDAICdiff = AllAICdiff(clilabel == 1,:);BDBIC = AllAIC(clilabel == 1,:);BDBICdiff = AllBICdiff(clilabel == 1,:);

mean_AllAICdiff = mean(AllAICdiff); mean_MDDAICdiff = mean(MDDAICdiff); mean_BDAICdiff = mean(BDAICdiff); 
mean_AllBICdiff = mean(AllBICdiff); mean_MDDBICdiff = mean(MDDBICdiff); mean_BDBICdiff = mean(BDBICdiff); 
Std_AllAICdiff = std(AllAICdiff); Std_MDDAICdiff = std(MDDAICdiff); Std_BDAICdiff = std(BDAICdiff); 
Std_AllBICdiff = std(AllBICdiff); Std_MDDBICdiff = std(MDDBICdiff); Std_BDBICdiff = std(BDBICdiff);

[~,~,~,AllPXP,~] = spm_BMS(-.5*AllBIC);[~,~,~,MDDPXP,~] = spm_BMS(-.5*MDDBIC);[~,~,~,BDPXP,~] = spm_BMS(-.5*BDBIC);
%% 对数据进行自动排序
[sMean_AllAICdiff, sInd_AllAICdiff] = sort(mean_AllAICdiff,'descend');[sMean_AllBICdiff, sInd_AllBICdiff] = sort(mean_AllBICdiff,'descend');
[sMean_MDDAICdiff, sInd_MDDAICdiff] = sort(mean_MDDAICdiff,'descend');[sMean_MDDBICdiff, sInd_MDDBICdiff] = sort(mean_MDDBICdiff,'descend');
[sMean_BDAICdiff, sInd_BDAICdiff] = sort(mean_BDAICdiff,'descend');[sMean_BDBICdiff, sInd_BDBICdiff] = sort(mean_BDBICdiff,'descend');
sStd_AllAICdiff = Std_AllAICdiff(sInd_AllAICdiff);sStd_AllBICdiff = Std_AllBICdiff(sInd_AllBICdiff);
sStd_MDDAICdiff = Std_MDDAICdiff(sInd_MDDAICdiff);sStd_MDDBICdiff = Std_MDDBICdiff(sInd_MDDBICdiff);
sStd_BDAICdiff = Std_BDAICdiff(sInd_BDAICdiff);sStd_BDBICdiff = Std_BDBICdiff(sInd_BDBICdiff);

[s_AllPXP, sInd_AllPXP] = sort(AllPXP);
[s_MDDPXP, sInd_MDDPXP] = sort(MDDPXP);
[s_BDPXP, sInd_BDPXP] = sort(BDPXP);
%% 绘制组总体bar图
set(groot,'defaultFigurePosition',[200, 200, 1400, 500]);

figure; set(gcf,'Color','white');
t1 = tiledlayout(1,3,'TileSpacing','tight');

nexttile
barh(sMean_AllAICdiff,'LineWidth',3.5, 'Edgecolor',All_color,'Facecolor',All_color,'FaceAlpha',0.5,'ShowBaseLine','off');
hold on;
xline(0, ':k', 'LineWidth', 1.2);
scatter(AllAICdiff(:,sInd_AllAICdiff),repmat(1:length(sMean_AllAICdiff), size(AllAICdiff, 1) , 1),  20, 'filled', ...
    'MarkerEdgeColor', All_color, 'MarkerFaceColor', All_color, 'MarkerFaceAlpha', 0.6);
errorbar(sMean_AllAICdiff,1:length(sMean_AllAICdiff),sStd_AllAICdiff,'horizontal','.', 'LineWidth', 3.5,'CapSize', 12,...
    'Color',[82/255, 82/255, 82/255],'MarkerEdgeColor',[82/255, 82/255, 82/255],'MarkerFaceColor',[82/255, 82/255, 82/255]);
hold off;
ylabel('Model');
xlabel('Δ AIC');
yticklabels(Modellabel(sInd_AllAICdiff));
set(gca,'box','off', 'linewidth', 3.5, 'fontsize', 20, 'fontname', 'Arial','TickDir','out','TickLength',[0.025 0]);

nexttile
barh(sMean_AllBICdiff,'LineWidth',3.5, 'Edgecolor',All_color,'Facecolor',All_color,'FaceAlpha',0.5,'ShowBaseLine','off');
hold on;
xline(0, ':k', 'LineWidth', 1.2);
scatter(AllBICdiff(:,sInd_AllBICdiff), repmat(1:length(sMean_AllBICdiff), size(AllBICdiff, 1) , 1), 20,'filled', ...
    'MarkerEdgeColor', All_color, 'MarkerFaceColor', All_color, 'MarkerFaceAlpha', 0.6);
errorbar(sMean_AllBICdiff,1:length(sMean_AllBICdiff), sStd_AllBICdiff,'horizontal','.', 'LineWidth', 3.5,'CapSize', 12, ...
    'Color',[82/255, 82/255, 82/255],'MarkerEdgeColor',[82/255, 82/255, 82/255],'MarkerFaceColor',[82/255, 82/255, 82/255]);
hold off;
xlabel('Δ BIC');
yticklabels(Modellabel(sInd_AllBICdiff));
set(gca,'box','off', 'linewidth', 3.5, 'fontsize', 20, 'fontname', 'Arial','TickDir','out','TickLength',[0.025 0]);

nexttile
barh(s_AllPXP,'LineWidth',3.5, 'Edgecolor',All_color,'Facecolor',All_color,'FaceAlpha',0.5,'ShowBaseLine','off');
xlabel('PXP');
yticklabels(Modellabel(sInd_AllPXP));
xticks([0,0.5,1]);xlim([0,1])
set(gca,'box','off', 'linewidth', 3.5, 'fontsize', 20, 'fontname', 'Arial','TickDir','out','TickLength',[0.025 0]);
%% 绘制MDD组bar图
set(groot,'defaultFigurePosition',[200, 200, 1400, 500]);
figure; set(gcf,'Color','white');
t2 = tiledlayout(1,3,'TileSpacing','tight');

nexttile
barh(sMean_MDDAICdiff,'LineWidth',3.5, 'Edgecolor',MDD_color,'Facecolor',MDD_color,'FaceAlpha',0.5,'ShowBaseLine','off');
hold on;
xline(0, ':k', 'LineWidth', 1.2);
scatter(MDDAICdiff(:,sInd_MDDAICdiff),repmat(1:length(sMean_MDDAICdiff), size(MDDAICdiff, 1) , 1),  20, 'filled', ...
    'MarkerEdgeColor', MDD_color, 'MarkerFaceColor', MDD_color, 'MarkerFaceAlpha', 0.6);
errorbar(sMean_MDDAICdiff,1:length(sMean_MDDAICdiff),sStd_MDDAICdiff,'horizontal','.', 'LineWidth', 3.5,'CapSize', 12,...
    'Color',[82/255, 82/255, 82/255],'MarkerEdgeColor',[82/255, 82/255, 82/255],'MarkerFaceColor',[82/255, 82/255, 82/255]);
hold off;
ylabel('Model');
xlabel('Δ AIC');
yticklabels(Modellabel(sInd_MDDAICdiff));
set(gca,'box','off', 'linewidth', 3.5, 'fontsize', 20, 'fontname', 'Arial','TickDir','out','TickLength',[0.025 0]);

nexttile
barh(sMean_MDDBICdiff,'LineWidth',3.5, 'Edgecolor',MDD_color,'Facecolor',MDD_color,'FaceAlpha',0.5,'ShowBaseLine','off');
hold on;
xline(0, ':k', 'LineWidth', 1.2);
scatter(MDDBICdiff(:,sInd_MDDBICdiff), repmat(1:length(sMean_MDDBICdiff), size(MDDBICdiff, 1) , 1), 20,'filled', ...
    'MarkerEdgeColor', MDD_color, 'MarkerFaceColor', MDD_color, 'MarkerFaceAlpha', 0.6);
errorbar(sMean_MDDBICdiff,1:length(sMean_MDDBICdiff), sStd_MDDBICdiff,'horizontal','.', 'LineWidth', 3.5,'CapSize', 12, ...
    'Color',[82/255, 82/255, 82/255],'MarkerEdgeColor',[82/255, 82/255, 82/255],'MarkerFaceColor',[82/255, 82/255, 82/255]);
hold off;
xlabel('Δ BIC');
yticklabels(Modellabel(sInd_MDDBICdiff));
set(gca,'box','off', 'linewidth', 3.5, 'fontsize', 20, 'fontname', 'Arial','TickDir','out','TickLength',[0.025 0]);

nexttile
barh(s_MDDPXP,'LineWidth',3.5, 'Edgecolor',MDD_color,'Facecolor',MDD_color,'FaceAlpha',0.5,'ShowBaseLine','off');
xlabel('PXP');
yticklabels(Modellabel(sInd_MDDPXP));
xticks([0,0.5,1]);xlim([0 1]);
set(gca,'box','off', 'linewidth', 3.5, 'fontsize', 20, 'fontname', 'Arial','TickDir','out','TickLength',[0.025 0]);
%% 绘制BD组bar图
set(groot,'defaultFigurePosition',[200, 200, 1400, 500]);
figure; set(gcf,'Color','white');
t3 = tiledlayout(1,3,'TileSpacing','tight');

nexttile
barh(sMean_BDAICdiff,'LineWidth',3.5, 'Edgecolor',BD_color,'Facecolor',BD_color,'FaceAlpha',0.5,'ShowBaseLine','off');
hold on;
xline(0, ':k', 'LineWidth', 1.2);
scatter(BDAICdiff(:,sInd_BDAICdiff),repmat(1:length(sMean_BDAICdiff), size(BDAICdiff, 1) , 1),  20, 'filled', ...
    'MarkerEdgeColor', BD_color, 'MarkerFaceColor', BD_color, 'MarkerFaceAlpha', 0.6);
errorbar(sMean_BDAICdiff,1:length(sMean_BDAICdiff),sStd_BDAICdiff,'horizontal','.', 'LineWidth', 3.5,'CapSize', 12,...
    'Color',[82/255, 82/255, 82/255],'MarkerEdgeColor',[82/255, 82/255, 82/255],'MarkerFaceColor',[82/255, 82/255, 82/255]);
hold off;
ylabel('Model');
xlabel('Δ AIC');
yticklabels(Modellabel(sInd_BDAICdiff));
set(gca,'box','off', 'linewidth', 3.5, 'fontsize', 20, 'fontname', 'Arial','TickDir','out','TickLength',[0.025 0]);

nexttile
barh(sMean_BDBICdiff,'LineWidth',3.5, 'Edgecolor',BD_color,'Facecolor',BD_color,'FaceAlpha',0.5,'ShowBaseLine','off');
hold on;
xline(0, ':k', 'LineWidth', 1.2);
scatter(BDBICdiff(:,sInd_BDBICdiff), repmat(1:length(sMean_BDBICdiff), size(BDBICdiff, 1) , 1), 20,'filled', ...
    'MarkerEdgeColor', BD_color, 'MarkerFaceColor', BD_color, 'MarkerFaceAlpha', 0.6);
errorbar(sMean_BDBICdiff,1:length(sMean_BDBICdiff), sStd_BDBICdiff,'horizontal','.', 'LineWidth', 3.5,'CapSize', 12, ...
    'Color',[82/255, 82/255, 82/255],'MarkerEdgeColor',[82/255, 82/255, 82/255],'MarkerFaceColor',[82/255, 82/255, 82/255]);
hold off;
xlabel('Δ BIC');xticks([-20,0,20]);xlim([-20,20])
yticklabels(Modellabel(sInd_BDBICdiff));
set(gca,'box','off', 'linewidth', 3.5, 'fontsize', 20, 'fontname', 'Arial','TickDir','out','TickLength',[0.025 0]);

nexttile
barh(s_BDPXP,'LineWidth',3.5, 'Edgecolor',BD_color,'Facecolor',BD_color,'FaceAlpha',0.5,'ShowBaseLine','off');
xlabel('PXP');
yticklabels(Modellabel(sInd_BDPXP));
xticks([0,0.5,1]);xlim([0 1]);
set(gca,'box','off', 'linewidth', 3.5, 'fontsize', 20, 'fontname', 'Arial','TickDir','out','TickLength',[0.025 0]);