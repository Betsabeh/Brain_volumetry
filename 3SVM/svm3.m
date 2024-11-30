clc;
clear all;
close all;
mypath;
n_row=181;
n_col=217;
row=181;
col=217;
k=1;
%%%%selected_slice=[10 20 30 40  50 70 90 110 140];
% % % % % selected_slice=[70];
% % % % %     m=1;
% % % % % for k=1:1
% % % % % %%%%%%%%%%%%%%%%%%%csf
% % % % % images = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\nromal\1mm\t1_icbm_normal_1mm_pn0_rf0.mnc',selected_slice(k));
% % % % % a = reshape (images, 181, 217);
% % % % % [bin,a1,TP(m),FN(m),FP(m),TN(m),OM(m),ACC(m)]=skull_strip2(a,selected_slice(k));
% % % % % a=imresize(a1,[n_row,n_col]);
% % % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%find label
% % % % % images_crisp = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\noram_part\phantom_1[1].0mm_normal_crisp.mnc',selected_slice(k));
% % % % % nimage = reshape(images_crisp, row, col);
% % % % % figure
% % % % % [fig_handle, image_handle, bar_handle] = viewimage(nimage)
% % % % % n=imresize(nimage,[n_row n_col]);
% % % % % for i=1:n_row
% % % % %     for j=1:n_col 
% % % % %         if (n(i,j)==1)
% % % % %             label(i,j)=1;
% % % % %         else
% % % % %             label(i,j)=4;
% % % % %         end 
% % % % %     end
% % % % % end
% % % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%svm inputs
% % % % % l=(k-1)*n_row*n_col+1;
% % % % % u=k*n_row*n_col;
% % % % % %   svm_data(l:u,1)=reshape((n_t1),n_row*n_col,1);
% % % % %     t=otsu(a);
% % % % %     d=bwdist(t,'euclidean');
% % % % % svm_data(l:u,1)=reshape(a,n_row*n_col,1);
% % % % %     svm_data(l:u,2)=reshape(d,n_row*n_col,1);
% % % % % la=reshape(label,n_row*n_col,1);
% % % % % svm_data(l:u,3)=la;
% % % % % k=k+1;
% % % % % close all
% % % % % end
% % % % % %%%%%%%%%%%%%%%train 5 class svm
% % % % % tic
% % % % % [mAlphaY1, mSVs1, mBias1, mParameters1, mnSV1, mnLabel1]=my_svmtrain(svm_data',3,1);
% % % % % toc
% % % % % save('svm_train_csf_1mm.mat','mAlphaY1','mSVs1','mBias1','mParameters1','mnSV1','mnLabel1');
% % % % % % **************************************************************************
% % % % % for k=1:1
% % % % % %********************************************************************gray
% % % % % images = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\nromal\1mm\t1_icbm_normal_1mm_pn0_rf0.mnc',selected_slice(k));
% % % % % a = reshape (images, 181, 217);
% % % % % [bin,a1,TP(m),FN(m),FP(m),TN(m),OM(m),ACC(m)]=skull_strip2(a,selected_slice(k));
% % % % % a=imresize(a1,[n_row,n_col]);
% % % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%find label
% % % % % images_crisp = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\noram_part\phantom_1[1].0mm_normal_crisp.mnc',selected_slice(k));
% % % % % nimage = reshape(images_crisp, row, col);
% % % % % figure
% % % % % [fig_handle, image_handle, bar_handle] = viewimage(nimage)
% % % % % n=imresize(nimage,[n_row n_col]);
% % % % % for i=1:n_row
% % % % %     for j=1:n_col 
% % % % %         if (n(i,j)==2)
% % % % %             label(i,j)=2;
% % % % %         else
% % % % %             label(i,j)=4;
% % % % %         end 
% % % % %     end
% % % % % end
% % % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%svm inputs
% % % % % l=(k-1)*n_row*n_col+1;
% % % % % u=k*n_row*n_col;
% % % % % %%   svm_data(l:u,1)=reshape((n_t1),n_row*n_col,1);
% % % % %     t=otsu(a);
% % % % %     d=bwdist(t,'euclidean');
% % % % % svm_data(l:u,1)=reshape(a,n_row*n_col,1);
% % % % %     svm_data(l:u,2)=reshape(d,n_row*n_col,1);
% % % % % la=reshape(label,n_row*n_col,1);
% % % % % svm_data(l:u,3)=la;
% % % % % k=k+1;
% % % % % close all
% % % % % end
% % % % % %%%%%%%%%%%%%%%%train 5 class svm
% % % % % tic
% % % % % [mAlphaY1, mSVs1, mBias1, mParameters1, mnSV1, mnLabel1]=my_svmtrain(svm_data',3,1);
% % % % % toc
% % % % % save('svm_train_gry_1mm.mat','mAlphaY1','mSVs1','mBias1','mParameters1','mnSV1','mnLabel1');
% % % % % 
% % % % % %**************************************************************************
% % % % % for k=1:1
% % % % % %*******************************************************************white 
% % % % % images = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\nromal\1mm\t1_icbm_normal_1mm_pn0_rf0.mnc',selected_slice(k));
% % % % % a = reshape (images, 181, 217);
% % % % % [bin,a1,TP(m),FN(m),FP(m),TN(m),OM(m),ACC(m)]=skull_strip2(a,selected_slice(k));
% % % % % a=imresize(a1,[n_row,n_col]);
% % % % % 
% % % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%find label
% % % % % images_crisp = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\noram_part\phantom_1[1].0mm_normal_crisp.mnc',selected_slice(k));
% % % % % nimage = reshape(images_crisp, row, col);
% % % % % figure
% % % % % [fig_handle, image_handle, bar_handle] = viewimage(nimage)
% % % % % n=imresize(nimage,[n_row n_col]);
% % % % % for i=1:n_row
% % % % %     for j=1:n_col 
% % % % %         if (n(i,j)==3)
% % % % %             label(i,j)=3;
% % % % %         else
% % % % %             label(i,j)=4;
% % % % %         end 
% % % % %     end
% % % % % end
% % % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%svm inputs
% % % % % l=(k-1)*n_row*n_col+1;
% % % % % u=k*n_row*n_col;
% % % % % %%   svm_data(l:u,1)=reshape((n_t1),n_row*n_col,1);
% % % % %     t=otsu(a);
% % % % %     d=bwdist(t,'euclidean');
% % % % % svm_data(l:u,1)=reshape(a,n_row*n_col,1);
% % % % %     svm_data(l:u,2)=reshape(d,n_row*n_col,1);
% % % % % la=reshape(label,n_row*n_col,1);
% % % % % svm_data(l:u,3)=la;
% % % % % k=k+1;
% % % % % close all
% % % % % end
% % % % % %%%%%%%%%%%%%%%%train 5 class svm
% % % % % tic
% % % % % [mAlphaY1, mSVs1, mBias1, mParameters1, mnSV1, mnLabel1]=my_svmtrain(svm_data',3,1);
% % % % % toc
% % % % % save('svm_train_wht_1mm.mat','mAlphaY1','mSVs1','mBias1','mParameters1','mnSV1','mnLabel1');
% % % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%****************************************************************************************8888
% % % % % 
% % % % % 
% % % % % 


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
  
    for s_num=9:10:150
    test_data = mireadimages ('h:\betsabeh\my_project\volumetry\matlab\data\phantom\nromal\1mm\t1_icbm_normal_1mm_pn0_rf0.mnc',s_num);
    test_image=reshape(test_data,row,col);
    figure,
    [fig_handle, image_handle, bar_handle] = viewimage(test_image)  
    [bin,s_test,TP(m),FN(m),FP(m),TN(m),OM(m),ACC(m)]=skull_strip21(test_image,s_num);
    xtest(:,1)=reshape(s_test,1,row*col);
   %% xtest= medfilt2(xtest,[5 5]); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % test_data1(:,1)=reshape((xtest),n_row*n_col,1);
    t=otsu(s_test);
    d=bwdist(t,'euclidean');
    xtest(:,2)=reshape(d,n_row*n_col,1);
    tic
load('svm_train_csf_1mm.mat')
% %     test_data1(:,1)=reshape((xtest),n_row*n_col,1);
    segment1=test_svm(xtest',3,1,mAlphaY1, mSVs1, mBias1, mParameters1, mnSV1, mnLabel1);
load('svm_train_gry_1mm.mat')
%     test_data1(:,1)=reshape((xtest),n_row*n_col,1);
    segment2=test_svm(xtest',3,1,mAlphaY1, mSVs1, mBias1, mParameters1, mnSV1, mnLabel1);
load('svm_train_wht_1mm.mat')
%     test_data1(:,1)=reshape((xtest),n_row*n_col,1);
    segment3=test_svm(xtest',3,1,mAlphaY1, mSVs1, mBias1, mParameters1, mnSV1, mnLabel1);
% % % v=[segment1 segment2 segment3];
% % % for i=1:row*col
% % %     vot=zeros(1,4);
% % %     for j=1:3
% % %         if (v(i,j)~=0)
% % %             vot(1,v(i,j))=vot(1,v(i,j))+1;
% % %             vote1(i,v(i,j))=vot(1,v(i,j))+1;
% % %         end
% % %     end
% % %     [val,ind(i)]=max(vot);
% % % end
% % % 
% % % my_seg=reshape(ind,n_row,n_col);
   r1=reshape(segment1,row,col);
   r2=reshape(segment2,row,col);
   r3=reshape(segment3,row,col);
   my_seg=r1+r2+r3;
    for i=1:row
        for j=1:col
            switch my_seg(i,j)
                case 9
                my_seg(i,j)=1;
                case 10
                    my_seg(i,j)=2;
                case 11
                    my_seg(i,j)=3;
                case 12
                    my_seg(i,j)=4;
            end
        end
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%accuracy
figure
[fig_handle, image_handle, bar_handle] = viewimage(my_seg)
images_crisp = mireadimages ('h:\betsabeh\my_project\volumetry\matlab\data\phantom\noram_part\phantom_1[1].0mm_normal_crisp.mnc',s_num);
nimage = reshape(images_crisp, row, col);
toc
[acc(m),acc_csf(m),acc_gry(m),acc_white(m),om_csf,om_gry,om_white,TP_csf,FP_csf,TP_gry,FP_gry,TP_wht,FP_wht]=accuracy(nimage,my_seg);
% % % cor=0;
% % % for i=1:row
% % %     for j=1:col
% % %         if (nimage(i,j)==1)&&(my_seg(i,j)==1)
% % %             cor=cor+1;
% % %         end
% % %     end
% % % end
% % % [x,y]=find(nimage==1);
% % % NR=size(x,1);
% % % TP(m)=cor/NR;
% % % NB=size(find(my_seg==1),1);
% % % FP(m)=abs(NB-cor)/NR
% % % %OM
% % % OM(m)=TP(m)/(1+FP(m))
% % % TN(m)=1-FP(m);
% % % FN(m)=1-TP(m);
% % % acc(m)=(TN(m)+TP(m))/(TN(m)+TP(m)+FN(m)+(FP(m)));
% % % 
toc
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