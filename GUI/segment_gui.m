function segment_gui(action, varargin)
clc;
mypath;
if nargin<1,
   action='Initialize';
end;
Initialize()
% feval(action,varargin{:});
return;



%%%
%%%  Sub-function - Initialize
%%%

function Initialize()

% If dctdemo is already running, bring it to the foreground.
% h = findobj(allchild(0), 'tag', 'Brain segmentation and Volumetry');
% if ~isempty(h)
%    figure(h(1))
%    return
% end

screenD = get(0, 'ScreenDepth');
if screenD>8
   grayres=256;
else
   grayres=128;
end
 
ImFig = figure( ...
   'Name','Brain segmentation and Volumetry', ...
   'NumberTitle','off', 'HandleVisibility', 'on', ...
   'tag', 'Brain segmentation and Volumetry', ...
   'Visible','off', 'Resize', 'off',...
   'BusyAction','Queue','Interruptible','off', ...
   'Color', [.8 .8 .8], 'Pointer', 'watch',...
   'DoubleBuffer', 'on', ...
   'IntegerHandle', 'off', ...
   'Colormap', gray(grayres));

figpos = get(ImFig, 'position');
% Adjust the size of the figure window
figpos(3:4) = [560 420];
horizDecorations = 10;  % resize controls, etc.
vertDecorations = 45;   % title bar, etc.
screenSize = get(0,'ScreenSize');
if (screenSize(3) <= 1)
    % No display connected (apparently)
    screenSize(3:4) = [100000 100000]; % don't use Inf because of vms
end
if (((figpos(3) + horizDecorations) > screenSize(3)) | ...
            ((figpos(4) + vertDecorations) > screenSize(4)))
    % Screen size is too small for this demo!
    delete(fig);
    error(['Screen resolution is too low ', ...
                '(or text fonts are too big) to run this demo']);
end
dx = screenSize(3) - figpos(1) - figpos(3) - horizDecorations;
dy = screenSize(4) - figpos(2) - figpos(4) - vertDecorations;
if (dx < 0)
    figpos(1) = max(5,figpos(1) + dx);
end
if (dy < 0)
    figpos(2) = max(5,figpos(2) + dy);
end
set(ImFig, 'position', figpos);
rows = figpos(4); cols = figpos(3);

spac = 25;   % Spacing

ud.Computer = computer;

Std.Interruptible = 'off';
Std.BusyAction = 'queue';    

% Defaults for image axes
Ax = Std;
Ax.Units = 'Pixels';
Ax.Parent = ImFig;
Ax.ydir = 'reverse';
Ax.XLim = [.5 128.5];
Ax.YLim = [.5 128.5];
Ax.CLim = [0 1];
Ax.XTick = [];
Ax.YTick = [];

Img = Std;
Img.CData = [];
Img.Xdata = [1 128];
Img.Ydata = [1 128];
Img.CDataMapping = 'Scaled';
Img.Erasemode = 'none';

Ctl = Std;
Ctl.Units = 'Pixels';
Ctl.Parent = ImFig;

Btn = Ctl;
Btn.Parent = ImFig;
Btn.Style = 'pushbutton';
Btn.Enable = 'on';

btnHt = 26;
txtHt = 18;
menuHt = 26;
editHt = 21;
% Colors
bgcolor = [0.45 0.45 0.45];  % Background color for frames
wdcolor = [.8 .8 .8];  % Window color
fgcolor = [1 1 1];  % For text


%================================
% Original Image 
ud.hOriginalAxes = axes(Ax, ...
   'Position', [spac rows-txtHt-2*spac-128 128 128]);
title('Real Brain Slice ');
ud.hOriginalImage = image(Img, ...
   'Parent', ud.hOriginalAxes);

%================================
% White Matter 
ud.hAdjustedAxes = axes(Ax, ...
   'Position', [spac*2+128 rows-txtHt-2*spac-128 128 128]);
title('White Matter');%adjusted images
ud.hAdjustedImage = image(Img, ...
   'Parent', ud.hAdjustedAxes);

%================================
% Axes for Gray Matter
ud.hOriginalHist = axes(Ax, ...
   'Position', [spac rows-txtHt-4*spac-246 128 118]);
title('Gray Matter');

%================================
% Axes for CSF
ud.hAdjustedHist = axes(Ax, ...
   'Position', [spac*2+128 rows-txtHt-4*spac-246 128 118]);
title('CSF');

% Colorbars for image histograms
ud.hColbar1Ax = axes(Ax, ...
   'Position', [spac rows-txtHt-4*spac-256 128 10]);
ud.hColbar1 = image(Img, ...
   'Parent', ud.hColbar1Ax, ...
   'Cdata', repmat(uint8(0:255),[1,1,3]));
ud.hColbar2Ax = axes(Ax, ...
   'Position', [spac*2+128 rows-txtHt-4*spac-256 128 10]);
ud.hColbar2 = image(Img, ...
   'Parent', ud.hColbar2Ax, ...
   'Cdata', repmat(uint8(0:255),[1,1,3]));

%================================
% Text label for slice num
uicontrol( Std, ...
   'Parent', ImFig, ...
   'Style','text', ...
   'Units','pixels', ...
   'Position',[spac rows-(spac*1.3) 128 txtHt], ...
   'Horiz','left', ...
   'Background',wdcolor, ...
   'String','Slice Number:');

% Edit box for slice number
ud.hsliceEdit = uicontrol(Std, ...
   'Parent', ImFig, ...
   'Style','edit', ...
   'Units','pixels', ...
   'Position',[spac+4*txtHt rows-(spac*1.3) 128 txtHt+5], ...
   'Horiz','left', ...
   'Background','white', ...
   'Foreground','black', ...
   'String','1.0');
   %'callback','imadjdemo(''UpdateGamma'')');




