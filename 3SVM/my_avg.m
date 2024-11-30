function avg_img=my_avg(img)
[row,col]=size(img);
avg_img=zeros(row,col);
for i=1:row
    for j=1:col
        if (i>3)&&(j>3)&(i<row-3)&&(j<col-3)
            t=[img(i-1,j) img(i+1,j) img(i,j-1) img(i,j+1) img(i+1,j-1) img(i+1,j+1) img(i-1,j+1) img(i-1,j-1)];
            m(i,j)=mean(t);
            s(i,j)=std(t);
            avg_img(i,j)=m(i,j)-1*s(i,j);
            
            
        end
    end
end