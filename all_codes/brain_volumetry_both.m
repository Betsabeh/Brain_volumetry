%choose find brain volume with 1_vs_1
clc;
clear all;
close all;
mypath;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%test data
m=1;
n_row=181;
n_col=217;
row=181;
col=217;

for s_num=30:10:150
    test_data = mireadimages ('h:\betsabeh\my_project\volumetry\matlab\data\phantom\nromal\1mm\t1_icbm_normal_1mm_pn0_rf0.mnc',s_num);
    test_image=reshape(test_data,row,col);
    figure,
    [fig_handle, image_handle, bar_handle] = viewimage(test_image)
    images_crisp = mireadimages ('h:\betsabeh\my_project\volumetry\matlab\data\phantom\noram_part\phantom_1[1].0mm_normal_crisp.mnc',s_num);
    nimage = reshape(images_crisp, row, col);
    real_seg=imresize(nimage,[n_row n_col]);
    [bin,s_test,TP(m),FN(m),FP(m),TN(m),OM(m),ACC(m)]=skull_strip21(test_image,s_num);   
    xtest=imresize(s_test,[n_row n_col]);
    %% xtest= medfilt2(xtest,[5 5]); 
    t=otsu(xtest);
    d=bwdist(t,'euclidean');
    test_data1(:,1)=reshape(d,n_row*n_col,1);
    test_data1(:,2)=reshape(sqrt(xtest),n_row*n_col,1);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%test1_vs_1
    load('svm_train_1vs_1_1mm.mat');
    % test_data1(:,1)=reshape((xtest),n_row*n_col,1);
     n=1;
    for i=1:5
        for j=i+1:5
            mAlphaY=cell2num(fAlphaY(i,j));
            mSVs=cell2num( fSVs(i,j));
            mBias=cell2num( fBias(i,j));
            mParameters=cell2num(fParameters(i,j));
            mnSV=cell2num( fnSV(i,j));
            mnLabel=cell2num( fnLabel(i,j));
            segment1(:,n)=test_svm(test_data1',5,2,mAlphaY, mSVs, mBias, mParameters, mnSV, mnLabel);
            n=n+1;
        end
    end
    for i=1:n_row*n_col
        for j=1:5
            s(j)=size(find(segment1(i,:)==j),2);
        end
    [v,index]=max(s);
    ind(i)=index;
    end
my_seg=reshape(ind,n_row,n_col);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%accuracy
% % % figure
% % % [fig_handle, image_handle, bar_handle] = viewimage(my_seg)
[acc(m),acc_csf_vs1(m),acc_gry_vs1(m),acc_white_vs1(m),om_csf_vs1(m),om_gry_vs1(m),om_white_vs1(m),TP_csf_vs1(m),FP_csf_vs1(m),TP_gry_vs1(m),FP_gry_vs1(m),TP_wht_vs1(m),FP_wht_vs1(m)]=accuracy(real_seg,my_seg)
all_segments_1_vs_1(m,:,:)=my_seg;
real_segments(m,:,:)=real_seg;
% save('brain_1_vs_1_1mm_n9_r40.mat','all_segments_1_vs_1','real_segments','acc_csf_vs1','acc_gry_vs1','acc_white_vs1','TP_csf_vs1','FP_csf_vs1','TP_gry_vs1','FP_gry_vs1','TP_wht_vs1','FP_wht_vs1','TP','FN','FP','TN','OM','ACC');  

% % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%test1_vs_all
load('svm_train_1vs_all_1mm.mat');
for i=1:5
    mAlphaY=cell2num(fAlphaY(1,i));
    mSVs=cell2num( fSVs(1,i));
    mBias=cell2num( fBias(1,i));
    mParameters=cell2num(fParameters(1,i));
    mnSV=cell2num( fnSV(1,i));
    mnLabel=cell2num( fnLabel(1,i));
    segment2(:,i)=test_svm(test_data1',5,2,mAlphaY, mSVs, mBias, mParameters, mnSV, mnLabel);
end
[v,ind]=max(segment2');
my_seg=reshape(ind,n_row,n_col);

%%%%%%%%%%%%%%%%%%%%%%%%%%%accuracy
% % % figure
% % % [fig_handle, image_handle, bar_handle] = viewimage(my_seg)
[acc(m),acc_csf_vs_all(m),acc_gry_vs_all(m),acc_white_vs_all(m),om_csf_vs_all(m),om_gry_vs_all(m),om_white_vs_all(m),TP_csf_vs_all(m),FP_csf_vs_all(m),TP_gry_vs_all(m),FP_gry_vs_all(m),TP_wht_vs_all(m),FP_wht_vs_all(m)]=accuracy(real_seg,my_seg)
all_segments_1_vs_all(m,:,:)=my_seg;
 m=m+1;
% save('brain_1_vs_all_1mm_n9_r40.mat','all_segments_1_vs_all','real_segments','acc_csf_vs_all','acc_gry_vs_all','acc_white_vs_all','TP_csf_vs_all','FP_csf_vs_all','TP_gry_vs_all','FP_gry_vs_all','TP_wht_vs_all','FP_wht_vs_all','TP','FN','FP','TN','OM','ACC');  
close all;
s_num
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%1_vs_1 volume
[csf_volume,gry_volume,white_volume,r_csf_volume,r_gry_volume,r_white_volume]=brain_volumetry(all_segments_1_vs_1,real_segments,1)
diff_csf=r_csf_volume-csf_volume
diff_gry=r_gry_volume-gry_volume
diff_white=r_white_volume-white_volume
save('brainvolume_1_vs_1_1mm_n9_r40.mat','csf_volume','gry_volume','white_volume','r_csf_volume','r_gry_volume','r_white_volume');  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%1_vs_1ll volume
[csf_volume,gry_volume,white_volume,r_csf_volume,r_gry_volume,r_white_volume]=brain_volumetry(all_segments_1_vs_all,real_segments,1)
diff_csf=r_csf_volume-csf_volume
diff_gry=r_gry_volume-gry_volume
diff_white=r_white_volume-white_volume
save('brainvolume_1_vs_all_1mm_n9_r40.mat','csf_volume','gry_volume','white_volume','r_csf_volume','r_gry_volume','r_white_volume');  
