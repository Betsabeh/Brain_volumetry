function [svm_data_w,svm_data_g,svm_data_c]=read_skull_strip_data(s_num,row,col,n_row,n_col)
    images = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\nromal\1mm\t1_icbm_normal_1mm_pn0_rf0.mnc',s_num);
    a = reshape (images, row, col);
    [bin,a1,TP,FN,FP,TN,OM,ACC]=skull_strip21(a,s_num);
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
                    %%%%%%%%%%%%%%label's for csf
                    if (n(i,j)==1)
                        part_label_c(i,j)=1;
                    else
                      part_label_c(i,j)=4;
                    end 
                       %%%%%%%%%%%%%%label's for gray
                        if (n(i,j)==2)
                            part_label_g(i,j)=2;
                        else
                            part_label_g(i,j)=4;
                        end
                                %%%%%%%%%%%%%label's for white
                                 if (n(i,j)==3)
                                    part_label_w(i,j)=3;
                                else
                                   part_label_w(i,j)=4;
                                 end
                            end
                        end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%svm inputs
K=1;
l=(K-1)*n_row*n_col+1;
u=K*n_row*n_col;

svm_data_w(l:u,1)=reshape(a.^2,n_row*n_col,1);
svm_data_g(l:u,1)=reshape(a.^2,n_row*n_col,1);
svm_data_c(l:u,1)=reshape(a.^2,n_row*n_col,1);

t=otsu(a);
d=bwdist(t,'euclidean');
svm_data_w(l:u,2)=reshape(d,n_row*n_col,1);
svm_data_g(l:u,2)=reshape(d,n_row*n_col,1);
svm_data_c(l:u,2)=reshape(d,n_row*n_col,1);

part_la_w=reshape(part_label_w,n_row*n_col,1);
part_la_g=reshape(part_label_g,n_row*n_col,1);
part_la_c=reshape(part_label_c,n_row*n_col,1);

svm_data_w(l:u,3)=part_la_w;
svm_data_g(l:u,3)=part_la_g;
svm_data_c(l:u,3)=part_la_c;

close all