%================================
% Control Frame
frsp = spac/3;  % Frame spacing
fleft = spac*3+256;
fbot = frsp*1.5;
fwid = cols - fleft - frsp*1.5;
fht = rows - 4*spac - 128;
ud.hControlFrame = uicontrol(Std, ...
   'Parent', ImFig, ...
   'Style', 'Frame', ...
   'Units', 'pixels', ...
   'Position', [fleft fbot fwid fht], ...
   'BackgroundColor', bgcolor);

%=================================
% 3segment
atwid = 140;
atht = 128;
atleft = fleft+(fwid-atwid)/2;
atbot = fbot+fht+1.5*spac+txtHt;
ud.hAdjustToolAxes = axes(...
   'Units', 'Pixels', ...
   'Parent', ImFig, ...
   'XTick', [0 0.5 1], ...
   'YTick', [0 0.5 1], ...
   'XLim', [0 1], ...
   'YLim', [0 1], ...
   'Position', [atleft atbot atwid atht]);
title('3segment');

% Line object for intensity transform of Histogram Eq Operation.
ud.hT = line(Std, ...
   'Xdata',0:(1/255):1,...
   'YData',0:(1/255):1,...
   'Parent',ud.hAdjustToolAxes,...
   'Visible', 'off', ...
   'Color', [0 0 1]);

if isequal(ud.Computer(1:2), 'MA')
   CtlEraseMode = 'normal';
else
   CtlEraseMode = 'xor';
end

% Line objects for Intensity Adjustment
ud.hAdjLineCtl = line(Std, ...
   'Tag', 'linectl', ...
   'Parent', ud.hAdjustToolAxes, ...
   'ButtonDownFcn', 'imadjdemo(''BtnDown'',1)', ...
   'Xdata',[0 .15 .85 1], ...
   'Ydata', [.15 .15 .85 .85], ...
   'EraseMode', CtlEraseMode, ...
   'Color', [0 0 1]);
ud.hAdjTopCtl = line(Std, ...
   'Tag','topctl',...
   'Parent', ud.hAdjustToolAxes, ...
   'ButtonDownFcn', 'imadjdemo(''BtnDown'',2)', ...
   'LineStyle', 'none', ...
   'Xdata',[.85], ...
   'Ydata', [.85], ...
   'Marker', 'square', ...
   'MarkerFaceCol', [.8 0 0], ...
   'EraseMode', CtlEraseMode, ...
   'Color', [0 0 0]);
ud.hAdjGammaCtl = line(Std, ...
   'Tag', 'gammactl',...
   'Parent', ud.hAdjustToolAxes, ...
   'ButtonDownFcn', 'imadjdemo(''BtnDown'',3)', ...
   'LineStyle', 'none', ...
   'Xdata',[.5], ...
   'Ydata', [.5], ...
   'Marker', 'o', ...
   'MarkerFaceCol', [1 1 0], ...
   'EraseMode', CtlEraseMode, ...
   'Color', [0 0 0]);
ud.hAdjBotCtl = line(Std, ...
   'Tag', 'botctl',...
   'Parent', ud.hAdjustToolAxes, ...
   'ButtonDownFcn', 'imadjdemo(''BtnDown'',4)', ...
   'LineStyle', 'none', ...
   'Xdata',[.15], ...
   'Ydata', [.15], ...
   'Marker', 'square', ...
   'MarkerFaceCol', [0 1 0], ...
   'EraseMode', CtlEraseMode, ...
   'Color', [0 0 0]);

% % % % % % ud.Gamma = 1;                 % Gamma for imadjust
% % % % % % 
% % % % % % %=================================
% % % % % % % Text label for Gamma
% % % % % % ud.hGammaLabel = uicontrol(Std, ...
% % % % % %    'Parent', ImFig, ...
% % % % % %    'Style','text', ...
% % % % % %    'Units','pixels', ...
% % % % % %    'Position',[atleft atbot-spac-txtHt atwid/2 txtHt ], ...
% % % % % %    'Horiz','left', ...
% % % % % %    'Background',wdcolor, ...
% % % % % %    'Foreground','black', ...
% % % % % %    'String','Gamma: ');
% % % % % % % Edit box for Gamma
% % % % % % ud.hGammaEdit = uicontrol(Std, ...
% % % % % %    'Parent', ImFig, ...
% % % % % %    'Style','edit', ...
% % % % % %    'Units','pixels', ...
% % % % % %    'Position',[atleft+atwid/2 atbot-spac-editHt atwid/2 editHt ], ...
% % % % % %    'Horiz','right', ...
% % % % % %    'Background','white', ...
% % % % % %    'Foreground','black', ...
% % % % % %    'String','1.0',...
% % % % % %    'callback','imadjdemo(''UpdateGamma'')');
% % % % % % 

%================================
% Operations Popup menu
opleft = fleft+frsp; 
opbot = fbot+fht-frsp/3-txtHt-btnHt;
opwid = fwid-2*frsp;
opht = menuHt;
% % % % % ud.hOpPop = uicontrol(Ctl, ...
% % % % %    'Style', 'Popupmenu',...
% % % % %    'Position',[opleft opbot opwid opht], ...
% % % % % %    'Enable','on', ...
% % % % % %    'String','Intensity Adjustment|Histogram Equalization', ...
% % % % % %    'Tag','OpPop',...
% % % % % %    'Callback','imadjdemo(''UpdateOperations'')');
% % % % % % 
% % % % % % 
% Text label for Operations Menu Popup
uicontrol( Std, ...
   'Parent', ImFig, ...
   'Style','text', ...
   'Units','pixels', ...
   'Position',[opleft opbot+menuHt opwid txtHt], ...
   'Horiz','left', ...
   'Background',bgcolor, ...
   'Foreground',fgcolor, ...
   'String','Operations:');

