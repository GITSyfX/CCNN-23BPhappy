%risky_decision的练习

clear;clc;rng('Shuffle');addpath('materials');

%%
mix_score=[30, 50, 80, 110 , 150];
mix_mul=[0.2, 0.3, 0.4, 0.52, 0.66, 0.82, 1, 1.2, 1.5, 2];
gain_score=[20, 30, 40, 50, 60];
loss_score=[-20, -30, -40, -50, -60];
gain_loss_mul=[1.68, 1.82, 2, 2.22, 2.48, 2.8, 3.16, 3.6, 4.2, 5 ];

now_score=500; %初始积分

fix_size=80; %注视点尺寸
fix_color=255; %注视点颜色
rect_size=300; %白色方块边长
rect_color=255; %白色方块颜色
text_size=60; %字体大小
text_color=0; %字体颜色

rect2xc=300; %白色方块中心与屏幕的水平距离
rect2yc=200;  %白色方块中心与屏幕的垂直距离

ques_str='你现在的心情怎么样？';
ques_dy=300; %问题与屏幕中心的垂直距离
rating_bar_L=800; %评分轴的长度
rating_ball_D=50;  %评分轴的小球直径
rating_bar_w=10; %评分轴宽度
option_dy=100; %非常开心，非常不开心的垂直位置， 越大越靠下
pointer_color=[255 255 0]; %point颜色

key_L=KbName('1!');
key_R=KbName('2@');

time1=3; %第一屏（最大值）
time2=1; %第二屏
time3=1; %第三屏

time5=1; %问被试有多开心，时间
time6=3; %被试打分，时间

init_time=3; %初始和结束的空屏时间

exp_hz=90; %刷新率
bgc=0; %背景颜色
skip=2; %同步性测试

%%  ------------------------以下代码请勿更改---------------------------
sub=inputdlg({'被试编号'});
subID=sub{1};
clock0 = fix(clock);
f = sprintf('%04d%02d%02d%02d%02d%02d',clock0(1),clock0(2),clock0(3),clock0(4),clock0(5),clock0(6));
expname=[pwd,'/record/',f,'_subID-',subID,' risky_decision_practice.mat'] ;

[w,wrect,hz,xc,yc]=init_screen(bgc,skip,exp_hz);

%%
RectFrame4=GetRectFrame2(xc,yc,rect_size,rect_size,rect2xc*2,rect2yc*2,2,2);
RectFrame2=GetRectFrame2(xc,yc,rect_size,rect_size,rect2xc*2,rect2yc*2,2,1);

uncertainty_rect_L=RectFrame4(:,[1,3]);  %左侧的上下两个白色方块
certainty_rect_R=RectFrame2(:,2); %右侧的单个白色方块

uncertainty_rect_R=RectFrame4(:,[2,4]);
certainty_rect_L=RectFrame2(:,1);

center_rect=[xc-rect_size/2,yc-rect_size/2,xc+rect_size/2,yc+rect_size/2]; %中央方块， 用于呈现惩罚刺激

rating_ball_rect=GetRectFrame2(xc,yc,rating_ball_D,rating_ball_D,rating_bar_L,0,2,1);
rating_bar_rect=[xc-rating_bar_L/2,yc-rating_bar_w/2,xc+rating_bar_L/2,yc+rating_bar_w/2]; %
pointer_rect=GetRectFrame2(xc,yc,rating_ball_D,rating_ball_D,rating_bar_L/6,0,7,1); %7个评分位置

trial_num=30;
rating_num=12;
trial_list=get_trial_list_for_risky_decision(trial_num,rating_num);
%第一行， 1表示trial， 2表示rating
%第二行，数字表示第几种条件
%第三行， 数字表示这个条件下的第几个基准金钱（混合里的gain金钱， 必赢里的certainty金钱，必输里的certainty金钱）
%第四行，第几个trial或者rating
prac_num=42; %练习数量  必须等于trial_num 和 rating_num 之和

%%
ITI_list=get_ITI_list(42); %获取42个ITI ,均值固定为3
ITI_list=ITI_list-1.5;  %整体时间减去1.5秒，加快练习速度

