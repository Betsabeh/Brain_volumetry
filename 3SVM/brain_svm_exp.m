clc;
clear all;
close all;
mypath;
row=181;
col=217;
m=1;
K=1;
s_num=70;
test_data = mireadimages ('h:\betsabeh\my_project\volumetry\matlab\data\phantom\nromal\1mm\t1_icbm_normal_1mm_pn0_rf0.mnc',s_num);
test_image=reshape(test_data,row,col);
[bin,s_test,TP(m),FN(m),FP(m),TN(m),OM(m),ACC(m)]=skull_strip2(test_image,s_num);
im2=s_test.^2;
figure
[fig_handle, image_handle, bar_handle] = viewimage(-im2)
test_data1(:,1)=reshape((-im2),row*col,1);
images_crisp = mireadimages ('h:\betsabeh\my_project\volumetry\matlab\data\phantom\noram_part\phantom_1[1].0mm_normal_crisp.mnc',s_num);
nimage = reshape(images_crisp, row, col);
for i=1:row
    for j=1:col
        if (nimage(i,j)==3)
            la(i,j)=1;
        else
            la(i,j)=2;
        end
    end
end
test_data1(:,2)=reshape(la,row*col,1);
 [fAlphaY, fSVs, fBias, fParameters, fnSV, fnLabel]=train_svm_1_vs_1(test_data1',2,1)
 m=1;
 for s_num=10:10:150
    test_data = mireadimages ('h:\betsabeh\my_project\volumetry\matlab\data\phantom\nromal\1mm\t1_icbm_normal_1mm_pn0_rf0.mnc',s_num);
    test_image=reshape(test_data,row,col);
    figure,
    [fig_handle, image_handle, bar_handle] = viewimage(test_image)  
    [bin,s_test,TP(m),FN(m),FP(m),TN(m),OM(m),ACC(m)]=skull_strip2(test_image,s_num);
    im2=s_test.^2;
    test_data1(:,1)=reshape((-im2),row*col,1);
            mAlphaY=cell2num(fAlphaY(1,2));
            mSVs=cell2num( fSVs(1,2));
            mBias=cell2num( fBias(1,2));
            mParameters=cell2num(fParameters(1,2));
            mnSV=cell2num( fnSV(1,2));
            mnLabel=cell2num( fnLabel(1,2));
           segment3=test_svm(test_data1',2,1,mAlphaY, mSVs, mBias, mParameters, mnSV, mnLabel);
       r3=reshape(segment3,row,col);
       images_crisp = mireadimages ('h:\betsabeh\my_project\volumetry\matlab\data\phantom\noram_part\phantom_1[1].0mm_normal_crisp.mnc',s_num);
nimage = reshape(images_crisp, row, col);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%white accuracy
cor=0;
for i=1:row
    for j=1:col
        if((r3(i,j)==1)&&(nimage(i,j)==3))
              cor=cor+1;
          end
      end
  end
NR=size(find(nimage==3),1);
if (NR==0)&&(cor==0)
    TP_wht=1;
else
    TP_wht=cor/NR
end

%FP_wht
[o,p]=find(r3==1);
NB=size(o,1);
FP_wht=abs(NB-cor)/NR;
%OM
om_white=TP_wht/(1+FP_wht);
TN_wht=1-FP_wht;
FN_wht=1-TP_wht;
acc_white(m)=(TN_wht+TP_wht)/(TN_wht+TP_wht+abs(FN_wht)+abs(FP_wht));
m=m+1;
close all
 end
