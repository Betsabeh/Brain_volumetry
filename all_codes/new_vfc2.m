function [x,y]=new_vfc2(I,oo,o,r1,r2,c_x,c_y,ITER)
% % % % % % t = (0:0.01:2*pi);
% % % % % %     x = c_x + (r1)*cos(t);  
% % % % % %     y = c_y+ (r2)*sin(t);
% % % % % %       [x,y] = snakeinterp(x,y,2,0.5); 
% % % % % %       [row,col]=size(I);
% % % % % %       mask=zeros(row,col);
% % % % % %        for i=1:size(x,1)
% % % % % %           mask(floor(y(i)),floor(x(i)))=1;
% % % % % %       end
% % % % % %       se=ones(4,4);
% % % % % %       mask=imdilate(mask,se);
% % % % % %      mask=imclose(mask,se);
% % % % % %      mask=imfill(mask,4,'holes');
% % % % % %      mask1=oo.*mask+o.*mask;
% % % % % %      I=I.*mask1;

% % %      Img1=I.*(1-mask);
% % %      Img1=diffusion(Img1,'pm2',25,20,0.2);
% % % 
% % %    %%%%  H_image=homogeneuos(I);
% % %      Img2=  (H_image).*mask;
% % % I=Img1+Img2;
[row,col]=size(I);
 f=1-I./255;
              
% % % % h=fspecial('gaussian',5);
% % % % Im=imfilter(I,h);
% % % [gx,gy]=gradient(I);
% % % f=-sqrt(gx.^2+gy.^2);
%%%%%%%%%%%%%%%%%f=-bwmorph(oo,'thicken');
% % % % %  [gx,gy]=gradient(I);
% % % % %  f=(gx.^2+gy.^2);
% % % % % f=1./(1+f);
%f=I;
 
  % display the results
     figure(1); 
     subplot(221); imdisp(I); title('test image');
     subplot(222); imdisp(f); title('edge map');

     % display the gradient of the edge map
      K = AM_VFK(2, 90,' power',1.5);
% %             c1 = 2+K(:,:,1)./sqrt(sum(K.^2, 3)+eps);
% %             c1(:,:,2) = c1;

    Fext = AM_VFC(f, K, 1, .1);
    px=Fext(:,:,1);
    py=Fext(:,:,2);
     % display the GVF 
% %      subplot(224); quiver(px,py);
% %      axis off; axis equal; axis 'ij';     % fix the axis 
% %      title('VFC field');

   % snake deformation
% %      disp(' Press any key to start GVF snake deformation');
% %      pause;
     subplot(221);
    imshow(f,[]);
     axis('square', 'off');
     colormap(gray(64)); 
     % this is for student version
     % for professional version, use 
     %   [x,y] = snakeinterp(x,y,2,0.5);
    t =(0:0.009:2*pi);
    x = c_x + r1*cos(t);  
    y = c_y+ r2*sin(t);
    [x,y] = snakeinterp(x,y,2,0.5);
%%%%%   [x,y] = snakeinterp(x,y,col/100,col/400);  % 2 0.5
     snakedisp(x,y,'r') 
     pause(1);

     
    
     for i=1:ITER,
       [x,y] = snakedeform(x,y,0.5,0,5,0.5,px,py,3);
        [x,y] = snakeinterp(x,y,2,0.5);
       %%%%%[x,y] = snakeinterp(x,y,col/100,col/400); % this is for student version
       % for professional version, use 
       %   [x,y] = snakeinterp(x,y,2,0.5);
       snakedisp(x,y,'r') 
       title(['Deformation in progress,  iter = ' num2str(i*3)])
       pause(0.5);
   end

% %      disp(' Press any key to display the final result');
% %      pause;
     cla;
     colormap(gray(64)); imshow(f,[]); axis('square', 'off');
     snakedisp(x,y,'r') 
     title(['Final result,  iter = ' num2str(i*5)]);
    

     
