% % % %  gry ,wht , csf svm 
% % % %
% % % %  clc;
clear all;
 close all;
mypath;
m=1;
n_row=181;
n_col=217;
row=181;
col=217;
 k=1;
s_num_w=[ 60];
s_num_g=[ 40];
s_num_c=[ 100];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%train
for i=1:1
% % % %  test_data = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\nromal\1mm\t1_icbm_normal_1mm_pn0_rf0.mnc',s_num(i));
% % % % test_image=reshape(test_data,row,col);
% % % % figure,
% % % % [fig_handle, image_handle, bar_handle] = viewimage(test_image)
images_crisp = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\noram_part\phantom_1[1].0mm_normal_crisp.mnc',s_num_w(i));
nimage = reshape(images_crisp, row, col);
% % % % real_seg=imresize(nimage,[n_row n_col]);
l=(k-1)*n_row*n_col+1;
u=k*n_row*n_col;

svm_data_w(l:u,:)=read_skull_strip_data4(s_num_w(i),row,col,n_row,n_col,'white');
svm_data_g(l:u,:)=read_skull_strip_data4(s_num_g(i),row,col,n_row,n_col,'gray');
svm_data_c(l:u,:)=read_skull_strip_data4(s_num_c(i),row,col,n_row,n_col,'csf');

%%[svm_data_w(l:u,:),svm_data_g(l:u,:),svm_data_c(l:u,:)]=read_skull_strip_data2(s_num(i),row,col,n_row,n_col);
 k=k+1;
 close all;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%1-vs-1
[c_mAlphaY1, c_mSVs1, c_mBias1, c_mParameters1, c_mnSV1, c_mnLabel1]=my_svmtrain(svm_data_c',2,2);
[g_mAlphaY1, g_mSVs1, g_mBias1, g_mParameters1, g_mnSV1, g_mnLabel1]=my_svmtrain(svm_data_g',2,2);
[w_mAlphaY1, w_mSVs1, w_mBias1, w_mParameters1, w_mnSV1,w_mnLabel1]=my_svmtrain(svm_data_w',2,2);
% % % % % % % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 m=1;
for s_num=30:5:150
 test_data = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\nromal\1mm\t1_icbm_normal_1mm_pn0_rf0.mnc',s_num);
test_image=reshape(test_data,row,col);
figure,
[fig_handle, image_handle, bar_handle] = viewimage(test_image)
images_crisp = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\noram_part\phantom_1[1].0mm_normal_crisp.mnc',s_num);
nimage = reshape(images_crisp, row, col);
real_seg=nimage;
[bin,s_test,TP(m),FN(m),FP(m),TN(m),OM(m),ACC(m)]=skull_strip21(test_image,s_num);  
s1=reshape(s_test,1,row*col);
% % % % % w=watershed(s_test);

 mu=mean(s1);
 Y = expcdf(s1,mu);

% % su=sum(s1);
% % p1=s1/su;
% % Y = geocdf(s1,p1);
svm_data1(:,1)=reshape(Y,1,row*col);
svm_data1(:,2)=s1;

%%%%%%%%%%%%%%%%%%%%%%%%
segment1=test_svm(svm_data1',2,2,c_mAlphaY1,c_mSVs1, c_mBias1, c_mParameters1, c_mnSV1, c_mnLabel1);
segment2=test_svm(svm_data1',2,2,g_mAlphaY1,g_mSVs1,g_mBias1, g_mParameters1, g_mnSV1, g_mnLabel1);
segment3=test_svm(svm_data1',2,2,w_mAlphaY1, w_mSVs1, w_mBias1, w_mParameters1, w_mnSV1, w_mnLabel1);
r1=reshape(segment1,row,col);
r2=reshape(segment2,row,col);
r3=reshape(segment3,row,col);
   my_seg=zeros(row,col);
 [o,p]=find(r3==3);
 for i=1:size(o,1)
     my_seg(o(i),p(i))=3;
 end
 
 [o,p]=find(r2==2);
 for i=1:size(o,1)
     my_seg(o(i),p(i))=2;
 end
 
[o,p]=find(r1==1);
 for i=1:size(o,1)
     my_seg(o(i),p(i))=1;
 end
% % %  
% % % 
% % % for i=1:row
% % %     for j=1:col
% % %         if (nimage(i,j)~=1)&&(nimage(i,j)~=2)&&(nimage(i,j)~=3)
% % %             ni(i,j)=4;
% % %         else
% % %             ni(i,j)=nimage(i,j)*100;
% % %         end
% % %     end
% % % end
% % % 
% % %  figure,
% % % [fig_handle, image_handle, bar_handle] = viewimage(ni)
% % % figure,
% % % [fig_handle, image_handle, bar_handle] = viewimage(my_seg)
  
[acc_csf(m),acc_gry(m),acc_white(m),om_csf,om_gry,om_white,TP_csf,FP_csf,TP_gry,FP_gry,TP_wht,FP_wht]=accuracy_3_parts(nimage,r1,r2,r3)
all_segments(m,:,:)=my_seg;
real_segments(m,:,:)=nimage;
  close all
  m=m+1;
  
end
[csf_volume,gry_volume,white_volume,r_csf_volume,r_gry_volume,r_white_volume]=brain_volumetry(all_segments,real_segments,1)
diff_csf=((r_csf_volume-csf_volume)/r_csf_volume)*100
diff_gry=((r_gry_volume-gry_volume)/r_gry_volume)*100
diff_white=((r_white_volume-white_volume)/r_white_volume)*100
