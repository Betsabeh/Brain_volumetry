function [acc_csf,acc_gry,acc_white,om_csf,om_gry,om_white,TP_csf,FP_csf,TP_gry,FP_gry,TP_wht,FP_wht]=accuracy_3_parts(real_seg,csf,gry,wht)
[row,col]=size(real_seg);
% % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%find the accuracy of bain
% % % %     cor=0;
% % % %     for i=1:row
% % % %         for j=1:col
% % % %             if((test_seg(i,j)~=4)&&(test_seg(i,j)~=5)&&(real_seg(i,j)==1)||(real_seg(i,j)==2)||(real_seg(i,j)==3))
% % % %                   cor=cor+1; 
% % % %             end
% % % %             
% % % %           end
% % % %       end
% % % % NR=size(find(real_seg==1),1)+size(find(real_seg==2),1)+size(find(real_seg==3),1);
% % % % TP=cor/NR
% % % % %FP
% % % % NB=size(find(test_seg==1),1)+size(find(test_seg==2),1)+size(find(test_seg==3),1);
% % % % FP=abs(NB-cor)/NR
% % % % %OM
% % % % OM=TP/(1+FP)
% % % % TN=1-FP;
% % % % FN=1-TP;
% % % % acc=(TN+TP)/(TN+TP+FN+(FP));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%csf accuracy
cor=0;
for i=1:row
    for j=1:col
        if((csf(i,j)==1)&&(real_seg(i,j)==1))
              cor=cor+1;
          end
      end
  end
NR=size(find(real_seg==1),1);
if (NR==0)&&(cor==0)
    TP_csf=1;
else
    TP_csf=cor/NR
end
%FP
[o,p]=find(csf==1);
NB=size(o,1);
FP_csf=abs(NB-cor)/NR;
%OM
om_csf=TP_csf/(1+FP_csf);
TN_csf=1-FP_csf;
FN_csf=1-TP_csf;
acc_csf=(TN_csf+TP_csf)/(TN_csf+TP_csf+abs(FN_csf)+abs(FP_csf));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%gray accuracy
cor=0;
for i=1:row
    for j=1:col
        if((gry(i,j)==2)&&(real_seg(i,j)==2))
              cor=cor+1;
          end
      end
  end
NR=size(find(real_seg==2),1);
if (NR==0)&&(cor==0)
    TP_gry=1;
else
    TP_gry=cor/NR
end

%FP_gry
[o,p]=find(gry==2);
NB=size(o,1);
FP_gry=abs(NB-cor)/NR;
%OM
om_gry=TP_gry/(1+FP_gry);
TN_gry=1-FP_gry;
FN_gry=1-TP_gry;
acc_gry=(TN_gry+TP_gry)/(TN_gry+TP_gry+abs(FN_gry)+abs(FP_gry));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%white accuracy
cor=0;
for i=1:row
    for j=1:col
        if((wht(i,j)==3)&&(real_seg(i,j)==3))
              cor=cor+1;
          end
      end
  end
NR=size(find(real_seg==3),1);
if (NR==0)&&(cor==0)
    TP_wht=1;
else
    TP_wht=cor/NR
end

%FP_wht
[o,p]=find(wht==3);
NB=size(o,1);
FP_wht=abs(NB-cor)/NR;
%OM
om_white=TP_wht/(1+FP_wht);
TN_wht=1-FP_wht;
FN_wht=1-TP_wht;
acc_white=(TN_wht+TP_wht)/(TN_wht+TP_wht+abs(FN_wht)+abs(FP_wht));
