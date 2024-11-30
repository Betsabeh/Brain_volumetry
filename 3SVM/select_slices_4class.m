clc;
clear all;
close all;
mypath;
n_row=181;%120
n_col=217;%!40
row=181;
col=217;
m=1;
K=1;
%%s(1)=80;
% % number_of_slices=2;
% % load('select_slices.mat')
s=[10 30 50 70 100 150]
 for K=1:6
    l=(K-1)*n_row*n_col+1;
    u=K*n_row*n_col;
    svm_data(l:u,:)=read_skull_strip_data3(s(K),row,col,n_row,n_col);
% %     svm_data_gry(l:u,:)=read_skull_strip_data(s_gry(K),row,col,n_row,n_col,'gray');
% %     svm_data_wht(l:u,:)=read_skull_strip_data(s_wht(K),row,col,n_row,n_col,'white');  
% %     
 end
% % %  K=K+1;
% % % load('select_train_5CLASS_2SVM.mat');
% % % c=90;
% % % while(c<=150)
% % %     c=c+10;
% % %    
% % % % %     if (ismember(c,s_csf))
% % % % %         c=c+5;
% % % % %     end
% % % % %     if (ismember(g,s_gry))
% % % % %         g=g+5;
% % % % %     end
% % % % %      if (ismember(w,s_wht))
% % % % %         w=w+5;
% % % % %      end
% % %     l=(K-1)*n_row*n_col+1;
% % %     u=K*n_row*n_col;
% % %   svm_data(l:u,:)=read_skull_strip_data3(c,row,col,n_row,n_col);
%%%%%%%%%%%%%%%%%%train svms
[c_mAlphaY1, c_mSVs1, c_mBias1, c_mParameters1, c_mnSV1, c_mnLabel1]=my_svmtrain(svm_data',5,2);
m=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%test
 for s_num=10:10:150
    test_data = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\nromal\1mm\t1_icbm_normal_1mm_pn0_rf0.mnc',s_num);
    test_image=reshape(test_data,row,col);
    figure,
    [fig_handle, image_handle, bar_handle] = viewimage(test_image)  
    [bin,s_test,TP(m),FN(m),FP(m),TN(m),OM(m),ACC(m)]=skull_strip2(test_image,s_num);
    t=otsu(s_test);
    d=bwdist(t,'euclidean'); 
    test_data1(:,1)=reshape(d,row*col,1);
    test_data1(:,2)=reshape((s_test),row*col,1);
    segment1=test_svm(test_data1',5,2,c_mAlphaY1,c_mSVs1, c_mBias1, c_mParameters1, c_mnSV1, c_mnLabel1);
    r1=reshape(segment1,row,col);
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%accuracy
figure
[fig_handle, image_handle, bar_handle] = viewimage(r1)
images_crisp = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\noram_part\phantom_1[1].0mm_normal_crisp.mnc',s_num);
nimage = reshape(images_crisp, row, col);
[acc(m),acc_csf(m),acc_gry(m),acc_white(m),om_csf,om_gry,om_white,TP_csf(m),FP_csf,TP_gry(m),FP_gry,TP_wht(m),FP_wht]=accuracy(nimage,r1)
m=m+1;
s_num
close all;
end
avg_csf(c)=mean(acc_csf);
avg_gry(c)=mean(acc_gry);
avg_wht(c)=mean(acc_white);
avg_TP_csf(c)=mean(TP_csf);
avg_TP_gry(c)=mean(TP_gry);
avg_TP_wht(c)=mean(TP_wht);
% % save('select_train_5CLASS_2SVM.mat','avg_csf','avg_gry','avg_wht','avg_TP_csf','avg_TP_gry','avg_TP_wht'); 
c
% % % end
% % 
% %  [v,s_csf(number_of_slices+1)]=max(avg_csf);
% % [v,s_gry(number_of_slices+1)]=max(avg_gry);
% % [v,s_wht(number_of_slices+1)]=max(avg_wht);   
% % save('select_slices_5CLASS.mat','s_csf','s_wht','s_gry')