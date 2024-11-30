clc;
clear all;
close all;
mypath;
n_row=120;
n_col=140;
row=181;
col=217;
m=1;
K=1;
s_num=60;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 test_data = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\nromal\1mm\t1_icbm_normal_1mm_pn0_rf0.mnc',s_num);
test_image=reshape(test_data,row,col);
images_crisp = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\noram_part\phantom_1[1].0mm_normal_crisp.mnc',s_num);
nimage = reshape(images_crisp, row, col);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
test_image=imresize(test_image,[n_row,n_col]);
clabel=ones(n_row,n_col)*4;
glabel=ones(n_row,n_col)*4;
wlabel=ones(n_row,n_col)*4;
for i=1:n_row
    for j=1:n_col
        t(i,j)=i+j+test_image(i,j);
        if (nimage(i,j)==1)
            clabel(i,j)=1;
        elseif (nimage(i,j)==2)
            glabel(i,j)=2;
        elseif (nimage(i,j)==3)
            wlabel(i,j)=3;
        end
    end
end

l=(K-1)*n_row*n_col+1;
u=K*n_row*n_col;
svm_data_csf(l:u,1)=reshape(t,n_row*n_col,1);
svm_data_gry(l:u,1)=reshape(t,n_row*n_col,1);
svm_data_wht(l:u,1)=reshape(t,n_row*n_col,1);
svm_data_csf(l:u,2)=reshape(clabel,n_row*n_col,1);
svm_data_gry(l:u,2)=reshape(glabel,n_row*n_col,1);
svm_data_wht(l:u,2)=reshape(wlabel,n_row*n_col,1);
%%%%%%%%%%%%%%%%%%train svms
[c_mAlphaY1, c_mSVs1, c_mBias1, c_mParameters1, c_mnSV1, c_mnLabel1]=my_svmtrain(svm_data_csf',2,1);
[g_mAlphaY1, g_mSVs1, g_mBias1, g_mParameters1, g_mnSV1, g_mnLabel1]=my_svmtrain(svm_data_gry',2,1);
[w_mAlphaY1, w_mSVs1, w_mBias1, w_mParameters1, w_mnSV1, w_mnLabel1]=my_svmtrain(svm_data_wht',2,1);
m=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%test
 for s_num=10:10:150
    test_data = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\nromal\1mm\t1_icbm_normal_1mm_pn0_rf0.mnc',s_num);
    test_image=reshape(test_data,row,col);
    figure,
    [fig_handle, image_handle, bar_handle] = viewimage(test_image)  
   for i=1:n_row
    for j=1:n_col
        t(i,j)=i+j+test_image(i,j);
    end
   end
    xtest=imresize(t,[n_row n_col]);
    test_data1(:,1)=reshape((xtest),row*col,1);
    segment1=test_svm(test_data1',2,1,c_mAlphaY1,c_mSVs1, c_mBias1, c_mParameters1, c_mnSV1, c_mnLabel1);
    segment2=test_svm(test_data1',2,1,g_mAlphaY1,g_mSVs1,g_mBias1, g_mParameters1, g_mnSV1, g_mnLabel1);
    segment3=test_svm(test_data1',2,1,w_mAlphaY1, w_mSVs1, w_mBias1, w_mParameters1, w_mnSV1, w_mnLabel1);
   r1=reshape(segment1,row,col);
   r2=reshape(segment2,row,col);
   r3=reshape(segment3,row,col);
 
my_seg=r1+r2+r3;
% % % % % %     for i=1:row
% % % % % %         for j=1:col
% % % % % %             switch my_seg(i,j)
% % % % % %                 case 9
% % % % % %                 my_seg(i,j)=1;
% % % % % %                 case 10
% % % % % %                     my_seg(i,j)=2;
% % % % % %                 case 11
% % % % % %                     my_seg(i,j)=3;
% % % % % %                 case 12
% % % % % %                     my_seg(i,j)=4;
% % % % % %             end
% % % % % %         end
% % % % % %     end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%accuracy
figure
[fig_handle, image_handle, bar_handle] = viewimage(my_seg)
images_crisp = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\noram_part\phantom_1[1].0mm_normal_crisp.mnc',s_num);
nimage = reshape(images_crisp, row, col);
[acc_csf(m),acc_gry(m),acc_white(m),om_csf,om_gry,om_white,TP_csf,FP_csf,TP_gry,FP_gry,TP_wht,FP_wht]=accuracy_3_parts(nimage,r1,r2,r3)
m=m+1;
s_num
close all;
end
avg_csf(c)=mean(acc_csf);
avg_gry(g)=mean(acc_gry);
avg_wht(w)=mean(acc_white);
avg_TP_csf(c)=mean(TP_csf);
avg_TP_gry(g)=mean(TP_gry);
avg_TP_wht(w)=mean(TP_wht);
