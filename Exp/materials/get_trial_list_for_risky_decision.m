function trial_list=get_trial_list_for_risky_decision(trial_num,rating_num)

%����rating_num�����ֲַ���trial_num��trial��

%  ����12�����ֲַ���30��trial� ��֤���Ϊ2-3������1�����һ��tirla��Ȼ��һ������
% ��� ��2��3�����ѡ��(rating_num-1)�����֣���֤���Ϊ30

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

%����trial���
list=fullfact([3,5,trial_num/3/5]); %����������5�ֽ�Ǯ
list=Shuffle(list,2);
inx=trial_list==1;
inx2=trial_list==2;

trial_list(2,inx)=list(:,1)';
trial_list(3,inx)=list(:,2)';

trial_list(4,inx)=1:trial_num;
trial_list(4,inx2)=1:rating_num;

%��һ�У� 1��ʾtrial�� 2��ʾrating
%�ڶ��У����ֱ�ʾ�ڼ�������
%�����У� ���ֱ�ʾ��������µĵڼ�����׼��Ǯ��������gain��Ǯ�� ��Ӯ���certainty��Ǯ���������certainty��Ǯ��
%�����У��ڼ���trial����rating