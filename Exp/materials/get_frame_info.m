function [this_texids,frame_info,ready_texid]=get_frame_info(now_ball,next_ball,all_gif,act_time_frame)


%��ȡ���������Լ���������
gif_name=[num2str(now_ball),'to',num2str(next_ball),'.gif'];
inx=strcmp({all_gif.name},gif_name);
this_texids=all_gif(inx).texids;

%����һ��ִ����ң��������Ͷ����ͬ����ң���ô�������������ǲ�һ����
%Ϊ�˱�����������������������������������ѡ��һ��
while 1
    dice=randperm(4,1);
    if now_ball~=dice
        break;
    end
end
inx=strcmp( {all_gif.name},  [num2str(now_ball),'to',num2str(dice),'.gif'] );
ready_texid=all_gif(inx).texids(1);


%Ϊ������������
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

%ready_texid ׼������ 


