function TruncateMainPanel()
	global MP_handles;

	load('Ye.mat', 'Data');
	MP_handles.Data =Data;
	%--Data{x, x, x, x, x}
	%       |  |  |  |   |
	%       |  |  |  |   1,Main_Channel_1 
    %       |  |  |  |   2,Main_Channel_2
    %       |  |  |  1,RE
    %       |  |  |  2,CB
    %       |  |  |  3,PT
    %       |  |  |  4,GN
    %       |  |  |  5,NW
    %       |  |  1,Healthy
    %       |  |  2,Disease
    %       |  1,Before
    %       |  2,Before
    %       1,first
    %       2,second 
    %       3,third
    %       4,fourth
    %	    ........



	%---Main Layout of the Main Panel
	hFigureBase = figure('Name', 'Rawdata showing...', ...
						 'Units', 'normalized', ...
						 'Position', [0 0 1 0.9]);
% 	maximize(hFigureBase);
	hPanelLeft = uipanel('Parent', hFigureBase, ...
						'Title', 'EMG signals', ...
						'FontSize', 12, ...
						'Units', 'normalized', ...
						'Position', [0.0 0.01 0.85 0.98]);
	Channel_Counts = 8;
	Channel_Values = [1 2 3 4 1 2 3 4];
	hAxes_EMG = zeros(Channel_Counts,1);
	hPlots_EMG =zeros(Channel_Counts,1);
	%Left four axes
	for ch=1:Channel_Counts/2
		hAxes_EMG(ch) = axes('Parent', hPanelLeft, ...
							 'Units', 'normalized', ...
							 'Position', [0.02 1-0.23*ch, 0.47, 0.18], ...
							 'YGrid', 'on', ...
							 'XGrid', 'on', ...
							 'YLimMode', 'manual');
		set(hAxes_EMG(ch), 'Color', [0.15 0.15 0.15]);
		%set(hAxes_EMG(ch), 'YLim', [-0.005 0.005]);
		hPlots_EMG(ch) = plot(hAxes_EMG(ch), 0, '-y', ...
							 'LineWidth',1);
		title(['Channel', num2str(Channel_Values(ch))]);
	end
	%Right four axes
	for ch=Channel_Counts/2+1:Channel_Counts
		hAxes_EMG(ch) = axes('Parent', hPanelLeft, ...
							 'Units', 'normalized', ...
							 'Position', [0.51 1-0.23*(ch-4), 0.47, 0.18], ...
							 'YGrid', 'on', ...
							 'XGrid', 'on', ...
							 'YLimMode', 'manual');
		set(hAxes_EMG(ch), 'Color', [0.15 0.15 0.15]);
		%set(hAxes_EMG(ch), 'YLim', [-0.005 0.005]);
		hPlots_EMG(ch) = plot(hAxes_EMG(ch), 0, '-y', ...
							 'LineWidth',1);
		title(['Channel', num2str(Channel_Values(ch))]);
	end

	%--Length_TimeWindow
	hEdit_Length_TimeWindow = uicontrol('Parent', hFigureBase, ...
										'Style', 'Edit', ...
										'Units', 'normalized', ...
										'FontSize', 10, ...
										'Position', [0.86 0.95 0.1 0.02], ...
										'String', '128');
	%--Length_IncreaseWindow
	hEdit_Length_IncreaseWindow = uicontrol('Parent', hFigureBase, ...
										'Style', 'Edit', ...
										'Units', 'normalized', ...
										'FontSize', 10, ...
										'Position', [0.86 0.92 0.1 0.02], ...
										'String', '64');
	hEdit_PatientName = uicontrol('Parent', hFigureBase, ...
								'Style', 'Edit', ...
								'Units', 'normalized', ...
								'FontSize', 10, ...
								'Position', [0.86 0.88 0.08 0.02], ...
								'String', 'Ye');
	hEdit_Times = uicontrol('Parent', hFigureBase, ...
							'Style', 'Edit', ...
							'Units', 'normalized', ...
							'FontSize', 10, ...
							'Position', [0.95 0.88 0.04 0.02], ...
							'String', '1');
	hList_AB = uicontrol('Parent', hFigureBase, ...
						'Style', 'list', ...
						'Units', 'normalized', ...
						'FontSize', 10, ...
						'Position', [0.86 0.82 0.05 0.04], ...
						'String', 'Before|After');
	hList_Movement = uicontrol('Parent', hFigureBase, ...
								'Style', 'list', ...
								'Units', 'normalized', ...
								'FontSize', 10, ...
								'Position', [0.91 0.76 0.08 0.1], ...
								'String', 'Raise Eyebrow|Cheek Bulging|Pouting|Grinning|Nose Wrinkling', ...
								'CallBack', @List_Movement_CallBack);
	MP_handles.Add_Number = 0;
	hButton_AddClipped = uicontrol('Parent', hFigureBase, ...
									'Style', 'pushbutton', ...
									'Units', 'normalized', ...
									'Position', [0.86 0.66 0.03 0.02], ...
									'FontSize', 10, ...
									'String', 'Add+', ...
									'CallBack', {@Button_AddClipped_CallBack}, ...
									'Enable', 'on');
	Total_Clipped = 5;
	MP_handles.Total_Clipped = Total_Clipped;
	%--Left
	hButton_LeftMinus = zeros(Total_Clipped, 1);
	hEdit_Left = zeros(Total_Clipped, 1);
	hButton_LeftPlus = zeros(Total_Clipped, 1);
	%--Right
	hButton_RightMinus = zeros(Total_Clipped, 1);
	hEdit_Right = zeros(Total_Clipped, 1);
	hButton_RightPlus = zeros(Total_Clipped, 1);
	for n=1:Total_Clipped
		%--Left
		hButton_LeftMinus(n) = uicontrol('Parent', hFigureBase, ...
										 'Style', 'pushbutton', ...
										 'Units', 'normalized', ...
										 'FontSize', 14, ...
										 'String', '-', ...
										 'Position', [0.85 0.63-(n-1)*0.023 0.02 0.02], ...
										 'CallBack', {@Button_Minus_CallBack,n,'L'}, ...
										 'Visible', 'off');
		hEdit_Left(n) = uicontrol('Parent', hFigureBase, ...
								  'Style', 'Edit', ...
								  'Units', 'normalized', ...
								  'FontSize', 10, ...
								  'Position', [0.872, 0.63-(n-1)*0.023 0.026 0.02], ...
								  'String', '20000', ...
								  'CallBack', {@Edit_CallBack,n,'L'}, ...
								  'Visible', 'off');
		hButton_LeftPlus(n) = uicontrol('Parent', hFigureBase, ...
										'Style', 'pushbutton', ...
										'Units', 'normalized', ...
										'Position', [0.90 0.63-(n-1)*0.023 0.02 0.02], ...
										'FontSize', 14, ...
										'String', '+', ...
										'CallBack', {@Button_Plus_CallBack,n,'L'}, ...
										'Visible', 'off');
		hButton_RightMinus(n) = uicontrol('Parent', hFigureBase, ...
										'Style', 'pushbutton', ...
										'Units', 'normalized', ...
										'Position', [0.921 0.63-(n-1)*0.023 0.02 0.02], ...
										'FontSize', 14, ...
										'String', '-', ...
										'CallBack', {@Button_Minus_CallBack,n,'R'}, ...
										'Visible', 'off');
		hEdit_Right(n) = uicontrol('Parent', hFigureBase, ...
								   'Style', 'Edit', ...
								   'Units', 'normalized', ...
								   'FontSize', 10, ...
								   'Position', [0.942 0.63-(n-1)*0.023 0.026 0.02 ], ...
								   'String', '30000', ...
								   'CallBack', {@Edit_CallBack,n,'R'}, ...
								   'Visible', 'off');
		hButton_RightPlus(n) = uicontrol('Parent', hFigureBase, ...
										'Style', 'pushbutton', ...
										'Units', 'normalized', ...
										'Position', [0.97 0.63-(n-1)*0.023 0.02 0.02], ...
										'FontSize', 14, ...
										'String', '+', ...
										'CallBack', {@Button_Plus_CallBack,n,'R'}, ...
										'Visible', 'off');
	end

	hButton_Truncate = uicontrol('Parent', hFigureBase, ...
							   'Style', 'pushbutton', ...
							   'Units', 'normalized', ...
							   'FontSize', 10, ...
							   'Position', [0.86 0.46 0.06 0.04 ], ...
							   'String', 'Truncate', ...
							   'CallBack', @Button_Truncate_CallBack);
	hButton_Analyze = uicontrol('Parent', hFigureBase, ...
							   'Style', 'pushbutton', ...
							   'Units', 'normalized', ...
							   'FontSize', 10, ...
							   'Position', [0.86 0.41 0.06 0.04 ], ...
							   'String', 'Analyze', ...
							   'CallBack', @Button_Analyze_CallBack);

	%----------Attach key handles to the MP_handles
	MP_handles.Channel_Counts = Channel_Counts;
	MP_handles.Channel_Values = Channel_Values;
	MP_handles.hAxes_EMG = hAxes_EMG;
	MP_handles.hPlots_EMG = hPlots_EMG;
	%-Time Windows.
	MP_handles.hEdit_Length_TimeWindow = hEdit_Length_TimeWindow;
	MP_handles.hEdit_Length_IncreaseWindow = hEdit_Length_IncreaseWindow;
	%-Patient Name.
	MP_handles.hEdit_PatientName = hEdit_PatientName;
	MP_handles.hEdit_Times = hEdit_Times;
	%-List After or Before.
	MP_handles.hList_AB = hList_AB;
	%-List of five movements.
	MP_handles.hList_Movement = hList_Movement;
	%-Button Add+
	MP_handles.hButton_AddClipped = hButton_AddClipped;
	%-Left five Clipped Lines.
	MP_handles.hButton_LeftMinus = hButton_LeftMinus;
	MP_handles.hEdit_Left = hEdit_Left;
	MP_handles.hButton_LeftPlus = hButton_LeftPlus;
	%-Right five Clipped Lines.
	MP_handles.hButton_RightMinus = hButton_RightMinus;
	MP_handles.hEdit_Right = hEdit_Right;
	MP_handles.hButton_RightPlus = hButton_RightPlus;


