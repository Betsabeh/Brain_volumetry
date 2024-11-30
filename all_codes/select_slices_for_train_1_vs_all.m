%choose best series of slices for train 1_vs_all
clc;
%%clear all;
close all;
mypath;
n_row=50;
n_col=50;
 max_gry=0;
max_csf=0;
max_wht=0;
load('select1_vs_all.mat');
for k=50:5:150
   
    images = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\nromal\1mm\t1_icbm_normal_1mm_pn0_rf0.mnc',k);
    a = reshape (images, 181, 217);
    [row,col]=size(a);
    figure,
    [fig_handle, image_handle, bar_handle] = viewimage (a);
    [s_a,TP,FN,FP,TN,OM,acc]=skull_strip(a,k);
    n_t1=imresize(s_a,[n_row n_col]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%find labels
    images_crisp = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\noram_part\phantom_1[1].0mm_normal_crisp.mnc',k);
    nimage = reshape(images_crisp, row, col);
    figure
    [fig_handle, image_handle, bar_handle] = viewimage(nimage)
    n=imresize(nimage,[n_row n_col]);
     for i=1:n_row
        for j=1:n_col 
            switch n(i,j)
                case 0
                   label(i,j)=5;
                case {1,2,3}
                   label(i,j)=n(i,j); 
                otherwise
                label(i,j)=4;
            end
        end
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%svm inputs
    l=(k-1)*n_row*n_col+1;
    u=k*n_row*n_col;
 %%   svm_data(l:u,1)=reshape((n_t1),n_row*n_col,1);
    t=otsu(n_t1);
    d=bwdist(t,'euclidean');
    svm_data(l:u,1)=reshape(d,n_row*n_col,1);

    svm_data(l:u,2)=reshape(sqrt(n_t1),n_row*n_col,1);

    la=reshape(label,n_row*n_col,1);
    svm_data(l:u,3)=la;
% % [x,y]=gradient(n_t1);
% % svm_data(l:u,2)=reshape(x,n_row*n_col,1);
% % svm_data(l:u,3)=reshape(y,n_row*n_col,1);
    %%%%%%%%%%%%%%%%train 5 class svm
    tic
     [fAlphaY, fSVs, fBias, fParameters, fnSV, fnLabel]=train_svm_1vs_all(svm_data',5,2)
    toc
    save('svm_train_1_vs_all.mat','fAlphaY','fSVs','fBias','fParameters','fnSV','fnLabel');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%test data
      m=1;
% % %     s1=0;
% % %     s2=0;
% % %     s3=0;
% % %     r_s1=0;
% % %     r_s2=0;
% % %     r_s3=0;
    acc_csf=zeros(1,5);
    acc_gry=zeros(1,5);
    acc_white=zeros(1,5);
    n_row=50;
    n_col=50;
    row=181;
    col=217;
    for s_num=10:10:150
    test_data = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\nromal\1mm\t1_icbm_normal_1mm_pn0_rf0.mnc',s_num);
    test_image=reshape(test_data,row,col);
    figure,
    [fig_handle, image_handle, bar_handle] = viewimage(test_image)
    [s_test,TP,FN,FP,TN,OM,aCC]=skull_strip(test_image,s_num);   
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
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%accuracy
figure
[fig_handle, image_handle, bar_handle] = viewimage(my_seg)
images_crisp = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\noram_part\phantom_1[1].0mm_normal_crisp.mnc',s_num);
nimage = reshape(images_crisp, row, col);
real_seg=imresize(nimage,[n_row n_col]);
[acc(m),acc_csf(m),acc_gry(m),acc_white(m),om_csf(m),om_gry(m),om_white(m)]=accuracy(real_seg,my_seg)

m=m+1;
close all;
    end
    avg_csf(k)=mean(om_csf);
    avg_gry(k)=mean(om_gry);
    avg_wht(k)=mean(om_white);
    if (avg_csf(k)>max_csf)
        slice_num_csf=k;
        max_csf=avg_csf(k);
    end
     if (avg_wht(k)>max_wht)
        slice_num_wht=k;
        max_wht=avg_wht(k);
    end
     if (avg_gry(k)>max_gry)
        slice_num_gry=k;
        max_gry=avg_gry(k);
     end
      save('select1_vs_all.mat','avg_csf','avg_gry','avg_wht','slice_num_csf','slice_num_gry','slice_num_wht');    
  end
    
   

% % % % % % % for i=1:n_row
% % % % % % %     for j=1:n_col
% % % % % % %         switch my_seg(i,j)
% % % % % % %             case 1
% % % % % % %                 s1=s1+1;
% % % % % % %             case 2
% % % % % % %                 s2=s2+1;
% % % % % % %             case 3
% % % % % % %                 s3=s3+1;
% % % % % % %         end
% % % % % % %          switch real_seg(i,j)
% % % % % % %             case 1
% % % % % % %                 r_s1=r_s1+1;
% % % % % % %             case 2
% % % % % % %                 r_s2=r_s2+1;
% % % % % % %             case 3
% % % % % % %                 r_s3=r_s3+1;
% % % % % % %         end
% % % % % % %     end
% % % % % % % end
% % % % % % % m=m+1;
% % % % % % % close all;
% % % % % % % end
% % % % % % % csf_volume=s1/1000;
% % % % % % % gry_volume=s2/1000;
% % % % % % % white_volume=s3/1000;