function h=histogram(image)
%,,numbin,s
[m,n]=size(image);
 h=zeros(1,256);
% % % % % if(numbin==256)
    for i=1:m
        for j=1:n
            h(double(image(i,j))+1)=h(double(image(i,j))+1)+1;
        end
    end
% % % % % % else
% % % % % %    for i=1:m
% % % % % %         for j=1:n
% % % % % %             temp=double(image(i,j));
% % % % % %             for k=1:numbin-1
% % % % % %                 if((temp+1>=s(k))&(temp+1<=s(k+1)))
% % % % % %                     h(k)=h(k)+1;
% % % % % %                     t=-1;
% % % % % %                     break;
% % % % % %                 end
% % % % % %             end
% % % % % %             if(t~=-1)
% % % % % %                 t=1;
% % % % % %             end
% % % % % %         end
% % % % % %     end

return
end
