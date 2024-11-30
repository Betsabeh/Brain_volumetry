function [fAlphaY, fSVs, fBias, fParameters, fnSV, fnLabel]=train_svm_1vs_all(traindata,C,O)
% % L=size(traindata,3);
Gamma=2;
% % % sA=zeros(1,C);
% % % sB=zeros(1,C);
%*********************************
for j=1:C
        tr=[];
% %         tr(:,:)=traindata(1:O+1,1,:);
        tr=[traindata(:,traindata(O+1,:)==j) traindata(:,traindata(O+1,:)~=j)];
        tr(O+1,tr(O+1,:)~=j)=-1;
        tr(O+1,tr(O+1,:)==j)=1;
        xt = tr(1:O,:);
        yt = tr(O+1,:);
        weight(1)=1;
        weight(2)=1;
        [AlphaY, SVs, Bias, Parameters, nSV, nLabel] = RbfSVC(xt, yt, Gamma,1,weight);
        mAlphaY(j)=num2cell(AlphaY,[1 2]);
        mSVs(j)=num2cell(SVs,[1 2]);
        mBias(j)=num2cell(Bias,[1 2]);
        mParameters(j)=num2cell(Parameters,[1 2]);
        mnSV(j)=num2cell(nSV,[1 2]);
        mnLabel(j)=num2cell(nLabel,[1 2]);
        
% %         [ClassRate, DecisionValue, Ns, ConfMatrix, PreLabels]=...
% %             SVMTest(xt,yt, AlphaY, SVs, Bias,Parameters, nSV, nLabel);
% %         pos=size(PreLabels(:,PreLabels==nLabel(1)),2);
% %         neg=size(PreLabels(:,PreLabels==nLabel(2)),2);
% %         [A1,B1]=platt(DecisionValue,PreLabels,neg,pos);
% %         Am(j)=A1;
% %         sA(j)=A1+sA(j);
% %         sB(j)=B1+sB(j);
% %         Bm(j)=B1;
end
%*********************************
fnLabel=mnLabel;
fnSV=mnSV;
fParameters=mParameters;
fBias=mBias;
fAlphaY=mAlphaY;
fSVs=mSVs;
 
 
 
 
 