%------------------------CallBack of Buttons.
function List_Movement_CallBack(source, eventdata)
	global MP_handles;

	%--get the rawdata according Patient Name + Times + AB + Movement_Name
	MP_handles.PatientName = get(MP_handles.hEdit_PatientName, 'String');
	MP_handles.Times_Value = get(MP_handles.hEdit_Times, 'String');
	MP_handles.Times_Value = str2num(MP_handles.Times_Value);
	%-1,2,3,4...
	MP_handles.BA_Value = get(MP_handles.hList_AB, 'Value');
	%-1, B, Before
	%-2, A, After
	MP_handles.Movement_Value = get(MP_handles.hList_Movement, 'Value');
	%-1, RE
	%-2, CB
	%-3, PT
	%-4, GN
	%-5, NW
	MP_handles.Rawdata = cell(MP_handles.Times_Value, 1);
	BA_Cell = {'Before', 'After'};
	Movement_Cell = {'RE', 'CB', 'PT', 'GN', 'NW'};
	%				   1	 2 	   3	 4	   5
	File_Name = [MP_handles.PatientName, ...
				 '_', num2str(MP_handles.Times_Value), ...
				 '_', BA_Cell{MP_handles.BA_Value}, ...
				 '_', Movement_Cell{MP_handles.Movement_Value}, ...
				 '.csv'];
	MP_handles.Rawdata = csvread(File_Name, 9,1);
	%---Displaying Rawdata on the Axes.
	for ch=1:MP_handles.Channel_Counts
		Limit = max(MP_handles.Rawdata(:,1));
		YLimit = [-1.2*Limit 1.2*Limit];
		set(MP_handles.hAxes_EMG(ch), ...
			'YLimMode', 'manual', ...
			'YLim', [-1.2*Limit 1.2*Limit])
		set(MP_handles.hPlots_EMG(ch), ...
			'Color', 'b', ...
			'YData', MP_handles.Rawdata(:, ch));
	end
