function [white,csf,gry]=segment2(f,nimage)
%this program fisrt find max of histogram and then partition the image in 2
%and then segment wht and gry and csf
% % % % % clc;
% % % % % clear all;
% % % % % mypath;
% % % % % m=1;
% % % for slice_num=70:10:150
% % % %%%%%%%%%%%%%%%%%%%%%%INPUT: image PD
% % % images = mireadimages ('F:\betsabeh\volumetry\segmentation\matlab\data\phantom\nromal\1mm\pd_icbm_normal_1mm_pn0_rf0.mnc',slice_num);
% % % PD = reshape (images, 181, 217);
% % % figure,
% % % [fig_handle, image_handle, bar_handle] = viewimage (PD);
% % % title('real image')
% % % %PD = wiener2(PD);
% % % % pause
% % % [row,col] = size(PD);
% % % fmin  = min(PD(:));
% % % fmax  = max(PD(:));
% % % PD= (PD-fmin)/(fmax-fmin);  % Normalize f to the range [0,1]
% % % PD=PD*255;
% % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % %nimage(i,j)=1==csf
% % % %nimage(i,j)=2==gray
% % % %nimage(i,j)=3==white
% % % images = mireadimages ('F:\betsabeh\volumetry\segmentation\matlab\data\phantom\noram_part\phantom_1[1].0mm_normal_crisp.mnc',slice_num);
% % % nimage = reshape (images, 181, 217);
% % % figure,
% % % [fig_handle, image_handle, bar_handle] = viewimage (nimage)
% % % title('crisp brain ')
% % % for i=1:row
% % %     for j=1:col
% % %         if((nimage(i,j)==1)||(nimage(i,j)==2)||(nimage(i,j)==3))
% % %             f(i,j)=PD(i,j);
% % %         else
% % %             f(i,j)=0;
% % %         end
% % %     end
% % % end
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
% figure,
% [fig_handle, image_handle, bar_handle] = viewimage (first)
% figure,
% [fig_handle, image_handle, bar_handle] = viewimage (second)

% result1=different_threshol_method(first);%include wht and gry for pd
% result2=different_threshol_method(second);%include csf and gry for pd
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
max_TP=0;
class=max(max(result1));
low=min(min(result1));
for k=low:class
    cor=0;
    for i=1:row
        for j=1:col
              if((result1(i,j)==k)&&(nimage(i,j)==3))%white
                   cor=cor+1;
              end
          end
      end
[o,p]=find(nimage==3);
NR=size(o,1);
TP=cor/NR;
%FP
[o,p]=find(result1==k);
NB=size(o,1);
FP=(NB-cor)/NR;
%OM
OM=TP/(1+FP);
TN=1-FP;
FN=1-TP;
acc=(TN+TP)/(TN+TP+abs(FN)+abs(FP));
if (TP>max_TP)
    max_acc=acc;
    max_TP=TP;
    cl=k;
end
end
for i=1:row
    for j=1:col
        if (result1(i,j)==cl)
            white(i,j)=f(i,j);
        else
            white(i,j)=0;
        end
    end
end

acc_wht=max_acc;
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
max_TP=0;
class=max(max(result2));
low=min(min(result2));
for k=low:class
    cor=0;
    for i=1:row
        for j=1:col
              if((result2(i,j)==k)&&(nimage(i,j)==1))%csf
                   cor=cor+1;
              end
          end
      end
[o,p]=find(nimage==1);
NR=size(o,1);
TP=cor/NR;
%FP
[o,p]=find(result2==k);
NB=size(o,1);
FP=(NB-cor)/NR;
%OM
OM=TP/(1+FP);
TN=1-FP;
FN=1-TP;
acc=(TN+TP)/(TN+TP+abs(FN)+abs(FP));
if (TP>max_TP)
    max_acc=acc;
    max_TP=TP;
    cl=k;
end
end
for i=1:row
    for j=1:col
        if (result2(i,j)==cl)
            csf(i,j)=f(i,j);
        else
            csf(i,j)=0;
        end
    end
end

acc_csf=max_acc;
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
        if ((result1(i,j)==gry_ind(1))||(result2(i,j)==gry_ind(2)))&&(nimage(i,j)==2)
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
acc_gry=(TN+TP)/(TN+TP+abs(FN)+abs(FP));
% % % % % m=m+1;
% % % % % close all;
% % % % % 
% % % % % 
% end