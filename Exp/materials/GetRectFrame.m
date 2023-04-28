function RectFrame=GetRectFrame(bxc,byc,rw,rh,rwg,rhg,rwn,rhn)
%选框阵列的中心x，选框阵列的中心y，选框宽度，选框高， 选框横间隔，选框纵间隔，选框横数量，选框纵数量

w=0:rwg+rw:(rwg+rw)*(rwn-1);
h=0:rhg+rh:(rhg+rh)*(rhn-1);

fulldot=fullfact([rwn,rhn]);

dots(1,:)=w(fulldot(:,1)); %横坐标
dots(2,:)=h(fulldot(:,2)); %纵坐标

bw=rwn*(rw+rwg)-rwg; %总高度
bh=rhn*(rh+rhg)-rhg; %总宽度

cx=bxc-bw/2; %横轴偏移量
cy=byc-bh/2; %纵轴偏移量


dots(1,:)=dots(1,:)+rw/2+cx;  %校正
dots(2,:)=dots(2,:)+rh/2+cy;

RectFrame=[dots(1,:)-rw/2;dots(2,:)-rh/2;dots(1,:)+rw/2;dots(2,:)+rh/2];


