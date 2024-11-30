function [initialLSF,image]=show_boundry(image)
%%%%%%%%image is binary  and it remove the boundry of the image
[row,col]=size(image);
thresholded_image=otsu(double(image),2);
%%%%%%%%%%%%%%%find height and weight
se=strel('disk',4);
im=imclose(thresholded_image,se);
im=imfill(im,4,'holes');
im=double(im);
[o,p]=find(im==1);
[v_i_1,i]=max(o);
[v_i_2,i]=min(o);
width=v_i_1-v_i_2;
[v_j_1,i]=max(p);
[v_j_2,i]=min(p);
height=v_j_1-v_j_2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% boundry
if (width>row-3)
    l_cof=0.07;%0.1
    r_cof=0.05;%0.1
    b_cof=0.07;%0.09
    t_cof=0.05;%0.1

else
    l_cof=0.05;%0.1
    r_cof=0.07;%0.1
    b_cof=0.05;%0.05
    t_cof=0.05;%0.05

end
left_num=floor(l_cof*width)-1;
right_num= floor(r_cof*width)-1;
bot_num=ceil(b_cof*height);
top_num=ceil(t_cof*height);
c0=4;

initialLSF=c0*ones(row,col);
r1=width/2-l_cof*width;
r2=height/2-b_cof*height;
for i=1:row
    for j=1:col
        temp1=((i-(width/2))^2)/(r1^2);
        temp2=((j-(height/2)+1)^2)/(r2^2);
        if (temp1+temp2<=1)
            initialLSF(i+v_i_2,j+v_j_2+1)=-c0;
        end
    end
end
e=edge(initialLSF,'canny');
initialLSF=initialLSF+e*c0;
% % % % initialLSF(left_num+v_i_2:v_i_1-right_num,v_j_2+bot_num)=0;
% % % % initialLSF(left_num+v_i_2, v_j_2+bot_num:v_j_1-top_num)=0;
% % % % initialLSF(left_num+v_i_2:v_i_1-right_num, v_j_1-top_num)=0;
% % % % initialLSF(v_i_1-right_num,v_j_2+bot_num:v_j_1-top_num)=0;
% % % % 
% % % % initialLSF(v_i_2+left_num+1:v_i_1-right_num-1, v_j_2+bot_num+1:v_j_1-top_num-1)=-c0;

% % figure,
% % [fig_handle, image_handle, bar_handle] = viewimage (initialLSF);
for i=1:row
    for j=1:col
        if (initialLSF(i,j)>=0)
            image(i,j)=0;
        end
    end
end
% % % figure,
% % % imshow(image,[])