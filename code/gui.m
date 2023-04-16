function temp_control()
    fontsize = 8;
    %--------------------------GUI PANELS-------------------------------------
    %%%%%%%%%%%%%%%%%%%%%%%%Temperature Control%%%%%%%%%%%%%%%%%%%%%%%%%
    window = figure('Units', 'characters', ...
        'Visible', 'on', ...
        'Position', [5 5 200 16]);

    ctrl_panel = uipanel('Title', 'Control Panel', ...
        'Units', 'characters', ...
        'Position', [0 4 55 12], ...
        'Parent', window);

    graph_panel = uipanel('Title', 'Live graph', ...
        'Units', 'characters', ...
        'Position', [55 0 110 16], ...
        'Parent', window);

    data_panel = uipanel('Title', 'Data', ...
        'Units', 'characters', ...
        'Position', [165 0 28 16], ...
        'Parent', window);

    console_panel = uipanel('Title', 'Console', ...
        'Units', 'characters', ...
        'Position', [0 0 55 4], ...
        'Parent', window);

    %Calculate the correct position for the data table workaround
    %An old version of uitable is used, which does not support 'Position' in characters so it must be converted into pixels.
    size_characters = get(window, 'Position');
    set(gcf, 'Units', 'Pixels');
    size_pixels = get(window, 'Position');
    char_to_pix = size_pixels(3:4) ./ size_characters(3:4);

    graph_panel_pos = get(graph_panel, 'Position');

    data_table_pos_x = char_to_pix(1) * (graph_panel_pos(1) + graph_panel_pos(3));
    data_table_pos_y = 0;
    data_table_pos_h = char_to_pix(2) * (graph_panel_pos(4) - 1);
    data_table_pos_w = char_to_pix(1) * 28;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Keithley%%%%%%%%%%%%%%%%%%%%%%%%%
    window2 = figure('name', 'Keithley', ...
        'Units', 'characters', ...
        'Visible', 'off', ...
        'Position', [5 1 156 55]);

    keithley_graph_panel_A = uipanel('Title', 'Channel A', ...
        'Units', 'characters', ...
        'Position', [16 27 100 27], ...
        'Parent', window2);

    keithley_graph_panel_B = uipanel('Title', 'Channel B', ...
        'Units', 'characters', ...
        'Position', [16 0 100 27], ...
        'Parent', window2);

    keithley_ctrl_panel = uipanel('Title', 'Keithley Control', ...
        'Units', 'characters', ...
        'Position', [0 24.5 16 6.5], ...
        'Parent', window2);

    keithley_data_panel = uipanel('Title', 'Data', ...
        'Units', 'characters', ...
        'Position', [116 0 40 27], ...
        'Parent', window2);

    %Calculate the correct position for the data table workaround
    %An old version of uitable is used, which does not support 'Position' in characters so it must be converted into pixels.
    keithley_graph_panel_pos = get(keithley_graph_panel_A, 'Position');

    keithley_data_table_pos_x = char_to_pix(1) * (keithley_graph_panel_pos(1) + keithley_graph_panel_pos(3));
    keithley_data_table_pos_y = char_to_pix(2) * keithley_graph_panel_pos(2);
    keithley_data_table_pos_h = char_to_pix(2) * (keithley_graph_panel_pos(4) - 1);
    keithley_data_table_pos_w = char_to_pix(1) * 40;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%keithley2%%%%%%%%%%%%%%%%%%%%%%%%%
    window3 = figure('name', 'keithley2', ...
        'Units', 'characters', ...
        'Visible', 'off', ...
        'Position', [5 1 156 55]);

    keithley_graph_panel_A2 = uipanel('Title', 'Channel A', ...
        'Units', 'characters', ...
        'Position', [16 27 100 27], ...
        'Parent', window3);

    keithley_graph_panel_B2 = uipanel('Title', 'Channel B', ...
        'Units', 'characters', ...
        'Position', [16 0 100 27], ...
        'Parent', window3);

    keithley_ctrl_panel2 = uipanel('Title', 'keithley2 Control', ...
        'Units', 'characters', ...
        'Position', [0 24.5 16 6.5], ...
        'Parent', window3);

    keithley_data_panel2 = uipanel('Title', 'Data', ...
        'Units', 'characters', ...
        'Position', [116 0 40 27], ...
        'Parent', window3);

    %Calculate the correct position for the data table workaround
    %An old version of uitable is used, which does not support 'Position' in characters so it must be converted into pixels.
    keithley_graph_panel_pos2 = get(keithley_graph_panel_A2, 'Position');

    keithley_data_table_pos_x2 = char_to_pix(1) * (keithley_graph_panel_pos2(1) + keithley_graph_panel_pos2(3));
    keithley_data_table_pos_y2 = char_to_pix(2) * keithley_graph_panel_pos2(2);
    keithley_data_table_pos_h2 = char_to_pix(2) * (keithley_graph_panel_pos2(4) - 1);
    keithley_data_table_pos_w2 = char_to_pix(1) * 40;
    %--------------------------------------------------------------------------

    %--------------------------GUI ELEMENTS------------------------------------
    %%%%%%%%%%%%%%%%%%%%%%%%Temperature Control%%%%%%%%%%%%%%%%%%%%%%%%%
    ports_dropdown_label = uicontrol('Parent', ctrl_panel, ...
        'Units', 'characters', ...
        'FontSize', fontsize, ...
        'Style', 'text', ...
        'String', 'COM Port', ...
        'HorizontalAlignment', 'left', ...
        'Position', [1, 9, 10, 1]);
    %Get the avaliable COM ports. Note that MATLAB generates this on startup, so the Arduino must be connected before
    %MATLAB is started.
    com_info = instrhwinfo('serial');
    com_avail = com_info.SerialPorts;
    ports_dropdown = uicontrol('Parent', ctrl_panel, ...
        'Units', 'characters', ...
        'FontSize', fontsize, ...
        'Style', 'popupmenu', ...
        'String', com_avail, ...
        'Position', [15, 9, 10, 1], ...
        'Callback', {@ports_dropdown_callback})

    temp_editbox_label = uicontrol('Parent', ctrl_panel, ...
        'Units', 'characters', ...
        'FontSize', fontsize, ...
        'Style', 'text', ...
        'String', 'Chamber Temp', ...
        'HorizontalAlignment', 'left', ...
        'Position', [1, 6.5, 13, 1.5]);

    temp_editbox = uicontrol('Parent', ctrl_panel, ...
        'Units', 'characters', ...
        'FontSize', fontsize, ...
        'Style', 'edit', ...
        'Units', 'characters', ...
        'String', '0', ...
        'Position', [15, 7, 8, 1], ...
        'Callback', {@temp_editbox_callback});

    start_stop_pushbox = uicontrol('Parent', ctrl_panel, ...
        'Style', 'pushbutton', ...
        'Units', 'characters', ...
        'FontSize', fontsize, ...
        'String', 'Start', ...
        'Position', [39, 8, 13, 2], ...
        'Callback', {@start_stop_pushbox_callback});

    p_editbox_label = uicontrol('Parent', ctrl_panel, ...
        'Units', 'characters', ...
        'FontSize', fontsize, ...
        'Style', 'Text', ...
        'Units', 'characters', ...
        'String', 'P', ...
        'HorizontalAlignment', 'left', ...
        'Position', [12, 5, 2, 1.5]);

    p_editbox = uicontrol('Parent', ctrl_panel, ...
        'Units', 'characters', ...
        'FontSize', fontsize, ...
        'Style', 'Edit', ...
        'Units', 'characters', ...
        'String', '0', ...
        'Position', [15, 5.5, 4, 1], ...
        'Callback', {@p_editbox_callback});

    i_editbox_label = uicontrol('Parent', ctrl_panel, ...
        'Units', 'characters', ...
        'FontSize', fontsize, ...
        'Style', 'Text', ...
        'Units', 'characters', ...
        'String', 'I', ...
        'HorizontalAlignment', 'left', ...
        'Position', [21, 5, 1, 1.5]);

    i_editbox = uicontrol('Parent', ctrl_panel, ...
        'Units', 'characters', ...
        'FontSize', fontsize, ...
        'Style', 'Edit', ...
        'Units', 'characters', ...
        'String', '0', ...
        'Position', [24, 5.5, 4, 1], ...
        'Callback', {@i_editbox_callback});

    d_editbox_label = uicontrol('Parent', ctrl_panel, ...
        'Units', 'characters', ...
        'FontSize', fontsize, ...
        'Style', 'Text', ...
        'Units', 'characters', ...
        'String', 'D', ...
        'HorizontalAlignment', 'left', ...
        'Position', [30, 5, 2, 1.5]);

    d_editbox = uicontrol('Parent', ctrl_panel, ...
        'Units', 'characters', ...
        'FontSize', fontsize, ...
        'Style', 'Edit', ...
        'Units', 'characters', ...
        'String', '0', ...
        'Position', [33, 5.5, 4, 1], ...
        'Callback', {@d_editbox_callback});

    pid_set_pushbox = uicontrol('Parent', ctrl_panel, ...
        'Style', 'pushbutton', ...
        'Units', 'characters', ...
        'FontSize', fontsize, ...
        'String', 'Set PID', ...
        'Position', [39, 5.5, 13, 1.5], ...
        'Callback', {@pid_set_pushbox_callback});

    exit_pushbox = uicontrol('Parent', ctrl_panel, ...
        'Style', 'pushbutton', ...
        'Units', 'characters', ...
        'FontSize', fontsize, ...
        'String', 'Exit', ...
        'Position', [39, 1, 13, 1.5], ...
        'Callback', {@exit_pushbox_callback});

    filename_editbox_label = uicontrol('Parent', ctrl_panel, ...
        'Units', 'characters', ...
        'FontSize', fontsize, ...
        'Style', 'edit', ...
        'Units', 'characters', ...
        'String', 'File Name', ...
        'HorizontalAlignment', 'left', ...
        'Position', [1, 3, 20, 1.5]);

    save_data_pushbox = uicontrol('Parent', ctrl_panel, ...
        'Style', 'pushbutton', ...
        'Units', 'characters', ...
        'FontSize', fontsize, ...
        'String', 'Save data', ...
        'Position', [23, 3, 13, 1.5], ...
        'Callback', {@save_data_pushbox_callback});
    console_editbox = uicontrol('Parent', console_panel, ...
        'Style', 'listbox', ...
        'Max', 2, ...
        'HorizontalAlignment', 'left', ...
        'Units', 'characters', ...
        'FontSize', 8, ...
        'Position', [0, 0, 54, 3], ...
        'Callback', {@console_editbox_callback});

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Keithley%%%%%%%%%%%%%%%%%%%%%%%%%%
    keithley_pushbox = uicontrol('Parent', ctrl_panel, ...
        'Style', 'pushbutton', ...
        'Units', 'characters', ...
        'FontSize', fontsize, ...
        'String', 'Keithley', ...
        'Position', [0, 1, 13, 1.5], ...
        'Callback', {@keithley_pushbox_callback});

    keithley_close_pushbox = uicontrol('Parent', keithley_ctrl_panel, ...
        'Style', 'pushbutton', ...
        'Units', 'characters', ...
        'FontSize', fontsize, ...
        'String', 'Close', ...
        'Position', [1, 1, 13, 2], ...
        'Callback', {@keithley_close_pushbox_callback});

    keithley_save_data_pushbox = uicontrol('Parent', keithley_ctrl_panel, ...
        'Style', 'pushbutton', ...
        'Units', 'characters', ...
        'FontSize', fontsize, ...
        'String', 'Save data', ...
        'Position', [1, 3.5, 13, 1.5], ...
        'Callback', {@keithley_save_data_pushbox_callback});

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%keithley2%%%%%%%%%%%%%%%%%%%%%%%%%%
    keithley_pushbox2 = uicontrol('Parent', ctrl_panel, ...
        'Style', 'pushbutton', ...
        'Units', 'characters', ...
        'FontSize', fontsize, ...
        'String', 'Keithley2', ...
        'Position', [15, 1, 13, 1.5], ...
        'Callback', {@keithley_pushbox_callback2});

    keithley_close_pushbox2 = uicontrol('Parent', keithley_ctrl_panel2, ...
        'Style', 'pushbutton', ...
        'Units', 'characters', ...
        'FontSize', fontsize, ...
        'String', 'Close', ...
        'Position', [1, 1, 13, 2], ...
        'Callback', {@keithley_close_pushbox_callback2});

    keithley_save_data_pushbox2 = uicontrol('Parent', keithley_ctrl_panel2, ...
        'Style', 'pushbutton', ...
        'Units', 'characters', ...
        'FontSize', fontsize, ...
        'String', 'Save data', ...
        'Position', [1, 3.5, 13, 1.5], ...
        'Callback', {@keithley_save_data_pushbox_callback2});

    %--------------------------------------------------------------------------
    %----------------------------GUI VARIABLES---------------------------------
    %%%%%%%%%%%%%%%%%%%%%%%%Temperature Control%%%%%%%%%%%%%%%%%%%%%%%%%
    %Array storing the user input temperatures
    global set_temp_history
    set_temp_history = 0;

    %Serial port being used
    global port;

    %P value set by user
    global p_value;
    p_value = 0;

    %I value set by user
    global i_value;
    i_value = 0;

    %D value set by user
    global d_value;
    d_value = 0;

    %Exit flag signalling while loop to exit
    global exit;
    exit = 0;

    %Console output history
    global console_history
    console_history = 'Starting application';
    global console_i;
    console_i = 2;

    %Port status
    global port_flag;
    port_flag = 0;

    %Start/Stop
    global start;
    start = 0; %OFF

    %Console row length
    global console_size;
    console_size = 1;

    %Temp control table row length
    global data_table_size;
    data_table_size = 1;

    %Loop every...
    global update;
    update = 1;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Keithley%%%%%%%%%%%%%%%%%%%%%%%%%
    %Keithley time index
    global n;
    n = 1;

    %Flag to setup communication with Keithley
    %If set to 1, setup has already been done
    global keithley;
    keithley = 0; %OFF

    %Flag for the Keithley window
    global keithley_start;
    keithley_start = 0;

    %Flag for Keithley window
    global keithley_close;
    keithley_close = 0;

    %Keithley Table row length
    global keithley_data_table_size;
    keithley_data_table_size = 0;

    %Initialization for Keithley graph
    Ilevel = 1E-6; % Current in A
    Vlevel = 3;
    VlevelC = num2str(Vlevel);
    IlevelC = num2str(Ilevel);
    length = 2000;
    fC = num2str(update);
    gas = 'EtOH';
    filename = ['S1-' VlevelC 'A-f' fC 'Hz' '-Gas' gas '-2'];

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%keithley2%%%%%%%%%%%%%%%%%%%%%%%%%%
    %keithley2 time index
    global n2;
    n2 = 1;

    %Flag to setup communication with keithley2
    %If set to 1, setup has already been done
    global keithley2;
    keithley2 = 0; %OFF

    %Flag for the keithley2 window
    global keithley_start2;
    keithley_start2 = 0;

    %Flag for keithley2 window
    global keithley_close2;
    keithley_close2 = 0;

    %keithley2 Table row length2
    global keithley_data_table_size2;
    keithley_data_table_size2 = 0;

    %Initialization for keithley2 graph
    Ilevel2 = 1E-6; % Current in A
    Vlevel2 = 3;
    VlevelC2 = num2str(Vlevel2);
    IlevelC2 = num2str(Ilevel2);
    length2 = 2000;
    fC2 = num2str(update);
    gas2 = 'EtOH';
    filename2 = ['S1-' VlevelC2 'A-f' fC2 'Hz' '-gas2' gas2 '-2'];

    %--------------------------------------------------------------------------
    %--------------------------GUI CALLBACKS-----------------------------------
    %COMM Port Dropdown
    function ports_dropdown_callback(hObject, eventdata, handles)
        val = get(hObject, 'Value');
        string_list = get(hObject, 'String');
        selected_string = string_list{val};
        port = serial(selected_string, 'BAUD', 9600);
        fopen(port);

        %Communication will hang if data is sent before the port is ready
        pause(3);
        port_flag = 1;
        console_history = {console_history; 'Opening COM5'};
        set(console_editbox, 'String', console_history);
    end

    %Input Temperature Field
    function temp_editbox_callback(hObject, eventdata, handles)
    end

    %Start Stop Button
    function start_stop_pushbox_callback(hObject, eventdata, handles)

        if (start == 0)
            start = 1;
            set(start_stop_pushbox, 'String', 'Stop');
        else
            start = 0;
            set(start_stop_pushbox, 'String', 'Start');
        end

    end

    %P Field
    function p_editbox_callback(hObject, eventdata, handles)
    end

    %I Field
    function i_editbox_callback(hObject, eventdata, handles)
    end

    %D Field
    function d_editbox_callback(hObject, eventdata, handles)
    end

    %Set PID Buttion
    function pid_set_pushbox_callback(hObject, eventdata, handles)
        %Get the P value set by user
        p_value = str2num(get(p_editbox, 'String'));

        console_history{end + 1} = ['Sending P = ' num2str(p_value)];
        set(console_editbox, 'String', console_history);
        set(console_editbox, 'ListboxTop', console_size);
        console_size = console_size + 1;

        %Get the I value set by user
        i_value = str2num(get(i_editbox, 'String'));

        console_history{end + 1} = ['Sending I = ' num2str(i_value)];
        set(console_editbox, 'String', console_history);
        set(console_editbox, 'ListboxTop', console_size);
        console_size = console_size + 1;

        %Get the D value set by user
        d_value = str2num(get(d_editbox, 'String'));

        console_history{end + 1} = ['Sending D = ' num2str(d_value)];
        set(console_editbox, 'String', console_history);
        set(console_editbox, 'ListboxTop', console_size);
        console_size = console_size + 1;

        set_temp = str2num(get(temp_editbox, 'String'));

        %Save the temperature set
        set_temp_history = [set_temp_history set_temp];

        console_history{end + 1} = ['Sending Temp = ' num2str(set_temp_history(end))];

        set(console_editbox, 'String', console_history);
        set(console_editbox, 'ListboxTop', console_size);
        console_size = console_size + 1;
        console_history{end + 1} = '-';
        set(console_editbox, 'String', console_history);
        set(console_editbox, 'ListboxTop', console_size);
        console_size = console_size + 1;
    end

    function exit_pushbox_callback(hObject, eventdata, handles)

        if (port_flag)
            fclose(port);
        end

        instrreset;
        exit = 1;
        close(window);
        close(window2);
        error('');
    end

    function console_editbox_callback(hObject, eventdata, handles)
    end

    %Keithley Pushbox
    function keithley_pushbox_callback(hObject, eventdata, handles)
        keithley_start = 1;
        %Don't run Keithley communication setup if done already
        if (~keithley)
            c = gpib('ics', 0, 24); % % % % % % % % % % % % % % % % %Keithley source meter address
            fopen(c);
            fprintf(c, 'reset()');

            % set(c, 'EOIMode', 'off');
            %ob=instrfind;
            %set(ob(1), 'EOSMode', 'write');

            set(c, 'EOSMode', 'write');

            %channel A apply current, measure voltage
            fprintf(c, 'smua.reset();');

            %channel B
            fprintf(c, 'smub.reset();');
            set(c, 'EOSMode', 'write');
            set(c, 'Timeout', 1);

            %Channel A
            fprintf(c, 'smua.source.func = smua.OUTPUT_DCVOLTS'); % Select current source function
            fprintf(c, 'smua.source.autorangei = smua.AUTORANGE_ON'); %Set source range to 50mA
            fprintf(c, 'display.smua.measure.func = display.MEASURE_OHMS'); %display Ohm on device
            fprintf(c, ['smua.source.limitv = ', num2str(10, 10)]);
            fprintf(c, ['smua.source.limiti = 0', num2str(1E-3, 10)]);

            %fprintf(c(1),'smua.measure.nplc=2;');
            % Number of Power Line Cycles (NPLC), where 1 PLC for
            %60Hz is 16.67msec (1/60) and 1 PLC for 50Hz is 20msec (1/50).
            fprintf(c, 'smua.sense= smua.SENSE_REMOTE'); %Enable 4-wire prob
            fprintf(c, 'smua.measure.autorangev = smua.AUTORANGE_ON'); %set voltage range

            %Channel B
            fprintf(c, 'smub.source.func = smub.OUTPUT_DCVOLTS'); % Select current source function
            fprintf(c, 'smub.source.autorangei = smub.AUTORANGE_ON'); %Set source range to 50mA
            fprintf(c, 'display.smub.measure.func = display.MEASURE_OHMS'); %display Ohm on device

            fprintf(c, ['smub.source.limitv = ', num2str(10, 10)]);
            fprintf(c, ['smub.source.limiti = 0', num2str(1E-3, 10)]);
            %fprintf(c(1),'smub.measure.nplc=2;'); % Number of Power Line Cycles (NPLC), where 1 PLC for
            %60Hz is 16.67msec (1/60) and 1 PLC for 50Hz is 20msec (1/50).
            fprintf(c, 'smub.sense= smub.SENSE_REMOTE'); %Enable 4-wire prob
            fprintf(c, 'smub.measure.autorangev = smub.AUTORANGE_ON'); %set voltage range
            fprintf(c, 'beeper.enable = 1');
            %fprintf(c,['smua.source.leveli = ',num2str(Ilevel,10)]); %Set current leve with 10 precision
            fprintf(c, ['smua.source.levelv = ', num2str(Vlevel, 10)]); %Set current leve with 10 precision
            %fprintf(c,'smua.source.output = smua.OUTPUT_ON');
            %fprintf(c,['smub.source.leveli = ',num2str(Ilevel,10)]); %Set current leve with 10 precision
            fprintf(c, ['smub.source.levelv = ', num2str(Vlevel, 10)]); %Set current leve with 10 precision
            %fprintf(c,'smub.source.output = smub.OUTPUT_ON');
        end

        keithley = 1;

        %If the Keithley window was closed, redraw all GUI elements
        if (keithley_close)
            window2 = figure('name', 'Keithley', ...
                'Units', 'characters', ...
                'Visible', 'off', ...
                'Position', [5 1 156 55]);

            keithley_graph_panel_A = uipanel('Title', 'Channel A', ...
                'Units', 'characters', ...
                'Position', [16 27 100 27], ...
                'Parent', window2);

            keithley_graph_panel_B = uipanel('Title', 'Channel B', ...
                'Units', 'characters', ...
                'Position', [16 0 100 27], ...
                'Parent', window2);

            keithley_ctrl_panel = uipanel('Title', 'Keithley Control', ...
                'Units', 'characters', ...
                'Position', [0 24.5 16 6.5], ...
                'Parent', window2);

            keithley_data_panel = uipanel('Title', 'Data', ...
                'Units', 'characters', ...
                'Position', [116 0 40 27], ...
                'Parent', window2);

            keithley_close_pushbox = uicontrol('Parent', keithley_ctrl_panel, ...
                'Style', 'pushbutton', ...
                'Units', 'characters', ...
                'FontSize', fontsize, ...
                'String', 'Close', ...
                'Position', [1, 1, 13, 2], ...
                'Callback', {@keithley_close_pushbox_callback});

            keithley_save_data_pushbox = uicontrol('Parent', keithley_ctrl_panel, ...
                'Style', 'pushbutton', ...
                'Units', 'characters', ...
                'FontSize', fontsize, ...
                'String', 'Save data', ...
                'Position', [1, 3.5, 13, 1.5], ...
                'Callback', {@keithley_save_data_pushbox_callback});

            keithley_close = 0;
        end

        figure(window2);

        axes('parent', keithley_graph_panel_A);
        subplot(3, 1, 1); ylabel('Voltage [V]');
        subplot(3, 1, 2); ylabel('Current [A]');
        subplot(3, 1, 3); ylabel('Resistance [\Omega]');

        axes('parent', keithley_graph_panel_B);
        subplot(3, 1, 1); ylabel('Voltage [V]');
        subplot(3, 1, 2); ylabel('Current [A]');
        subplot(3, 1, 3); ylabel('Resistance [\Omega]');
    end

    %keithley2 Pushbox
    function keithley_pushbox_callback2(hObject, eventdata, handles)
        keithley_start2 = 1;

        %Don't run keithley2 communication setup if done already
        if (~keithley2)
            c2 = gpib('ics', 0, 24); % % % % % % % % % % % % % % % % %keithley2 source meter address

            fopen(c2);
            fprintf(c2, 'reset()');
            % set(c2, 'EOIMode', 'off');
            %ob=instrfind;
            %set(ob(1), 'EOSMode', 'write');

            set(c2, 'EOSMode', 'write');

            %channel A apply current, measure voltage
            fprintf(c2, 'smua.reset();');

            %channel B
            fprintf(c2, 'smub.reset();');
            set(c2, 'EOSMode', 'write');
            set(c2, 'Timeout', 1);

            %Channel A
            fprintf(c2, 'smua.source.func = smua.OUTPUT_DCVOLTS'); % Select current source function
            fprintf(c2, 'smua.source.autorangei = smua.AUTORANGE_ON'); %Set source range to 50mA
            fprintf(c2, 'display.smua.measure.func = display.MEASURE_OHMS'); %display Ohm on device
            fprintf(c2, ['smua.source.limitv = ', num2str(10, 10)]);
            fprintf(c2, ['smua.source.limiti = 0', num2str(1E-3, 10)]);

            %fprintf(c2(1),'smua.measure.nplc=2;');
            % Number of Power Line Cycles (NPLC), where 1 PLC for
            %60Hz is 16.67msec (1/60) and 1 PLC for 50Hz is 20msec (1/50).
            fprintf(c2, 'smua.sense= smua.SENSE_REMOTE'); %Enable 4-wire prob
            fprintf(c2, 'smua.measure.autorangev = smua.AUTORANGE_ON'); %set voltage range

            %Channel B
            fprintf(c2, 'smub.source.func = smub.OUTPUT_DCVOLTS'); % Select current source function
            fprintf(c2, 'smub.source.autorangei = smub.AUTORANGE_ON'); %Set source range to 50mA
            fprintf(c2, 'display.smub.measure.func = display.MEASURE_OHMS'); %display Ohm on device
            fprintf(c2, ['smub.source.limitv = ', num2str(10, 10)]);
            fprintf(c2, ['smub.source.limiti = 0', num2str(1E-3, 10)]);

            %fprintf(c2(1),'smub.measure.nplc=2;');
            % Number of Power Line Cycles (NPLC), where 1 PLC for
            %60Hz is 16.67msec (1/60) and 1 PLC for 50Hz is 20msec (1/50).
            fprintf(c2, 'smub.sense= smub.SENSE_REMOTE'); %Enable 4-wire prob
            fprintf(c2, 'smub.measure.autorangev = smub.AUTORANGE_ON'); %set voltage range

            fprintf(c, 'beeper.enable = 1');
            %fprintf(c,['smua.source.leveli = ',num2str(Ilevel,10)]); %Set current leve with 10 precision
            fprintf(c, ['smua.source.levelv = ', num2str(Vlevel, 10)]); %Set current leve with 10 precision
            %fprintf(c,'smua.source.output = smua.OUTPUT_ON');
            %fprintf(c,['smub.source.leveli = ',num2str(Ilevel,10)]); %Set current leve with 10 precision
            fprintf(c, ['smub.source.levelv = ', num2str(Vlevel, 10)]); %Set current leve with 10 precision
            %fprintf(c,'smub.source.output = smub.OUTPUT_ON');
        end

        keithley = 1;
        %If the Keithley window was closed, redraw all GUI elements
        if (keithley_close)
            window2 = figure('name', 'Keithley', ...
                'Units', 'characters', ...
                'Visible', 'off', ...
                'Position', [5 1 156 55]);

            keithley_graph_panel_A = uipanel('Title', 'Channel A', ...
                'Units', 'characters', ...
                'Position', [16 27 100 27], ...
                'Parent', window2);

            keithley_graph_panel_B = uipanel('Title', 'Channel B', ...
                'Units', 'characters', ...
                'Position', [16 0 100 27], ...
                'Parent', window2);

            keithley_ctrl_panel = uipanel('Title', 'Keithley Control', ...
                'Units', 'characters', ...
                'Position', [0 24.5 16 6.5], ...
                'Parent', window2);

            keithley_data_panel = uipanel('Title', 'Data', ...
                'Units', 'characters', ...
                'Position', [116 0 40 27], ...
                'Parent', window2);

            keithley_close_pushbox = uicontrol('Parent', keithley_ctrl_panel, ...
                'Style', 'pushbutton', ...
                'Units', 'characters', ...
                'FontSize', fontsize, ...
                'String', 'Close', ...
                'Position', [1, 1, 13, 2], ...
                'Callback', {@keithley_close_pushbox_callback});

            keithley_save_data_pushbox = uicontrol('Parent', keithley_ctrl_panel, ...
                'Style', 'pushbutton', ...
                'Units', 'characters', ...
                'FontSize', fontsize, ...
                'String', 'Save data', ...
                'Position', [1, 3.5, 13, 1.5], ...
                'Callback', {@keithley_save_data_pushbox_callback});

            keithley_close = 0;
        end

        figure(window2);

        axes('parent', keithley_graph_panel_A);
        subplot(3, 1, 1); ylabel('Voltage [V]');
        subplot(3, 1, 2); ylabel('Current [A]');
        subplot(3, 1, 3); ylabel('Resistance [\Omega]');

        axes('parent', keithley_graph_panel_B);
        subplot(3, 1, 1); ylabel('Voltage [V]');
        subplot(3, 1, 2); ylabel('Current [A]');
        subplot(3, 1, 3); ylabel('Resistance [\Omega]');
    end

    %keithley2 Pushbox
    function keithley_pushbox_callback2(hObject, eventdata, handles)
        keithley_start2 = 1;

        %Don't run keithley2 communication setup if done already
        if (~keithley2)
            c2 = gpib('ics', 0, 24); % % % % % % % % % % % % % % % % %keithley2 source meter address
            fopen(c2);
            fprintf(c2, 'reset()');

            % set(c2, 'EOIMode', 'off');
            %ob=instrfind;
            %set(ob(1), 'EOSMode', 'write');
            set(c2, 'EOSMode', 'write');

            %channel A apply current, measure voltage
            fprintf(c2, 'smua.reset();');

            %channel B
            fprintf(c2, 'smub.reset();');
            set(c2, 'EOSMode', 'write');
            set(c2, 'Timeout', 1);

            %Channel A
            fprintf(c2, 'smua.source.func = smua.OUTPUT_DCVOLTS'); % Select current source function
            fprintf(c2, 'smua.source.autorangei = smua.AUTORANGE_ON'); %Set source range to 50mA
            fprintf(c2, 'display.smua.measure.func = display.MEASURE_OHMS'); %display Ohm on device
            fprintf(c2, ['smua.source.limitv = ', num2str(10, 10)]);
            fprintf(c2, ['smua.source.limiti = 0', num2str(1E-3, 10)]);
            %fprintf(c2(1),'smua.measure.nplc=2;'); % Number of Power Line Cycles (NPLC), where 1 PLC for
            %60Hz is 16.67msec (1/60) and 1 PLC for 50Hz is 20msec (1/50).

            fprintf(c2, 'smua.sense= smua.SENSE_REMOTE'); %Enable 4-wire prob
            fprintf(c2, 'smua.measure.autorangev = smua.AUTORANGE_ON'); %set voltage range

            %Channel B
            fprintf(c2, 'smub.source.func = smub.OUTPUT_DCVOLTS'); % Select current source function
            fprintf(c2, 'smub.source.autorangei = smub.AUTORANGE_ON'); %Set source range to 50mA
            fprintf(c2, 'display.smub.measure.func = display.MEASURE_OHMS'); %display Ohm on device
            fprintf(c2, ['smub.source.limitv = ', num2str(10, 10)]);
            fprintf(c2, ['smub.source.limiti = 0', num2str(1E-3, 10)]);
            %fprintf(c2(1),'smub.measure.nplc=2;'); % Number of Power Line Cycles (NPLC), where 1 PLC for
            %60Hz is 16.67msec (1/60) and 1 PLC for 50Hz is 20msec (1/50).
            fprintf(c2, 'smub.sense= smub.SENSE_REMOTE'); %Enable 4-wire prob
            fprintf(c2, 'smub.measure.autorangev = smub.AUTORANGE_ON'); %set voltage range

            fprintf(c2, 'beeper.enable = 1');
            %fprintf(c2,['smua.source.leveli = ',num2str(Ilevel2,10)]); %Set current leve with 10 precision
            fprintf(c2, ['smua.source.levelv = ', num2str(Vlevel2, 10)]); %Set current leve with 10 precision
            %fprintf(c2,'smua.source.output = smua.OUTPUT_ON');
            %fprintf(c2,['smub.source.leveli = ',num2str(Ilevel2,10)]); %Set current leve with 10 precision
            fprintf(c2, ['smub.source.levelv = ', num2str(Vlevel2, 10)]); %Set current leve with 10 precision
            %fprintf(c2,'smub.source.output = smub.OUTPUT_ON');
        end

        keithley2 = 1;
        %If the keithley2 window was closed, redraw all GUI elements
        if (keithley_close2)
            window3 = figure('name', 'keithley2', ...
                'Units', 'characters', ...
                'Visible', 'off', ...
                'Position', [5 1 156 55]);

            keithley_graph_panel_A2 = uipanel('Title', 'Channel A', ...
                'Units', 'characters', ...
                'Position', [16 27 100 27], ...
                'Parent', window3);

            keithley_graph_panel_B2 = uipanel('Title', 'Channel B', ...
                'Units', 'characters', ...
                'Position', [16 0 100 27], ...
                'Parent', window3);

            keithley_ctrl_panel2 = uipanel('Title', 'keithley2 Control', ...
                'Units', 'characters', ...
                'Position', [0 24.5 16 6.5], ...
                'Parent', window3);

            keithley_data_panel2 = uipanel('Title', 'Data', ...
                'Units', 'characters', ...
                'Position', [116 0 40 27], ...
                'Parent', window3);

            keithley_close_pushbox2 = uicontrol('Parent', keithley_ctrl_panel2, ...
                'Style', 'pushbutton', ...
                'Units', 'characters', ...
                'FontSize', fontsize, ...
                'String', 'Close', ...
                'Position', [1, 1, 13, 2], ...
                'Callback', {@keithley_close_pushbox_callback2});

            keithley_save_data_pushbox2 = uicontrol('Parent', keithley_ctrl_panel2, ...
                'Style', 'pushbutton', ...
                'Units', 'characters', ...
                'FontSize', fontsize, ...
                'String', 'Save data', ...
                'Position', [1, 3.5, 13, 1.5], ...
                'Callback', {@keithley_save_data_pushbox_callback2});

            keithley_close2 = 0;
        end

        figure(window3);

        axes('parent', keithley_graph_panel_A2);
        subplot(3, 1, 1); ylabel('Voltage [V]');

        subplot(3, 1, 2); ylabel('Current [A]');
        subplot(3, 1, 3); ylabel('Resistance [\Omega]');
        axes('parent', keithley_graph_panel_B2);
        subplot(3, 1, 1); ylabel('Voltage [V]');
        subplot(3, 1, 2); ylabel('Current [A]');
        subplot(3, 1, 3); ylabel('Resistance [\Omega]');
    end

    %Save Data Button
    function save_data_pushbox_callback(hObject, eventdata, handles)
        %Write to the console
        console_history{end + 1} = ['Saved ' get(filename_editbox_label, 'String')];
        set(console_editbox, 'String', console_history);
        set(console_editbox, 'ListboxTop', console_size);
        console_size = console_size + 1;
        set(graph_panel, 'Units', 'pixels');

        %Define the area of the graph, and save a picture in Temp/Graphs
        %Save the data in Temp/Results
        %http://www.mathworks.com/matlabcentral/newsreader/view_thread/301782
        rect_pos = get(graph_panel, 'Position');
        f = getframe(window, rect_pos);
        [im, map] = frame2im(f);
        imwrite(im, ['Temp/Graphs/' get(filename_editbox_label, 'String') '.tiff']);
        save(['Temp/Results/' get(filename_editbox_label, 'String') '.mat'], 'meas_temp_history', 'pwm_history'); % saves
        WS variable
        set(graph_panel, 'Units', 'Characters');
    end

    %Keithley Save Data Button
    function keithley_save_data_pushbox_callback(hObject, eventdata, handles)
        set(keithley_graph_panel_A, 'Units', 'pixels');

        %Define the area of the graph, and save a picture in Temp/Graphs
        %Save the data in Temp/Results
        %http://www.mathworks.com/matlabcentral/newsreader/view_thread/301782

        rect_pos = get(keithley_graph_panel_A, 'Position');
        f = getframe(window2, rect_pos);
        [im, map] = frame2im(f);
        imwrite(im, ['Keithley/Graphs/' filename '.tiff']);
        save(['Keithley/Results/' filename '.mat'], 'rpos', 'vpos', 'ipos'); % saves WS variable

        %saveas(keithley_graph_panel_A,['Graphs/' filename '.tiff'], 'tiffn') %saves in uncompressed tiff.
        %saveas(keithley_grap_panel,['Graphs/' filename '.fig'], 'fig') %saves as matlab fig.
        set(keithley_graph_panel_A, 'Units', 'Characters');
    end

    %keithley2 Save Data Button
    function keithley_save_data_pushbox_callback2(hObject, eventdata, handles)
        set(keithley_graph_panel_A2, 'Units', 'pixels');
        %Define the area of the graph, and save a picture in Temp/Graphs
        %Save the data in Temp/Results
        %http://www.mathworks.com/matlabcentral/newsreader/view_thread/301782

        rect_pos = get(keithley_graph_panel_A2, 'Position');
        f = getframe(window3, rect_pos);
        [im, map] = frame2im(f);
        imwrite(im, ['keithley2/Graphs/' filename2 '.tiff']);
        save(['keithley2/Results/' filename2 '.mat'], 'rpos', 'vpos', 'ipos'); % saves WS variable
        %saveas(keithley_graph_panel_A2,['Graphs/' filename2 '.tiff'], 'tiffn') %saves in uncompressed tiff.
        %saveas(keithley_grap_panel,['Graphs/' filename2 '.fig'], 'fig') %saves as matlab fig.

        set(keithley_graph_panel_A2, 'Units', 'Characters');
    end

    %Keithley Close
    function keithley_close_pushbox_callback(hObject, eventdata, handles)
        keithley_start = 0;
        close(window2);
        keithley_close = 1;
    end

    %keithley2 Close
    function keithley_close_pushbox_callback2(hObject, eventdata, handles)
        keithley_start2 = 0;
        close(window3);
        keithley_close2 = 1;
    end

    %--------------------------------------------------------------------------
    %--------------------------Main Loop---------------------------------------
    %Initialize variables
    time = 0;
    i = 1;
    meas_temp_history = 30;
    pwm_history = 0;
    debug1_history = 0;
    debug2_history = 0;
    debug3_history = 0;

    %Set up axes
    axes('parent', graph_panel);

    set(0, 'CurrentFigure', window);
    subplot(1, 2, 1);
    graph_1 = plot(time, meas_temp_history);
    set(gca, 'FontSize', fontsize);
    ylabel('Temperature (°C)', 'FontSize', fontsize);
    subplot(1, 2, 2);
    graph_2 = plot(time, pwm_history);
    set(gca, 'FontSize', fontsize);
    ylabel('PWM', 'FontSize', fontsize);

    while (1)
        set(graph_1, 'XData', time);
        set(graph_1, 'YData', meas_temp_history);
        set(graph_2, 'XData', time);
        set(graph_2, 'YData', pwm_history);

        refreshdata;
        drawnow;

        if (exit == 1)
            close all;
            return;
        end

        if (port_flag)
            %Send P, I, D to the Arduino
            fwrite(port, start);
            fwrite(port, p_value);
            fwrite(port, i_value);
            fwrite(port, d_value);

            %Write the last entry in temperature history
            fwrite(port, set_temp_history(end));

            %Read the available bytes in the buffer
            status = get(port, {'BytesAvailable'});

            %read_temp is a 1x1 cell array
            %Loop until measured temperature is available
            while ~status{1, 1}
                status = get(port, {'BytesAvailable'});
                pause(0.1);
            end

            %Read the temperature and PWM
            meas_temp = fscanf(port, '%f');
            meas_temp_history = [meas_temp_history meas_temp];
            pwm = fscanf(port, '%f');
            pwm_history = [pwm_history pwm];
            time = [time time(end) + 1];

            if (data_table_size ~= 1)
                clear mtable;
            end

            %There is no way to control the scrollbar in uitable. The cursor will move to the first row ever time a now row is
            %added.
            %To work around this, the old version of uitable returns a reference that is used to get the java reference of the
            %table.
            %With the java reference, manually set the cursor selection to be the last row.
            %Note that 'v0' in uitable ports the old version of uitable to the latest version.
            %http://www.mathworks.com/matlabcentral/newsreader/view_thread/165066
            mtable = uitable('v0', window, [rot90(meas_temp_history, 3) rot90(pwm_history, 3)], {'Temp', 'PWM'});
            jtable = mtable.getTable;
            jtable.setRowSelectionAllowed(0);
            jtable.setColumnSelectionAllowed(0);
            jtable.changeSelection(data_table_size, 2 - 1, false, false);
            set(mtable.UIContainer, 'Position', [data_table_pos_x data_table_pos_y data_table_pos_w data_table_pos_h]);
            data_table_size = data_table_size + 1;
        end

        %Keithley
        if (keithley)

            if (keithley_start)
                set(0, 'CurrentFigure', window2);
                fprintf(c, ['smua.source.levelv = ', num2str(Vlevel, 10)]);
                fprintf(c, ['smub.source.levelv = ', num2str(Vlevel, 10)]);

                %fprintf(c,['smua.source.leveli = ',num2str(Ilevel,10)]);

                fprintf(c, 'smua.source.output = smua.OUTPUT_ON');
                fprintf(c, 'smub.source.output = smub.OUTPUT_ON');

                fprintf(c, 'print(smua.measure.i())'); %reads voltage
                fprintf(c, 'print(smua.measure.v())'); %reads current
                fprintf(c, 'print(smua.measure.r())'); %reads resistance

                fprintf(c, 'print(smub.measure.i())'); %reads voltage
                fprintf(c, 'print(smub.measure.v())'); %reads current
                fprintf(c, 'print(smub.measure.r())'); %reads resistance
                axes('parent', keithley_graph_panel_A)

                i1 = fscanf(c); ipos_A(n) = str2double(i1);
                subplot(3, 1, 1);
                plot([1:1:n], ipos_A, 'Marker', 'x'); ylabel('Current [A]');

                v1 = fscanf(c); vpos_A(n) = str2double(v1);
                subplot(3, 1, 2);
                plot([1:1:n], vpos_A, 'Marker', 'x'); ylabel('Voltage [V]');

                r1 = fscanf(c); rpos_A(n) = str2double(r1);
                subplot(3, 1, 3);
                plot([1:1:n], rpos_A, 'Marker', 'x'); ylabel('Resistance [\Omega]');
                axes('parent', keithley_graph_panel_B);

                i1 = fscanf(c); ipos_B(n) = str2double(i1);
                subplot(3, 1, 1);
                plot([1:1:n], ipos_B, 'Marker', 'x'); ylabel('Current [A]');

                v1 = fscanf(c); vpos_B(n) = str2double(v1);
                subplot(3, 1, 2);
                plot([1:1:n], vpos_B, 'Marker', 'x'); ylabel('Voltage [V]');

                r1 = fscanf(c); rpos_B(n) = str2double(r1);
                subplot(3, 1, 3);
                plot([1:1:n], rpos_B, 'Marker', 'x'); ylabel('Resistance [\Omega]');

                fprintf(c, 'smua.source.output = smua.OUTPUT_OFF');
                fprintf(c, 'smub.source.output = smub.OUTPUT_OFF');
                pause(1 / update) %timeout to get stabel current and voltage
                Ilevel = Ilevel;
                %fprintf(c,'beeper.beep(0.1, 453)');
                %

                %There is no way to control the scrollbar in uitable. The cursor will move to the first row ever time a now row is
                %added.
                %To work around this, the old version of uitable returns a reference that is used to get the java reference of the
                %table.
                %With the java reference, manually set the cursor selection to be the last row.
                %Note that 'v0' in uitable ports the old version of uitable to the latest version.
                if (keithley_start)
                    keithley_mtable_A = uitable('v0', window2, [rot90(ipos_A, 3) rot90(vpos_A, 3) rot90(rpos_A, 3)], {'Current',
                                                                                                                   'Voltage', 'Resistance'});
                    keithley_jtable_A = keithley_mtable_A.getTable;
                    keithley_jtable_A.setRowSelectionAllowed(0);
                    keithley_jtable_A.setColumnSelectionAllowed(0);
                    keithley_jtable_A.changeSelection(keithley_data_table_size, 3 - 1, false, false);
                    set(keithley_mtable_A.UIContainer, 'Position', [keithley_data_table_pos_x keithley_data_table_pos_y
                                                          keithley_data_table_pos_w keithley_data_table_pos_h]);

                    keithley_data_table_size = keithley_data_table_size + 1;
                end

                if (keithley_start)
                    keithley_mtable_B = uitable('v0', window2, [rot90(ipos_B, 3) rot90(vpos_B, 3) rot90(rpos_B, 3)], {'Current',
                                                                                                                   'Voltage', 'Resistance'});
                    keithley_jtable_B = keithley_mtable_B.getTable;
                    keithley_jtable_B.setRowSelectionAllowed(0);
                    keithley_jtable_B.setColumnSelectionAllowed(0);
                    keithley_jtable_B.changeSelection(keithley_data_table_size, 3 - 1, false, false);
                    set(keithley_mtable_B.UIContainer, 'Position', [keithley_data_table_pos_x 0 keithley_data_table_pos_w
                                                          keithley_data_table_pos_h]);
                    keithley_data_table_size = keithley_data_table_size + 1;
                end

                n = n + 1;
            end

        end

        %keithley2
        if (keithley2)

            if (keithley_start2)
                set(0, 'CurrentFigure', window3);
                fprintf(c2, ['smua.source.levelv = ', num2str(Vlevel2, 10)]);
                fprintf(c2, ['smub.source.levelv = ', num2str(Vlevel2, 10)]);

                %fprintf(c2,['smua.source.leveli = ',num2str(Ilevel2,10)]);

                fprintf(c2, 'smua.source.output = smua.OUTPUT_ON');
                fprintf(c2, 'smub.source.output = smub.OUTPUT_ON');

                fprintf(c2, 'print(smua.measure.i())'); %reads voltage
                fprintf(c2, 'print(smua.measure.v())'); %reads current
                fprintf(c2, 'print(smua.measure.r())'); %reads resistance
                fprintf(c2, 'print(smub.measure.i())'); %reads voltage
                fprintf(c2, 'print(smub.measure.v())'); %reads current
                fprintf(c2, 'print(smub.measure.r())'); %reads resistance

                axes('parent', keithley_graph_panel_A2);

                i1 = fscanf(c2); ipos_A2(n2) = str2double(i1);
                subplot(3, 1, 1);
                plot([1:1:n2], ipos_A2, 'Marker', 'x'); ylabel('Current [A]');

                v1 = fscanf(c2); vpos_A2(n2) = str2double(v1);
                subplot(3, 1, 2);
                plot([1:1:n2], vpos_A2, 'Marker', 'x'); ylabel('Voltage [V]');

                r1 = fscanf(c2); rpos_A2(n2) = str2double(r1);
                subplot(3, 1, 3);
                plot([1:1:n2], rpos_A2, 'Marker', 'x'); ylabel('Resistance [\Omega]');
                axes('parent', keithley_graph_panel_B2);

                i1 = fscanf(c2); ipos_B(n2) = str2double(i1);
                subplot(3, 1, 1);
                plot([1:1:n2], ipos_B, 'Marker', 'x'); ylabel('Current [A]');

                v1 = fscanf(c2); vpos_B(n2) = str2double(v1);
                subplot(3, 1, 2);
                plot([1:1:n2], vpos_B, 'Marker', 'x'); ylabel('Voltage [V]');

                r1 = fscanf(c2); rpos_B(n2) = str2double(r1);
                subplot(3, 1, 3);
                plot([1:1:n2], rpos_B, 'Marker', 'x'); ylabel('Resistance [\Omega]');

                fprintf(c2, 'smua.source.output = smua.OUTPUT_OFF');
                fprintf(c2, 'smub.source.output = smub.OUTPUT_OFF');
                pause(1 / update) %timeout to get stabel current and voltage
                Ilevel2 = Ilevel2;
                %fprintf(c2,'beeper.beep(0.1, 453)');
                %

                %There is no way to control the scrollbar in uitable. The cursor will move to the first row ever time a now row is
                %added.
                %To work around this, the old version of uitable returns a reference that is used to get the java reference of the
                %table.
                %With the java reference, manually set the cursor selection to be the last row.
                %Note that 'v0' in uitable ports the old version of uitable to the latest version.
                if (keithley_start2)
                    keithley_mtable_A2 = uitable('v0', window3, [rot90(ipos_A2, 3) rot90(vpos_A2, 3) rot90(rpos_A2, 3)], {'Current',
                                                                                                                    'Voltage', 'Resistance'});
                    keithley_jtable_A2 = keithley_mtable_A2.getTable;
                    keithley_jtable_A2.setRowSelectionAllowed(0);
                    keithley_jtable_A2.setColumnSelectionAllowed(0);
                    keithley_jtable_A2.changeSelection(keithley_data_table_size2, 3 - 1, false, false);
                    set(keithley_mtable_A2.UIContainer, 'Position', [keithley_data_table_pos_x2 keithley_data_table_pos_y2
                                                           keithley_data_table_pos_w2 keithley_data_table_pos_h2]);
                    keithley_data_table_size2 = keithley_data_table_size2 + 1;
                end

                if (keithley_start2)
                    keithley_mtable_B2 = uitable('v0', window3, [rot90(ipos_B, 3) rot90(vpos_B, 3) rot90(rpos_B, 3)], {'Current',
                                                                                                                 'Voltage', 'Resistance'});
                    keithley_jtable_B2 = keithley_mtable_B2.getTable;
                    keithley_jtable_B2.setRowSelectionAllowed(0);
                    keithley_jtable_B2.setColumnSelectionAllowed(0);
                    keithley_jtable_B2.changeSelection(keithley_data_table_size2, 3 - 1, false, false);
                    set(keithley_mtable_B2.UIContainer, 'Position', [keithley_data_table_pos_x2 0 keithley_data_table_pos_w2
                                                           keithley_data_table_pos_h2]);
                    keithley_data_table_size2 = keithley_data_table_size2 + 1;
                end

                n2 = n2 + 1;
            end

        end

        pause(update)
    end

    %--------------------------------------------------------------------------
end
