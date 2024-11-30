clc;
clear all;
close all;
mypath;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%train paramter
m=53;
n_row=181;
n_col=217;
row=181;
col=217;
load('csf_trained.mat');
load('gry_trained.mat');
load('wht_trained.mat');
load('brain_n0_r0.mat')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%test data
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
    segment1=test_svm(test_data1',2,2,c_mAlphaY1,c_mSVs1, c_mBias1, c_mParameters1, c_mnSV1, c_mnLabel1);
    segment2=test_svm(test_data1',2,2,g_mAlphaY1,g_mSVs1,g_mBias1, g_mParameters1, g_mnSV1, g_mnLabel1);
    segment3=test_svm(test_data1',2,2,w_mAlphaY1, w_mSVs1, w_mBias1,w_mParameters1, w_mnSV1, w_mnLabel1);
    r1=reshape(segment1,row,col);
    r2=reshape(segment2,row,col);
    r3=reshape(segment3,row,col);
    images_crisp = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\noram_part\phantom_1[1].0mm_normal_crisp.mnc',s_num);
    nimage = reshape(images_crisp, row, col);
    [acc_csf(m),acc_gry(m),acc_white(m),om_csf(m),om_gry(m),om_white(m),TP_csf(m),FP_csf(m),TP_gry(m),FP_gry(m),TP_wht(m),FP_wht(m)]=accuracy_3_parts(nimage,r1,r2,r3)
    csf_segments(m,:,:)=r1;
    gry_segments(m,:,:)=r2;
    wht_segments(m,:,:)=r3;
    real_segments(m,:,:)=nimage;
   % save('brain_n0_r0.mat','csf_segments','gry_segments','wht_segments','real_segments','acc_csf','acc_gry','acc_white','TP_csf','FP_csf','TP_gry','FP_gry','TP_wht','FP_wht','TP','FN','FP','TN','OM','ACC');  
    m=m+1;
    close all
    s_num
end
[csf_volume,gry_volume,white_volume,r_csf_volume,r_gry_volume,r_white_volume]=brain_volumetry1( real_segments,csf_segments,gry_segments,wht_segments,1);
diff_csf=r_csf_volume-csf_volume
diff_gry=r_gry_volume-gry_volume
diff_white=r_white_volume-white_volume
save('brainvolume_1mm_n0_r0.mat','csf_volume','gry_volume','white_volume','r_csf_volume','r_gry_volume','r_white_volume','diff_csf','diff_gry','diff_white' );  

