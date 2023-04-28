%用于进行前后侧

clear global ; clear ; clc; addpath('materials');

%%
ques_str={'愤怒','悲伤','沮丧','无助','焦虑','快乐','满足'};
ques_dy=200; %问题与屏幕中心的垂直距离
warnning_dy=-200;

rating_bar_L=800; %评分轴的长度
rating_ball_D=50;  %评分轴的小球直径
rating_bar_w=10; %评分轴宽度
option_dy=100; %非常不符合，一般，非常符合，垂直位置， 越大越靠下
pointer_color=[255 255 0]; %point颜色

fix_size=80; %注视点尺寸
fix_color=255; %注视点颜色

key_L=KbName('1!');
key_R=KbName('2@');
key_confirm=KbName('3#');

text_size=90;
init_time=5; %初始空屏时长
time1=10; %每道题最长10秒钟，超过后自动跳转下一题并提出警告信息，
time2=5; %如果5秒还没作答，则提示被试尽快确认
time3=2; %每道题回答完毕后的空屏时间

exp_hz=90; %刷新率
bgc=0; %背景颜色
skip=0; %同步性测试
%%
sub=inputdlg({'被试编号','pre_post'});
subID=sub{1};
clock0 = fix(clock);
f = sprintf('%04d%02d%02d%02d%02d%02d',clock0(1),clock0(2),clock0(3),clock0(4),clock0(5),clock0(6));
expname=[pwd,'/record/',f,'_subID-',subID,' ',sub{2},'_test.mat'] ;
[w,wrect,hz,xc,yc]=init_screen(bgc,skip,exp_hz);

%%
rating_ball_rect=GetRectFrame2(xc,yc,rating_ball_D,rating_ball_D,rating_bar_L,0,2,1);
rating_bar_rect=[xc-rating_bar_L/2,yc-rating_bar_w/2,xc+rating_bar_L/2,yc+rating_bar_w/2]; %
pointer_rect=GetRectFrame2(xc,yc,rating_ball_D,rating_ball_D,rating_bar_L/6,0,7,1); %7个评分位置


%%
drawcenteredtext_dot(w,'主试按S开始问卷填写',xc,yc,255,30);
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
    rating=4; %初始状态为4
    drawcenteredtext_dot(w,ques_str{trial},xc,yc-ques_dy,255,text_size);
    Screen('FillRect',w,255,rating_bar_rect);
    Screen('FillOval',w,255,rating_ball_rect);
    drawcenteredtext_dot(w,'非常不符合',xc-rating_bar_L/2,yc+option_dy,255,30);
    drawcenteredtext_dot(w,'非常符合',xc+rating_bar_L/2,yc+option_dy,255,30);
    drawcenteredtext_dot(w,'一般',xc,yc+option_dy,255,30);
    
    Screen('FillOval',w,pointer_color,pointer_rect(:,rating)); %评分轴
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
            drawcenteredtext_dot(w,'请尽快作答',xc,yc-warnning_dy,[255 100 100],text_size);
            Screen('FillRect',w,255,rating_bar_rect);
            Screen('FillOval',w,255,rating_ball_rect);
            drawcenteredtext_dot(w,'非常不符合',xc-rating_bar_L/2,yc+option_dy,255,30);
            drawcenteredtext_dot(w,'非常符合',xc+rating_bar_L/2,yc+option_dy,255,30);
            drawcenteredtext_dot(w,'一般',xc,yc+option_dy,255,30);
            Screen('FillOval',w,pointer_color,pointer_rect(:,rating)); %评分轴
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
                    drawcenteredtext_dot(w,'请尽快作答',xc,yc-warnning_dy,[255 100 100],text_size);
                end
                Screen('FillRect',w,255,rating_bar_rect);
                Screen('FillOval',w,255,rating_ball_rect);
                drawcenteredtext_dot(w,'非常不符合',xc-rating_bar_L/2,yc+option_dy,255,30);
                drawcenteredtext_dot(w,'非常符合',xc+rating_bar_L/2,yc+option_dy,255,30);
                drawcenteredtext_dot(w,'一般',xc,yc+option_dy,255,30);
                Screen('FillOval',w,pointer_color,pointer_rect(:,rating)); %评分轴
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
    drawcenteredtext_dot(w,'接下来请保持放松，头不要动',xc,yc-50,255,text_size);
    drawcenteredtext_dot(w,'等待本轮扫描结束',xc,yc+80,255,text_size);
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



