function [this_texids,frame_info,ready_texid]=get_frame_info(now_ball,next_ball,all_gif,act_time_frame)


%获取动画名称以及动画序列
gif_name=[num2str(now_ball),'to',num2str(next_ball),'.gif'];
inx=strcmp({all_gif.name},gif_name);
this_texids=all_gif(inx).texids;

%对于一个执球玩家，如果他会投给不同的玩家，那么他的起手姿势是不一样的
%为了避免这个混淆，我们在三种起手姿势里随机选择一个
while 1
    dice=randperm(4,1);
    if now_ball~=dice
        break;
    end
end
inx=strcmp( {all_gif.name},  [num2str(now_ball),'to',num2str(dice),'.gif'] );
ready_texid=all_gif(inx).texids(1);


%为序列做出安排
% play_frame_inx=floor(linspace(1,act_time_frame,length(this_texids)))

play_frame_inx=floor(linspace(1,act_time_frame,length(this_texids)+1));

frame_info=[];
m=1;
for i=1:act_time_frame
    frame_info(i)=m;
    if play_frame_inx(m)==i
        m=m+1;
    end
end
frame_info=frame_info-1;
frame_info(1)=1;

%ready_texid 准备画面 


