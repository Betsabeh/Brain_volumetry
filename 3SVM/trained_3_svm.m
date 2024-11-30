% this file train 3 seprate svm for csf , GM, WM with the selected slices
clc;
% % clear all;
% % close all;
% % mypath;
% % n_row=181;%120
% % n_col=217;%140
% % row=181;
% % col=217;
% % K=1;
% % load('select_slices_2f_real_int.mat');
% % number_of_slices=size(s_csf,2);
% % for K=1:number_of_slices
% %     l=(K-1)*n_row*n_col+1;
% %     u=K*n_row*n_col;
% %     svm_data_csf(l:u,:)=read_skull_strip_data2(s_csf(K),row,col,n_row,n_col,'csf');
% % end
% % number_of_slices=size(s_gry,2);
% % for K=1:number_of_slices
% %     l=(K-1)*n_row*n_col+1;
% %     u=K*n_row*n_col;
% %     svm_data_gry(l:u,:)=read_skull_strip_data2(s_gry(K),row,col,n_row,n_col,'gray');
% % end
number_of_slices=size(s_wht,2);
for K=1:number_of_slices-1
    l=(K-1)*n_row*n_col+1;
    u=K*n_row*n_col;
    svm_data_wht(l:u,:)=read_skull_strip_data2(s_wht(K),row,col,n_row,n_col,'white');
end
[c_mAlphaY1, c_mSVs1, c_mBias1, c_mParameters1, c_mnSV1, c_mnLabel1]=my_svmtrain(svm_data_csf',2,2);
[g_mAlphaY1, g_mSVs1, g_mBias1, g_mParameters1, g_mnSV1, g_mnLabel1]=my_svmtrain(svm_data_gry',2,2);
[w_mAlphaY1, w_mSVs1, w_mBias1, w_mParameters1, w_mnSV1,w_mnLabel1]=my_svmtrain(svm_data_wht',2,2);
save('csf_trained.mat','c_mAlphaY1', 'c_mSVs1', 'c_mBias1', 'c_mParameters1', 'c_mnSV1','c_mnLabel1');
save('gry_trained.mat','g_mAlphaY1', 'g_mSVs1', 'g_mBias1', 'g_mParameters1', 'g_mnSV1','g_mnLabel1');
save('wht_trained.mat','w_mAlphaY1', 'w_mSVs1', 'w_mBias1', 'w_mParameters1', 'w_mnSV1','w_mnLabel1');