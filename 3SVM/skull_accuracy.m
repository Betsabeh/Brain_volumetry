function [TP,FN,FP,TN,OM,acc]=skull_accuracy(segmented_image,k)
%find the accuracy of skull striping
    [row,col]=size(segmented_image);
    images_crisp = mireadimages ('h:\betsabeh\my_project\volumetry\matlab\data\phantom\noram_part\phantom_1[1].0mm_normal_crisp.mnc',k);
    nim = reshape(images_crisp, 181, 217);
    nimage=imresize(nim,[row col]);
    figure
    [fig_handle, image_handle, bar_handle] = viewimage(nimage)
    cor=0;
    for i=1:row
        for j=1:col
            if ((nimage(i,j)==1)||(nimage(i,j)==2)||(nimage(i,j)==3))&&(segmented_image(i,j)==1)
                cor=cor+1;
            end
        end
    end
    NR=size(find(nimage==1),1)+size(find(nimage==2),1)+size(find(nimage==3),1);
    TP=cor/NR
    %FP
    [l,p]=find(segmented_image==1);
    NB=size(l,1);
    FP=abs(NB-cor)/NR
    %OM
    OM=TP/(1+FP)
    TN=1-FP;
    FN=1-TP;
    acc=(TN+TP)/(TN+TP+FN+(FP))
    figure
    [fig_handle, image_handle, bar_handle] = viewimage(nimage.*segmented_image)