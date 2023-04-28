function RectFrame=GetRectFrame2(bxc,byc,rw,rh,rwg,rhg,rwn,rhn)

%这个脚本的间隔是C2C的
%选框阵列的中心x，选框阵列的中心y，选框宽度，选框高， 选框横间隔，选框纵间隔，选框横数量，选框纵数量


w=(rwn-1)*rwg;
w=linspace(0,w,rwn)-w/2;

h=(rhn-1)*rhg;
h=linspace(0,h,rhn)-h/2;

fulldot=fullfact([rwn,rhn]);

dots(1,:)=w(fulldot(:,1)); %横坐标
dots(2,:)=h(fulldot(:,2)); %纵坐标

dots(1,:)=dots(1,:)+bxc;  %校正
dots(2,:)=dots(2,:)+byc;

RectFrame=[dots(1,:)-rw/2;dots(2,:)-rh/2;dots(1,:)+rw/2;dots(2,:)+rh/2];


