function svm_data=read_skull_strip_data3(s_num,row,col,n_row,n_col)
    images = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\nromal\1mm\t1_icbm_normal_1mm_pn0_rf0.mnc',s_num);
    a = reshape (images, row, col);
    [bin,a1,TP,FN,FP,TN,OM,ACC]=skull_strip2(a,s_num);
    a=imresize(a1,[n_row,n_col]);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%find label
    images_crisp = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\noram_part\phantom_1[1].0mm_normal_crisp.mnc',s_num);
    nimage = reshape(images_crisp, row, col);
    figure
    [fig_handle, image_handle, bar_handle] = viewimage(nimage)
    n=imresize(nimage,[n_row n_col]);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%labels
   for i=1:n_row
       for j=1:n_col 
           if ((n(i,j)==1)||(n(i,j)==2)||(n(i,j)==3))
               part_label(i,j)=n(i,j);
           elseif (n(i,j)==0)
               part_label(i,j)=4;
           else
               part_label(i,j)=5;
           end
       end
   end
  
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%svm inputs
 
t=otsu(a);
d=bwdist(t,'euclidean'); 
svm_data(:,1)=reshape(d,n_row*n_col,1);
svm_data(:,2)=reshape(a,n_row*n_col,1);
part_la=reshape(part_label,n_row*n_col,1);
svm_data(:,3)=part_la;
close all