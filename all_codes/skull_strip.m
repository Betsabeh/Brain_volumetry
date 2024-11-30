function [skull_image,TP,FN,FP,TN,OM,acc]=skull_strip(image,k)
%this function extract the brain from skull
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%normalized   
[row,col]=size(image);
m1=max(max(image));
m2=min(min(image));
image1=((image-m2)/(m1-m2))*255;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%apply threshold
[thresholded_image,negative] =apply_threshold(image1,1);
Jd=diffusion(image1,'pm1',15,20,0.2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%contour initilaization
[r1,r2,c_x,c_y]=new_bound_increasing_by_slice_num(image,k);
mask1=(negative*30+thresholded_image*100);
%             mask1=bwareaopen(mask1,50);
if (k>=9)&&(k<16)
   ITER=100;%120
elseif (k>20)&&(k<30)
ITER=300;
elseif (k>30)&&(k<55)
    ITER=440;
else
 ITER=350;
end

[y,x]=new_vfc2(Jd+mask1,negative,thresholded_image,r2,r1,c_y,c_x,ITER );%%r1-3 , c_y+1
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
skull_image=image.*segmented_image;
   