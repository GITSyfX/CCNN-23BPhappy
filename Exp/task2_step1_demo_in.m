%演示投球，但这个脚本里被试角色也会参与投球

clear;clc;rng('Shuffle');
addpath('materials'); addpath('profile');
load('4player\all_gif.mat');
load('subinfo.mat');

%% 显示效果参数
play_ground_width=800; %操场宽度(高度成比例增加)
profile_gap_ground=20; %头像与操场之间的空隙尺寸
profile_size=150;  %游戏界面里的头像尺寸
name_gap_profile=0.8; %头像与名字之间的空隙，值越大空隙越大

fix_size=80; %注视点尺寸

bgc=255; %背景颜色
skip=0; %同步性测试

time3=10; %初始以及结束的10秒空屏
time_rest=3; %静息态时长
time4=4; %演示画面提示时间
trial_time=2; %单个试次的时长 包含静止时间+球运动时间
act_time=0.5; %球运动时间（包含在单个试次内）

%%  打开屏幕
sub=inputdlg({'被试编号'});
subID=sub{1};
clock0 = fix(clock);
f = sprintf('%04d%02d%02d%02d%02d%02d',clock0(1),clock0(2),clock0(3),clock0(4),clock0(5),clock0(6));
expname=[pwd,'/record/',f,'_subID-',subID,' cyber_ball_demo.mat'] ;
[w,wrect,hz,xc,yc]=init_screen(bgc,skip,60);

%% 试次信息
init_ball2sub=get_trial_list;
init_ball2sub=init_ball2sub(1:60); %给被试15次投球机会，但不允许被试做出反应

% init_ball2sub=zeros(1,60);  %全0序列表示被试不会投球
%% 显示信息
act_time_frame=act_time*60;  %扔球帧数中用于呈现运动动画的帧数

play_ground_height=play_ground_width/450*250; %呈现高度

play_ground_rect=CenterRectOnPoint([0 0 play_ground_width play_ground_height],xc,yc);
play_ground_rect_for_img=CenterRectOnPoint([0 0 play_ground_width play_ground_height]*0.95,xc,yc);

xL=xc-play_ground_width/2-profile_size/2-profile_gap_ground;
xR=xc+play_ground_width/2+profile_size/2+profile_gap_ground;
yU=yc-play_ground_height/2-profile_size/2-profile_gap_ground;
yD=yc+play_ground_height/2+profile_size/2+profile_gap_ground;

%1234表示左下右上四个玩家
profile_rect(:,1)= CenterRectOnPoint([0 0 profile_size profile_size],xL,yc)';
profile_rect(:,2)= CenterRectOnPoint([0 0 profile_size profile_size],xc,yD)';
profile_rect(:,3)= CenterRectOnPoint([0 0 profile_size profile_size],xR,yc)';
profile_rect(:,4)= CenterRectOnPoint([0 0 profile_size profile_size],xc,yU)';

name_posi(:,1)=[xL,yc+profile_size*name_gap_profile];
name_posi(:,2)=[xc, yD+profile_size*name_gap_profile];
name_posi(:,3)=[xR,yc+profile_size*name_gap_profile];
name_posi(:,4)=[xc, yU-profile_size*name_gap_profile];

%%  参与者信息
sub_name=subinfo{1};
sub_profile_code=subinfo{5};

player_name={'玩家1','玩家3','玩家2'};
player_name={player_name{1},sub_name,player_name{2:3}};

result=[];
%% 读取图片

%随机获取4个图像
all_profile=dir('profile\*.png');
all_profile=Shuffle(all_profile);
for i=1:3
    array=imread(['profile\',all_profile(i).name]);
    profile_texid(i)=Screen('MakeTexture',w,array);
end
%获取被试头像
array=imread(['profile\',num2str(sub_profile_code),'.png']);
profile_texid(4)=Screen('MakeTexture',w,array);
profile_texid=profile_texid([1,4,2,3]);

%读取gif
for i=1:length(all_gif)
    this_array=all_gif(i).this_array;
    this_name=all_gif(i).name;
    texids=[];
    for j=1:size(this_array,2)
        img = ind2rgb(this_array{1,j},this_array{2,j});
        img =img .*255;
        texids(j)=Screen('MakeTexture',w,img);
    end
    all_gif(i).texids=texids;
    all_gif(i).code=str2num(this_name(1));
end

%% 生成bg
Screen('Flip',w);
Screen('DrawTextures',w,profile_texid,[],profile_rect);
for i=1:4
    drawcenteredtext_dot(w,player_name{i},name_posi(1,i),name_posi(2,i),0,30);
end
Screen('FrameRect',w,155, profile_rect ,3);
Screen('FrameRect',w,55, play_ground_rect ,3);

img=Screen('GetImage',w,[],'backbuffer');
bg_texid=Screen('MakeTexture',w,img);

Screen('FillRect',w,bgc);
Screen('Flip',w);

%% 等待开始(S触发)
Screen('FillRect',w,bgc);
drawcenteredtext_dot(w,'下面请观看投球游戏的演示画面',xc,yc,0,30);
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
    Screen('DrawTexture',w,bg_texid);
    drawfix(w,fix_size,xc,yc,0);
    Screen('Flip',w);
    checkend;
end

%% 实验开始
ball2sub=init_ball2sub;
ball2sub(end+1)=0;
ball2sub(1)=1; %第一个试次里由玩家1号进行投球

for trial=1:60
    
    trial_start_time=GetSecs;
    now_ball=ball2sub(trial); %当前谁来投球
    next_ball=ball2sub(trial+1); %初步获取球要投给谁
    %如果是电脑来投球，如果下一个玩家是被试，则直接投给被试，如果下一个玩家是电脑，则随机选择一个电脑
    %如果是玩家来投球，则下一个玩家必然是电脑，此时随机选择一个电脑， 如果被试有明确选择，则使用被试的选择。
    if next_ball==0
        next_ball=randsample([1,3,4],1);
        while next_ball==now_ball
            next_ball=randsample([1,3,4],1);
        end
    end
    ball2sub(trial+1)=next_ball; %将下一个序列信息更新为next_ball
    %获取动画名称以及动画序列
    [this_texids,frame_info,ready_texid]=get_frame_info(now_ball,next_ball,all_gif,act_time_frame);
    time_record(1,trial)=GetSecs-trial_start_time;
    
    Screen('DrawTexture',w,bg_texid);
    Screen('DrawTexture',w, ready_texid ,[],play_ground_rect_for_img);
    [~,onset]=Screen('Flip',w);
    time_record(2,trial)=GetSecs-onset;

    while 1
        if GetSecs-onset>trial_time-act_time-0.5/hz
            break;
        end
        checkend;
    end
    
    for flip=1:length(frame_info)
        Screen('DrawTexture',w,bg_texid);
        Screen('DrawTexture',w, this_texids(frame_info(flip))  ,[],play_ground_rect_for_img);
        Screen('Flip',w);
        if flip==1
            time_record(3,trial)=GetSecs-trial_start_time;
        end
        checkend;
    end
    
    time_record(4,trial)=GetSecs-trial_start_time;
    
    result(trial).trial=trial;
    result(trial).now_ball=now_ball;
    result(trial).next_ball=next_ball;
    result(trial).trial_dur=GetSecs-trial_start_time;
    result(trial).trial_end_time=GetSecs-start_time;
    
end
%%
for i=1:hz*time3
    Screen('DrawTexture',w,bg_texid);
    drawfix(w,fix_size,xc,yc,0);
    Screen('Flip',w);
    checkend;
end

%%
ListenChar(0);
ShowCursor;
sca;
save(expname);
return










