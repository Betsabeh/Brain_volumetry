function [r1,r2,r3]=vote(r1,D1,r2,D2,r3,D3)
[row,col]=size(r1);
for i=1:row
    for j=1:col
        if (r1(i,j)+r2(i,j)+r3(i,j)>8)
            if (r1(i,j)==4)&&(r2(i,j)==2)&&(r3(i,j)==3)
                if (abs(D2(i,j))>=abs(D3(i,j)))
                    r2(i,j)=2;
                    r3(i,j)=3;
                end
            else
               continue;
            end
        else
            [val,ind]=max(abs([D1(i,j),D2(i,j),D3(i,j)]));
                switch ind
                    case 1
                        r1(i,j)=r1(i,j);
                        r2(i,j)=4;
                        r3(i,j)=4;
                    case 2
                        r1(i,j)=4;
                        r2(i,j)=r2(i,j);
                        r3(i,j)=4;
                    case 3
                        r1(i,j)=4;
                        r2(i,j)=4;
                        r3(i,j)=r3(i,j);
                end
        end
    end
end

                