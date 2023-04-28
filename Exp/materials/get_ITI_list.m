function ITI_list=get_ITI_list(num)

% 42个ITI， 值从2 3 4 5中随机， 均值为3

while 1
    ITI_list=randsample([2 3 4 5],1);
    for i=2:num
        if mean(ITI_list)>=3
            ITI_list(i)=randsample([2 3],1);
        elseif mean(ITI_list)<3
            ITI_list(i)=randsample([4,5],1);
        end
    end
    if  mean(ITI_list)==3
        break;
    end
end