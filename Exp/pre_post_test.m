%���ڽ���ǰ���

clear global ; clear ; clc; addpath('materials');

%%
ques_str={'��ŭ','����','��ɥ','����','����','����','����'};
ques_dy=200; %��������Ļ���ĵĴ�ֱ����
warnning_dy=-200;

rating_bar_L=800; %������ĳ���
rating_ball_D=50;  %�������С��ֱ��
rating_bar_w=10; %��������
option_dy=100; %�ǳ������ϣ�һ�㣬�ǳ����ϣ���ֱλ�ã� Խ��Խ����
pointer_color=[255 255 0]; %point��ɫ

fix_size=80; %ע�ӵ�ߴ�
fix_color=255; %ע�ӵ���ɫ

key_L=KbName('1!');
key_R=KbName('2@');
key_confirm=KbName('3#');

text_size=90;
init_time=5; %��ʼ����ʱ��
time1=10; %ÿ�����10���ӣ��������Զ���ת��һ�Ⲣ���������Ϣ��
time2=5; %���5�뻹û��������ʾ���Ծ���ȷ��
time3=2; %ÿ����ش���Ϻ�Ŀ���ʱ��

exp_hz=90; %ˢ����
bgc=0; %������ɫ
skip=0; %ͬ���Բ���
%%
sub=inputdlg({'���Ա��','pre_post'});
subID=sub{1};
clock0 = fix(clock);
f = sprintf('%04d%02d%02d%02d%02d%02d',clock0(1),clock0(2),clock0(3),clock0(4),clock0(5),clock0(6));
expname=[pwd,'/record/',f,'_subID-',subID,' ',sub{2},'_test.mat'] ;
[w,wrect,hz,xc,yc]=init_screen(bgc,skip,exp_hz);

%%
rating_ball_rect=GetRectFrame2(xc,yc,rating_ball_D,rating_ball_D,rating_bar_L,0,2,1);
rating_bar_rect=[xc-rating_bar_L/2,yc-rating_bar_w/2,xc+rating_bar_L/2,yc+rating_bar_w/2]; %
pointer_rect=GetRectFrame2(xc,yc,rating_ball_D,rating_ball_D,rating_bar_L/6,0,7,1); %7������λ��


%%
drawcenteredtext_dot(w,'���԰�S��ʼ�ʾ���д',xc,yc,255,30);
Screen('Flip',w);
while 1
    [~,~,kc]=KbCheck;
    if kc(KbName('s'))
        break;
    end
end

for flip=1:init_time*hz
    drawfix(w,fix_size,xc,yc,fix_color);
    Screen('Flip',w);
end

%%
for trial=1:length(ques_str)
    rating=4; %��ʼ״̬Ϊ4
    drawcenteredtext_dot(w,ques_str{trial},xc,yc-ques_dy,255,text_size);
    Screen('FillRect',w,255,rating_bar_rect);
    Screen('FillOval',w,255,rating_ball_rect);
    drawcenteredtext_dot(w,'�ǳ�������',xc-rating_bar_L/2,yc+option_dy,255,30);
    drawcenteredtext_dot(w,'�ǳ�����',xc+rating_bar_L/2,yc+option_dy,255,30);
    drawcenteredtext_dot(w,'һ��',xc,yc+option_dy,255,30);
    
    Screen('FillOval',w,pointer_color,pointer_rect(:,rating)); %������
    Screen('Flip',w);
    lastkid=0;
    subres=0;
    rating_start=GetSecs;
    disp_warnning=0;
    while 1
        if GetSecs-rating_start>time1
            break;
        end
        
        if GetSecs-rating_start>time2
            disp_warnning=1;
            drawcenteredtext_dot(w,ques_str{trial},xc,yc-ques_dy,255,text_size);
            drawcenteredtext_dot(w,'�뾡������',xc,yc-warnning_dy,[255 100 100],text_size);
            Screen('FillRect',w,255,rating_bar_rect);
            Screen('FillOval',w,255,rating_ball_rect);
            drawcenteredtext_dot(w,'�ǳ�������',xc-rating_bar_L/2,yc+option_dy,255,30);
            drawcenteredtext_dot(w,'�ǳ�����',xc+rating_bar_L/2,yc+option_dy,255,30);
            drawcenteredtext_dot(w,'һ��',xc,yc+option_dy,255,30);
            Screen('FillOval',w,pointer_color,pointer_rect(:,rating)); %������
            Screen('Flip',w);
        end
        
        [kid,~,kc]=KbCheck;
        
        if lastkid==0
            if kc(key_L) || kc(key_R)
                if kc(key_L)
                    rating=rating-1;
                elseif kc(key_R)
                    rating=rating+1;
                end
                if rating>7
                    rating=7;
                elseif rating<1;
                    rating=1;
                end
                drawcenteredtext_dot(w,ques_str{trial},xc,yc-ques_dy,255,text_size);
                if disp_warnning==1
                    drawcenteredtext_dot(w,'�뾡������',xc,yc-warnning_dy,[255 100 100],text_size);
                end
                Screen('FillRect',w,255,rating_bar_rect);
                Screen('FillOval',w,255,rating_ball_rect);
                drawcenteredtext_dot(w,'�ǳ�������',xc-rating_bar_L/2,yc+option_dy,255,30);
                drawcenteredtext_dot(w,'�ǳ�����',xc+rating_bar_L/2,yc+option_dy,255,30);
                drawcenteredtext_dot(w,'һ��',xc,yc+option_dy,255,30);
                Screen('FillOval',w,pointer_color,pointer_rect(:,rating)); %������
                Screen('Flip',w);
            end
            if kc(key_confirm)
                subres=1;
                break
            end
        end
        lastkid=kid;
        checkend;
    end
    
    result(trial).trial=trial;
    result(trial).ques=ques_str{trial};
    result(trial).subres=subres;
    result(trial).rating=rating;
    
    drawfix(w,fix_size,xc,yc,fix_color);
    Screen('Flip',w);
    WaitSecs(time3);
end

while 1
    drawcenteredtext_dot(w,'�������뱣�ַ��ɣ�ͷ��Ҫ��',xc,yc-50,255,text_size);
    drawcenteredtext_dot(w,'�ȴ�����ɨ�����',xc,yc+80,255,text_size);
    Screen('Flip',w);
    [~,~,kc]=KbCheck;
    if kc(27)
        ListenChar(0);
        ShowCursor;
        sca;
        break;
    end
end
save(expname);
%%
return