btnWid = (opwid-frsp)/2;

%====================================
% Buttons for Intensity Adjustment
ud.hBrighten=uicontrol(Btn, ...
   'Position',[opleft opbot-btnHt-frsp btnWid btnHt], ...
   'String','Slice Show', ...
   'Callback','imadjdemo(''show_image'')');

ud.hDarken = uicontrol(Btn, ...
   'Position',[opleft+btnWid+frsp opbot-btnHt-frsp btnWid btnHt], ...
   'String','- Brightness', ...
   'Callback','imadjdemo(''DecreaseBrightness'')');

ud.hIncrContr=uicontrol(Btn, ...
   'Position',[opleft opbot-2*btnHt-2*frsp btnWid btnHt], ...
   'String','+ Contrast', ...
   'Callback','imadjdemo(''IncreaseContrast'')');

ud.hDecrContr=uicontrol(Btn, ...
   'Position',[opleft+btnWid+frsp opbot-2*btnHt-2*frsp btnWid btnHt], ...
   'String','- Contrast', ...
   'Callback','imadjdemo(''DecreaseContrast'')');

% % % % ud.hIncrGam=uicontrol(Btn, ...
% % % %    'Position',[opleft opbot-3*btnHt-3*frsp btnWid btnHt], ...
% % % %    'String','+ Gamma', ...
% % % %    'Callback','imadjdemo(''IncreaseGamma'')');
% % % % 
% % % % ud.hDecrGam=uicontrol(Btn, ...
% % % %    'Position',[opleft+btnWid+frsp opbot-3*btnHt-3*frsp btnWid btnHt], ...
% % % %    'String','- Gamma', ...
% % % %    'Callback','imadjdemo(''DecreaseGamma'')');

%====================================
% Buttons for Histogram operations  - None

%====================================
% Buttons - Info and Close
% % % ud.hInfo=uicontrol(Btn, ...
% % %    'Position',[opleft fbot+frsp btnWid btnHt], ...
% % %    'String','Info', ...
% % %    'Callback','helpwin imadjdemo');

ud.hClose=uicontrol(Btn, ...
   'Position',[opleft opbot-3*btnHt-3*frsp btnWid btnHt], ...
   'String','Close', ...
   'Callback','close(gcbf)');

%====================================
% Status bar
ud.hStatus = uicontrol(Std, ...
   'Parent', ImFig, ...
   'Style','text', ...
   'Units','pixels', ...
   'Position',[spac 6 256+spac txtHt], ...
   'Foreground', [.8 0 0], ...
   'Background',wdcolor, ...
   'Horiz','center', ...
   'Tag', 'Status', ...
   'String','Initializing imadjdemo...');

set(ImFig, 'UserData', ud,'Visible','on');
% % % LoadNewImage(ImFig);
% % % UpdateOperations(ImFig);
% % % drawnow
% % set(ImFig,'Pointer','arrow','HandleVisibility', 'Callback');
% % set([ud.hBrighten ud.hDarken ud.hIncrContr ud.hDecrContr  ud.hIncrGam ...
% %       ud.hDecrGam ud.hInfo ud.hClose] , 'enable', 'on');
return

%%%
%%%  Sub-function - UpdateOperations
%%%

function UpdateOperations(DemoFig)

if nargin<1
   callb = 1;    % We're in a callback
   DemoFig = gcbf;
else 
   callb = 0;    % We're in the initialization
end

ud = get(DemoFig, 'UserData');
op = get(ud.hOpPop, 'Value');

switch op
case 1   % Intensity Adjustment
   % Turn off histeq part
   set(ud.hT, 'Visible', 'off');
   % Turn on imadjust part
% % % % %    set([ud.hBrighten ud.hDarken ud.hIncrContr ud.hDecrContr ud.hIncrGam ...
% % % % %          ud.hDecrGam ud.hGammaLabel ud.hGammaEdit], 'Enable', 'on');
% % % % %    set([ud.hAdjLineCtl ud.hAdjTopCtl ud.hAdjGammaCtl ud.hAdjBotCtl], 'Visible', 'on');
   % Set labels correctly
   set(get(ud.hAdjustToolAxes, 'Title'), 'String', '3segment');
   set(get(ud.hAdjustedAxes, 'Title'), 'String', 'White Matter');
   InitializeAdjustmentTool(DemoFig);
   DoAdjust(DemoFig);
case 2   % Histogram Equalization
   % Turn off imadjust part
% % % % %    set([ud.hBrighten ud.hDarken ud.hIncrContr ud.hDecrContr ud.hIncrGam ...
% % % % %          ud.hDecrGam ud.hGammaLabel ud.hGammaEdit],'Enable', 'off');
% % % % %    set([ud.hAdjLineCtl ud.hAdjTopCtl ud.hAdjGammaCtl ud.hAdjBotCtl], 'Visible', 'off');
   % Turn on histeq part
   set(ud.hT, 'Visible', 'on');
   % Set labels correctly
   set(get(ud.hAdjustToolAxes, 'Title'), 'String', '3segment');
   set(get(ud.hAdjustedAxes, 'Title'), 'String', 'Equalized Image');
   EqualizeHistogram(DemoFig);
otherwise
   error('Undefined Operation');
end
return


%%%
%%%  Sub-function - InitializeAdjustmentTool
%%%

function InitializeAdjustmentTool(DemoFig)

if nargin<1
   callb = 1;    % We're in a callback
   DemoFig = gcbf;
else 
   callb = 0;    % We're in the initialization
