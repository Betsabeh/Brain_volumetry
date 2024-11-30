function [acc,acc_csf,acc_gry,acc_white]=accuracy(real_seg,test_seg)
%%%%%%%%%%%find accuracy of brain
[o,p]=find(test_seg==1);
n1=size(o,1);
[o,p]=find(test_seg==2);
n2=size(o,1);
[o,p]=find(test_seg==3);
n3=size(o,1);
[o,p]=find(test_seg==4);
n4=size(o,1);
num=[n1 n2 n3 n4];
[val,ind]=max(num);
[row,col]=size(test_seg);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%find the accuracy of bain
    cor=0;
    for i=1:row
        for j=1:col
            if((test_seg(i,j)~=ind)&&(real_seg(i,j)==1)||(real_seg(i,j)==2)||(real_seg(i,j)==3))
                  cor=cor+1;
                
            end
              if(test_seg(i,j)~=ind)
                  n(i,j)=1;
              else
                  n(i,j)=0;
              end
          end
      end
NR=size(find(real_seg==1),1)+size(find(real_seg==2),1)+size(find(real_seg==3),1);
TP=cor/NR
%FP
[o,p]=find(test_seg~=ind);
NB=size(o,1);
FP=abs(NB-cor)/NR
%OM
OM=TP/(1+FP)
TN=1-FP;
FN=1-TP;
acc=(TN+TP)/(TN+TP+abs(FN)+abs(FP));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%csf accuracy
  cor=0;
    for i=1:row
        for j=1:col
            if((test_seg(i,j)==1)&&(real_seg(i,j)==1))
                  cor=cor+1;
              end
          end
      end
NR=size(find(real_seg==1),1);
TP=cor/NR;
%FP
[o,p]=find(test_seg==1);
NB=size(o,1);
FP=abs(NB-cor)/NR;
%OM
OM=TP/(1+FP);
TN=1-FP;
FN=1-TP;
acc_csf=(TN+TP)/(TN+TP+abs(FN)+abs(FP));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%gray accuracy
 cor=0;
    for i=1:row
        for j=1:col
            if((test_seg(i,j)==2)&&(real_seg(i,j)==2))
                  cor=cor+1;
              end
          end
      end
NR=size(find(real_seg==2),1);
TP=cor/NR;
%FP
[o,p]=find(test_seg==2);
NB=size(o,1);
FP=abs(NB-cor)/NR;
%OM
OM=TP/(1+FP);
TN=1-FP;
FN=1-TP;
acc_gry=(TN+TP)/(TN+TP+abs(FN)+abs(FP));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%white accuracy
 cor=0;
    for i=1:row
        for j=1:col
            if((test_seg(i,j)==3)&&(real_seg(i,j)==3))
                  cor=cor+1;
              end
          end
      end
NR=size(find(real_seg==3),1);
TP=cor/NR;
%FP
[o,p]=find(test_seg==3);
NB=size(o,1);
FP=abs(NB-cor)/NR;
%OM
OM=TP/(1+FP);
TN=1-FP;
FN=1-TP;
acc_white=(TN+TP)/(TN+TP+abs(FN)+abs(FP));
%%%%