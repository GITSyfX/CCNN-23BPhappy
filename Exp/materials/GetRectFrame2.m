function RectFrame=GetRectFrame2(bxc,byc,rw,rh,rwg,rhg,rwn,rhn)

%����ű��ļ����C2C��
%ѡ�����е�����x��ѡ�����е�����y��ѡ���ȣ�ѡ��ߣ� ѡ�������ѡ���ݼ����ѡ���������ѡ��������


w=(rwn-1)*rwg;
w=linspace(0,w,rwn)-w/2;

h=(rhn-1)*rhg;
h=linspace(0,h,rhn)-h/2;

fulldot=fullfact([rwn,rhn]);

dots(1,:)=w(fulldot(:,1)); %������
dots(2,:)=h(fulldot(:,2)); %������

dots(1,:)=dots(1,:)+bxc;  %У��
dots(2,:)=dots(2,:)+byc;

RectFrame=[dots(1,:)-rw/2;dots(2,:)-rh/2;dots(1,:)+rw/2;dots(2,:)+rh/2];