%-Add Clipped Line.
function Button_AddClipped_CallBack(source, eventdata)
	global MP_handles;
	%--Update Add_Number
	MP_handles.Add_Number = MP_handles.Add_Number + 1;
	%--Visible 
	%-the Number_th Clipped left line 
	%-the Edit box.
	%-the Clipped right line.
	%-Left
	set(MP_handles.hButton_LeftMinus(MP_handles.Add_Number), 'Visible', 'on');
	set(MP_handles.hEdit_Left(MP_handles.Add_Number), 'Visible', 'on');
	set(MP_handles.hButton_LeftPlus(MP_handles.Add_Number), 'Visible', 'on');
	%-Right
	set(MP_handles.hButton_RightMinus(MP_handles.Add_Number), 'Visible', 'on');
	set(MP_handles.hEdit_Right(MP_handles.Add_Number), 'Visible', 'on');
	set(MP_handles.hButton_RightPlus(MP_handles.Add_Number), 'Visible', 'on');

	%--Initiate the Position of Clipped Line.
	% XLim = MP_handles.Rawdata_Size(1);
	XLim = get(MP_handles.hAxes_EMG(1), 'XLim');
	XLim = XLim(2);
	ClippedLine_Position = [XLim/MP_handles.Total_Clipped*MP_handles.Add_Number-2000, ...
							XLim/MP_handles.Total_Clipped*MP_handles.Add_Number+2000];
	set(MP_handles.hEdit_Left(MP_handles.Add_Number), 'String', num2str(ClippedLine_Position(1)));
	set(MP_handles.hEdit_Right(MP_handles.Add_Number), 'String', num2str(ClippedLine_Position(2)));

	%--Clipped line initiation.
	global Clipped_Line;
	Color_map = {'m','k','r','g','c'};
	for ch=1:MP_handles.Channel_Counts
		Clipped_Line(2*MP_handles.Add_Number-1,ch) = line([ClippedLine_Position(1),ClippedLine_Position(1)], ...
														  [-0.0005 0.0005], ...
														 'Color', Color_map{MP_handles.Add_Number}, ...
														 'LineWidth', 1, ...
														 'Parent', MP_handles.hAxes_EMG(ch));
		Clipped_Line(2*MP_handles.Add_Number,ch) = line([ClippedLine_Position(2),ClippedLine_Position(2)], ...
														 [-0.0005 0.0005], ...
														 'Color', Color_map{MP_handles.Add_Number}, ...
														 'LineWidth', 1, ...
														 'Parent', MP_handles.hAxes_EMG(ch));
	end
	
