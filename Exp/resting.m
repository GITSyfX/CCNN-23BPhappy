clear;clc;rng('Shuffle');
addpath('materials'); addpath('profile');

%% ��ʾЧ������

bgc=0; %������ɫ
skip=0; %ͬ���Բ���

time3=10; %��ʼ�Լ�������10�����
time_rest=580; %��Ϣ̬ʱ��

fix_size=80;

%%
[w,wrect,hz,xc,yc]=init_screen(bgc,skip,60);

%% �ȴ���ʼ(S����)
Screen('FillRect',w,bgc);
drawcenteredtext_dot(w,'�������Ϣ������ͷ��Ҫ��',xc,yc-50,255,30);
drawcenteredtext_dot(w,'�ȴ�S����',xc,yc+50,255,30);
Screen('Flip',w);
while 1
    [~,~,kc]=KbCheck;
    if kc(KbName('s'))
        start_time=GetSecs;
        break;
    end
    checkend;
end

%% �ȴ�10�����
for i=1:hz*time3
    Screen('FillRect',w,bgc);
    drawfix(w,fix_size,xc,yc,255);
    Screen('Flip',w);
    checkend;
end

%% ��Ϣ̬ 
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










