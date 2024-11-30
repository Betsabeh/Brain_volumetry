function [thresholded_image,negative] =apply_threshold(image,mode)
%mode=1 first sharp image then apply thresholding
%mode=0 with out shapening the image
if mode==1
    H = fspecial('unsharp');
   image = imfilter(image,H,'replicate');
    figure
    [fig_handle, image_handle, bar_handle] = viewimage (image);
    title('unsharped filtered image')
end
thresholded_image=otsu(image);
% % % figure
% % % [fig_handle, image_handle, bar_handle] = viewimage (thresholded_image);
% % % title('otsu')
I=(1-thresholded_image).*image;
% % figure
% % [fig_handle, image_handle, bar_handle] = viewimage (I);
% % title('I=(1-otsu)*unsharped image')
negative=otsu(I);
% % % figure
% % % [fig_handle, image_handle, bar_handle] = viewimage (negative);
% % % title('otsu(I)')
