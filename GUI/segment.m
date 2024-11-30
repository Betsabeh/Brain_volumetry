function [white,csf,gry]=segment(f,nimage)
%this program fisrt find max of histogram and then partition the image in 2
%and then segment wht and gry and csf

[row,col] = size(f);
h=my_hist(round(f));
h(1)=0;
h=smooth(h);
h=smooth(h);
h=smooth(h);
[max_v,max_in]=lmax(h);
[val1,ind1]=max(max_v);
t(1)=max_in(ind1);
max_v(ind1)=0;
[val1,ind1]=max(max_v);
t(2)=max_in(ind1);
max_v(ind1)=0;
[val1,ind1]=max(max_v);
t(3)=max_in(ind1);
t=sort(t);

for i=1:row
    for j=1:col
        if (f(i,j)>=t(2))
            first(i,j)=f(i,j);
            second(i,j)=0;
        else
            first(i,j)=0;
            second(i,j)=f(i,j); 
        end
    end
end
% % % figure,
% % % [fig_handle, image_handle, bar_handle] = viewimage (first)
% % % figure,
% % % [fig_handle, image_handle, bar_handle] = viewimage (second)
% % % % % % 
% % % % % % result1=different_threshol_method(first);%include wht and gry for pd
% % % % % % result2=different_threshol_method(second);%include csf and gry for pd

r=reshape(first,1,row*col);
class=3;
[CENTER, U, OBJ_FCN] = FCM(r',class) ;
[o,p]=max(U);
result1=reshape(p,row,col);

 r=reshape(second,1,row*col);
[CENTER, U, OBJ_FCN] = FCM(r',class) ;
[o,p]=max(U);
result2=reshape(p,row,col);

%%%%%%%%%%%%%%%accuracy
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%wht
low=min(min(result1));
[x1,y1]=find(result1==1);
n1=size(x1,1);
s=0;
for i=1:n1
    s=s+f(x1(i),y1(i));
end
avg1=s/n1;

[x2,y2]=find(result1==2);
n2=size(x2,1);
s=0;
for i=1:n2
    s=s+f(x2(i),y2(i));
end
avg2=s/n2;

[x3,y3]=find(result1==3);
n3=size(x3,1);
s=0;
for i=1:n3
    s=s+f(x3(i),y3(i));
end
avg3=s/n3;
a=[avg1,avg2,avg3];
[val,ind]=max(a);
cl=ind;
cor=0;
    for i=1:row
        for j=1:col
              if(result1(i,j)==cl)%%&&(nimage(i,j)==3)%white
                   cor=cor+1;
                   white(i,j)=f(i,j);
              else
                  white(i,j)=0;
              end
          end
    end
[o,p]=find(nimage==3);
NR=size(o,1);
TP=cor/NR;
%FP
[o,p]=find(result1~=cl);
NB=size(o,1);
FP=(NB-cor)/NR;
%OM
OM=TP/(1+FP);
TN=1-FP;
FN=1-TP;
acc_wht=(TN+TP)/(TN+TP+abs(FN)+abs(FP));

gry_num=39277;
for i=low:class
    if(i~=cl)
        num=size(find(result1==i));
        if (num(1)<gry_num)
            gry_num=num(1);
            gry_ind(1)=i;
        end
    end
end
   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%csf
low=min(min(result2));
[x1,y1]=find(result2==1);
n1=size(x1,1);
s=0;
for i=1:n1
    s=s+f(x1(i),y1(i));
end
avg1=s/n1;

[x2,y2]=find(result2==2);
n2=size(x2,1);
s=0;
for i=1:n2
    s=s+f(x2(i),y2(i));
end
avg2=s/n2;

[x3,y3]=find(result2==3);
n3=size(x3,1);
s=0;
for i=1:n3
    s=s+f(x3(i),y3(i));
end
avg3=s/n3;
a=[avg1,avg2,avg3];
[val,ind]=min(a);
cl=ind;
cor=0;
for i=1:row
    for j=1:col
        if(result2(i,j)==cl )%%%&&(nimage(i,j)==1)%csf
            cor=cor+1;
            csf(i,j)=f(i,j);
        else
            csf(i,j)=0;
        end
    end
end
[o,p]=find(nimage==1);
NR=size(o,1);
TP=cor/NR;
%FP
[o,p]=find(result2~=cl);
NB=size(o,1);
FP=(NB-cor)/NR;
%OM
OM=TP/(1+FP);
TN=1-FP;
FN=1-TP;
acc_csf=(TN+TP)/(TN+TP+abs(FN)+abs(FP));

gry_num=39277;
for i=low:class
    if(i~=cl)
        num=size(find(result2==i));
        if (num(1)<gry_num)
            gry_num=num(1);
            gry_ind(2)=i;
        end
    end
end
   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%gry
cor=0;
for i=1:row
    for j=1:col
        if ((result1(i,j)==gry_ind(1))||(result2(i,j)==gry_ind(2)))%%&&(nimage(i,j)==2)
            cor=cor+1;
            gry(i,j)=f(i,j);
        else
            gry(i,j)=0;
        end
    end
end
[o,p]=find(nimage==2);
NR=size(o,1);
TP=cor/NR;
%FP
[o,p]=find(result1==gry_ind(1));
NB=size(o,1);
[o,p]=find(result2==gry_ind(2));
NB=size(o,1)+NB;
FP=(NB-cor)/NR;
%OM
OM=TP/(1+FP);
TN=1-FP;
FN=1-TP;
tp_gry=TP;
fp_gry=FP;
acc_gry=(TN+TP)/(TN+TP+abs(FN)+abs(FP));

