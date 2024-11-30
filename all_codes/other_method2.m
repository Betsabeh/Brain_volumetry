% % % % i want to group into 3 . and gry ,wht , csf svm for these 3 groups of slices 
% % % % 9-50, 51-100 , 101-153

% % % clc;
% % % clear all;
% % % close all;
% % % mypath;
% % % m=1;
% % % n_row=181;
% % % n_col=217;
% % % row=181;
% % % col=217;
% % %  k=1;
% % %  s_num=70;
% % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%train
% % % % for s_num=60:10:100
% % %  test_data = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\nromal\1mm\t1_icbm_normal_1mm_pn0_rf0.mnc',s_num);
% % % test_image=reshape(test_data,row,col);
% % % figure,
% % % [fig_handle, image_handle, bar_handle] = viewimage(test_image)
% % % images_crisp = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\noram_part\phantom_1[1].0mm_normal_crisp.mnc',s_num);
% % % nimage = reshape(images_crisp, row, col);
% % % real_seg=imresize(nimage,[n_row n_col]);
% % % 
% % % l=(k-1)*n_row*n_col+1;
% % % u=k*n_row*n_col;
% % % [svm_data_w(l:u,:),svm_data_g(l:u,:),svm_data_c(l:u,:)]=read_skull_strip_data(s_num,row,col,n_row,n_col)
% % %  k=k+1;
% % %  close all;
% % % % end
% % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%1-vs-1
% % % [c_mAlphaY1, c_mSVs1, c_mBias1, c_mParameters1, c_mnSV1, c_mnLabel1]=my_svmtrain(svm_data_c',2,2);
% % % [g_mAlphaY1, g_mSVs1, g_mBias1, g_mParameters1, g_mnSV1, g_mnLabel1]=my_svmtrain(svm_data_g',2,2);
% % % [w_mAlphaY1, w_mSVs1, w_mBias1, w_mParameters1, w_mnSV1,w_mnLabel1]=my_svmtrain(svm_data_w',2,2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
m=1;
for s_num=10:10:150
     test_data = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\nromal\1mm\t1_icbm_normal_1mm_pn0_rf0.mnc',s_num);
test_image=reshape(test_data,row,col);
figure,
[fig_handle, image_handle, bar_handle] = viewimage(test_image)
images_crisp = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\noram_part\phantom_1[1].0mm_normal_crisp.mnc',s_num);
nimage = reshape(images_crisp, row, col);
real_seg=nimage
[bin,s_test,TP(m),FN(m),FP(m),TN(m),OM(m),ACC(m)]=skull_strip21(test_image,s_num);  
t=otsu(s_test);
d=bwdist(t,'euclidean');
svm_data1(:,1)=reshape(d,row*col,1);
svm_data1(:,2)=reshape((s_test.^2),row*col,1);
%%%%%%%%%%%%%%%%%%%%%%%%
 segment1=test_svm(svm_data1',2,2,c_mAlphaY1,c_mSVs1, c_mBias1, c_mParameters1, c_mnSV1, c_mnLabel1);
  segment2=test_svm(svm_data1',2,2,g_mAlphaY1,g_mSVs1,g_mBias1, g_mParameters1, g_mnSV1, g_mnLabel1);
  segment3=test_svm(svm_data1',2,2,w_mAlphaY1, w_mSVs1, w_mBias1, w_mParameters1, w_mnSV1, w_mnLabel1);
   r1=reshape(segment1,row,col);
   r2=reshape(segment2,row,col);
   r3=reshape(segment3,row,col);
 
my_seg=r1+r2+r3;
   figure,
[fig_handle, image_handle, bar_handle] = viewimage(my_seg) 
[acc_csf(m),acc_gry(m),acc_white(m),om_csf,om_gry,om_white,TP_csf,FP_csf,TP_gry,FP_gry,TP_wht,FP_wht]=accuracy_3_parts(nimage,r1,r2,r3)
  close all
  m=m+1;
end