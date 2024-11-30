% this file train 3 seprate svm for csf , GM, WM with the selected slices
clc;
% % clear all;
% % close all;
mypath;
n_row=181;%120
n_col=217;%140
row=181;
col=217;
K=1;
number_of_slices=1;
s_csf=[60  90  150];
s_gry=[60   60 150];
s_wht=[60 60 150];
m=1;
for K=1:number_of_slices
    test_data = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\nromal\1mm\t1_icbm_normal_1mm_pn0_rf0.mnc',s_csf(K));
    test_image=reshape(test_data,row,col);
    images_crisp = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\noram_part\phantom_1[1].0mm_normal_crisp.mnc',s_csf(K));
    nimage = reshape(images_crisp, row, col);
    [bin,s_test,TP(m),FN(m),FP(m),TN(m),OM(m),ACC(m)]=skull_strip2(test_image,s_csf(K));
    l=(K-1)*n_row*n_col+1;
    u=K*n_row*n_col;
%     t=otsu(s_test);
%     d=bwdist(t,'euclidean'); 
    test_data1(:,1)=reshape(s_test,row*col,1);
    avg_img=my_avg(s_test);
    test_data1(:,2)=reshape(avg_img,row*col,1);
    for i=1:row
          for j=1:col 
            %%%%%%%%%%%%%%label's for csf
            if (nimage(i,j)==1)
                c_label(i,j)=1;
            else
                c_label(i,j)=4;
            end 
          end
    end
   svm_data_csf(l:u,1:2)=test_data1;
   svm_data_csf(l:u,3)= reshape(c_label,row*col,1); 
   close all
end

for K=1:1
    test_data = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\nromal\1mm\t1_icbm_normal_1mm_pn0_rf0.mnc',s_gry(K));
    test_image=reshape(test_data,row,col);
    images_crisp = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\noram_part\phantom_1[1].0mm_normal_crisp.mnc',s_gry(K));
    nimage = reshape(images_crisp, row, col);
    [bin,s_test,TP(m),FN(m),FP(m),TN(m),OM(m),ACC(m)]=skull_strip2(test_image,s_gry(K));
    l=(K-1)*n_row*n_col+1;
    u=K*n_row*n_col;
% %     t=otsu(s_test);
% %     d=bwdist(t,'euclidean'); 
    test_data1(:,1)=reshape(s_test,row*col,1);
    avg_img=my_avg(s_test);
    test_data1(:,2)=reshape(avg_img,row*col,1);
    for i=1:row
          for j=1:col 
               %%%%%%%%%%%%%%label's for gry
             if (nimage(i,j)==2)
                g_label(i,j)=2;
            else
                g_label(i,j)=4;
             end 
          end
    end
     svm_data_gry(l:u,1:2)=test_data1;
     svm_data_gry(l:u,3)=reshape(g_label,row*col,1);
     close all
end


for K=1:1
    test_data = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\nromal\1mm\t1_icbm_normal_1mm_pn0_rf0.mnc',s_wht(K));
    test_image=reshape(test_data,row,col);
    images_crisp = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\noram_part\phantom_1[1].0mm_normal_crisp.mnc',s_wht(K));
    nimage = reshape(images_crisp, row, col);
    [bin,s_test,TP(m),FN(m),FP(m),TN(m),OM(m),ACC(m)]=skull_strip2(test_image,s_wht(K));
    l=(K-1)*n_row*n_col+1;
    u=K*n_row*n_col;
% %     t=otsu(s_test);
% %     d=bwdist(t,'euclidean'); 
    test_data1(:,1)=reshape(s_test,row*col,1);
    avg_img=my_avg(s_test);
    test_data1(:,2)=reshape(avg_img,row*col,1);
    for i=1:row
          for j=1:col 
                %%%%%%%%%%%%%%label's for wht
             if (nimage(i,j)==3)
                w_label(i,j)=3;
            else
                w_label(i,j)=4;
             end 
    
          end
    end
     svm_data_wht(l:u,1:2)=test_data1;
     svm_data_wht(l:u,3)=reshape(w_label,row*col,1);
     close all
end

         
           
     
[c_mAlphaY1, c_mSVs1, c_mBias1, c_mParameters1, c_mnSV1, c_mnLabel1]=my_svmtrain(svm_data_csf',2,2);
[g_mAlphaY1, g_mSVs1, g_mBias1, g_mParameters1, g_mnSV1, g_mnLabel1]=my_svmtrain(svm_data_gry',2,2);
[w_mAlphaY1, w_mSVs1, w_mBias1, w_mParameters1, w_mnSV1,w_mnLabel1]=my_svmtrain(svm_data_wht',2,2);
save('csf_trained_me-s2.mat','c_mAlphaY1', 'c_mSVs1', 'c_mBias1', 'c_mParameters1', 'c_mnSV1','c_mnLabel1');
save('gry_trained_me-s2.mat','g_mAlphaY1', 'g_mSVs1', 'g_mBias1', 'g_mParameters1', 'g_mnSV1','g_mnLabel1');
save('wht_trained_me-s2.mat','w_mAlphaY1', 'w_mSVs1', 'w_mBias1', 'w_mParameters1', 'w_mnSV1','w_mnLabel1');