function Button_Minus_CallBack(source, eventdata, number, Left_Right)
	global MP_handles;
	global Clipped_Line;

	Color_map = {'m','k','r','g','c'};
	XLim = get(MP_handles.hAxes_EMG(1), 'XLim');
	%-[0 60000]
	YLim = get(MP_handles.hAxes_EMG(1), 'YLim');
	%-[-0.0005 0.0005]

	switch Left_Right
		case 'L'
			%--delete the older clipped line.
			delete(Clipped_Line(2*number-1,:));
		
			Current_Value = get(MP_handles.hEdit_Left(number), 'String');
			Current_Value = str2num(Current_Value);
			Current_Value = Current_Value -50;
			Current_Value = num2str(Current_Value);
			set(MP_handles.hEdit_Left(number), 'String', Current_Value)
			%-Left
			for ch=1:MP_handles.Channel_Counts
				Clipped_Line(2*number-1,ch) = line([str2num(get(MP_handles.hEdit_Left(number), 'String')), ...
												 str2num(get(MP_handles.hEdit_Left(number), 'String'))], ...
												 YLim, ...
												 'Color', Color_map{number}, ...
												 'LineWidth', 1, ...
												 'Parent', MP_handles.hAxes_EMG(ch));
			end
			
		case 'R'
			%--delete the older clipped line.
			delete(Clipped_Line(2*number,:));

			Current_Value = get(MP_handles.hEdit_Right(number), 'String');
			Current_Value = str2num(Current_Value);
			Current_Value = Current_Value - 50;
			Current_Value = num2str(Current_Value);
			set(MP_handles.hEdit_Right(number), 'String', Current_Value)
			%-Right
			for ch=1:MP_handles.Channel_Counts
				Clipped_Line(2*number,ch) = line([str2num(get(MP_handles.hEdit_Right(number), 'String')), ...
												 str2num(get(MP_handles.hEdit_Right(number), 'String'))], ...
												 YLim, ...
												 'Color', Color_map{number}, ...
												 'LineWidth', 1, ...
												 'Parent', MP_handles.hAxes_EMG(ch));
			end
	end

