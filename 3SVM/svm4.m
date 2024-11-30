clc;
clear all;
close all;
mypath;
n_row=181;
n_col=217;
k=1;
%%%%%%%%%%%%%%%%%%%%csf
images = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\nromal\1mm\t1_icbm_normal_1mm_pn0_rf0.mnc',85);
a = reshape (images, 181, 217);
[bin,a,TP(m),FN(m),FP(m),TN(m),OM(m),ACC(m)]=skull_strip2(a,85);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%find label
images_crisp = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\noram_part\phantom_1[1].0mm_normal_crisp.mnc',85);
nimage = reshape(images_crisp, row, col);
figure
[fig_handle, image_handle, bar_handle] = viewimage(nimage)
n=imresize(nimage,[n_row n_col]);
for i=1:n_row
    for j=1:n_col 
        if (n(i,j)==1)
            label(i,j)=1;
        else
            label(i,j)=4;
        end 
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%svm inputs
l=(k-1)*n_row*n_col+1;
u=k*n_row*n_col;
%%   svm_data(l:u,1)=reshape((n_t1),n_row*n_col,1);
% % %     t=otsu(n_t1);
% % %     d=bwdist(t,'euclidean');
svm_data(l:u,1)=reshape(a,n_row*n_col,1);
% % %     svm_data(l:u,2)=reshape(sqrt(n_t1),n_row*n_col,1);
la=reshape(label,n_row*n_col,1);
svm_data(l:u,2)=la;
k=k+1;
close all

