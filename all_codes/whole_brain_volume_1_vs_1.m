%choose best series of slices for train 1_vs_1
clc;
clear all;
max_gry=0;
max_csf=0;
max_wht=0;
load('select1_vs_1.mat'); 
close all;
mypath;
n_row=181;%%%120
n_col=217;%%%140
selected_slice=[11 20 30 40  50 70 90 110 140];
for k=6:6
    images = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\nromal\1mm\t1_icbm_normal_1mm_pn0_rf0.mnc',selected_slice(k));
    a = reshape (images, 181, 217);
    [row,col]=size(a);
    figure,
    [fig_handle, image_handle, bar_handle] = viewimage (a);
    [bin,s_a,TP,FN,FP,TN,OM,acc]=skull_strip2(a,selected_slice(k));
    n_t1=imresize(s_a,[n_row n_col]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%find labels
    images_crisp = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\noram_part\phantom_1[1].0mm_normal_crisp.mnc',selected_slice(k));
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
close all
end
    %%%%%%%%%%%%%%%%train 5 class svm
    tic
    [fAlphaY, fSVs, fBias, fParameters, fnSV, fnLabel]=train_svm_1_vs_1(svm_data',5,2)
    toc
% % %     save('svm_train_1vs_1_1mm.mat','fAlphaY','fSVs','fBias','fParameters','fnSV','fnLabel');
% % % %     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%test data
     m=1;
% % %     s1=0;
% % %     s2=0;
% % %     s3=0;
% % %     r_s1=0;
% % %     r_s2=0;
% % %     r_s3=0;
   load('svm_train_1vs_1_1mm.mat')
    n_row=181;
    n_col=217;
    row=181;
    col=217;
    for s_num=90:20:150
    test_data = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\nromal\1mm\t1_icbm_normal_1mm_pn0_rf0.mnc',s_num);
    test_image=reshape(test_data,row,col);
    figure,
    [fig_handle, image_handle, bar_handle] = viewimage(test_image)
    [bin,s_test,TP(m),FN(m),FP(m),TN(m),OM(m),ACC(m)]=skull_strip21(test_image,s_num);   
    xtest=imresize(s_test,[n_row n_col]);
   %% xtest= medfilt2(xtest,[5 5]); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % test_data1(:,1)=reshape((xtest),n_row*n_col,1);
    t=otsu(xtest);
    d=bwdist(t,'euclidean');
    test_data1(:,1)=reshape(d,n_row*n_col,1);
    test_data1(:,2)=reshape(sqrt(xtest),n_row*n_col,1);
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
figure
[fig_handle, image_handle, bar_handle] = viewimage(my_seg)
images_crisp = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\noram_part\phantom_1[1].0mm_normal_crisp.mnc',s_num);
nimage = reshape(images_crisp, row, col);
real_seg=imresize(nimage,[n_row n_col]);
[acc(m),acc_csf(m),acc_gry(m),acc_white(m),om_csf(m),om_gry(m),om_white(m),TP_csf(m),FP_csf(m),TP_gry(m),FP_gry(m),TP_wht(m),FP_wht(m)]=accuracy(real_seg,my_seg)
all_segments(m,:,:)=my_seg;
real_segments(m,:,:)=real_seg;
m=m+1;
s_num
% %   save('brain_1_vs_1_1mm_n0_r0.mat','acc_csf','acc_gry','acc_white','TP_csf','FP_csf','TP_gry','FP_gry','TP_wht','FP_wht','TP','FN','FP','TN','OM','ACC');  
close all;
    end
    avg_csf=mean(acc_csf);
avg_gry=mean(acc_gry);
avg_wht=mean(acc_white);

[csf_volume,gry_volume,white_volume,r_csf_volume,r_gry_volume,r_white_volume]=brain_volumetry(all_segments,real_segments,1)

diff_csf=r_csf_volume-csf_volume
diff_gry=r_gry_volume-gry_volume
diff_white=r_white_volume-white_volume
     save('brainvolume_1_vs_1_1mm_n0_r0.mat','csf_volume','gry_volume','white_volume','r_csf_volume','r_gry_volume','r_white_volume');  

  


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