function Edit_CallBack(source, eventdata, number, Left_Right)
	global MP_handles;
	global Clipped_Line;

	XLim = get(MP_handles.hAxes_EMG(1), 'XLim');
	%-[0 60000]
	YLim = get(MP_handles.hAxes_EMG(1), 'YLim');
	%-[-0.0005 0.0005]

	Color_map = {'m','k','r','g','c'};

	switch Left_Right
		case 'L'
			%--delete the older clipped line.
			delete(Clipped_Line(2*number-1,:));

			%-Left
			for ch=1:MP_handles.Channel_Counts
				Clipped_Line(2*number-1,ch) = line([str2num(get(MP_handles.hEdit_Left(number), 'String')), ...
												 str2num(get(MP_handles.hEdit_Left(number), 'String'))], ...
												 YLim, ...
												 'Color', Color_map{number}, ...
												 'LineWidth', 1, ...
												 'Parent', MP_handles.hAxes_EMG(ch));
			end
		case 'R'
			%--delete the older clipped line.
			delete(Clipped_Line(2*number,:));

			%-Right
			for ch=1:MP_handles.Channel_Counts
				Clipped_Line(2*number,ch) = line([str2num(get(MP_handles.hEdit_Right(number), 'String')), ...
												 str2num(get(MP_handles.hEdit_Right(number), 'String'))], ...
												 YLim, ...
												 'Color', Color_map{number}, ...
												 'LineWidth', 1, ...
												 'Parent', MP_handles.hAxes_EMG(ch));
			end
	end

function Button_Plus_CallBack(source, eventdata, number, Left_Right)
	global MP_handles;
	global Clipped_Line;

	XLim = get(MP_handles.hAxes_EMG(1), 'XLim');
	%-[0 60000]
	YLim = get(MP_handles.hAxes_EMG(1), 'YLim');
	%-[-0.0005 0.0005]

	Color_map = {'m','k','r','g','c'};

	switch Left_Right
		case 'L'
			%--delete the older clipped line.
			delete(Clipped_Line(2*number-1,:));

			Current_Value = get(MP_handles.hEdit_Left(number), 'String');
			Current_Value = str2num(Current_Value);
			Current_Value = Current_Value + 50;
			Current_Value = num2str(Current_Value);
			set(MP_handles.hEdit_Left(number), 'String', Current_Value)
			%-Left
			for ch=1:MP_handles.Channel_Counts
				Clipped_Line(2*number-1,ch) = line([str2num(get(MP_handles.hEdit_Left(number), 'String')), ...
												 str2num(get(MP_handles.hEdit_Left(number), 'String'))], ...
												 YLim, ...
												 'Color', Color_map{number}, ...
												 'LineWidth', 1, ...
												 'Parent', MP_handles.hAxes_EMG(ch));
			end
		case 'R'
			%--delete the older clipped line.
			delete(Clipped_Line(2*number,:));

			Current_Value = get(MP_handles.hEdit_Right(number), 'String');
			Current_Value = str2num(Current_Value);
			Current_Value = Current_Value + 50;
			Current_Value = num2str(Current_Value);
			set(MP_handles.hEdit_Right(number), 'String', Current_Value)
			%-Right
			for ch=1:MP_handles.Channel_Counts
				Clipped_Line(2*number,ch) = line([str2num(get(MP_handles.hEdit_Right(number), 'String')), ...
												 str2num(get(MP_handles.hEdit_Right(number), 'String'))], ...
												 YLim, ...
												 'Color', Color_map{number}, ...
												 'LineWidth', 1, ...
												 'Parent', MP_handles.hAxes_EMG(ch));
			end
	end


