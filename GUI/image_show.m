function IM=image_show(handles,axes_num,slice_num)
images = mireadimages ('c:\betsabeh\my_project\volumetry\matlab\data\phantom\nromal\1mm\t1_icbm_normal_1mm_pn0_rf0.mnc',slice_num);
t1 = reshape (images, 181, 217);
[row,col] = size(t1);
% % % fmin  = min(t1(:));
% % % fmax  = max(t1(:));
% % % t1= (t1-fmin)/(fmax-fmin);  % Normalize f to the range [0,1]
% % % t1=t1*255;
axes(handles.axes1);
imshow((t1),[])
%[fig_handle, image_handle, bar_handle] = viewimage (t1);
%title('real image')
IM=t1;