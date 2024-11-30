function [mAlphaY, mSVs, mBias, mParameters, mnSV, mnLabel]=my_svmtrain(train_data,C,O)
Gamma=2;
% train1(:,:)=train_data(1:O+1,1,:);
%****************************trian
% % % for j=1:C
% % %            tr=[];
% % %            tr=[train_data(:,train_data(O+1,:)==j) train_data(:,train_data(O+1,:)~=j)];
% % %            tr(O+1,tr(O+1,:)~=j)=-1;
% % %            tr(O+1,tr(O+1,:)==j)=1;
% % % 	        xt = tr(1:O,:);
% % %             yt = tr(O+1,:);

% % %             weight(1)=0.05;
% % %             weight(2)=0.12;
% % %             weight(3)=0.1;
% % %             weight(4)=0.31;
% % %             weight(5)=0.42;
            [mAlphaY, mSVs, mBias, mParameters, mnSV, mnLabel] = RbfSVC(train_data(1:O,:),train_data(O+1,:) , Gamma,0.5);
% %             mAlphaY(j)=num2cell(AlphaY,[1 2]);
% %             mSVs(j)=num2cell(SVs,[1 2]);
% %             mBias(j)=num2cell(Bias,[1 2]);
% %             mParameters(j)=num2cell(Parameters,[1 2]);
% %             mnSV(j)=num2cell(nSV,[1 2]);
% %             mnLabel(j)=num2cell(nLabel,[1 2]);
%end
        
   


