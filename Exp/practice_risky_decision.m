%risky_decision����ϰ

clear;clc;rng('Shuffle');addpath('materials');

%%
mix_score=[30, 50, 80, 110 , 150];
mix_mul=[0.2, 0.3, 0.4, 0.52, 0.66, 0.82, 1, 1.2, 1.5, 2];
gain_score=[20, 30, 40, 50, 60];
loss_score=[-20, -30, -40, -50, -60];
gain_loss_mul=[1.68, 1.82, 2, 2.22, 2.48, 2.8, 3.16, 3.6, 4.2, 5 ];

now_score=500; %��ʼ����

fix_size=80; %ע�ӵ�ߴ�
fix_color=255; %ע�ӵ���ɫ
rect_size=300; %��ɫ����߳�
rect_color=255; %��ɫ������ɫ
text_size=60; %�����С
text_color=0; %������ɫ

rect2xc=300; %��ɫ������������Ļ��ˮƽ����
rect2yc=200;  %��ɫ������������Ļ�Ĵ�ֱ����

ques_str='�����ڵ�������ô����';
ques_dy=300; %��������Ļ���ĵĴ�ֱ����
rating_bar_L=800; %������ĳ���
rating_ball_D=50;  %�������С��ֱ��
rating_bar_w=10; %��������
option_dy=100; %�ǳ����ģ��ǳ������ĵĴ�ֱλ�ã� Խ��Խ����
pointer_color=[255 255 0]; %point��ɫ

key_L=KbName('1!');
key_R=KbName('2@');

time1=3; %��һ�������ֵ��
time2=1; %�ڶ���
time3=1; %������

time5=1; %�ʱ����ж࿪�ģ�ʱ��
time6=3; %���Դ�֣�ʱ��

init_time=3; %��ʼ�ͽ����Ŀ���ʱ��

exp_hz=90; %ˢ����
bgc=0; %������ɫ
skip=2; %ͬ���Բ���

%%  ------------------------���´����������---------------------------
sub=inputdlg({'���Ա��'});
subID=sub{1};
clock0 = fix(clock);
f = sprintf('%04d%02d%02d%02d%02d%02d',clock0(1),clock0(2),clock0(3),clock0(4),clock0(5),clock0(6));
expname=[pwd,'/record/',f,'_subID-',subID,' risky_decision_practice.mat'] ;

[w,wrect,hz,xc,yc]=init_screen(bgc,skip,exp_hz);

%%
RectFrame4=GetRectFrame2(xc,yc,rect_size,rect_size,rect2xc*2,rect2yc*2,2,2);
RectFrame2=GetRectFrame2(xc,yc,rect_size,rect_size,rect2xc*2,rect2yc*2,2,1);

uncertainty_rect_L=RectFrame4(:,[1,3]);  %��������������ɫ����
certainty_rect_R=RectFrame2(:,2); %�Ҳ�ĵ�����ɫ����

uncertainty_rect_R=RectFrame4(:,[2,4]);
certainty_rect_L=RectFrame2(:,1);

center_rect=[xc-rect_size/2,yc-rect_size/2,xc+rect_size/2,yc+rect_size/2]; %���뷽�飬 ���ڳ��ֳͷ��̼�

rating_ball_rect=GetRectFrame2(xc,yc,rating_ball_D,rating_ball_D,rating_bar_L,0,2,1);
rating_bar_rect=[xc-rating_bar_L/2,yc-rating_bar_w/2,xc+rating_bar_L/2,yc+rating_bar_w/2]; %
pointer_rect=GetRectFrame2(xc,yc,rating_ball_D,rating_ball_D,rating_bar_L/6,0,7,1); %7������λ��

trial_num=30;
rating_num=12;
trial_list=get_trial_list_for_risky_decision(trial_num,rating_num);
%��һ�У� 1��ʾtrial�� 2��ʾrating
%�ڶ��У����ֱ�ʾ�ڼ�������
%�����У� ���ֱ�ʾ��������µĵڼ�����׼��Ǯ��������gain��Ǯ�� ��Ӯ���certainty��Ǯ���������certainty��Ǯ��
%�����У��ڼ���trial����rating
prac_num=42; %��ϰ����  �������trial_num �� rating_num ֮��

%%
ITI_list=get_ITI_list(42); %��ȡ42��ITI ,��ֵ�̶�Ϊ3
ITI_list=ITI_list-1.5;  %����ʱ���ȥ1.5�룬�ӿ���ϰ�ٶ�

schedule=ITI_list;
for i=1:length(ITI_list)
    if trial_list(1,i)==1
        schedule(2,i)=time1+time2+time3;
    elseif trial_list(1,i)==2
        schedule(2,i)=time5+time6;
    end