end

ud = get(DemoFig, 'UserData');

ax = ud.hAdjustToolAxes;
img = get(ud.hOriginalImage, 'Cdata');
high = max(img(:)); low = min(img(:));
%%%%%ud.Gamma = 1.0;
%%%%%set(ud.hGammaEdit, 'String', 1.0);
set(ud.hAdjLineCtl,'Xdata',[0 low high 1],'Ydata',[0 0 1 1]);
set(ud.hAdjTopCtl,'Xdata',[high], 'Ydata', [1]);
set(ud.hAdjBotCtl,'Xdata',[low], 'Ydata', [0]);
%%%%%%set(ud.hAdjGammaCtl,'Xdata',[(high+low)/2], 'Ydata', [0.5]);
ud.LowHiBotTop = [low high 0 1];  % Actual Low,high,bot,top
set(DemoFig, 'UserData', ud);


%%%
%%%  Sub-function - BtnDown
%%%

function BtnDown(control)
% The input argument is the control which called the BtnDown function

DemoFig = gcbf;
ud = get(DemoFig, 'UserData');
if control==1  % Remember out-of-limits control points
   low  = ud.LowHiBotTop(1);  
   bot  = ud.LowHiBotTop(3);
   high = ud.LowHiBotTop(2);
   top  = ud.LowHiBotTop(4);
else   % Use control points within the axes
   low  = get(ud.hAdjBotCtl, 'Xdata');
   bot  = get(ud.hAdjBotCtl, 'Ydata');
   high = get(ud.hAdjTopCtl, 'Xdata');
   top  = get(ud.hAdjTopCtl, 'Ydata');
end   

if isequal(ud.Computer(1:2), 'MA')  % For the Macintosh
   set(ud.hAdjLineCtl , 'EraseMode', 'Xor');
   set(ud.hAdjTopCtl , 'EraseMode', 'Xor');
   set(ud.hAdjBotCtl , 'EraseMode', 'Xor');
  %%%%% set(ud.hAdjGammaCtl , 'EraseMode', 'Xor');
end

switch control
case 1  % The line
   pt = get(gca, 'CurrentPoint');
   ud.StartingPoint = pt(1,1:2);
   setptr(DemoFig, 'closedhand');
   setstatus(DemoFig, 'Drag the line to modify the transformation');
% % % % % case 3  % Gamma
% % % % %    pt = get(gca, 'CurrentPoint');
% % % % %    ud.StartingPoint = pt(1,1:2);
% % % % %    setptr(DemoFig, 'uddrag');
% % % % %    setstatus(DemoFig, 'Drag the yellow point up and down to adjust Gamma');
case {2,4}  % The Top and Bottom Controls
   setptr(DemoFig, 'fleur');
   setstatus(DemoFig, 'Drag the control point to modify the transformation');
end

ud.StartingLowHiBotTop = [low high bot top];
set(DemoFig, 'UserData', ud);

motionfcn = ['imadjdemo(''BtnMotion'',' num2str(control) ')'];
set(DemoFig, 'WindowButtonMotionFcn',motionfcn,...
   'WindowButtonUpFcn', 'imadjdemo(''BtnUp'')');


%%%
%%%  Sub-function - BtnUp
%%%

function BtnUp

DemoFig = gcbf;
ud = get(DemoFig, 'UserData');
set(DemoFig, 'WindowButtonMotionFcn','','WindowButtonUpFcn','');
setstatus(DemoFig, '');
DoAdjust(DemoFig);
if isequal(ud.Computer(1:2), 'MA')  % For the Macintosh
   set(ud.hAdjLineCtl , 'EraseMode', 'normal');
   set(ud.hAdjTopCtl , 'EraseMode', 'normal');
   set(ud.hAdjBotCtl , 'EraseMode', 'normal');
  %%%%% set(ud.hAdjGammaCtl , 'EraseMode', 'normal');
end
setptr(DemoFig, 'arrow');
return


%%%
%%%  Sub-function - BtnMotion
%%%

function BtnMotion(control, low, high, bot, top)
% The first input argument is the control which called the BtnDown function
% If there are two input arguments, we are triggering a redraw from a callback
% and the second argument contains [low high bot top].

DemoFig = gcbf;
ud = get(DemoFig, 'UserData');
ax = ud.hAdjustToolAxes;

% Parameters for imadjust
pt = get(ax, 'CurrentPoint');
pt = pt(1,1:2);

if control==5  % Just do a redraw from a button callback function
   if nargin == 1
      low = ud.LowHiBotTop(1);
      high = ud.LowHiBotTop(2);
      bot = ud.LowHiBotTop(3);
      top = ud.LowHiBotTop(4);
   end   
   ud.StartingLowHiBotTop = [low high bot top];
else
   low = ud.StartingLowHiBotTop(1);
   high = ud.StartingLowHiBotTop(2);
   bot = ud.StartingLowHiBotTop(3);
   top = ud.StartingLowHiBotTop(4);
end

pt = Constrain(control, pt, ud);
dx = 0;
dy = 0;

% Change parameters for the line redraw
switch control
case 1                 % the user grabbed the line
   start = ud.StartingPoint;
   dx = pt(1)-start(1);
   dy = pt(2)-start(2);
   low = low+dx;  
   high = high+dx;
   bot = bot+dy;
   top = top+dy;
case 2                 % the user grabbed the top box
   high = pt(1); 
   top = pt(2);
