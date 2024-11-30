% % % % .  svm for these 3 groups of slices  with two features
% % % % 9-50, 51-100 , 101-153

clc;
clear all;
close all;
mypath;
m=1;
n_row=181;
n_col=217;
row=181;
col=217;
 k=1;
 s_num=140;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%train
% for s_num=60:10:100
 test_data = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\nromal\1mm\t1_icbm_normal_1mm_pn0_rf0.mnc',s_num);
test_image=reshape(test_data,row,col);
figure,
[fig_handle, image_handle, bar_handle] = viewimage(test_image)
images_crisp = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\noram_part\phantom_1[1].0mm_normal_crisp.mnc',s_num);
nimage = reshape(images_crisp, row, col);
real_seg=imresize(nimage,[n_row n_col]); 
l=(k-1)*n_row*n_col+1;
u=k*n_row*n_col;
svm_data(l:u,:)=read_skull_strip_data3(s_num,row,col,n_row,n_col);
 k=k+1;
 close all;
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%1-vs-1
[fAlphaY, fSVs, fBias, fParameters, fnSV, fnLabel]=train_svm_1_vs_1(svm_data',4,2);
% save('vs1.mat','fAlphaY', 'fSVs', 'fBias', 'fParameters', 'fnSV', 'fnLabel');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%1-vs-all
[AlphaY, SVs, Bias, Parameters, nSV, nLabel]=train_svm_1vs_all(svm_data',4,2);
% % % save('all.mat','AlphaY', 'SVs', 'Bias', 'Parameters', 'nSV', 'nLabel');

% % load('vs1.mat');
% % load('all.mat');
% % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
m=1;
for s_num=10:10:150
     test_data = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\nromal\1mm\t1_icbm_normal_1mm_pn0_rf0.mnc',s_num);
test_image=reshape(test_data,row,col);
figure,
[fig_handle, image_handle, bar_handle] = viewimage(test_image)
images_crisp = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\noram_part\phantom_1[1].0mm_normal_crisp.mnc',s_num);
nimage = reshape(images_crisp, row, col);
real_seg=nimage;
[bin,s_test,TP(m),FN(m),FP(m),TN(m),OM(m),ACC(m)]=skull_strip21(test_image,s_num);  
s1=reshape(s_test,1,n_row*n_col);
% % su=sum(s1);
% % p1=s1/su;
% % Y = geocdf(s1,p1);
mu=mean(s1);
Y = expcdf(s1,mu);
 
svm_data1(:,1)=Y;
svm_data1(l:u,2)=s1;

%%%%%%%%%%%%%%%%%%%%%%%%1-vs-all
for i=1:4
        mAlphaY=cell2num(AlphaY(1,i));
        mSVs=cell2num( SVs(1,i));
        mBias=cell2num( Bias(1,i));
        mParameters=cell2num(Parameters(1,i));
        mnSV=cell2num( nSV(1,i));
        mnLabel=cell2num( nLabel(1,i));
       seg1(:,i)=test_svm(svm_data1',4,2,mAlphaY, mSVs, mBias, mParameters, mnSV, mnLabel);
   end
  [v,inde]=max(seg1');
  my_seg=reshape(inde,row,col);
  [acc(m),acc_csf_vs_all(m),acc_gry_vs_all(m),acc_white_vs_all(m),om_csf_vs_all(m),om_gry_vs_all(m),om_white_vs_all(m),TP_csf_vs_all(m),FP_csf_vs_all(m),TP_gry_vs_all(m),FP_gry_vs_all(m),TP_wht_vs_all(m),FP_wht_vs_all(m)]=accuracy(real_seg,my_seg)
  %%%%%%%%%%%%%%%%%%%%%%%%1-vs-1
n=1;
for i=1:4
        for j=i+1:4
            mAlphaY=cell2num(fAlphaY(i,j));
            mSVs=cell2num( fSVs(i,j));
            mBias=cell2num( fBias(i,j));
            mParameters=cell2num(fParameters(i,j));
            mnSV=cell2num( fnSV(i,j));
            mnLabel=cell2num( fnLabel(i,j));
            segment1(:,n)=test_svm(svm_data1',4,2,mAlphaY, mSVs, mBias, mParameters, mnSV, mnLabel);
            n=n+1;
        end
end
 for i=1:row*col
        for j=1:4
            se(j)=size(find(segment1(i,:)==j),2);
        end
        [v,index]=max(se);
        ind(i)=index;
    end
    my_seg=reshape(ind,row,col);   
    
[acc(m),acc_csf_vs1(m),acc_gry_vs1(m),acc_white_vs1(m),om_csf_vs1(m),om_gry_vs1(m),om_white_vs1(m),TP_csf_vs1(m),FP_csf_vs1(m),TP_gry_vs1(m),FP_gry_vs1(m),TP_wht_vs1(m),FP_wht_vs1(m)]=accuracy1(real_seg,my_seg)
  close all
  m=m+1;
end