%%%%%%%%%%%%%%%%train 5 class svm
tic
[mAlphaY1, mSVs1, mBias1, mParameters1, mnSV1, mnLabel1]=my_svmtrain(svm_data',2,1);
toc
save('svm_train_csf_1mm.mat','mAlphaY1','mSVs1','mBias1','mParameters1','mnSV1','mnLabel1');
%**************************************************************************
%********************************************************************gray
images = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\nromal\1mm\t1_icbm_normal_1mm_pn0_rf0.mnc',85);
a = reshape (images, 181, 217);
[bin,a,TP(m),FN(m),FP(m),TN(m),OM(m),ACC(m)]=skull_strip2(a,85);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%find label
images_crisp = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\noram_part\phantom_1[1].0mm_normal_crisp.mnc',85);
nimage = reshape(images_crisp, row, col);
figure
[fig_handle, image_handle, bar_handle] = viewimage(nimage)
n=imresize(nimage,[n_row n_col]);
for i=1:n_row
    for j=1:n_col 
        if (n(i,j)==2)
            label(i,j)=2;
        else
            label(i,j)=4;
        end 
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%svm inputs
l=(k-1)*n_row*n_col+1;
u=k*n_row*n_col;
%%   svm_data(l:u,1)=reshape((n_t1),n_row*n_col,1);
% % %     t=otsu(n_t1);
% % %     d=bwdist(t,'euclidean');
svm_data(l:u,1)=reshape(a,n_row*n_col,1);
% % %     svm_data(l:u,2)=reshape(sqrt(n_t1),n_row*n_col,1);
la=reshape(label,n_row*n_col,1);
svm_data(l:u,2)=la;
k=k+1;
close all

%%%%%%%%%%%%%%%%train 5 class svm
tic
[mAlphaY1, mSVs1, mBias1, mParameters1, mnSV1, mnLabel1]=my_svmtrain(svm_data',2,1);
toc
save('svm_train_gry_1mm.mat','mAlphaY1','mSVs1','mBias1','mParameters1','mnSV1','mnLabel1');

%**************************************************************************
%*******************************************************************white 
images = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\nromal\1mm\t1_icbm_normal_1mm_pn0_rf0.mnc',90);
a = reshape (images, 181, 217);
[bin,a,TP(m),FN(m),FP(m),TN(m),OM(m),ACC(m)]=skull_strip2(a,90);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%find label
images_crisp = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\noram_part\phantom_1[1].0mm_normal_crisp.mnc',90);
nimage = reshape(images_crisp, row, col);
figure
[fig_handle, image_handle, bar_handle] = viewimage(nimage)
n=imresize(nimage,[n_row n_col]);
for i=1:n_row
    for j=1:n_col 
        if (n(i,j)==3)
            label(i,j)=3;
        else
            label(i,j)=4;
        end 
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%svm inputs
l=(k-1)*n_row*n_col+1;
u=k*n_row*n_col;
%%   svm_data(l:u,1)=reshape((n_t1),n_row*n_col,1);
% % %     t=otsu(n_t1);
% % %     d=bwdist(t,'euclidean');
svm_data(l:u,1)=reshape(a,n_row*n_col,1);
% % %     svm_data(l:u,2)=reshape(sqrt(n_t1),n_row*n_col,1);
la=reshape(label,n_row*n_col,1);
svm_data(l:u,2)=la;
k=k+1;
close all

%%%%%%%%%%%%%%%%train 5 class svm
tic
[mAlphaY1, mSVs1, mBias1, mParameters1, mnSV1, mnLabel1]=my_svmtrain(svm_data',2,1);
toc
save('svm_train_wht_1mm.mat','mAlphaY1','mSVs1','mBias1','mParameters1','mnSV1','mnLabel1');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%****************************************************************************************8888
% *************************************************non-brain
images = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\nromal\1mm\t1_icbm_normal_1mm_pn0_rf0.mnc',85);
a = reshape (images, 181, 217);
[bin,a,TP(m),FN(m),FP(m),TN(m),OM(m),ACC(m)]=skull_strip2(a,85);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%find label
images_crisp = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\noram_part\phantom_1[1].0mm_normal_crisp.mnc',85);
nimage = reshape(images_crisp, row, col);
figure
[fig_handle, image_handle, bar_handle] = viewimage(nimage)
n=imresize(nimage,[n_row n_col]);
for i=1:n_row
    for j=1:n_col 
        if ~((n(i,j)==1)||(n(i,j)==2)||(n(i,j)==3))
            label(i,j)=4;
        else
            label(i,j)=0;
        end 
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%svm inputs
l=(k-1)*n_row*n_col+1;
u=k*n_row*n_col;
%%   svm_data(l:u,1)=reshape((n_t1),n_row*n_col,1);
% % %     t=otsu(n_t1);
% % %     d=bwdist(t,'euclidean');
svm_data(l:u,1)=reshape(a,n_row*n_col,1);
% % %     svm_data(l:u,2)=reshape(sqrt(n_t1),n_row*n_col,1);
la=reshape(label,n_row*n_col,1);
svm_data(l:u,2)=la;
k=k+1;
close all

%%%%%%%%%%%%%%%%train 5 class svm
tic
[mAlphaY1, mSVs1, mBias1, mParameters1, mnSV1, mnLabel1]=my_svmtrain(svm_data',2,1);
toc
save('svm_train_back_1mm.mat','mAlphaY1','mSVs1','mBias1','mParameters1','mnSV1','mnLabel1');





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%test data
m=1;
% % %     s1=0;
% % %     s2=0;
% % %     s3=0;
% % %     r_s1=0;
% % %     r_s2=0;
% % %     r_s3=0;
 %%%%  load('svm_train_1vs_1_1mm.mat')
    n_row=181;
    n_col=217;
    row=181;
    col=217;
    for s_num=10:10:150
    test_data = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\nromal\1mm\t1_icbm_normal_1mm_pn0_rf0.mnc',s_num);
    test_image=reshape(test_data,row,col);
    figure,
    [fig_handle, image_handle, bar_handle] = viewimage(test_image)  
    [bin,s_test,TP(m),FN(m),FP(m),TN(m),OM(m),ACC(m)]=skull_strip2(test_image,s_num);
    xtest=imresize(s_test,[n_row n_col]);
   %% xtest= medfilt2(xtest,[5 5]); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % test_data1(:,1)=reshape((xtest),n_row*n_col,1);
% % % %     t=otsu(xtest);
% % % %     d=bwdist(t,'euclidean');
% % % %     test_data1(:,1)=reshape(d,n_row*n_col,1);
load('svm_train_back_1mm.mat')
    test_data1(:,1)=reshape((xtest),n_row*n_col,1);
    segment1=test_svm(test_data1',2,1,mAlphaY1, mSVs1, mBias1, mParameters1, mnSV1, mnLabel1);
load('svm_train_csf_1mm.mat')
    test_data1(:,1)=reshape((xtest),n_row*n_col,1);
    segment2=test_svm(test_data1',2,1,mAlphaY1, mSVs1, mBias1, mParameters1, mnSV1, mnLabel1);
load('svm_train_gry_1mm.mat')
    test_data1(:,1)=reshape((xtest),n_row*n_col,1);
    segment3=test_svm(test_data1',2,1,mAlphaY1, mSVs1, mBias1, mParameters1, mnSV1, mnLabel1);
load('svm_train_wht_1mm.mat')
    test_data1(:,1)=reshape((xtest),n_row*n_col,1);
    segment4=test_svm(test_data1',2,1,mAlphaY1, mSVs1, mBias1, mParameters1, mnSV1, mnLabel1);
v=[segment1 segment2 segment3 segment4];
for i=1:row*col
    vot=zeros(1,4);
    for j=1:4
        if (v(i,j)~=0)
            vot(1,v(i,j))=vot(1,v(i,j))+1;
        end
    end
    [val,ind(i)]=max(vot);
end

    
    my_seg=reshape(ind,n_row,n_col);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%accuracy
figure
[fig_handle, image_handle, bar_handle] = viewimage(my_seg)
images_crisp = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\noram_part\phantom_1[1].0mm_normal_crisp.mnc',s_num);
nimage = reshape(images_crisp, row, col);
cor=0;
for i=1:row
    for j=1:col
        if (nimage(i,j)==1)&&(my_seg(i,j)==1)
            cor=cor+1;
        end
    end
end
[x,y]=find(nimage==1);
NR=size(x,1);
TP(m)=cor/NR;
NB=size(find(my_seg==1),1);
FP(m)=abs(NB-cor)/NR
%OM
OM(m)=TP(m)/(1+FP(m))
TN(m)=1-FP(m);
FN(m)=1-TP(m);
acc(m)=(TN(m)+TP(m))/(TN(m)+TP(m)+FN(m)+(FP(m)));

m=m+1;
s_num
close all;
    end
 
  


% % % % % % % for i=1:n_row
% % % % % % %     for j=1:n_col
% % % % % % %         switch my_seg(i,j)
% % % % % % %             case 1
% % % % % % %                 s1=s1+1;
% % % % % % %             case 2
% % % % % % %                 s2=s2+1;
% % % % % % %             case 3
% % % % % % %                 s3=s3+1;
% % % % % % %         end
% % % % % % %          switch real_seg(i,j)
% % % % % % %             case 1
% % % % % % %                 r_s1=r_s1+1;
% % % % % % %             case 2
% % % % % % %                 r_s2=r_s2+1;
% % % % % % %             case 3
% % % % % % %                 r_s3=r_s3+1;
% % % % % % %         end
% % % % % % %     end
% % % % % % % end
% % % % % % % m=m+1;
% % % % % % % close all;
% % % % % % % end
% % % % % % % csf_volume=s1/1000;
% % % % % % % gry_volume=s2/1000;
% % % % % % % white_volume=s3/1000;