%choose find brain volume with 1_vs_1
clc;
clear all;
close all;
mypath;
n_row=50;
n_col=50;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%load  svm train parameter
load('svm_train_1vs_all_1mm.mat');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%test data
 m=1;
n_row=181;
n_col=217;
row=181;
col=217;
for s_num=17:153
    test_data = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\nromal\1mm\t1_icbm_normal_1mm_pn3_rf20[1].mnc',s_num);
    test_image=reshape(test_data,row,col);
    figure,
    [fig_handle, image_handle, bar_handle] = viewimage(test_image)
    [bin,s_test,TP(m),FN(m),FP(m),TN(m),OM(m),ACC(m)]=skull_strip2(test_image,s_num); 
    xtest=imresize(s_test,[n_row n_col]);
   %% xtest= medfilt2(xtest,[5 5]); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % test_data1(:,1)=reshape((xtest),n_row*n_col,1);
    t=otsu(xtest);
    d=bwdist(t,'euclidean');
    test_data1(:,1)=reshape(d,n_row*n_col,1);
    test_data1(:,2)=reshape(sqrt(xtest),n_row*n_col,1);
    for i=1:5
        mAlphaY=cell2num(fAlphaY(1,i));
        mSVs=cell2num( fSVs(1,i));
        mBias=cell2num( fBias(1,i));
        mParameters=cell2num(fParameters(1,i));
        mnSV=cell2num( fnSV(1,i));
        mnLabel=cell2num( fnLabel(1,i));
       segment1(:,i)=test_svm(test_data1',5,2,mAlphaY, mSVs, mBias, mParameters, mnSV, mnLabel);
   end
  [v,ind]=max(segment1');
  my_seg=reshape(ind,n_row,n_col);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%accuracy
figure
[fig_handle, image_handle, bar_handle] = viewimage(my_seg)
images_crisp = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\noram_part\phantom_1[1].0mm_normal_crisp.mnc',slice_num(k));
nimage = reshape(images_crisp, row, col);
real_seg=imresize(s_test,[n_row n_col]);
[acc(m),acc_csf(m),acc_gry(m),acc_white(m),om_csf(m),om_gry(m),om_white(m),TP_csf(m),FP_csf(m),TP_gry(m),FP_gry(m),TP_wht(m),FP_wht(m)]=accuracy(real_seg,my_seg)

all_segments(m,:,:)=my_seg;
real_segments(m,:,:)=real_seg;
m=m+1;
  save('brain_1_vs_all_1mm_n3_r20.mat','acc_csf','acc_gry','acc_white','TP_csf','FP_csf','TP_gry','FP_gry','TP_wht','FP_wht','TP','FN','FP','TN','OM','ACC');  
close all;
end

avg_csf=mean(acc_csf);
avg_gry=mean(acc_gry);
avg_wht=mean(acc_white);

[csf_volume,gry_volume,white_volume,r_csf_volume,r_gry_volume,r_white_volume]=brain_volumetry(segmented_image,real_segments,thickness)

diff_csf=r_csf_volume-csf_volume
diff_gry=r_gry_volume-gry_volume
diff_white=r_white_volume-white_volume
  save('brainvolume_1_vs_all_1mm_n3_r20.mat','csf_volume','gry_volume','white_volume','r_csf_volume','r_gry_volume','r_white_volume');  
