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
k=1;
for s_num=60:20:90
test_data = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\nromal\1mm\t1_icbm_normal_1mm_pn0_rf0.mnc',s_num);
test_image=reshape(test_data,row,col);
figure,
[fig_handle, image_handle, bar_handle] = viewimage(test_image)  
 test_image=imresize(test_image,[n_row n_col]);
 %test_image=my_avg(test_image);
images_crisp = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\noram_part\phantom_1[1].0mm_normal_crisp.mnc',s_num);
nimage = reshape(images_crisp, row, col);
 images_crisp=imresize(images_crisp,[n_row n_col]);
for i=1:n_row
    for j=1:n_col
        if (nimage(i,j)==1)||(nimage(i,j)==2)||(nimage(i,j)==3)
            s(i,j)=test_image(i,j);
            la(i,j)=nimage(i,j);
        else
            s(i,j)=0;
            la(i,j)=4;
        end
    end
end
 l=(k-1)*n_row*n_col+1;
  u=k*n_row*n_col;
svm_data(l:u,1)=reshape(s,n_row*n_col,1);
svm_data(l:u,2)=reshape(la,n_row*n_col,1);
k=k+1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Train
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%1-vs-1
[fAlphaY, fSVs, fBias, fParameters, fnSV, fnLabel]=train_svm_1_vs_1(svm_data',4,1);1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%1-vs-all
[AlphaY, SVs, Bias, Parameters, nSV, nLabel]=train_svm_1vs_all(svm_data',4,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Test
m=1;
for s_num=10:10:150
 test_data = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\nromal\1mm\t1_icbm_normal_1mm_pn9_rf40.mnc',s_num);
test_image=reshape(test_data,row,col);
figure,
[fig_handle, image_handle, bar_handle] = viewimage(test_image)  
%test_image=my_avg(test_image);
images_crisp = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\noram_part\phantom_1[1].0mm_normal_crisp.mnc',s_num);
nimage = reshape(images_crisp, row, col);
real_seg=imresize(nimage,[row col]);
 svm_data1(:,1)=reshape(test_image,row*col,1);
%%%%%%%%%%%%%%%%%%%%%%%%1-vs-all
for i=1:4
        mAlphaY=cell2num(AlphaY(1,i));
        mSVs=cell2num( SVs(1,i));
        mBias=cell2num( Bias(1,i));
        mParameters=cell2num(Parameters(1,i));
        mnSV=cell2num( nSV(1,i));
        mnLabel=cell2num( nLabel(1,i));
       seg1(:,i)=test_svm(svm_data1',4,1,mAlphaY, mSVs, mBias, mParameters, mnSV, mnLabel);
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
            segment1(:,n)=test_svm(svm_data1',4,1,mAlphaY, mSVs, mBias, mParameters, mnSV, mnLabel);
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

m=m+1;
close all
end