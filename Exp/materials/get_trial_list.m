function init_ball2sub=get_trial_list

%���Ȼ�ȡ���ݽ׶ε�����
while 1
    temp1=Shuffle([ones(1,15),zeros(1,45)]);  %�ɱ���Ͷ����Դ�
    if temp1(1)==1 || temp1(end)==1
        continue
    end
    if any(diff(find(temp1))==1)
        continue
    end
    break;
end
temp1=temp1*2;
%0��ʾ������Ͷ��2��ʾ������Ͷ��
%��ˣ�һ��0���������0�����ʾ���ɵ���Ͷ������
%�����0����2��������ɵ���Ͷ������

%��ȡ�ų�׶ε�ǰʮ���Դε�����
while 1
    temp2=Shuffle([ones(1,3),zeros(1,7)]);  %�ɱ���Ͷ����Դ�
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