% % % % case 3                 % The user grabbed the Gamma control (circle)
% % % %    % Figure out Gamma for redraw
% % % %    x = pt(1);
% % % %    y = pt(2);
% % % %    gamma_old = ud.Gamma;         % Save this in case we get negative Gamma
% % % %    if ((y-bot) ~= 0) & ((x-low) ~= 0) 
% % % %       denominator = log(abs((x-low)/(high-low)));
% % % %       if denominator ~= 0
% % % %          ud.Gamma = log(abs((y-bot)/(top-bot)))/denominator;
% % % %       end
% % % %    end  
% % % %    if ud.Gamma < 0
% % % %       ud.Gamma = gamma_old;
% % % %    end
% % % %    set(DemoFig, 'UserData', ud);
% % % %    set(ud.hGammaEdit, 'String', num2str(ud.Gamma));
case 4                 % The user grabbed the Bottom control
   low = pt(1); 
   bot = pt(2);
end

ud.LowHiBotTop = [low high bot top];
set(DemoFig, 'UserData', ud);

if control==1 | control==5
   if top>1.0  % We dragged it off the axes
      high = (1-bot)*(high-low)/(top-bot)+low;
      top=1;
   elseif top<0.0
      high = low-bot*(high-low)/(top-bot);
      top=0;
   elseif bot<0.0 
      low = high - top*(high-low)/(top-bot);
      bot=0;
   elseif bot>1.0
      low = high+(top-1)*(high-low)/(bot-top);
      bot=1;
   end
end

% Now just draw the lines
% % % % % if abs(ud.Gamma-1)<.01      % if Gamma is close to 1, don't worry
% % % % %    set(ud.hAdjLineCtl,'Xdata',[0 low high 1],...
% % % % %       'Ydata',[bot bot top top]);
% % % % %    set(ud.hAdjBotCtl,'Xdata',[low], 'Ydata', [bot]);
% % % % %    set(ud.hAdjTopCtl,'Xdata',[high], 'Ydata', [top]);
% % % % %    set(ud.hAdjGammaCtl,'Xdata',[(high+low)/2], 'Ydata', [(bot+top)/2]);
% % % % % else
% % % % %    axpos = get(ud.hAdjustToolAxes, 'Position');
% % % % %    xres = 2/axpos(3);
% % % % %    curveX = [low:xres:high];  % MARKED LINE
% % % % %    if length(curveX)==1
% % % % %       curveX = [low high];
% % % % %    end
% % % % %    curveY = ( (curveX-low)/(high-low) ) .^ ud.Gamma;
% % % % %    curveY = curveY*(top-bot) + bot;
% % % % %    curveY(end) = top;   % This is needed because of the line marked above - HG Bug?
% % % % %    set(ud.hAdjLineCtl,...
% % % % %       'Xdata',[0 (curveX) 1], ...
% % % % %       'Ydata',[bot (curveY) top]);
% % % % %    set(ud.hAdjBotCtl,'Xdata',[low],'Ydata',[bot]);
% % % % %    set(ud.hAdjTopCtl,'Xdata',[high],'Ydata', [top]);
% % % % %    npts = length(curveX);
% % % % %    if rem(npts,2)==0
% % % % %       set(ud.hAdjGammaCtl,...
% % % % %          'Xdata', (curveX(npts/2) + curveX(1+npts/2))/2, ...
% % % % %          'Ydata', (curveY(npts/2) + curveY(1+npts/2))/2);
% % % % %    else
% % % % %       set(ud.hAdjGammaCtl, ...
% % % % %          'Xdata', curveX((npts+1)/2),'Ydata', curveY((npts+1)/2));
% % % % %    end
% % % % % end

return



%%%
%%%  Sub-function - Constrain
%%%

function out = Constrain(control, in, ud)
% Make sure the following conditions are all met:
% 1. The line still represents a function (1 to 1 mapping)
% 2. No part of the line extends beyond the range of the axes

low = ud.StartingLowHiBotTop(1);
high = ud.StartingLowHiBotTop(2);
bot = ud.StartingLowHiBotTop(3);
top = ud.StartingLowHiBotTop(4);

out = in;

out(in>1) = 1;  % Make sure the point stays in the axes
out(in<0) = 0;

axpos = get(ud.hAdjustToolAxes, 'Position');
xres = 1/axpos(3);
yres = 1/axpos(4);
switch control
case 1                 % the user grabbed the line
   start = ud.StartingPoint;
   dx = out(1)-start(1);
   dy = out(2)-start(2);
   if high+dx>1
      out(1) = 1-high+start(1);
   end
   if low+dx<0
      out(1) = start(1)-low;
   end
case 2                 % the user grabbed the top box
   if out(1) <= low,   
      out(1) = low + xres;  % One pixel
   end
% % % % % case 3                 % The user grabbed the Gamma control (circle)
% % % % %    start = ud.StartingPoint;
% % % % %    out(1) = start(1);  % Only move vertically
% % % % %    if top > bot  
% % % % %       if out(2) >= top
% % % % %          out(2) = top-yres;  % One pixel
% % % % %       elseif out(2) <= bot
% % % % %          out(2) = bot+yres;
% % % % %       end
% % % % %    elseif top <= bot
% % % % %       if out(2) > bot
% % % % %          out(2) = bot-yres;
% % % % %       elseif out(2) <= top
% % % % %          out(2) = top+yres;
% % % % %       end
% % % % %    end
case 4                 % The user grabbed the Bottom control
   if out(1) >= high,  
      out(1) = high - xres; 
   end
end



%%%
%%%  Sub-Function - UpdateGamma
%%%

