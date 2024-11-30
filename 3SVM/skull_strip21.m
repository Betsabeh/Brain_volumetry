function [bin,skull_image,TP,FN,FP,TN,OM,acc]=skull_strip21(image,k)
%this function extract the brain from skull
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%normalized   
[row,col]=size(image);
m1=max(max(image));
m2=min(min(image));
image1=((image-m2)/(m1-m2))*255;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%apply threshold
[thresholded_image,negative] =apply_threshold(image1,2);
Jd=my_diffusion(image1,'pm1',15,20,0.2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%contour initilaization
% % % % figure
% % % %  [fig_handle, image_handle, bar_handle] = viewimage (Jd);
[r1,r2,c_x,c_y]=new_bound_increasing_by_slice_num21(image,k);
% % % figure
% % %  [fig_handle, image_handle, bar_handle] = viewimage (Jd+negative*100);
% % %  figure
% % %   [fig_handle, image_handle, bar_handle] = viewimage (Jd+thresholded_image*100);
  negative=bwareaopen(negative,40);
  negative=bwmorph(negative,'thicken');
  negative=bwareaopen(negative,500);
mask1=(Jd+negative*60+thresholded_image*100);
ma=max(max(mask1));
mi=min(min(mask1));
mask1=(mask1-mi)/(ma-mi);
%             mask1=bwareaopen(mask1,50);
if (k<=35)
ITER=400;
elseif ((k>35)&&(k<94))
    ITER=630;
elseif (k>=94)&&(k<130)
    ITER=1000;
else
    ITER=240;
end
if (k>150)  
[y,x]=new_vfc21(mask1*255,negative,thresholded_image,r2+2,r1+2,c_y,c_x,ITER );%%r1-3 , c_y+1
  else
 [y,x]=new_vfc21(mask1*255,negative,thresholded_image,r2,r1,c_y,c_x,ITER );%%r1-3 , c_y+1
  end
segmented_image=zeros(row,col);
for i=1:size(x,1)
    segmented_image(floor(x(i)),floor(y(i)))=1;
end
% segmented_image=bwmorph(segmented_image,'thicken');
se=ones(4,4);
segmented_image=imdilate(segmented_image,se);
segmented_image=imfill(segmented_image,4,'holes');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%accuracy
[TP,FN,FP,TN,OM,acc]=skull_accuracy(segmented_image,k)
bin=segmented_image;
skull_image=image.*segmented_image;
   