function Button_Truncate_CallBack(source, eventdata)
	global MP_handles;

	% Data{x, x, x, x, x}
	%1, MP_handles.Times
	%2, MP_handles.BA_Value
	%3, 1Healthy[1 2 3 4], 
	%   2Disease[5 6 7 8],
	%4, MP_handles.Movement_Value
	%5, Main_Channel

	%--Get only three Clipped Lines.
	%-One
	for CL=1:3
		Position_Line(CL, 1) = str2num(get(MP_handles.hEdit_Left(CL), 'String'));
		Position_Line(CL, 2) = str2num(get(MP_handles.hEdit_Right(CL), 'String'));
	end
	%---Rawdata
	%--60000x8
	%--Healthy Parts.
	for ch=1:4
		MP_handles.Data{MP_handles.Times_Value, MP_handles.BA_Value, 1, MP_handles.Movement_Value, ch} ...
					   = [MP_handles.Rawdata(Position_Line(1,1):Position_Line(1,2), ch+4); ...
					      MP_handles.Rawdata(Position_Line(2,1):Position_Line(2,2), ch+4); ...
					      MP_handles.Rawdata(Position_Line(3,1):Position_Line(3,2), ch+4)];
	end

	%--Disease Parts
	for ch=1:4
		MP_handles.Data{MP_handles.Times_Value, MP_handles.BA_Value, 2, MP_handles.Movement_Value, ch} ...
						= [MP_handles.Rawdata(Position_Line(1,1):Position_Line(1,2), ch); ...
						   MP_handles.Rawdata(Position_Line(2,1):Position_Line(2,2), ch); ...
						   MP_handles.Rawdata(Position_Line(3,1):Position_Line(3,2), ch)];
	end

	BA_Cell = {'Before', 'After'};
	Movement_Cell = {'RE', 'CB', 'PT', 'GN', 'NW'};
	%				   1	 2 	   3	 4	   5
	disp(['Truncate ', MP_handles.PatientName, ...
		  '_', num2str(MP_handles.Times_Value), ...
		  '_', BA_Cell{MP_handles.BA_Value}, ...
		  '_', Movement_Cell{MP_handles.Movement_Value}]);
	%--save Data to the .mat file.
	Data = MP_handles.Data;
	save([MP_handles.PatientName, '.mat'], ...
		 'Data');
	
	%--Comparison and Checking.
	% figure(2)
	% for ch=1:4
	% 	%-Left Disease.
	% 	subplot(4,2,2*ch-1);
	% 	plot(MP_handles.Data{MP_handles.Times_Value, MP_handles.BA_Value, 2, MP_handles.Movement_Value, ch});
	% 	%-Right Healthy.
	% 	subplot(4,2,2*ch);
	% 	plot(MP_handles.Data{MP_handles.Times_Value, MP_handles.BA_Value, 1, MP_handles.Movement_Value, ch});
	% end


function Button_Analyze_CallBack(source, eventdata)
	global MP_handles;

% 	Data = MP_handles.Data;
% 	% save([MP_handles.PatientName, num2str(MP_handles.Times_Value), '.mat'], ...
% 	% 	 'Data');
% 	save([MP_handles.PatientName, '.mat'], ...
% 		 'Data');
     FeatureAbstractPanel()