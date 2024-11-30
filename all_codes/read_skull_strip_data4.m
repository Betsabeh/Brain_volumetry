function svm_data=read_skull_strip_data4(s_num,row,col,n_row,n_col,part)
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
    switch part
        case 'csf'
            for i=1:n_row
                  for j=1:n_col 
                    %%%%%%%%%%%%%%label's for csf
                    if (n(i,j)==1)
                        part_label(i,j)=1;
                    else
                      part_label(i,j)=4;
                    end 
                 end
            end
        case 'gray'
             for i=1:n_row
                for j=1:n_col 
                    %%%%%%%%%%%%%%label's for gray
                        if (n(i,j)==2)
                            part_label(i,j)=2;
                        else
                            part_label(i,j)=4;
                        end
                end
             end
                case 'white'
                        for i=1:n_row
                            for j=1:n_col 
                                %%%%%%%%%%%%%label's for white
                                 if (n(i,j)==3)
                                    part_label(i,j)=3;
                                else
                                   part_label(i,j)=4;
                                 end
                            end
                        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%svm inputs
    K=1;
    l=(K-1)*n_row*n_col+1;
    u=K*n_row*n_col;
    s1=reshape(a,1,n_row*n_col);
    mu=mean(s1);
    Y = expcdf(s1,mu);  
    svm_data(l:u,1)=reshape(Y,1,n_row*n_col);
    svm_data(l:u,2)=s1;
    part_la=reshape(part_label,n_row*n_col,1);
    svm_data(l:u,3)=part_la;

close all