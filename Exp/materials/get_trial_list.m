function init_ball2sub=get_trial_list

%首先获取包容阶段的序列
while 1
    temp1=Shuffle([ones(1,15),zeros(1,45)]);  %由被试投球的试次
    if temp1(1)==1 || temp1(end)==1
        continue
    end
    if any(diff(find(temp1))==1)
        continue
    end
    break;
end
temp1=temp1*2;
%0表示电脑来投球，2表示被试来投球
%因此，一个0后方如果还是0，则表示球由电脑投给电脑
%而如果0后方是2，则球会由电脑投给被试

%获取排斥阶段的前十个试次的序列
while 1
    temp2=Shuffle([ones(1,3),zeros(1,7)]);  %由被试投球的试次
    if temp2(1)==1 || temp2(end)==1
        continue
    end
    if any(diff(find(temp2))==1)
        continue
    end
    break;
end
temp2=temp2*2;

init_ball2sub=[temp1,temp2,zeros(1,50)];

