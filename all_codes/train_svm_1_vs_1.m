function [fAlphaY, fSVs, fBias, fParameters, fnSV, fnLabel]=train_svm_1_vs_1(traindata,C,O)
%%L=size(traindata,3);
Gamma=2;
sA=zeros(C,C);
sB=zeros(C,C);
%*********************************
for j=1:C
    for k=j+1:C
        if (j~=k)
            tr=[];
% %             tr(:,:)=traindata(1:O+1,1,:);
            tr=[traindata(:,traindata(O+1,:)==j) traindata(:,traindata(O+1,:)==k)];
% % 	        tr(O+1,tr(O+1,:)~=j)=-1;
% % 	        tr(O+1,tr(O+1,:)==j)=1;
            xt = tr(1:O,:);
            yt = tr(O+1,:);
            weight(1)=1;
            weight(2)=1;
            [AlphaY, SVs, Bias, Parameters, nSV, nLabel] = RbfSVC(xt, yt, Gamma,1,weight);
            mAlphaY(j,k)=num2cell(AlphaY,[1 2]);
            mSVs(j,k)=num2cell(SVs,[1 2]);
            mBias(j,k)=num2cell(Bias,[1 2]);
            mParameters(j,k)=num2cell(Parameters,[1 2]);
            mnSV(j,k)=num2cell(nSV,[1 2]);
            mnLabel(j,k)=num2cell(nLabel,[1 2]);
% % %             testx=traindata(1:O,1,:);
% % %             testy=traindata(O+1,1,:);
% % %             [ClassRate, DecisionValue, Ns, ConfMatrix, PreLabels]=...
% % %                 SVMTest(testx,testy, AlphaY, SVs, Bias,Parameters, nSV, nLabel);
% % %             pos=size(PreLabels(:,PreLabels==nLabel(1)),2);
% % %             neg=size(PreLabels(:,PreLabels==nLabel(2)),2);
% % %             PreLabels(PreLabels(:)==j)=-1;
% % % 	        PreLabels(PreLabels(:)==k)=1;
% % %             [A1,B1]=platt(DecisionValue,PreLabels,neg,pos);
% % %             Am(j,k)=A1;
% % %             sA(j,k)=A1+sA(j,k);
% % %             sB(j,k)=B1+sB(j,k);
% % %             Bm(j,k)=B1;
        end
    end 
end
%*********************************

fnLabel=mnLabel;
fnSV=mnSV;
fParameters=mParameters;
fBias=mBias;
fAlphaY=mAlphaY;
fSVs=mSVs;
 
 
 
 
 