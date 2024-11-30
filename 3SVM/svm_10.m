clc;
clear all;
close all;
mypath;
% % n_row=120;%120
% % n_col=140;%140
row=181;
col=217;
m=1;
% % K=1;
% %  s_num=[10 20  30  50 70 90 110 130 150];
% %  for l=1:9
% %      test_data = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\nromal\1mm\t1_icbm_normal_1mm_pn0_rf0.mnc',s_num(l));
% %      test_image=reshape(test_data,row,col);
% %      images_crisp = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\noram_part\phantom_1[1].0mm_normal_crisp.mnc',s_num(l));
% %      nimage = reshape(images_crisp, row, col);
% %       [bin,s_test,TP(m),FN(m),FP(m),TN(m),OM(m),ACC(m)]=skull_strip2(test_image,s_num(l));
% % % %     me=mean(mean(s_test));
% % % %     s=std(std(s_test));
% % % %     new=me-s*s_test;
% % % %     [fig_handle, image_handle, bar_handle] = viewimage(new)
% %     new1=imresize(s_test,[n_row n_col]);
% %     nn=reshape(new1,n_row*n_col,1);
% %     for j=1:n_row*n_col
% %         if (j<n_row*n_col-5)
% %             nn(j)=mean(nn(j:j+5));
% %         end
% %     end
% %     new1=reshape(nn,n_row,n_col);
% %     nimage1=imresize(nimage, [n_row n_col]);
% %     for i=1:n_row
% %         for j=1:n_col 
% %             %%%%%%%%%%%%%label's for white
% %              if (nimage1(i,j)==3)
% %                 w_label(i,j)=3;
% %             else
% %                w_label(i,j)=4;
% %              end
% %              %%%%%%%%%%%%%%%%%%%%%%gray
% %              if (nimage1(i,j)==2)
% %                 g_label(i,j)=2;
% %             else
% %                g_label(i,j)=4;
% %              end
% %              %%%%%%%%%%%%%%%%%%%%csf
% %              if (nimage1(i,j)==1)
% %                c_label(i,j)=1;
% %             else
% %                c_label(i,j)=4;
% %              end
% %         end
% %     end
% % %      t=otsu(s_test);
% % %     d=bwdist(t,'euclidean'); 
% % %     d1=imresize(d,[n_row n_col]);
% %      l=(K-1)*n_row*n_col+1;
% %     u=K*n_row*n_col;
% % %     w_svm_data(l:u,1)=reshape(d1,n_row*n_col,1);
% % w_svm_data(l:u,1)=reshape(new1,n_row*n_col,1);
% % w_la=reshape(w_label,n_row*n_col,1);
% % w_svm_data(l:u,2)=w_la;
% % 
% % %  g_svm_data(l:u,1)=reshape(d1,n_row*n_col,1);
% % g_svm_data(l:u,1)=reshape(new1,n_row*n_col,1);
% % g_la=reshape(g_label,n_row*n_col,1);
% % g_svm_data(l:u,2)=g_la;
% % 
% % %  c_svm_data(l:u,1)=reshape(d1,n_row*n_col,1);
% % c_svm_data(l:u,1)=reshape(new1,n_row*n_col,1);
% % c_la=reshape(c_label,n_row*n_col,1);
% % c_svm_data(l:u,2)=c_la;
% % 
% % K=K+1;
% % close all
% %  end
% %  [c_mAlphaY1, c_mSVs1, c_mBias1, c_mParameters1, c_mnSV1, c_mnLabel1]=my_svmtrain(c_svm_data',2,1);
% %  1
% % [g_mAlphaY1, g_mSVs1, g_mBias1, g_mParameters1, g_mnSV1, g_mnLabel1]=my_svmtrain(g_svm_data',2,1);
% % 2
% % [w_mAlphaY1, w_mSVs1, w_mBias1, w_mParameters1, w_mnSV1, w_mnLabel1]=my_svmtrain(w_svm_data',2,1);
% % 3
% % save('svm10__mean_trained.mat','c_mAlphaY1','c_mSVs1', 'c_mBias1', 'c_mParameters1', 'c_mnSV1', 'c_mnLabel1','g_mAlphaY1', 'g_mSVs1', 'g_mBias1', 'g_mParameters1', 'g_mnSV1', 'g_mnLabel1','w_mAlphaY1', 'w_mSVs1', 'w_mBias1', 'w_mParameters1', 'w_mnSV1', 'w_mnLabel1')
m=103
load('svm10__mean_trained.mat')
load('brain_n5_r40_mean.mat')
%%%%%%%%%%%%%%%%%%%%%%%%%test
 for s_num=50:1:153
    test_data = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\nromal\1mm\t1_icbm_normal_1mm_pn0_rf0.mnc',s_num);
    test_image=reshape(test_data,row,col);
    figure,
    [fig_handle, image_handle, bar_handle] = viewimage(test_image)  
    [bin,s_test,TP(m),FN(m),FP(m),TN(m),OM(m),ACC(m)]=skull_strip2(test_image,s_num);
% %     me=mean(mean(s_test));
% %     s=std(std(s_test));
% %     new=me-s*s_test;
% % %       t=otsu(s_test);
% % %     d=bwdist(t,'euclidean'); 
% % %      data(:,1)=reshape(d,row*col,1);
% % %    data(:,2)=reshape(s_test,row*col,1);

 nn=reshape(s_test,row*col,1);
    for j=1:row*col
        if (j<row*col-5)
            nn(j)=mean(nn(j:j+5));
        end
    end
    data(:,1)=nn;
   [segment1,D1]=test_svm1(data',2,1,c_mAlphaY1,c_mSVs1, c_mBias1, c_mParameters1, c_mnSV1, c_mnLabel1);
    [segment2,D2]=test_svm1(data',2,1,g_mAlphaY1,g_mSVs1,g_mBias1, g_mParameters1, g_mnSV1, g_mnLabel1);
     [segment3,D3]=test_svm1(data',2,1,w_mAlphaY1, w_mSVs1, w_mBias1, w_mParameters1, w_mnSV1, w_mnLabel1);
     r1=reshape(segment1,row,col);
      r2=reshape(segment2,row,col);
      r3=reshape(segment3,row,col);
      images_crisp = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\noram_part\phantom_1[1].0mm_normal_crisp.mnc',s_num);
nimage = reshape(images_crisp, row, col);
[acc_csf(m),acc_gry(m),acc_white(m),om_csf(m),om_gry(m),om_white(m),TP_csf,FP_csf,TP_gry,FP_gry,TP_wht,FP_wht]=accuracy_3_parts(nimage,r1,r2,r3)
 csf_segments(m,:,:)=r1;
    gry_segments(m,:,:)=r2;
    wht_segments(m,:,:)=r3;
    real_segments(m,:,:)=nimage;
    save('brain_n5_r40_mean.mat','csf_segments','gry_segments','wht_segments','real_segments','acc_csf','acc_gry','acc_white','TP_csf','FP_csf','TP_gry','FP_gry','TP_wht','FP_wht','TP','FN','FP','TN','OM','ACC'); 
m=m+1;
s_num
close all;
end
[csf_volume,gry_volume,white_volume,r_csf_volume,r_gry_volume,r_white_volume]=brain_volumetry1( real_segments,csf_segments,gry_segments,wht_segments,1);
diff_csf=r_csf_volume-csf_volume
diff_gry=r_gry_volume-gry_volume
diff_white=r_white_volume-white_volume
