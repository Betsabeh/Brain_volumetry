% SEGMENTSCRIPT Script to open image file, set initial circle, and
% run either traditional segmentation or active contours
% segmentation
 clc;
 clear;
 mypath;
close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%INPUT: image
for i=3:50
%images = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\noram_part\phantom_3.0mm_normal_crisp.mnc',i);
images = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\nromal\3mm\t1_icbm_normal_3mm_pn0_rf0.mnc',i);
im = reshape (images, 181, 217);
figure,5
[fig_handle, image_handle, bar_handle] = viewimage (im);
% % 
% % pause
% % close all
% % % end

 ma=max(max(im(:)));
 mi=min(min(im(:)));
 im=(im-mi)/(mi+ma);
im=im*255;
phi = activecontour( im, [85,90], 40, -1, 5, 5,'te' ,i);
end
display_it = 1;
movie_it = 1;
% % 
% % % grab the image filename and path
% % [ filename, pathname ] = uigetfile( '*', 'Select an image to segment' );
% % 
% % % if user cancelled dialog box then exit
% % if( filename == 0 )
% %   return;
% % end;

% Scale the image by a user specified amount
while( 1 )
  scalefactor = input( 'Enter scaling factor between 0 and 4: ');
  if( isnumeric( scalefactor ) )
    if( scalefactor > 0 & scalefactor <= 4 )
      break;
    end;
  end;
end;

% otherwise open the image and display it
% im = readimage( strcat( pathname, filename ));
 im_resized = imresize( im, scalefactor );
% % % % % imshow( uint8( im_resized ) );

% and get the user to click on the circle center
disp( 'Click on circle center' );
center = ginput( 1 );

% display the center and get the user to click again to define the
% radius
disp( 'Click again to define radius' );
hold on;
plot( center(1), center(2), 'go-' );
hold off;
radius = round( sqrt( sum( ( center - ginput( 1 ) ).^2 ) ) )

% Get the user to pick the method of segmentation
disp( 'Pick Segmentation Method' );
disp( '1. Level Sets using Edge Stopping Function' );
disp( '2. Level Sets using Active Contours without Edges' );

selection = 0;
while( selection ~= 1 & selection ~= 2 )
  selection = input( 'Please pick (1) or (2): ' );
end;

% Get the user to pick whether the circle contains the object
disp( 'Choose whether or not entire object is inside circle' );
disp( '1. Completely Inside' );
disp( '2. Not Completely Inside' );

inside = 0;
while( inside ~= 1 & inside ~= 2 )
  inside = input( 'Please pick (1) or (2): ' );
end;

%%moviename = filename( 1 : strfind( filename, '.' ) - 1 );
moviename='test';
% and run the level set segmentation
if( selection == 1 )
  phi = levelsetband( im_resized, circshift( center, [ 0, 1 ] ), radius, 2 - inside , display_it, movie_it, moviename );
else
  phi = activecontour( im_resized, circshift( [90,110], [ 0, 1 ] ), 80, 2 - inside, display_it, movie_it, moviename );
end;

% overlay the front on the original image
resized_phi = imresize( phi, size( im ) );
im_segmented = createimage( im, resized_phi );

% display the segmented image and save it to disk
clf; imshow( im_segmented ); drawnow;
imwrite( im_segmented, strcat( moviename, '_segmented.png' ) );