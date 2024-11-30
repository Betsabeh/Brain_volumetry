function seg = activecontour( u0, center, radius, isinside, d_it, m_it, m_name,slice_num )
% ACTIVECONTOUR Segment an image using active contours
%    ACTIVECONTOUR( u0, center, radius, isinside, d_it, m_it, m_name )
%    segments the image u0 with initial segmented region as a
%    circle with argument center and radius. The current segmented
%    image is displayed every d_it iterations and written to disk
%    every m_iterations with name m_name*.png.

% constants

ITERATIONS = 88;
delta_t = 0.1;
lambda1 = 1;
lambda2 = 1;
nu = 0;
h = 1; h_sq = h^2;
epsilon = 1;
mu = 0.01 * 255^2;

% initialize phi to signed distance function from circle
phi = initphi( size( u0 ), center, radius, isinside );
%phi=show_boundry(u0);

for ii = 1 : ITERATIONS;

  % display current iteration
  fprintf( 1, '%d\n', ii );

  % display the segmented image every 'd_it' iterations
  if( mod( ii - 1, d_it ) == 0 )
    disp( 'Displaying Segmented Image' );
    segim = createimage( u0, phi );
   clf; imshow( segim );
    drawnow;
  end;

  % write current segmented image to file every 'm_it'
  % iterations
% % %   if( mod( ii - 1, m_it ) == 0 )
% % %     segim = createimage( u0, phi );
% % %     filename = strcat( m_name, sprintf( '%06d', ( ( ii - 1 )/ m_it ) + 1 ), '.jpeg' );
% % %     imwrite( segim, filename );
% % %   end;

  % compute dirac(phi) * delta_t factor
  dirac_delta_t = delta_t * dirac( phi, epsilon );

  % calculate inside and outside curve terms
  [ inside, outside ] = calcenergy( u0, phi, epsilon );
  energy_term = -nu - lambda1 .* inside + lambda2 .* outside;

  % calculate central differences
  dx_central = ( circshift( phi, [ 0, -1 ] ) - circshift( phi, [ 0, 1 ] ) ) / 2;
  dy_central = ( circshift( phi, [ -1, 0 ] ) - circshift( phi, [ 1, 0 ] ) ) / 2;

  % calculate the divergence of grad_phi/|grad_phi|
  abs_grad_phi = ( sqrt( dx_central.^2 + dy_central.^2 ) + 0.00001 );
  x = dx_central ./ abs_grad_phi;
  y = dy_central ./ abs_grad_phi;
  grad_term = ( mu / h_sq ) .* divergence( x, y );

  % calculate phi^n+1
  phi = phi + dirac_delta_t .* ( grad_term + energy_term );

end;
maxv=max(max(phi));
minv=min(min(phi));
if (minv<0)
    phi=phi+abs(minv);
    maxv=max(max(phi));
    minv=min(min(phi));
end
phi=(phi-(minv))/(maxv-(minv));

[row,col]=size(u0);
n=otsu(phi);
n=1-double(n);
% % % % % %  bin=imfill(n,4,'holes');
% % % % % % [o,p]=find(bin==1);
% % % % % % [v_i_1,i]=max(o);
% % % % % % [v_i_2,i]=min(o);
% % % % % % width=v_i_1-v_i_2;
% % % % % % [v_j_1,i]=max(p);
% % % % % % [v_j_2,i]=min(p);
% % % % % % height=v_j_1-v_j_2;

l=bwlabel(n);
num_region=max(max(l))
 s_i=zeros(1,num_region+1);
%  s_j=zeros(1,num_region+1);
  nu=zeros(1,num_region+1);
  for i=1:num_region+1
      [o,p]=find(l==i-1);
      s_i(i)=size(o,1);
%       s_j(i)=mean(p,1);
  end
% % % % % %    top_bound=10+(col/2);
% % % % % %    bot_bound=(col/2)-10;
% % % % % %  left_bound=(row/2)-10;
% % % % % %   right_bound=10+(row/2);

[val,ind]=max(s_i);
if (ind==1)
    s_i(ind)=0;
    [val,ind]=max(s_i);
end
[o,p]=find(l==ind-1);
num=val;
y=zeros(row,col);
for i=1:num
    y(o(i),p(i))=1;
end
% % % % % %   for i=1:row
% % % % % %       for j=1:col
% % % % % %           label=l(i,j);
% % % % % %           % if (s_j(label+1)>=abs(cj-maxy*Iv))&&(s_j(label+1)<=cj+miny*Id)&&(s_i(label+1)>=abs(ci-minx*Il))&&(s_i(label+1)<=ci+(maxx*Ir))
% % % % % %           if (s_j(label+1)>=bot_bound)&&(s_j(label+1)<=top_bound)&&(s_i(label+1)>= left_bound)&&(s_i(label+1)<=right_bound)
% % % % % %              ni(i,j)=n(i,j);
% % % % % %          else
% % % % % %              ni(i,j)=0;
% % % % % %          end
% % % % % %      end
% % % % % %  end
% % % % % %  
% % figure,
% % [fig_handle, image_handle, bar_handle] = viewimage (ni)
% % title('after label')
se=strel('square',10);
y=imclose(y,se);
y=imfill(y,4,'holes');
% % % % images = mireadimages ('c:\betsabeh\my_project\volumetry\matlab\data\phantom\noram_part\phantom_3.0mm_normal_crisp.mnc',slice_num);
% % % % nimage = reshape (images, 181, 217);
% % % % % % % % figure,
% % % % % % % % [fig_handle, image_handle, bar_handle] = viewimage (nimage)
% % % % % % % title('crisp brain ')
% % % % 
% % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55555
% % % %     cor=0;
% % % %     for i=1:row
% % % %         for j=1:col
% % % %             if((y(i,j)~=0)&&(nimage(i,j)==1)||(nimage(i,j)==2)||(nimage(i,j)==3))
% % % %                   cor=cor+1;
% % % %                 
% % % %             end
% % % %            
% % % %           end
% % % %       end
% % % % NR=size(find(nimage==1),1)+size(find(nimage==2),1)+size(find(nimage==3),1);
% % % % TP=cor/NR
% % % % %FP
% % % % [o,p]=find(y~=0);
% % % % NB=size(o,1);
% % % % FP=abs(NB-cor)/NR
% % % % %OM
% % % % OM=TP/(1+FP)
% % % % TN=1-FP;
% % % % FN=1-TP;
% % % % acc=(TN+TP)/(TN+TP+abs(FN)+abs(FP));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:row
    for j=1:col
        if (y(i,j)==1)
            seg(i,j)=u0(i,j);
        else
            seg(i,j)=0;
        end
    end
end
imshow(seg)