function serialComm(varargin)

% Global Variables & Initializations
bufferSize = 500;
buffer = zeros(bufferSize,1);

readInTime = 1/300;
windowSize = 300;

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

specAxes = axes(...
    'parent',UIpGraphsPanel,...
    'units','pixels',...
    'visible','on',...
    'position',[30 30 500 150]);
set(specAxes,'Title',text('string','Control Loop Error'));

% Indicators hObjects
UIcStartStopBtn = uicontrol(...
    'style','toggle',...
    'string','Start',...
    'fontSize',14,...
    'position',[250 50 100 30]);

UIcVoltageDisplay = uicontrol(...
    'style','edit',...
    'fontSize',14,...
    'enable','off',...
    'position',[250 100 100 30]);

voltageUnitLabel = uicontrol(...
    'style','text',...
    'string','Volt',...
    'fontSize',14,...
    'position',[355 100 100 25],...
    'HorizontalAlignment','left');

% Callbacks Settings
set(UIcStartStopBtn,'callback',{@UIcStartStopBtn_Callback});
set(mainFig,'closeRequestFcn',{@mainFigCloseRequestFcn});

% Callbacks & Function definitions
    function UIcStartStopBtn_Callback(varargin)
        
        hObject = varargin{1};
        isPressed = get(hObject,'value');
        
        if isPressed
            set(hObject,'string','Stop');
        else
            set(hObject,'string','Start');
        end
        
        while isPressed && ~isempty(get(mainFig))
            buffer = circshift(buffer,1);
            fwrite(sp,'a');
            data = fread(sp,2);
            
            currentValue = 2^8*data(1)+2^0*data(2);
            buffer(1) = currentValue*0.004296875;
            
            set(mainFig,'currentAxes',voltAxes);
            plot((0:windowSize-1)*readInTime,buffer(1:windowSize,1));
            set(mainFig,'currentAxes',specAxes);
            plot((((0:windowSize-1)*readInTime)-0.5)*300,20*log10(abs((fftshift(fft(buffer(1:windowSize,1)))))));
            set(UIcVoltageDisplay,'string',buffer(1));
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