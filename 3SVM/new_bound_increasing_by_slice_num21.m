function [r1,r2,c_x,c_y]=new_bound_increasing_by_slice_num(image,k)
[row,col]=size(image);
% % % % % c_r1=round(row*0.26); %%47
% % % % % c_r2=round(col*0.23);%%49
c_r1=48;%49
c_r2=49;%49
o=otsu(image);
[x,y]=find(o==1);
c_x=mean(x)
c_y=mean(y)
if (k<45)
% % %         r1=round(c_r1+(k-9)*(row/181)); 
% % %         r2=round(c_r2+(k-9)*(col/217));
              r1=c_r1+(k-9)*0.9; 
              r2=c_r2+(k-9)*1.3;
             
        if (k<25)
        c_y=c_y-17;
   %%%    c_y=c_y-round(0.065*col)
        
      
        else
           %%%%c_y=c_y-round(0.033*col);  %%7
           c_y=c_y-7;
        end
elseif (k>105)
% % %     c_r1=round(row/2);%%90
% % %     c_r2=round(col*0.443);%%96
      c_r1=90;%90
      c_r2=94;
    
   
% % %     r1=round(c_r1-(k-100)*(row/181));
% % %     r2=round(c_r2-(k-100)*(col/217));
          r1=c_r1-(k-100)*1.05;
          r2=c_r2-(k-100);

else
% % % %     r1=round(row*0.42);%75
% % % %     r2=round(col*0.433);%94
r1=75; %%%75
r2=94;
    
% %      c_x=92;
% %     c_y=106;
    
end