%DEMMLP2 Demonstrate simple classification using a multi-layer perceptron
%
%	Description
%	The problem consists of input data in two dimensions drawn from a
%	mixture of three Gaussians: two of which are assigned to a single
%	class.  An MLP with logistic outputs trained with a quasi-Newton
%	optimisation algorithm is compared with the optimal Bayesian decision
%	rule.
%
%	See also
%	MLP, MLPFWD, NETERR, QUASINEW
%

%	Copyright (c) Ian T Nabney (1996-2001)
mypath

% Set up some figure parameters
AxisShift = 0.05;
ClassSymbol1 = 'r.';
ClassSymbol2 = 'y.';
PointSize = 12;
titleSize = 10;

% Fix the seeds
rand('state', 423);
randn('state', 423);
fh1 = figure;
set(fh1, 'Name', 'True Data Distribution');
whitebg(fh1, 'k');

% Generate the data
% 


% Set up mixture model: 2d data with three centres
% Class 1 is first centre, class 2 from the other two
mix = gmm(2, 3, 'full');
mix.priors = [0.5 0.25 0.25];
mix.centres = [0 -0.1; 1 1; 1 -1];
mix.covars(:,:,1) = [0.625 -0.2165; -0.2165 0.875];
mix.covars(:,:,2) = [0.2241 -0.1368; -0.1368 0.9759];
mix.covars(:,:,3) = [0.2375 0.1516; 0.1516 0.4125];

%[data, label] = gmmsamp(mix, n);
row=181;
col=217;
s_num=70;
images = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\nromal\1mm\t1_icbm_normal_1mm_pn0_rf0.mnc',s_num);
a = reshape (images, row, col);
[bin,a1,TP,FN,FP,TN,OM,ACC]=skull_strip2(a,s_num);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%find label
images_crisp = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\noram_part\phantom_1[1].0mm_normal_crisp.mnc',s_num);
nimage = reshape(images_crisp, row, col);

t=otsu(a1);
d=bwdist(t,'euclidean'); 
data(:,1)=reshape(d,row*col,1);
data(:,2)=images;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%csf
for i=1:row*col
    if (images_crisp(i)==1)
        clabel(i)=1;
    else
        clabel(i)=2;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%gry
for i=1:row*col
    if (images_crisp(i)==2)
        glabel(i)=1;
    else
        glabel(i)=2;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%wht
for i=1:row*col
    if (images_crisp(i)==3)
        wlabel(i)=1;
    else
        wlabel(i)=2;
    end
end