% % % % % function UpdateGamma(DemoFig)
% % % % % 
% % % % % if nargin<1
% % % % %    callb = 1;    % We're in a callback
% % % % %    DemoFig = gcbf;
% % % % % else 
% % % % %    callb = 0;    % We're in the initialization
% % % % % end
% % % % % 
% % % % % ud = get(DemoFig, 'UserData');
% % % % % gammastr = get(ud.hGammaEdit, 'String');
% % % % % gamma = str2double(gammastr);
% % % % % 
% % % % % if isempty(gamma) | gamma(1)<0 | ~isreal(gamma) 
% % % % %    errordlg('Gamma must be a real number greater than 0.');
% % % % % else   
% % % % %    ud.Gamma=gamma(1);
% % % % %    set(DemoFig, 'UserData', ud);
% % % % %    BtnMotion(5);  % Redraw
% % % % %    DoAdjust(DemoFig);
% % % % % end
% % % % % 
% % % % % set(ud.hGammaEdit, 'String', ud.Gamma);
% % % % % 

%%%
%%%  Sub-Function - DoAdjust
%%%

% % % % % function DoAdjust(DemoFig)
% % % % % 
% % % % % setptr(DemoFig, 'watch');
% % % % % setstatus(DemoFig, 'Adjusting image ...');
% % % % % ud = get(DemoFig, 'UserData');
% % % % % 
% % % % % % The add/subtracts in Constrain can introduce eps level
% % % % % % errors which put us outside of [0 1]
% % % % % low  = max(0.0, get(ud.hAdjBotCtl, 'Xdata'));
% % % % % bot  = max(0.0, get(ud.hAdjBotCtl, 'Ydata'));
% % % % % high = min(1.0, get(ud.hAdjTopCtl, 'Xdata'));
% % % % % top  = min(1.0, get(ud.hAdjTopCtl, 'Ydata'));
% % % % % 
% % % % % if( abs(high-low)<eps )  % Protect imadjust against divide by 0
% % % % %    high = low+.0001;
% % % % % end
% % % % % 
% % % % % img = get(ud.hOriginalImage, 'Cdata');
% % % % % imgAd = imadjust(img, [low;high],[bot;top],ud.Gamma);
% % % % % set(ud.hAdjustedImage, 'Cdata', imgAd);
% % % % % DoHist(imgAd,ud.hAdjustedHist, DemoFig);
% % % % % setstatus(DemoFig, '');
% % % % % setptr(DemoFig, 'arrow');
% % % % % 


%%%
%%%  Sub-function - EqualizeHistogram
%%%

% % % % % % % function EqualizeHistogram(DemoFig)
% % % % % % % 
% % % % % % % if nargin<1
% % % % % % %    callb = 1;    % We're in a callback
% % % % % % %    DemoFig = gcbf;
% % % % % % % else 
% % % % % % %    callb = 0;    % We're in the initialization
% % % % % % % end
% % % % % % % 
% % % % % % % ud = get(DemoFig, 'UserData');
% % % % % % % 
% % % % % % % img = get(ud.hOriginalImage, 'CData');
% % % % % % % [imgEq,T] = histeq(img, 64);
% % % % % % % set(ud.hAdjustedImage, 'CData', imgEq)
% % % % % % % set(ud.hT, 'Xdata',0:(1/255):1,'YData',T);
% % % % % % % 
% % % % % % % DoHist(imgEq,ud.hAdjustedHist, DemoFig);
% % % % % % % return
% % % % % % % 