schedule=ITI_list;
for i=1:length(ITI_list)
    if trial_list(1,i)==1
        schedule(2,i)=time1+time2+time3;
    elseif trial_list(1,i)==2
        schedule(2,i)=time5+time6;
    end
end
dur_list=sum(schedule,1); %每个试次的持续时间
schedule=cumsum(sum(schedule,1),2)+init_time; %每个试次的结束时间戳

%%
drawcenteredtext_dot(w,['当前积分：',num2str(now_score)],wrect(3)-150,wrect(4)-50,255,25);
drawcenteredtext_dot(w,'按S开始练习',xc,yc,255,40);
Screen('Flip',w);
while 1
    [~,~,kc]=KbCheck;
    if kc(KbName('s'))
        break;
    end
end
allstart=GetSecs;


for flip=1:init_time*hz
    drawcenteredtext_dot(w,['当前积分：',num2str(now_score)],wrect(3)-150,wrect(4)-50,255,25);
    drawfix(w,fix_size,xc,yc,fix_color);
    Screen('Flip',w);
end

%%
for alltrial=1:prac_num
    thistrial=trial_list(:,alltrial);
    
    if thistrial(1)==2 %评分试次
        drawcenteredtext_dot(w,ques_str,xc,yc-ques_dy,255,text_size);
        drawfix(w,fix_size,xc,yc,fix_color);
        drawcenteredtext_dot(w,['当前积分：',num2str(now_score)],wrect(3)-150,wrect(4)-50,255,25);
        Screen('Flip',w);
        trial_onset=GetSecs-allstart;
        WaitSecs(time5-0.5/hz);
        
        rating=4; %初始状态为4
        drawcenteredtext_dot(w,ques_str,xc,yc-ques_dy,255,text_size);
        Screen('FillRect',w,255,rating_bar_rect);
        Screen('FillOval',w,255,rating_ball_rect);
        drawcenteredtext_dot(w,'非常不开心',xc-rating_bar_L/2,yc+option_dy,255,40);
        drawcenteredtext_dot(w,'非常开心',xc+rating_bar_L/2,yc+option_dy,255,40);
        Screen('FillOval',w,pointer_color,pointer_rect(:,rating)); %评分轴
        drawcenteredtext_dot(w,['当前积分：',num2str(now_score)],wrect(3)-150,wrect(4)-50,255,25);
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
                drawcenteredtext_dot(w,'非常不开心',xc-rating_bar_L/2,yc+option_dy,255,40);
                drawcenteredtext_dot(w,'非常开心',xc+rating_bar_L/2,yc+option_dy,255,40);
                Screen('FillOval',w,pointer_color,pointer_rect(:,rating)); %评分轴
                drawcenteredtext_dot(w,['当前积分：',num2str(now_score)],wrect(3)-150,wrect(4)-50,255,25);
                Screen('Flip',w);
            end
            
            lastkid=kid;
            checkend;
        end
        
        drawfix(w,fix_size,xc,yc,fix_color);
        drawcenteredtext_dot(w,['当前积分：',num2str(now_score)],wrect(3)-150,wrect(4)-50,255,25);
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
    if thistrial(2)==1 %混合条件
        certainty=0;
        gamble_gain=mix_score(thistrial(3));
        gamble_loss=gamble_gain*randsample(mix_mul,1);
        uncertainty=Shuffle([gamble_gain,-gamble_loss]);
    elseif thistrial(2)==2 %必胜条件
        certainty=gain_score(thistrial(3));
        uncertainty=[certainty*randsample(gain_loss_mul,1),0];
        uncertainty=Shuffle(uncertainty);
    elseif thistrial(2)==3 %必输条件
        certainty=loss_score(thistrial(3));
        uncertainty=[certainty*randsample(gain_loss_mul,1),0];
        uncertainty=Shuffle(uncertainty);
    end
    punish_score=min([certainty,uncertainty]);
    
    %%
    dice=randperm(2,1); %1表示左侧呈现certainly，右侧呈现uncertainty,  2则相反
    if dice==1 %左1右2
        Screen('FillRect',w,rect_color,certainty_rect_L);
        Screen('FillRect',w,rect_color,uncertainty_rect_R);
        drawcenteredtext(w,num2str(certainty), certainty_rect_L ,text_color,text_size);
        drawcenteredtext(w,num2str(uncertainty(1)), uncertainty_rect_R(:,1),text_color,text_size);
        drawcenteredtext(w,num2str(uncertainty(2)), uncertainty_rect_R(:,2) ,text_color,text_size);
    elseif dice==2 %左2 右1
        Screen('FillRect',w,rect_color,certainty_rect_R);
        Screen('FillRect',w,rect_color,uncertainty_rect_L);
        drawcenteredtext(w,num2str(certainty), certainty_rect_R,text_color,text_size);
        drawcenteredtext(w,num2str(uncertainty(1)), uncertainty_rect_L(:,1),text_color,text_size);
        drawcenteredtext(w,num2str(uncertainty(2)), uncertainty_rect_L(:,2) ,text_color,text_size);
    end
    drawfix(w,fix_size,xc,yc,fix_color);
    drawcenteredtext_dot(w,['当前积分：',num2str(now_score)],wrect(3)-150,wrect(4)-50,255,25);
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
            if kc(key_L) && dice==1 %被试选择确定侧
                subres=1;
            elseif kc(key_R) && dice==2  %被试选择确定侧
                subres=1;
            else
                subres=2; %被试选择不确定侧
            end
            break;
        end
        checkend;
    end
    
    %%
    gamble_reveal_time=[];
    if subres==0 %被试没做选择  直接给出最大惩罚
        this_score=punish_score;
        now_score=now_score+this_score;
        Screen('FillRect',w,rect_color,center_rect);
        drawcenteredtext(w,num2str(punish_score),center_rect,text_color,text_size);
        drawcenteredtext_dot(w,['当前积分：',num2str(now_score)],wrect(3)-150,wrect(4)-50,255,25);
        Screen('Flip',w);
        reveal_time=GetSecs-allstart;
        WaitSecs(time2+time3-0.5/hz);
        
    else %被试做了选择
        if dice==1 %左1右2
            if subres==1 %选择了确定侧， 则
                this_score=certainty;
                now_score=now_score+this_score;
                Screen('FillRect',w,rect_color,certainty_rect_L);
                drawcenteredtext(w,num2str(certainty), certainty_rect_L ,text_color,text_size);
                drawfix(w,fix_size,xc,yc,fix_color);
                drawcenteredtext_dot(w,['当前积分：',num2str(now_score)],wrect(3)-150,wrect(4)-50,255,25);
                Screen('Flip',w);
                reveal_time=GetSecs-allstart;
                WaitSecs(time2+time3-0.5/hz);
            elseif subres==2 %选择非确定侧
                Screen('FillRect',w,rect_color,uncertainty_rect_R);
                drawcenteredtext(w,num2str(uncertainty(1)), uncertainty_rect_R(:,1),text_color,text_size);
                drawcenteredtext(w,num2str(uncertainty(2)), uncertainty_rect_R(:,2) ,text_color,text_size);
                drawfix(w,fix_size,xc,yc,fix_color);
                drawcenteredtext_dot(w,['当前积分：',num2str(now_score)],wrect(3)-150,wrect(4)-50,255,25);
                Screen('Flip',w);
                reveal_time=GetSecs-allstart;
                WaitSecs(time2-0.5/hz);
                gamble_dice=randperm(2,1); %1表示返回赌博的上面的选项，2表示返回下面的
                this_score=uncertainty(gamble_dice);
                now_score=now_score+this_score;
                Screen('FillRect',w,rect_color,uncertainty_rect_R(:,gamble_dice));
                drawcenteredtext(w,num2str(uncertainty(gamble_dice)), uncertainty_rect_R(:,gamble_dice),text_color,text_size);
                drawfix(w,fix_size,xc,yc,fix_color);
                drawcenteredtext_dot(w,['当前积分：',num2str(now_score)],wrect(3)-150,wrect(4)-50,255,25);
                Screen('Flip',w);
                gamble_reveal_time=GetSecs-allstart;
                WaitSecs(time3-0.5/hz);
            end
        else %左2右1
            if subres==1 %选择了确定侧， 则
                this_score=certainty;
                now_score=now_score+this_score;
                Screen('FillRect',w,rect_color,certainty_rect_R);
                drawcenteredtext(w,num2str(certainty), certainty_rect_R,text_color,text_size);
                drawfix(w,fix_size,xc,yc,fix_color);
                drawcenteredtext_dot(w,['当前积分：',num2str(now_score)],wrect(3)-150,wrect(4)-50,255,25);
                Screen('Flip',w);
                reveal_time=GetSecs-allstart;
                WaitSecs(time2+time3-0.5/hz);
            elseif subres==2 %选择非确定侧
                Screen('FillRect',w,rect_color,uncertainty_rect_L);
                drawcenteredtext(w,num2str(uncertainty(1)), uncertainty_rect_L(:,1),text_color,text_size);
                drawcenteredtext(w,num2str(uncertainty(2)), uncertainty_rect_L(:,2) ,text_color,text_size);
                drawfix(w,fix_size,xc,yc,fix_color);
                drawcenteredtext_dot(w,['当前积分：',num2str(now_score)],wrect(3)-150,wrect(4)-50,255,25);
                Screen('Flip',w);
                reveal_time=GetSecs-allstart;
                WaitSecs(time2-0.5/hz);
                gamble_dice=randperm(2,1); %1表示返回赌博的上面的选项，2表示返回下面的
                this_score=uncertainty(gamble_dice);
                now_score=now_score+this_score;
                Screen('FillRect',w,rect_color,uncertainty_rect_L(:,gamble_dice));
                drawcenteredtext(w,num2str(uncertainty(gamble_dice)), uncertainty_rect_L(:,gamble_dice),text_color,text_size);
                drawfix(w,fix_size,xc,yc,fix_color);
                drawcenteredtext_dot(w,['当前积分：',num2str(now_score)],wrect(3)-150,wrect(4)-50,255,25);
                Screen('Flip',w);
                gamble_reveal_time=GetSecs-allstart;
                WaitSecs(time3-0.5/hz);
            end
        end
    end
    
    %%
    drawfix(w,fix_size,xc,yc,fix_color);
    drawcenteredtext_dot(w,['当前积分：',num2str(now_score)],wrect(3)-150,wrect(4)-50,255,25);
    Screen('Flip',w);
    result(alltrial).alltrial=alltrial;
    result(alltrial).trial_type=thistrial(1);  % 1表示trial， 2表示rating
    result(alltrial).num=thistrial(4); %第几个trial或者rating
    result(alltrial).rating=[];
    result(alltrial).trial_condition=thistrial(2); %1mix   2gain  3loss
    result(alltrial).certainty=certainty; %确定性选项里的分数
    result(alltrial).uncertainty=uncertainty; %不确定性选项里的分数
    result(alltrial).subres=subres; %被试的选择， 1表示选择确定性， 2表示选择不确定性， 0表示没选择
    result(alltrial).RT=RT; %反应时
    result(alltrial).this_score=this_score; %本次的最终积分
    result(alltrial).trial_onset=trial_onset; %这个试次呈现的时刻
    result(alltrial).reveal_time=reveal_time; %选择结果呈现时刻
    result(alltrial).gamble_reveal_time=gamble_reveal_time; %如果选择了赌博，则赌博结果呈现时刻
    result(alltrial).trial_dur=dur_list(alltrial); %本试次的持续时间
    result(alltrial).ideal_trial_end_time=schedule(alltrial); %本试次的预计结束时刻
    while 1
        if GetSecs-allstart>schedule(alltrial)-0.5/hz;
            break;
        end
    end
end

for flip=1:init_time*hz
    drawfix(w,fix_size,xc,yc,fix_color);
    drawcenteredtext_dot(w,['当前积分：',num2str(now_score)],wrect(3)-150,wrect(4)-50,255,25);
    Screen('Flip',w);
end
save(expname);
%%
ListenChar(0);
ShowCursor;
sca;















