function [csf_volume,gry_volume,white_volume,r_csf_volume,r_gry_volume,r_white_volume]=brain_volumetry1(real_seg,csf_seg,gry_seg,wht_seg,thickness)
[slice_num,slice_row,slice_col]=size(real_seg);
s1=0;%segmented area of csf
s2=0;%segmented area of gry
s3=0;%segmented area of white
r_s1=0;%real area
r_s2=0;%real area
r_s3=0;%real area
for k=1:slice_num
    for i=1:slice_row
        for j=1:slice_col
            switch real_seg(k,i,j)
                case 1
                    r_s1=r_s1+1;
                case 2
                    r_s2=r_s2+1;
                case 3
                    r_s3=r_s3+1;
            end
             if (csf_seg(k,i,j)==1)
                 s1=s1+1;
             end
             if (gry_seg(k,i,j)==2)
                 s2=s2+1;
             end
             if (wht_seg(k,i,j)==3)
                 s3=s3+1;
             end
        end
    end
end
csf_volume=(s1*thickness)/1000;
gry_volume=(s2*thickness)/1000;
white_volume=(s3*thickness)/1000;

r_csf_volume=(r_s1*thickness)/1000;
r_gry_volume=(r_s2*thickness)/1000;
r_white_volume=(r_s3*thickness)/1000;