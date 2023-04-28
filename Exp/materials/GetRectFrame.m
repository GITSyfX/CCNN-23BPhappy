function RectFrame=GetRectFrame(bxc,byc,rw,rh,rwg,rhg,rwn,rhn)
%ѡ�����е�����x��ѡ�����е�����y��ѡ���ȣ�ѡ��ߣ� ѡ�������ѡ���ݼ����ѡ���������ѡ��������

w=0:rwg+rw:(rwg+rw)*(rwn-1);
h=0:rhg+rh:(rhg+rh)*(rhn-1);

fulldot=fullfact([rwn,rhn]);

dots(1,:)=w(fulldot(:,1)); %������
dots(2,:)=h(fulldot(:,2)); %������

bw=rwn*(rw+rwg)-rwg; %�ܸ߶�
bh=rhn*(rh+rhg)-rhg; %�ܿ��

cx=bxc-bw/2; %����ƫ����
cy=byc-bh/2; %����ƫ����


dots(1,:)=dots(1,:)+rw/2+cx;  %У��
dots(2,:)=dots(2,:)+rh/2+cy;

RectFrame=[dots(1,:)-rw/2;dots(2,:)-rh/2;dots(1,:)+rw/2;dots(2,:)+rh/2];


