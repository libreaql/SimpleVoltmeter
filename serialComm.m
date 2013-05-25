function serialComm(varargin)


% Global Variables & Initializations
bufferSize = 500;
buffer = zeros(bufferSize,1);
bufferIndex = 0;

readInTime = 0.01;
windowSize = 100;

sp = serial('COM1','baudrate',9600);
pause(0.05);
fopen(sp);
pause(0.05);


% Main Figure hObject
mainFig = figure(...
    'Name','Voltmeter',...
    'position',[50 50 600 670],...
    'menu','none',...
    'toolbar','none',...
    'numberTitle','off',...
    'resize','off',...
    'dockControls','off');

bgColor = get(mainFig,'defaultUicontrolBackgroundColor');
set(mainFig,'Color',bgColor)

% Graphs hObjects
UIpGraphsPanel = uipanel(...
    'parent',mainFig,...
    'title','Graphs',...
    'backgroundColor',bgColor,...
    'units','pixels',...
    'position',[10 180 560 480]);

voltAxes = axes(...
    'parent',UIpGraphsPanel,...
    'units','pixels',...
    'visible','on',...
    'position',[30 240 500 200]);
set(voltAxes,'Title',text('string','Voltage'));



% Indicators hObjects
UIcStartStopBtn = uicontrol(...
    'style','toggle',...
    'string','Start',...
    'fontSize',11,...
    'position',[450 20 80 25]);

% Callbacks Settings
set(UIcStartStopBtn,'callback',{@UIcStartStopBtn_Callback});
set(mainFig,'closeRequestFcn',{@mainFigCloseRequestFcn});


% Callbacks & Function definitions
    function UIcStartStopBtn_Callback(varargin)
        
        hObject = varargin{1};
        isPressed = get(hObject,'value');
        
        while isPressed && ~isempty(get(mainFig))
            buffer = circshift(buffer,1);
            bufferIndex = bufferIndex + 1;
            fwrite(sp,'a');
            data = fread(sp,2);
            
            currentValue = 2^8*data(1)+2^0*data(2);
            buffer(1) = currentValue*0.0043;
            

            set(mainFig,'currentAxes',voltAxes);
            plot((0:windowSize-1)*readInTime,buffer(1:windowSize,1));
            pause(readInTime)
            isPressed = get(hObject,'value');
            
        end
        
    end

    function mainFigCloseRequestFcn(varargin)
        
        fclose(sp);
        pause(0.05);
        handles = findall(mainFig);
        delete(handles);
        
    end

end