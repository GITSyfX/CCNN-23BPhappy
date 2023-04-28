clear;clc;rng('Shuffle');
addpath('materials'); addpath('profile');

%获取被试信息
subinfo=inputdlg({'姓名','性别','兴趣','理想'},'信息录入',[1,1,3,3]);

[w,wrect,hz,xc,yc]=init_screen(255,2);

RectFrame=GetRectFrame(xc,yc,200,200,50,50,4,4);

%%
alljpg=dir('profile\*.png');
for i=1:length(alljpg)
    array=imread(['profile/',num2str(i),'.png']);
    texids(i)=Screen('MakeTexture',w,array);
end

%%
for i=1:length(alljpg)
    Screen('DrawTexture',w,texids(i),[],RectFrame(:,i));
    Screen('FrameRect',w,155,RectFrame(:,i),2);
end
Screen('Flip',w);

ShowCursor;
subresed=0;
while 1
    [mx,my,button,~]=GetMouse;
    if button(1)
        for i=1:length(alljpg)
            if IsInRect(mx,my,RectFrame(:,i)')
                subresed=i;
                break;
            end
        end
    end
    if subresed~=0
        break;
    end
end

%%
ListenChar(0);
ShowCursor;
sca;

subinfo{end+1}=subresed;
save('subinfo','subinfo');

