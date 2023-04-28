%��ʾͶ�򣬵�����ű��ﱻ�Խ�ɫҲ�����Ͷ��

clear;clc;rng('Shuffle');
addpath('materials'); addpath('profile');
load('4player\all_gif.mat');
load('subinfo.mat');

%% ��ʾЧ������
play_ground_width=800; %�ٳ����(�߶ȳɱ�������)
profile_gap_ground=20; %ͷ����ٳ�֮��Ŀ�϶�ߴ�
profile_size=150;  %��Ϸ�������ͷ��ߴ�
name_gap_profile=0.8; %ͷ��������֮��Ŀ�϶��ֵԽ���϶Խ��

fix_size=80; %ע�ӵ�ߴ�

bgc=255; %������ɫ
skip=0; %ͬ���Բ���

time3=10; %��ʼ�Լ�������10�����
time_rest=3; %��Ϣ̬ʱ��
time4=4; %��ʾ������ʾʱ��
trial_time=2; %�����Դε�ʱ�� ������ֹʱ��+���˶�ʱ��
act_time=0.5; %���˶�ʱ�䣨�����ڵ����Դ��ڣ�

%%  ����Ļ
sub=inputdlg({'���Ա��'});
subID=sub{1};
clock0 = fix(clock);
f = sprintf('%04d%02d%02d%02d%02d%02d',clock0(1),clock0(2),clock0(3),clock0(4),clock0(5),clock0(6));
expname=[pwd,'/record/',f,'_subID-',subID,' cyber_ball_demo.mat'] ;
[w,wrect,hz,xc,yc]=init_screen(bgc,skip,60);

%% �Դ���Ϣ
init_ball2sub=get_trial_list;
init_ball2sub=init_ball2sub(1:60); %������15��Ͷ����ᣬ����������������Ӧ

% init_ball2sub=zeros(1,60);  %ȫ0���б�ʾ���Բ���Ͷ��
%% ��ʾ��Ϣ
act_time_frame=act_time*60;  %����֡�������ڳ����˶�������֡��

play_ground_height=play_ground_width/450*250; %���ָ߶�

play_ground_rect=CenterRectOnPoint([0 0 play_ground_width play_ground_height],xc,yc);
play_ground_rect_for_img=CenterRectOnPoint([0 0 play_ground_width play_ground_height]*0.95,xc,yc);

xL=xc-play_ground_width/2-profile_size/2-profile_gap_ground;
xR=xc+play_ground_width/2+profile_size/2+profile_gap_ground;
yU=yc-play_ground_height/2-profile_size/2-profile_gap_ground;
yD=yc+play_ground_height/2+profile_size/2+profile_gap_ground;

%1234��ʾ���������ĸ����
profile_rect(:,1)= CenterRectOnPoint([0 0 profile_size profile_size],xL,yc)';
profile_rect(:,2)= CenterRectOnPoint([0 0 profile_size profile_size],xc,yD)';
profile_rect(:,3)= CenterRectOnPoint([0 0 profile_size profile_size],xR,yc)';
profile_rect(:,4)= CenterRectOnPoint([0 0 profile_size profile_size],xc,yU)';

name_posi(:,1)=[xL,yc+profile_size*name_gap_profile];
name_posi(:,2)=[xc, yD+profile_size*name_gap_profile];
name_posi(:,3)=[xR,yc+profile_size*name_gap_profile];
name_posi(:,4)=[xc, yU-profile_size*name_gap_profile];

%%  ��������Ϣ
sub_name=subinfo{1};
sub_profile_code=subinfo{5};

player_name={'���1','���3','���2'};
player_name={player_name{1},sub_name,player_name{2:3}};

result=[];
%% ��ȡͼƬ

%�����ȡ4��ͼ��
all_profile=dir('profile\*.png');
all_profile=Shuffle(all_profile);
for i=1:3
    array=imread(['profile\',all_profile(i).name]);
    profile_texid(i)=Screen('MakeTexture',w,array);
end
%��ȡ����ͷ��
array=imread(['profile\',num2str(sub_profile_code),'.png']);
profile_texid(4)=Screen('MakeTexture',w,array);
profile_texid=profile_texid([1,4,2,3]);

%��ȡgif
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

%% ����bg
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

%% �ȴ���ʼ(S����)
Screen('FillRect',w,bgc);
drawcenteredtext_dot(w,'������ۿ�Ͷ����Ϸ����ʾ����',xc,yc,0,30);
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
    Screen('DrawTexture',w,bg_texid);
    drawfix(w,fix_size,xc,yc,0);
    Screen('Flip',w);
    checkend;
end

%% ʵ�鿪ʼ
ball2sub=init_ball2sub;
ball2sub(end+1)=0;
ball2sub(1)=1; %��һ���Դ��������1�Ž���Ͷ��

for trial=1:60
    
    trial_start_time=GetSecs;
    now_ball=ball2sub(trial); %��ǰ˭��Ͷ��
    next_ball=ball2sub(trial+1); %������ȡ��ҪͶ��˭
    %����ǵ�����Ͷ�������һ������Ǳ��ԣ���ֱ��Ͷ�����ԣ������һ������ǵ��ԣ������ѡ��һ������
    %����������Ͷ������һ����ұ�Ȼ�ǵ��ԣ���ʱ���ѡ��һ�����ԣ� �����������ȷѡ����ʹ�ñ��Ե�ѡ��
    if next_ball==0
        next_ball=randsample([1,3,4],1);
        while next_ball==now_ball
            next_ball=randsample([1,3,4],1);
        end
    end
    ball2sub(trial+1)=next_ball; %����һ��������Ϣ����Ϊnext_ball
    %��ȡ���������Լ���������
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










