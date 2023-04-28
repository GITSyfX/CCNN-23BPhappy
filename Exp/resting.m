clear;clc;rng('Shuffle');
addpath('materials'); addpath('profile');

%% 显示效果参数

bgc=0; %背景颜色
skip=0; %同步性测试

time3=10; %初始以及结束的10秒空屏
time_rest=580; %静息态时长

fix_size=80;

%%
[w,wrect,hz,xc,yc]=init_screen(bgc,skip,60);

%% 等待开始(S触发)
Screen('FillRect',w,bgc);
drawcenteredtext_dot(w,'请放松休息，保持头不要动',xc,yc-50,255,30);
drawcenteredtext_dot(w,'等待S触发',xc,yc+50,255,30);
Screen('Flip',w);
while 1
    [~,~,kc]=KbCheck;
    if kc(KbName('s'))
        start_time=GetSecs;
        break;
    end
    checkend;
end

%% 等待10秒空屏
for i=1:hz*time3
    Screen('FillRect',w,bgc);
    drawfix(w,fix_size,xc,yc,255);
    Screen('Flip',w);
    checkend;
end

%% 静息态 
for i=1:hz*time_rest
    Screen('FillRect',w,bgc);
    drawfix(w,fix_size,xc,yc,255);
    Screen('Flip',w);
    checkend;
end

%%
for i=1:hz*time3
    Screen('FillRect',w,bgc);
    drawfix(w,fix_size,xc,yc,255);
    Screen('Flip',w);
    checkend;
end

%%
ListenChar(0);
ShowCursor;
sca;
return