%%%
%%%  Sub-function - DoHist
%%%
% % % % % % 
% % % % % % function DoHist(img, ax, DemoFig)
% % % % % % 
% % % % % % setstatus(DemoFig, 'Calculating Histogram');
% % % % % % setptr(DemoFig, 'watch');
% % % % % % % Using 64 bins plots well in this demo, but imhist is optimized
% % % % % % % for 256 bins; it can be 20 times faster.  So call imhist with
% % % % % % % 256 bins and then cut the result down to 64.
% % % % % % [cnts,bins]=imhist(img,256);
% % % % % % cnts = reshape(cnts,4,64);
% % % % % % cnts = sum(cnts);
% % % % % % cnts = cnts(:);
% % % % % % n = 64;
% % % % % % bins = (1:n)';
% % % % % % axes(ax)
% % % % % % stem('v6',bins,cnts);
% % % % % % h = get(ax,'children');
% % % % % % delete(findobj(h,'flat','Marker','o')) % Remove 'o's from stem plot
% % % % % % limits = axis;
% % % % % % limits(1) = 0.5;
% % % % % % limits(2) = n+0.5;
% % % % % % var = sqrt(cnts'*cnts/length(cnts));
% % % % % % limits(4) = 2.5*var;
% % % % % % axis(limits);
% % % % % % set(ax, 'Xtick', [], 'Ytick', []);
% % % % % % title('Histogram')
% % % % % % setstatus(DemoFig, '');
% % % % % % setptr(DemoFig, 'arrow');


%%%
%%%  Sub-Function - LoadNewImage
%%%
% % % % % % % % % % 
% % % % % % % % % % function LoadNewImage(DemoFig)
% % % % % % % % % % 
% % % % % % % % % % if nargin<1
% % % % % % % % % %    callb = 1;    % We're in a callback
% % % % % % % % % %    DemoFig = gcbf;
% % % % % % % % % % else 
% % % % % % % % % %    callb = 0;    % We're in the initialization
% % % % % % % % % % end
% % % % % % % % % % 
% % % % % % % % % % set(DemoFig,'Pointer','watch');
% % % % % % % % % % ud=get(DemoFig,'Userdata');
% % % % % % % % % % v = get(ud.hImgPop,{'value','String'});
% % % % % % % % % % name = deblank(v{2}(v{1},:));
% % % % % % % % % % setstatus(DemoFig, ['Loading the ' name ' image...']);
% % % % % % % % % % drawnow
% % % % % % % % % % 
% % % % % % % % % % switch name
% % % % % % % % % % case 'Saturn',
% % % % % % % % % %    saturn = [];
% % % % % % % % % %    load imdemos saturn
% % % % % % % % % %    img = saturn;
% % % % % % % % % % case 'Tire',
% % % % % % % % % %    tire = [];
% % % % % % % % % %    load imdemos tire
% % % % % % % % % %    img = tire;
% % % % % % % % % % case 'Pout',
% % % % % % % % % %    pout = [];
% % % % % % % % % %    load imdemos pout
% % % % % % % % % %    img = pout;
% % % % % % % % % % case 'Trees',
% % % % % % % % % %    trees = [];
% % % % % % % % % %    load imdemos trees
% % % % % % % % % %    img = trees;
% % % % % % % % % % case 'Quarter',
% % % % % % % % % %    quarter = [];
% % % % % % % % % %    load imdemos quarter
% % % % % % % % % %    img = quarter;
% % % % % % % % % % case 'Circuit',
% % % % % % % % % %    circuit = [];
% % % % % % % % % %    load imdemos circuit
% % % % % % % % % %    img = circuit;
% % % % % % % % % % case 'Lifting Body',
% % % % % % % % % %    liftbody128 = [];
% % % % % % % % % %    load imdemos liftbody128
% % % % % % % % % %    img = liftbody128;
% % % % % % % % % % case 'Pepper',
% % % % % % % % % %    pepper = [];
% % % % % % % % % %    load imdemos pepper
% % % % % % % % % %    img = pepper;
% % % % % % % % % % case 'Rice',
% % % % % % % % % %    rice = [];
% % % % % % % % % %    load imdemos rice
% % % % % % % % % %    img = rice;
% % % % % % % % % % case 'Glass',
% % % % % % % % % %    glass = [];
% % % % % % % % % %    load imdemos glass
% % % % % % % % % %    img = glass; 
% % % % % % % % % % otherwise 
% % % % % % % % % %    error('IMADJDEMO: Unknown Image Option!');
% % % % % % % % % % end
% % % % % % % % % % 
% % % % % % % % % % img = double(img)/255;
% % % % % % % % % % set(ud.hOriginalImage, 'Cdata', img);
% % % % % % % % % % DoHist(img,ud.hOriginalHist, DemoFig);
% % % % % % % % % % 
% % % % % % % % % % switch get(ud.hOpPop, 'Value')
% % % % % % % % % % case 1
% % % % % % % % % %    InitializeAdjustmentTool(DemoFig);   
% % % % % % % % % %    DoAdjust(DemoFig);
% % % % % % % % % % case 2
% % % % % % % % % %    EqualizeHistogram(DemoFig)
% % % % % % % % % % end
% % % % % % % % % % set(DemoFig,'Pointer','arrow');
% % % % % % % % % % drawnow
% % % % % % % % % % if callb
% % % % % % % % % %    setstatus(DemoFig, '');
% % % % % % % % % % end
% % % % % % % % % % return;
% % % % % % % % % % 

%%% 
%%%  Sub-Function - IncreaseBrightness
%%%
function show_image
slice_num=get(ud.hsliceEdit,'string')
images = mireadimages ('c:\betsabeh\my_project\volumetry\matlab\data\phantom\nromal\noise0_INU0\t1_icbm_normal_1mm_pn0_rf0.mnc',str2double(slice_num));
t1 = reshape (images, 181, 217);
[row,col] = size(t1);
fmin  = min(t1(:));
fmax  = max(t1(:));
t1= (t1-fmin)/(fmax-fmin);  % Normalize f to the range [0,1]
t1=t1*255;
axes(handles.axes1);
imshow(t1',[])
%[fig_handle, image_handle, bar_handle] = viewimage (PD);
title('real image')
IM=t1;
% % % % % function IncreaseBrightness
% % % % % 
% % % % % DemoFig = gcbf;
% % % % % ud = get(DemoFig, 'UserData');
% % % % % low = ud.LowHiBotTop(1);
% % % % % high = ud.LowHiBotTop(2);
% % % % % bot = ud.LowHiBotTop(3);
% % % % % top = ud.LowHiBotTop(4);
% % % % % change = .1;
% % % % % % Don't shift the whole line out of the axes range:
% % % % % if top>=bot
% % % % %    if (bot+change > 1)
% % % % %       return     % Don't make it any brighter
% % % % %    end
% % % % % else
% % % % %    if (top+change > 1)
% % % % %       return     % Don't make it any brighter
% % % % %    end
% % % % % end   
% % % % % top = top + change;
% % % % % bot = bot + change;
% % % % % BtnMotion(5, low, high, bot, top);      % Redraw
% % % % % ud.LowHiBotTop = [low high bot top];
% % % % % set(DemoFig, 'UserData', ud);
% % % % % DoAdjust(DemoFig);


%%% 
%%%  Sub-Function - DecreaseBrightness
%%%

% % % % % % % % % % % % % % % % % % % % % % % function DecreaseBrightness
% % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % DemoFig = gcbf;
% % % % % % % % % % % % % % % % % % % % % % % ud = get(DemoFig, 'UserData');
% % % % % % % % % % % % % % % % % % % % % % % low = ud.LowHiBotTop(1);
% % % % % % % % % % % % % % % % % % % % % % % high = ud.LowHiBotTop(2);
% % % % % % % % % % % % % % % % % % % % % % % bot = ud.LowHiBotTop(3);
% % % % % % % % % % % % % % % % % % % % % % % top = ud.LowHiBotTop(4);
% % % % % % % % % % % % % % % % % % % % % % % change = .1;
% % % % % % % % % % % % % % % % % % % % % % % % Don't shift the whole line out of the axes range:
% % % % % % % % % % % % % % % % % % % % % % % if top>=bot
% % % % % % % % % % % % % % % % % % % % % % %    if (top-change < 0)   
% % % % % % % % % % % % % % % % % % % % % % %       return  % Don't make it any darker
% % % % % % % % % % % % % % % % % % % % % % %    end
% % % % % % % % % % % % % % % % % % % % % % % else
% % % % % % % % % % % % % % % % % % % % % % %    if (bot-change < 0)
% % % % % % % % % % % % % % % % % % % % % % %       return  % Don't make it any darker
% % % % % % % % % % % % % % % % % % % % % % %    end
% % % % % % % % % % % % % % % % % % % % % % % end
% % % % % % % % % % % % % % % % % % % % % % % top = top - change;
% % % % % % % % % % % % % % % % % % % % % % % bot = bot - change;
% % % % % % % % % % % % % % % % % % % % % % % BtnMotion(5, low, high, bot, top);      % Redraw
% % % % % % % % % % % % % % % % % % % % % % % ud.LowHiBotTop = [low high bot top];
% % % % % % % % % % % % % % % % % % % % % % % set(DemoFig, 'UserData', ud);
% % % % % % % % % % % % % % % % % % % % % % % DoAdjust(DemoFig);
% % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % %%% 
% % % % % % % % % % % % % % % % % % % % % % % %%%  Sub-Function - IncreaseContrast
% % % % % % % % % % % % % % % % % % % % % % % %%%
% % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % function IncreaseContrast
% % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % DemoFig = gcbf;
% % % % % % % % % % % % % % % % % % % % % % % ud = get(DemoFig, 'UserData');
% % % % % % % % % % % % % % % % % % % % % % % high = get(ud.hAdjTopCtl, 'Xdata');
% % % % % % % % % % % % % % % % % % % % % % % low = get(ud.hAdjBotCtl, 'Xdata');
% % % % % % % % % % % % % % % % % % % % % % % top = get(ud.hAdjTopCtl, 'Ydata');
% % % % % % % % % % % % % % % % % % % % % % % bot = get(ud.hAdjBotCtl, 'Ydata');
% % % % % % % % % % % % % % % % % % % % % % % change = .1*(high-low);
% % % % % % % % % % % % % % % % % % % % % % % low = low + change;
% % % % % % % % % % % % % % % % % % % % % % % high = high - change;
% % % % % % % % % % % % % % % % % % % % % % % BtnMotion(5, low, high, bot, top);      % Redraw
% % % % % % % % % % % % % % % % % % % % % % % DoAdjust(DemoFig);
% % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % %%% 
% % % % % % % % % % % % % % % % % % % % % % % %%%  Sub-Function - DecreaseContrast
% % % % % % % % % % % % % % % % % % % % % % % %%%
% % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % function DecreaseContrast
% % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % DemoFig = gcbf;
% % % % % % % % % % % % % % % % % % % % % % % ud = get(DemoFig, 'UserData');
% % % % % % % % % % % % % % % % % % % % % % % high = get(ud.hAdjTopCtl, 'Xdata');
% % % % % % % % % % % % % % % % % % % % % % % low = get(ud.hAdjBotCtl, 'Xdata');
% % % % % % % % % % % % % % % % % % % % % % % top = get(ud.hAdjTopCtl, 'Ydata');
% % % % % % % % % % % % % % % % % % % % % % % bot = get(ud.hAdjBotCtl, 'Ydata');
% % % % % % % % % % % % % % % % % % % % % % % change = .1*(high-low);
% % % % % % % % % % % % % % % % % % % % % % % low = max(low - change,0);
% % % % % % % % % % % % % % % % % % % % % % % high = min(high + change,1);
% % % % % % % % % % % % % % % % % % % % % % % BtnMotion(5, low, high, bot, top);      % Redraw
% % % % % % % % % % % % % % % % % % % % % % % DoAdjust(DemoFig);
% % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % %%% 
% % % % % % % % % % % % % % % % % % % % % % % %%%  Sub-Function - IncreaseGamma
% % % % % % % % % % % % % % % % % % % % % % % %%%
% % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % function IncreaseGamma
% % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % DemoFig = gcbf;
% % % % % % % % % % % % % % % % % % % % % % % ud = get(DemoFig, 'UserData');
% % % % % % % % % % % % % % % % % % % % % % % ud.Gamma = ud.Gamma * 1.2;
% % % % % % % % % % % % % % % % % % % % % % % set(ud.hGammaEdit, 'String', num2str(ud.Gamma)); drawnow
% % % % % % % % % % % % % % % % % % % % % % % set(DemoFig, 'UserData', ud);
% % % % % % % % % % % % % % % % % % % % % % % BtnMotion(5);  % Redraw
% % % % % % % % % % % % % % % % % % % % % % % DoAdjust(DemoFig);
% % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % %%% 
% % % % % % % % % % % % % % % % % % % % % % % %%%  Sub-Function - DecreaseGamma
% % % % % % % % % % % % % % % % % % % % % % % %%%
% % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % function DecreaseGamma
% % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % DemoFig = gcbf;
% % % % % % % % % % % % % % % % % % % % % % % ud = get(DemoFig, 'UserData');
% % % % % % % % % % % % % % % % % % % % % % % ud.Gamma = ud.Gamma * 0.8;
% % % % % % % % % % % % % % % % % % % % % % % set(ud.hGammaEdit, 'String', num2str(ud.Gamma)); drawnow
% % % % % % % % % % % % % % % % % % % % % % % set(DemoFig, 'UserData', ud);
% % % % % % % % % % % % % % % % % % % % % % % BtnMotion(5);  % Redraw
% % % % % % % % % % % % % % % % % % % % % % % DoAdjust(DemoFig);
