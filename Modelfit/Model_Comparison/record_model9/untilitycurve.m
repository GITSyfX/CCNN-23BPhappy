clear;clc;rng('Shuffle');



eqa_color = [190/255, 190/255, 190/255];
larg_color = [96/255, 124/255, 87/255];
smal_color = [178/255, 196/255, 172/255];

c = {larg_color,eqa_color,smal_color};

figure;set(gcf,'Color','white');

x = linspace(0, 2, 300);
a_values = [2.2, 1, 1/2.2];
lambda = [2.2,1/2.2];

for i = 1:length(a_values)
    a = a_values(i);
    y = x.^a; % 计算y值
    plot(x, y, 'LineWidth',3.5,'color',c{i}) ; % 绘制曲线
    hold on; % 保持当前图形，以便在同一图上绘制下一条曲线
end

x = -x;
for i = 1:length(a_values)
    a = a_values(i);
    y = -(-x).^a; % 计算y值
    plot(x, y, 'LineWidth',3.5,'color',c{i}) ; % 绘制曲线
    hold on; % 保持当前图形，以便在同一图上绘制下一条曲线
end

larg_color = [120/255, 120/255, 120/255]; 
smal_color = [220/255, 220/255, 220/255];
c = {larg_color,smal_color};
for i = 1:length(lambda)
    l = lambda(i);
    y = -l*(-x); % 计算y值
    plot(x, y, '--', 'LineWidth',3.5,'color',c{i}) ; % 绘制曲线
    hold on; % 保持当前图形，以便在同一图上绘制下一条曲线
end

pbaspect([4 4 1])
hold off

% 绘制 x 轴和 y 轴
ylim([-1.2 1.2]);xlim([-1.2 1.2]);
xticks([]);
yticks([]);

legend('Box','off','Location','best');
ax = gca;
set(ax,'box','off','linewidth', 3.5, 'fontsize', 12 ,'fontname', 'Arial'...
        ,'TickDir','out','TickLength',[0.05 0]);
ax.Layer = 'top';
ax.XAxisLocation = 'origin'; % 设置 x 轴在原点
ax.YAxisLocation = 'origin'; % 设置 y 轴在原点