function trial_list=get_trial_list_for_risky_decision(trial_num,rating_num)

%安排rating_num个评分分布在trial_num个trial里

%  安排12个评分分布在30个trial里， 保证间隔为2-3个，第1个最后一个tirla必然有一个评分
% 因此 从2、3中随机选择(rating_num-1)个数字，保证相加为30

while 1
    temp=randsample([2,3],1);
    for i=2:(rating_num-1)
        if mean(temp)*(rating_num-1)>=trial_num
            temp(i)=2;
        elseif mean(temp)*(rating_num-1)<trial_num
            temp(i)=3;
        end
    end
    if sum(temp)==trial_num
        break;
    end
end

trial_list=ones(1,trial_num);
trial_list(2,cumsum(temp))=2;
trial_list=[[0;2],trial_list];
trial_list=reshape(trial_list,1,[]);
trial_list(trial_list==0)=[];

%生成trial类别
list=fullfact([3,5,trial_num/3/5]); %三个条件，5种金钱
list=Shuffle(list,2);
inx=trial_list==1;
inx2=trial_list==2;

trial_list(2,inx)=list(:,1)';
trial_list(3,inx)=list(:,2)';

trial_list(4,inx)=1:trial_num;
trial_list(4,inx2)=1:rating_num;

%第一行， 1表示trial， 2表示rating
%第二行，数字表示第几种条件
%第三行， 数字表示这个条件下的第几个基准金钱（混合里的gain金钱， 必赢里的certainty金钱，必输里的certainty金钱）
%第四行，第几个trial或者rating