% 
% Calculate some useful axis limits
% 
x0 = min(data(:,1));
x1 = max(data(:,1));
y0 = min(data(:,2));
y1 = max(data(:,2));
dx = x1-x0;
dy = y1-y0;
expand = 5/100;			% Add on 5 percent each way
x0 = x0 - dx*expand;
x1 = x1 + dx*expand;
y0 = y0 - dy*expand;
y1 = y1 + dy*expand;
resolution = 100;
step = dx/resolution;
xrange = [x0:step:x1];
yrange = [y0:step:y1];
% 					
% Generate the grid
% 
[X Y]=meshgrid([x0:step:x1],[y0:step:y1]);
% 
% Calculate the class conditional densities, the unconditional densities and
% the posterior probabilities
% 
px_j = gmmactiv(mix, [X(:) Y(:)]);
px = reshape(px_j*(mix.priors)',size(X));
post = gmmpost(mix, [X(:) Y(:)]);
p1_x = reshape(post(:, 1), size(X));
p2_x = reshape(post(:, 2) + post(:, 3), size(X));

% 
% Generate some pretty pictures !!
% 
% % % colormap(hot)
% % % colorbar
% % % subplot(1,2,1)
% % % hold on
% % % plot(data((label==1),1),data(label==1,2),ClassSymbol1, 'MarkerSize', PointSize)
% % % plot(data((label>1),1),data(label>1,2),ClassSymbol2, 'MarkerSize', PointSize)
% % % contour(xrange,yrange,p1_x,[0.5 0.5],'w-');
% % % axis([x0 x1 y0 y1])
% % % set(gca,'Box','On')
% % % title('The Sampled Data');
% % % rect=get(gca,'Position');
% % % rect(1)=rect(1)-AxisShift;
% % % rect(3)=rect(3)+AxisShift;
% % % set(gca,'Position',rect)
% % % hold off
% % % 
% % % subplot(1,2,2)
% % % imagesc(X(:),Y(:),px);
% % % hold on
% % % [cB, hB] = contour(xrange,yrange,p1_x,[0.5 0.5],'w:');
% % % set(hB,'LineWidth', 2);
% % % axis([x0 x1 y0 y1])
% % % set(gca,'YDir','normal')
% % % title('Probability Density p(x)')
% % % hold off
% % % 
% % % drawnow;
% % % clc;
% % % disp('The first figure shows the data sampled from a mixture of three')
% % % disp('Gaussians, the first of which (whose centre is near the origin) is')
% % % disp('labelled red and the other two are labelled yellow.  The second plot')
% % % disp('shows the unconditional density of the data with the optimal Bayesian')
% % % disp('decision boundary superimposed.')
% % % disp(' ')
% % % disp('Press any key to continue.')
% % % % % % pause
% % % fh2 = figure;
% % % set(fh2, 'Name', 'Class-conditional Densities and Posterior Probabilities');
% % % whitebg(fh2, 'w');
% % % 
% % % subplot(2,2,1)
% % % p1=reshape(px_j(:,1),size(X));
% % % imagesc(X(:),Y(:),p1);
% % % colormap hot
% % % colorbar
% % % axis(axis)
% % % set(gca,'YDir','normal')
% % % hold on
% % % plot(mix.centres(:,1),mix.centres(:,2),'b+','MarkerSize',8,'LineWidth',2)
% % % title('Density p(x|red)')
% % % hold off
% % % 
% % % subplot(2,2,2)
% % % p2=reshape((px_j(:,2)+px_j(:,3)),size(X));
% % % imagesc(X(:),Y(:),p2);
% % % colorbar
% % % set(gca,'YDir','normal')
% % % hold on
% % % plot(mix.centres(:,1),mix.centres(:,2),'b+','MarkerSize',8,'LineWidth',2)
% % % title('Density p(x|yellow)')
% % % hold off
% % % 
% % % subplot(2,2,3)
% % % imagesc(X(:),Y(:),p1_x);
% % % set(gca,'YDir','normal')
% % % colorbar
% % % title('Posterior Probability p(red|x)')
% % % hold on
% % % plot(mix.centres(:,1),mix.centres(:,2),'b+','MarkerSize',8,'LineWidth',2)
% % % hold off
% % % 
% % % subplot(2,2,4)
% % % imagesc(X(:),Y(:),p2_x);
% % % set(gca,'YDir','normal')
% % % colorbar
% % % title('Posterior Probability p(yellow|x)')
% % % hold on
% % % plot(mix.centres(:,1),mix.centres(:,2),'b+','MarkerSize',8,'LineWidth',2)
% % % hold off

% Now set up and train the MLP
nhidden=6;
nout=1;
alpha = 0.2;	% Weight decay
ncycles = 300;	% Number of training cycles. 
% Set up MLP network
net = mlp(2, nhidden, nout, 'logistic', alpha);
options = zeros(1,18);
options(1) = 1;                 % Print out error values
options(14) = ncycles;

mlpstring = ['We now set up an MLP with ', num2str(nhidden), ...
    ' hidden units, logistic output and cross'];
trainstring = ['entropy error function, and train it for ', ...
    num2str(ncycles), ' cycles using the'];
wdstring = ['quasi-Newton optimisation algorithm with weight decay of ', ...
    num2str(alpha), '.'];

% Force out the figure before training the MLP
% % % % % drawnow;
% % % % % disp(' ')
% % % % % disp('The second figure shows the class conditional densities and posterior')
% % % % % disp('probabilities for each class. The blue crosses mark the centres of')
% % % % % disp('the three Gaussians.')
% % % % % disp(' ')
% % % % % disp(mlpstring)
% % % % % disp(trainstring)
% % % % % disp(wdstring)
% % % % % disp(' ')
% % % % % disp('Press any key to continue.')
% % % % % % % % pause

% Convert targets to 0-1 encoding
%%%%%%%%%%csf
   ctarget=[clabel==1];
%%%%%%%%%%gry
   gtarget=[glabel==1];
%%%%%%%%%%wht
   wtarget=[wlabel==1];


% Train using quasi-Newton.
[cnet] = netopt(net, options, data, ctarget', 'quasinew');
[gnet] = netopt(net, options, data, gtarget', 'quasinew');
[wnet] = netopt(net, options, data, wtarget', 'quasinew');
cy = mlpfwd(cnet, data);
gy = mlpfwd(gnet, data);
wy = mlpfwd(wnet, data);

yg1 = mlpfwd(cnet, [X(:) Y(:)]);
yg1 = reshape(yg1(:,1),size(X));

yg2 = mlpfwd(gnet, [X(:) Y(:)]);
yg2 = reshape(yg2(:,1),size(X));
yg3 = mlpfwd(wnet, [X(:) Y(:)]);
yg3 = reshape(yg3(:,1),size(X));


% % % % % fh3 = figure;
% % % % % set(fh3, 'Name', 'Network Output');
% % % % % whitebg(fh3, 'k')
% % % % % subplot(1, 2, 1)
% % % % % hold on
% % % % % plot(data((label==1),1),data(label==1,2),'r.', 'MarkerSize', PointSize)
% % % % % plot(data((label>1),1),data(label>1,2),'y.', 'MarkerSize', PointSize)
% % % % % % Bayesian decision boundary
% % % % % [cB, hB] = contour(xrange,yrange,p1_x,[0.5 0.5],'b-');
% % % % % [cN, hN] = contour(xrange,yrange,yg,[0.5 0.5],'r-');
% % % % % set(hB, 'LineWidth', 2);
% % % % % set(hN, 'LineWidth', 2);
% % % % % Chandles = [hB(1) hN(1)];
% % % % % legend(Chandles, 'Bayes', ...
% % % % %   'Network', 3);
% % % % % 
% % % % % axis([x0 x1 y0 y1])
% % % % % set(gca,'Box','on','XTick',[],'YTick',[])
% % % % % 
% % % % % title('Training Data','FontSize',titleSize);
% % % % % hold off

% % % % subplot(1, 2, 2)
% % % % imagesc(X(:),Y(:),yg);
% % % % colormap hot
% % % % colorbar
% % % % axis(axis)
% % % % set(gca,'YDir','normal','XTick',[],'YTick',[])
% % % % title('Network Output','FontSize',titleSize)
% % % % 
% % % % clc
% % % % disp('This figure shows the training data with the decision boundary')
% % % % disp('produced by the trained network and the network''s prediction of')
% % % % disp('the posterior probability of the red class.')
% % % % disp(' ')
% % % % disp('Press any key to continue.')
% % % % % % % pause

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Now generate and classify a test data set
% 
% % [testdata testlabel] = gmmsamp(mix, n);
m=1;
for s_num=10:10:150
 test_data = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\nromal\1mm\t1_icbm_normal_1mm_pn5_rf40.mnc',s_num);
 test_image=reshape(test_data,row,col);
images_crisp = mireadimages ('C:\betsabeh\my_project\volumetry\matlab\data\phantom\noram_part\phantom_1[1].0mm_normal_crisp.mnc',s_num);
nimage = reshape(images_crisp, row, col);
  [bin,a1,TP,FN,FP,TN,OM,ACC]=skull_strip2(test_image,s_num);

t=otsu(a1);
d=bwdist(t,'euclidean'); 
testdata(:,1)=reshape(d,row*col,1);
testdata(:,2)=reshape(a1,row*col,1);


% % % testlabel=label';
% % % testlab=[testlabel==1 testlabel>1];

% This is the Bayesian classification
% % % % % % tpx_j = gmmpost(mix, testdata);
% % % % % % Bpost = [tpx_j(:,1), tpx_j(:,2)+tpx_j(:,3)];
% % % % % % [Bcon Brate]=confmat(Bpost, [testlabel==1 testlabel>1]);

% Compute network classification
cyt = mlpfwd(cnet, testdata);
gyt = mlpfwd(gnet, testdata);
wyt = mlpfwd(wnet, testdata);
% Convert single output to posteriors for both classes
ctestpost = [cyt 1-cyt];
gtestpost = [gyt 1-gyt];
wtestpost = [wyt 1-wyt];
[maximum csf] = max(ctestpost', [], 1);
[maximum gry] = max(gtestpost', [], 1);
[maximum wht] = max(wtestpost', [], 1);
csf=reshape(csf,row,col);
gry=reshape(gry,row,col);
wht=reshape(wht,row,col);
for i=1:row
    for j=1:col
        if (gry(i,j)==1)
            gry(i,j)=2;
        else
            gry(i,j)=4;
        end
        if (wht(i,j)==1)
            wht(i,j)=3;
        else
           wht(i,j)=4;
        end
    end
end
[acc_csf(m),acc_gry(m),acc_white(m),om_csf(m),om_gry(m),om_white(m),TP_csf(m),FP_csf(m),TP_gry(m),FP_gry(m),TP_wht(m),FP_wht(m)]=accuracy_3_parts(nimage,csf,gry,wht)
% % [C trate]=confmat(testpost,[testlabel==1 testlabel>1]);
m=m+1;
close all;
end
% % % clear all;