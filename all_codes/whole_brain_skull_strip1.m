% this is for extracting brain for all slices and finding accuracy
clc;
clear all;
close all;
mypath;
m=1;
for k=50:60
    images = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\nromal\1mm\t1_icbm_normal_1mm_pn0_rf0.mnc',k);
    a = reshape (images, 181, 217);
    [row,col]=size(a);
    figure,
    [fig_handle, image_handle, bar_handle] = viewimage (a);
    [bin,skull_image,TP(m),FN(m),FP(m),TN(m),OM(m),acc(m)]=skull_strip1(a,k);
    m=m+1;
    filename = strcat('C:\betsabeh\my_project\volumetry\matlab\mine\thesis\skull_striped1_slices\normal_1mm_slice', sprintf( '%d',k ), '.jpeg' );
    ma=max(max(skull_image));
    mi=min(min(skull_image));
    skull_image=((skull_image-mi)/(ma-mi)*256);
% % % s_image=zeros(row,col);
% % % [x,y]=find(skull_image~=0);
% % % for i=1:size(x,1)
% % %     s_image(x(i),y(i))=1;
% % % end
  imwrite(uint8(skull_image), filename );  
    k
    if (mod(k,5)==0)
        pause(0.5)
    end
      close all
end
avg_acc=mean(acc)
avg_TP=mean(TP)
avg_FP=mean(FP)
avg_OM=mean(OM)
avg_FN=mean(FN)
avg_TN=mean(TN)
  save('skull_9_1_2new[150,240].mat','avg_acc','avg_TP','avg_FP','avg_OM','avg_FN','avg_TN');