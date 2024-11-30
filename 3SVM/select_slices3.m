clc;
 clear all;
close all;
mypath;
n_row=181;%120
n_col=217;%140
row=181;
col=217;
m=1;
K=1;
number_of_slices=3;
s_csf=0;
s_gry=0;
s_wht=0;

% % % %load(''select_train_with_2f_real_intensity.mat');
% % % %load('select_train_with_2f_real_intensity_2slice.mat')
% % %  load('select_slices_2f_real_int.mat');
% % % 
% % % for K=1:number_of_slices
% % %     l=(K-1)*n_row*n_col+1;
% % %     u=K*n_row*n_col;
% % % % %     svm_data_csf(l:u,:)=read_skull_strip_data2(s_csf(K),row,col,n_row,n_col,'csf');
% % %    svm_data_gry(l:u,:)=read_skull_strip_data2(s_gry(K),row,col,n_row,n_col,'gray');
% % %     svm_data_wht(l:u,:)=read_skull_strip_data2(s_wht(K),row,col,n_row,n_col,'white');  
% % %     
% % % end
% % %  load('select_train_with_2f_real_intensity_4slice.mat')
% % % K=K+1;
 c=110;
g=30;
w=140;
% % while(c<160)||(g<160)||(w<160)
   c=c+10;
   g=g+10;
   w=w+10;
% % %     if (ismember(c,s_csf))
% % %         c=c+10;
% % %     end
% %     while (ismember(g,s_gry))
% %         g=g+10;
% %     end
% %      while(ismember(w,s_wht))
% %         w=w+10;
% %      end
    l=(K-1)*n_row*n_col+1;
    u=K*n_row*n_col;
  svm_data_csf(l:u,:)=read_skull_strip_data2(c,row,col,n_row,n_col,'csf');
  svm_data_gry(l:u,:)=read_skull_strip_data2(g,row,col,n_row,n_col,'gray');
  svm_data_wht(l:u,:)=read_skull_strip_data2(w,row,col,n_row,n_col,'white');
%%%%%%%%%%%%%%%%%%train svms
[c_mAlphaY1, c_mSVs1, c_mBias1, c_mParameters1, c_mnSV1, c_mnLabel1]=my_svmtrain(svm_data_csf',2,2);
[g_mAlphaY1, g_mSVs1, g_mBias1, g_mParameters1, g_mnSV1, g_mnLabel1]=my_svmtrain(svm_data_gry',2,2);
[w_mAlphaY1, w_mSVs1, w_mBias1, w_mParameters1, w_mnSV1, w_mnLabel1]=my_svmtrain(svm_data_wht',2,2);
m=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%test
 for s_num=10:10:150
    test_data = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\nromal\1mm\t1_icbm_normal_1mm_pn0_rf0.mnc',s_num);
    test_image=reshape(test_data,row,col);
    figure,
    [fig_handle, image_handle, bar_handle] = viewimage(test_image)  
    [bin,s_test,TP(m),FN(m),FP(m),TN(m),OM(m),ACC(m)]=skull_strip2(test_image,s_num);
% %     xtest=imresize(s_test,[n_row n_col]);
t=otsu(s_test);
d=bwdist(t,'euclidean'); 
test_data1(:,1)=reshape(d,row*col,1);
    test_data1(:,2)=reshape(s_test,row*col,1);;
     [segment1,D1]=test_svm1(test_data1',2,2,c_mAlphaY1,c_mSVs1, c_mBias1, c_mParameters1, c_mnSV1, c_mnLabel1);
    [segment2,D2]=test_svm1(test_data1',2,2,g_mAlphaY1,g_mSVs1,g_mBias1, g_mParameters1, g_mnSV1, g_mnLabel1);
    [segment3,D3]=test_svm1(test_data1',2,2,w_mAlphaY1, w_mSVs1, w_mBias1, w_mParameters1, w_mnSV1, w_mnLabel1);
   r1=reshape(segment1,row,col);
   r2=reshape(segment2,row,col);
   r3=reshape(segment3,row,col);
% %    D1=reshape(D1,row,col);
% %    D2=reshape(D2,row,col);
% %    D3=reshape(D3,row,col);
% %    [r1,r2,r3]=vote(r1,D1,r2,D2,r3,D3)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%accuracy
% % figure
% % [fig_handle, image_handle, bar_handle] = viewimage(my_seg)
images_crisp = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\noram_part\phantom_1[1].0mm_normal_crisp.mnc',s_num);
nimage = reshape(images_crisp, row, col);
[acc_csf(m),acc_gry(m),acc_white(m),om_csf(m),om_gry(m),om_white(m),TP_csf,FP_csf,TP_gry,FP_gry,TP_wht,FP_wht]=accuracy_3_parts(nimage,r1,r2,r3)
m=m+1;
s_num
close all;
end
% % avg_csf(c)=mean(acc_csf);
avg_gry(g)=mean(acc_gry);
avg_wht(w)=mean(acc_white);
% % avg_TP_csf(c)=mean(TP_csf);
avg_TP_gry(g)=mean(TP_gry);
avg_TP_wht(w)=mean(TP_wht);
save('select_train_with_2f_real_intensity_4slice.mat','avg_csf','avg_TP_csf','avg_TP_gry','avg_TP_wht','avg_gry','avg_wht'); 
c
% end
 [v,s_csf(number_of_slices+1)]=max(avg_csf);
[v,s_gry(number_of_slices+1)]=max(avg_gry);
[v,s_wht(number_of_slices+1)]=max(avg_wht);   
save('select_slices_2f_real_int.mat','s_csf','s_wht','s_gry')