end
dur_list=sum(schedule,1); %ÿ���Դεĳ���ʱ��
schedule=cumsum(sum(schedule,1),2)+init_time; %ÿ���ԴεĽ���ʱ���

%%
drawcenteredtext_dot(w,['��ǰ���֣�',num2str(now_score)],wrect(3)-150,wrect(4)-50,255,25);
drawcenteredtext_dot(w,'��S��ʼ��ϰ',xc,yc,255,40);
Screen('Flip',w);
while 1
    [~,~,kc]=KbCheck;
    if kc(KbName('s'))
        break;
    end
end
allstart=GetSecs;


for flip=1:init_time*hz
    drawcenteredtext_dot(w,['��ǰ���֣�',num2str(now_score)],wrect(3)-150,wrect(4)-50,255,25);
    drawfix(w,fix_size,xc,yc,fix_color);
    Screen('Flip',w);
end

%%
for alltrial=1:prac_num
    thistrial=trial_list(:,alltrial);
    
    if thistrial(1)==2 %�����Դ�
        drawcenteredtext_dot(w,ques_str,xc,yc-ques_dy,255,text_size);
        drawfix(w,fix_size,xc,yc,fix_color);
        drawcenteredtext_dot(w,['��ǰ���֣�',num2str(now_score)],wrect(3)-150,wrect(4)-50,255,25);
        Screen('Flip',w);
        trial_onset=GetSecs-allstart;
        WaitSecs(time5-0.5/hz);
        
        rating=4; %��ʼ״̬Ϊ4
        drawcenteredtext_dot(w,ques_str,xc,yc-ques_dy,255,text_size);
        Screen('FillRect',w,255,rating_bar_rect);
        Screen('FillOval',w,255,rating_ball_rect);
        drawcenteredtext_dot(w,'�ǳ�������',xc-rating_bar_L/2,yc+option_dy,255,40);
        drawcenteredtext_dot(w,'�ǳ�����',xc+rating_bar_L/2,yc+option_dy,255,40);
        Screen('FillOval',w,pointer_color,pointer_rect(:,rating)); %������
        drawcenteredtext_dot(w,['��ǰ���֣�',num2str(now_score)],wrect(3)-150,wrect(4)-50,255,25);
        Screen('Flip',w);
        lastkid=0;
        rating_start=GetSecs;
        while 1
            if GetSecs-rating_start>time6
                break;
            end
            [kid,~,kc]=KbCheck;
            
            if lastkid==0 && (kc(key_L) || kc(key_R))
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
                drawcenteredtext_dot(w,ques_str,xc,yc-ques_dy,255,text_size);
                Screen('FillRect',w,255,rating_bar_rect);
                Screen('FillOval',w,255,rating_ball_rect);
                drawcenteredtext_dot(w,'�ǳ�������',xc-rating_bar_L/2,yc+option_dy,255,40);
                drawcenteredtext_dot(w,'�ǳ�����',xc+rating_bar_L/2,yc+option_dy,255,40);
                Screen('FillOval',w,pointer_color,pointer_rect(:,rating)); %������
                drawcenteredtext_dot(w,['��ǰ���֣�',num2str(now_score)],wrect(3)-150,wrect(4)-50,255,25);
                Screen('Flip',w);
            end
            
            lastkid=kid;
            checkend;
        end
        
        drawfix(w,fix_size,xc,yc,fix_color);
        drawcenteredtext_dot(w,['��ǰ���֣�',num2str(now_score)],wrect(3)-150,wrect(4)-50,255,25);
        Screen('Flip',w);
        result(alltrial).alltrial=alltrial;
        result(alltrial).trial_type=thistrial(1);
        result(alltrial).num=thistrial(4);
        result(alltrial).rating=rating;
        result(alltrial).trial_condition=[];
        result(alltrial).certainty=[];
        result(alltrial).uncertainty=[];
        result(alltrial).subres=[];
        result(alltrial).RT=[];
        result(alltrial).this_score=[];
        result(alltrial).trial_onset=trial_onset;
        result(alltrial).reveal_time=[];
        result(alltrial).gamble_reveal_time=[];
        result(alltrial).trial_dur=dur_list(alltrial);
        result(alltrial).ideal_trial_end_time=schedule(alltrial);
        while 1
            if GetSecs-allstart>schedule(alltrial)-0.5/hz;
                break;
            end
        end
        continue
    end
    
    %%
    if thistrial(2)==1 %�������
        certainty=0;
        gamble_gain=mix_score(thistrial(3));
        gamble_loss=gamble_gain*randsample(mix_mul,1);
        uncertainty=Shuffle([gamble_gain,-gamble_loss]);
    elseif thistrial(2)==2 %��ʤ����
        certainty=gain_score(thistrial(3));
        uncertainty=[certainty*randsample(gain_loss_mul,1),0];
        uncertainty=Shuffle(uncertainty);
    elseif thistrial(2)==3 %��������
        certainty=loss_score(thistrial(3));
        uncertainty=[certainty*randsample(gain_loss_mul,1),0];
        uncertainty=Shuffle(uncertainty);
    end
    punish_score=min([certainty,uncertainty]);
    
    %%
    dice=randperm(2,1); %1��ʾ������certainly���Ҳ����uncertainty,  2���෴
    if dice==1 %��1��2
        Screen('FillRect',w,rect_color,certainty_rect_L);
        Screen('FillRect',w,rect_color,uncertainty_rect_R);
        drawcenteredtext(w,num2str(certainty), certainty_rect_L ,text_color,text_size);
        drawcenteredtext(w,num2str(uncertainty(1)), uncertainty_rect_R(:,1),text_color,text_size);
        drawcenteredtext(w,num2str(uncertainty(2)), uncertainty_rect_R(:,2) ,text_color,text_size);
    elseif dice==2 %��2 ��1
        Screen('FillRect',w,rect_color,certainty_rect_R);
        Screen('FillRect',w,rect_color,uncertainty_rect_L);
        drawcenteredtext(w,num2str(certainty), certainty_rect_R,text_color,text_size);
        drawcenteredtext(w,num2str(uncertainty(1)), uncertainty_rect_L(:,1),text_color,text_size);
        drawcenteredtext(w,num2str(uncertainty(2)), uncertainty_rect_L(:,2) ,text_color,text_size);
    end
    drawfix(w,fix_size,xc,yc,fix_color);
    drawcenteredtext_dot(w,['��ǰ���֣�',num2str(now_score)],wrect(3)-150,wrect(4)-50,255,25);
    Screen('Flip',w);
    trial_onset=GetSecs-allstart;
    subres=0;
    RT=[];
    resstart=GetSecs;
    while 1
        if GetSecs-resstart>time1-0.5/hz
            break;
        end
        [~,~,kc]=KbCheck;
        if kc(key_L) || kc(key_R)
            RT=GetSecs-resstart;
            if kc(key_L) && dice==1 %����ѡ��ȷ����
                subres=1;
            elseif kc(key_R) && dice==2  %����ѡ��ȷ����
                subres=1;
            else
                subres=2; %����ѡ��ȷ����
            end
            break;
        end
        checkend;
    end
    
    %%
    gamble_reveal_time=[];
    if subres==0 %����û��ѡ��  ֱ�Ӹ������ͷ�
        this_score=punish_score;
        now_score=now_score+this_score;
        Screen('FillRect',w,rect_color,center_rect);
        drawcenteredtext(w,num2str(punish_score),center_rect,text_color,text_size);
        drawcenteredtext_dot(w,['��ǰ���֣�',num2str(now_score)],wrect(3)-150,wrect(4)-50,255,25);
        Screen('Flip',w);
        reveal_time=GetSecs-allstart;
        WaitSecs(time2+time3-0.5/hz);
        
    else %��������ѡ��
        if dice==1 %��1��2
            if subres==1 %ѡ����ȷ���࣬ ��
                this_score=certainty;
                now_score=now_score+this_score;
                Screen('FillRect',w,rect_color,certainty_rect_L);
                drawcenteredtext(w,num2str(certainty), certainty_rect_L ,text_color,text_size);
                drawfix(w,fix_size,xc,yc,fix_color);
                drawcenteredtext_dot(w,['��ǰ���֣�',num2str(now_score)],wrect(3)-150,wrect(4)-50,255,25);
                Screen('Flip',w);
                reveal_time=GetSecs-allstart;
                WaitSecs(time2+time3-0.5/hz);
            elseif subres==2 %ѡ���ȷ����
                Screen('FillRect',w,rect_color,uncertainty_rect_R);
                drawcenteredtext(w,num2str(uncertainty(1)), uncertainty_rect_R(:,1),text_color,text_size);
                drawcenteredtext(w,num2str(uncertainty(2)), uncertainty_rect_R(:,2) ,text_color,text_size);
                drawfix(w,fix_size,xc,yc,fix_color);
                drawcenteredtext_dot(w,['��ǰ���֣�',num2str(now_score)],wrect(3)-150,wrect(4)-50,255,25);
                Screen('Flip',w);
                reveal_time=GetSecs-allstart;
                WaitSecs(time2-0.5/hz);
                gamble_dice=randperm(2,1); %1��ʾ���ضĲ��������ѡ�2��ʾ���������
                this_score=uncertainty(gamble_dice);
                now_score=now_score+this_score;
                Screen('FillRect',w,rect_color,uncertainty_rect_R(:,gamble_dice));
                drawcenteredtext(w,num2str(uncertainty(gamble_dice)), uncertainty_rect_R(:,gamble_dice),text_color,text_size);
                drawfix(w,fix_size,xc,yc,fix_color);
                drawcenteredtext_dot(w,['��ǰ���֣�',num2str(now_score)],wrect(3)-150,wrect(4)-50,255,25);
                Screen('Flip',w);
                gamble_reveal_time=GetSecs-allstart;
                WaitSecs(time3-0.5/hz);
            end
        else %��2��1
            if subres==1 %ѡ����ȷ���࣬ ��
                this_score=certainty;
                now_score=now_score+this_score;
                Screen('FillRect',w,rect_color,certainty_rect_R);
                drawcenteredtext(w,num2str(certainty), certainty_rect_R,text_color,text_size);
                drawfix(w,fix_size,xc,yc,fix_color);
                drawcenteredtext_dot(w,['��ǰ���֣�',num2str(now_score)],wrect(3)-150,wrect(4)-50,255,25);
                Screen('Flip',w);
                reveal_time=GetSecs-allstart;
                WaitSecs(time2+time3-0.5/hz);
            elseif subres==2 %ѡ���ȷ����
                Screen('FillRect',w,rect_color,uncertainty_rect_L);
                drawcenteredtext(w,num2str(uncertainty(1)), uncertainty_rect_L(:,1),text_color,text_size);
                drawcenteredtext(w,num2str(uncertainty(2)), uncertainty_rect_L(:,2) ,text_color,text_size);
                drawfix(w,fix_size,xc,yc,fix_color);
                drawcenteredtext_dot(w,['��ǰ���֣�',num2str(now_score)],wrect(3)-150,wrect(4)-50,255,25);
                Screen('Flip',w);
                reveal_time=GetSecs-allstart;
                WaitSecs(time2-0.5/hz);
                gamble_dice=randperm(2,1); %1��ʾ���ضĲ��������ѡ�2��ʾ���������
                this_score=uncertainty(gamble_dice);
                now_score=now_score+this_score;
                Screen('FillRect',w,rect_color,uncertainty_rect_L(:,gamble_dice));
                drawcenteredtext(w,num2str(uncertainty(gamble_dice)), uncertainty_rect_L(:,gamble_dice),text_color,text_size);
                drawfix(w,fix_size,xc,yc,fix_color);
                drawcenteredtext_dot(w,['��ǰ���֣�',num2str(now_score)],wrect(3)-150,wrect(4)-50,255,25);
                Screen('Flip',w);
                gamble_reveal_time=GetSecs-allstart;
                WaitSecs(time3-0.5/hz);
            end
        end
    end
    
    %%
    drawfix(w,fix_size,xc,yc,fix_color);
    drawcenteredtext_dot(w,['��ǰ���֣�',num2str(now_score)],wrect(3)-150,wrect(4)-50,255,25);
    Screen('Flip',w);
    result(alltrial).alltrial=alltrial;
    result(alltrial).trial_type=thistrial(1);  % 1��ʾtrial�� 2��ʾrating
    result(alltrial).num=thistrial(4); %�ڼ���trial����rating
    result(alltrial).rating=[];
    result(alltrial).trial_condition=thistrial(2); %1mix   2gain  3loss
    result(alltrial).certainty=certainty; %ȷ����ѡ����ķ���
    result(alltrial).uncertainty=uncertainty; %��ȷ����ѡ����ķ���
    result(alltrial).subres=subres; %���Ե�ѡ�� 1��ʾѡ��ȷ���ԣ� 2��ʾѡ��ȷ���ԣ� 0��ʾûѡ��
    result(alltrial).RT=RT; %��Ӧʱ
    result(alltrial).this_score=this_score; %���ε����ջ���
    result(alltrial).trial_onset=trial_onset; %����Դγ��ֵ�ʱ��
    result(alltrial).reveal_time=reveal_time; %ѡ��������ʱ��
    result(alltrial).gamble_reveal_time=gamble_reveal_time; %���ѡ���˶Ĳ�����Ĳ��������ʱ��
    result(alltrial).trial_dur=dur_list(alltrial); %���Դεĳ���ʱ��
    result(alltrial).ideal_trial_end_time=schedule(alltrial); %���Դε�Ԥ�ƽ���ʱ��
    while 1
        if GetSecs-allstart>schedule(alltrial)-0.5/hz;
            break;
        end
    end
end

for flip=1:init_time*hz
    drawfix(w,fix_size,xc,yc,fix_color);
    drawcenteredtext_dot(w,['��ǰ���֣�',num2str(now_score)],wrect(3)-150,wrect(4)-50,255,25);
    Screen('Flip',w);
end
save(expname);
%%
ListenChar(0);
ShowCursor;
sca;















