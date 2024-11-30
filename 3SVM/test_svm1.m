function [seg_image ,DecisionValue]=test_svm1(test_data,C,O,mAlphaY, mSVs, mBias, mParameters, mnSV, mnLabel)
%**********************************test
test_no=size(test_data,2);
 c=zeros(test_no,C);
  z=zeros(1,test_no);
%   test=zeros(O+1,test_no);
% % % %   for k=1:C
% % % %         AlphaY=cell2mat(mAlphaY(k));
% % % %         SVs=cell2mat(mSVs(k));
% % % %         Bias=cell2mat(mBias(k));
% % % %         Parameters=cell2mat(mParameters(k));
% % % %         nSV=cell2mat(mnSV(k));
% % % %         nLabel=cell2mat(mnLabel(k));
%         test(:,:)=test_data(1:O+1,1,:);
       [ClassRate, DecisionValue, Ns, ConfMatrix, PreLabels]=...
       SVMTest(test_data(1:O,:), z, mAlphaY, mSVs, mBias,mParameters, mnSV, mnLabel);
% %        c(DecisionValue>0,nLabel(1))=c(DecisionValue>0,nLabel(1))+DecisionValue(DecisionValue>0)';
% %        c(DecisionValue<0,nLabel(2))=c(DecisionValue<0,nLabel(2))-DecisionValue(DecisionValue<0)';
%%%          c(:,k)=PreLabels';
% % % %           end 
      seg_image=PreLabels';
% % % for p=1:test_no
% % % %     c(p,c(p,:)==0)=-10000;
% % %     [m,idx]=max(c(p,:));
% % %     seg_image(p)=idx;
% % % end

%s=1*sign(abs(test_data(O+1,:)-test_svm));
%svmerr=sum(s)*100/test_no;
