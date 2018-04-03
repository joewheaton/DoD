%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   Parameter Initialisation
%       for use with Sediment Budget Analysis 2.0 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        Produced by Joseph Wheaton & James Brasington           %
%                           December 2004                        %
%                                                                %
%               Last Updated: 28 July 2007                 
%                                                                %
%                                                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%
% This function is intended to read in raster data from an existing ARC ascii file.
% It inherits the variable names from the parent program it is run in.
%
if BatchMode == 0
      % From Folder Management
    Dir_Project = 'NA';
    RunName = 'NA';
    metaD_Desc = 'NA';
    metaD_DateNew =  'NA'; 
	metaD_DateOld =   'NA';
	metaD_MethodNew =  'NA';
	metaD_MethodOld =  'NA';
	metaD_NoteNew =  'NA';
   	metaD_NoteOld =  'NA';
    
    userFilePref = 1;
    
    bin_LowerLimits = -2.5;            % Specify the lower analysis limit
    bin_UpperLimits = 2.5;            % Specify the upper analysis limit
    bin_increment = 0.05;              % Specify the bin size increment
    
    % DoD2
    
    button_Step1a = 'NA';         % 'Existing DoD','From two DEMs'
    button_Step1b = 'NA'; % 'Save DoD and Continue','Save DoD and Quit','Continue without saving DoD'
    button_Step1c = 'NA';             %'Skip','Continue'
    button_Step1d = 'NA';   % 'Simple','More Sophisticated'
    
    button_Step2a = 'NA';   %'Spatially Variable','Spatially Uniform'
    button_Step2b = 'NA';    % 'Load Existing FIS','Create New FIS'
    button_Step2c = 'NA';
    thresholdNew = 0.20;
    thresholdOld = 0.20;
    
    button_Step3a = 'NA';  % 'Do Spatial Coherence Analysis','Skip Spatial Coherence Analysis'
    button_Step3b = 'NA';
    button_Step3c = 'NA';
    button_Step3d = 'NA';
    button_Step3e = 'NA';
    lowe = 15;           
    upe = 25;             
    lowd = 15;           
    upd = 25;             
    
    button_Step5a = 'NA';
    button_Step5b = 'NA';
    button_Step5c = 'NA';
    button_Step5d = 'NA';
    
    % m Uniform Classify
    threshold = 0.20;
    button_Step2c = 'NA';     % 'Do Geomorphic Analysis','Skip'
    
    % m_2DEM_FIS
    button_Step2b_6 = 'NA';      %'Save and Continue','Save and Quit','Help'
    
    % io_Reader_FIS_Inputs
    button_Step2b_1_count0 = 'NA';
    button_Step2b_2_count0 = 'NA';
    button_Step2b_3_count0 = 'NA';
    button_Step2b_4_count0 = 'NA';
    button_Step2b_5_count0 = 'NA';
    button_Step2b_1_count1 = 'NA';
    button_Step2b_2_count1 = 'NA';
    button_Step2b_3_count1 = 'NA';
    button_Step2b_4_count1 = 'NA';
    button_Step2b_5_count1 = 'NA';
    filename_FIS_Slope_count0 = 'NA';
    filename_FIS_PD_count0 = 'NA';
    filename_FIS_Rough_count0 = 'NA';
    filename_FIS_PQ_count0 =  'NA';
    filename_FIS_WetDry_count0 = 'NA';
    filename_FIS_Slope_count1 = 'NA';
    filename_FIS_PD_count1 = 'NA';
    filename_FIS_Rough_count1 = 'NA';
    filename_FIS_PQ_count1 = 'NA';
    filename_FIS_WetDry_count1 = 'NA';
    
    % m_4ThresholdClassifcation
    CI = 0.95;
    button_Step4a = 'NA';    %'Skip','Save thresholded DoDs'
    button_Step4b = 'NA';              %'Skip','Do Analysis'
    button_Step4c = 'NA';              %'Skip','Do Analysis'
    
    
    
    % INPUT FILES
    filename_NewDEM = 'NA';
    filename_OldDEM = 'NA';
    filename_DoD = 'NA';
    
    
    filename_NbrhoodEros = 'NA';
    filename_NbrhoodDepos = 'NA';
    
    filename_FIS_New = 'NA';
    filename_FIS_Old = 'NA';
    
    filename_GeomorphNew = 'NA';
    filename_GeomorphOld = 'NA';  
elseif BatchMode == 1
          % From Folder Management
    Dir_Project = char(Dir_Project_A(mp));
    RunName = char(RunName_A(mp));
    metaD_Desc = char(metaD_Desc_A(mp));
    metaD_DateNew = char(metaD_DateNew_A(mp)); 
	metaD_DateOld = char(metaD_DateOld_A(mp));
	metaD_MethodNew = char(metaD_MethodNew_A(mp));
	metaD_MethodOld = char(metaD_MethodOld_A(mp));
	metaD_NoteNew = char(metaD_NoteNew_A(mp));
   	metaD_NoteOld = char( metaD_NoteOld_A(mp));
    
    userFilePref = 1;
    
    bin_LowerLimits = bin_LowerLimits_A(mp);            % Specify the lower analysis limit
    bin_UpperLimits = bin_UpperLimits_A(mp);            % Specify the upper analysis limit
    bin_increment = bin_increment_A(mp);                  % Specify the bin size increment
    
    % DoD2
    
    
    button_Step1a = char(button_Step1a_A(mp));         % 'Existing DoD','From two DEMs'
    button_Step1b = char(button_Step1b_A(mp)); % 'Save DoD and Continue','Save DoD and Quit','Continue without saving DoD'
    button_Step1c = char(button_Step1c_A(mp));             %'Skip','Continue'
    button_Step1d = char(button_Step1d_A(mp));   % 'Simple','More Sophisticated'
    
    button_Step2a = char(button_Step2a_A(mp));   %'Spatially Variable','Spatially Uniform'
    button_Step2b = char(button_Step2b_A(mp));    % 'Load Existing FIS','Create New FIS'
    button_Step2c = char(button_Step2c_A(mp));
    thresholdNew = thresholdNew_A(mp);
    thresholdOld = thresholdOld_A(mp);
    
    button_Step3a = char(button_Step3a_A(mp));  % 'Do Spatial Coherence Analysis','Skip Spatial Coherence Analysis'
    button_Step3b = char(button_Step3b_A(mp));
    button_Step3c = char(button_Step3c_A(mp));
    button_Step3d = char(button_Step3d_A(mp));
    button_Step3e = char(button_Step3e_A(mp));
    lowe = lowe_A(mp);           % set lower threshold sum value = p = 0
    upe = upe_A(mp);             % define upper threshold sum value = p = 1
    lowd = lowd_A(mp);           % set lower threshold sum value = p = 0
    upd = upd_A(mp);             % define upper threshold sum value = p = 1
    
    button_Step5a = char(button_Step5a_A(mp));
    button_Step5b = char(button_Step5b_A(mp));
    button_Step5c = char(button_Step5c_A(mp));
    button_Step5d = char(button_Step5d_A(mp));
    
    % m Uniform Classify
    threshold = threshold_A(mp);
%     button_Step2c = char(button_Step2c_A(mp));     % 'Do Geomorphic Analysis','Skip'
    
    % m_2DEM_FIS
    button_Step2b_6 = char(button_Step2b_6_A(mp));      %'Save and Continue','Save and Quit','Help'
    
    % io_Reader_FIS_Inputs
    button_Step2b_1_count0 = char(button_Step2b_1_count0_A(mp));
    button_Step2b_2_count0 = char(button_Step2b_2_count0_A(mp));
    button_Step2b_3_count0 = char(button_Step2b_3_count0_A(mp));
    button_Step2b_4_count0 = char(button_Step2b_4_count0_A(mp));
    button_Step2b_5_count0 = char(button_Step2b_5_count0_A(mp));
    button_Step2b_1_count1 = char(button_Step2b_1_count1_A(mp));
    button_Step2b_2_count1 = char(button_Step2b_2_count1_A(mp));
    button_Step2b_3_count1 = char(button_Step2b_3_count1_A(mp));
    button_Step2b_4_count1 = char(button_Step2b_4_count1_A(mp));
    button_Step2b_5_count1 = char(button_Step2b_5_count1_A(mp));
    filename_FIS_Slope_count0 = char(filename_FIS_Slope_count0_A(mp));
    filename_FIS_PD_count0 = char(filename_FIS_PD_count0_A(mp));
    filename_FIS_Rough_count0 = char(filename_FIS_Rough_count0_A(mp));
    filename_FIS_PQ_count0 = char( filename_FIS_PQ_count0_A(mp));
    filename_FIS_WetDry_count0 = char(filename_FIS_WetDry_count0_A(mp));
    filename_FIS_Slope_count1 = char(filename_FIS_Slope_count1_A(mp));
    filename_FIS_PD_count1 = char(filename_FIS_PD_count1_A(mp));
    filename_FIS_Rough_count1 = char(filename_FIS_Rough_count1_A(mp));
    filename_FIS_PQ_count1 = char(filename_FIS_PQ_count1_A(mp));
    filename_FIS_WetDry_count1 = char(filename_FIS_WetDry_count1_A(mp));
    
    % m_4ThresholdClassifcation
    CI = CI_A(mp);
    button_Step4a = char(button_Step4a_A(mp));    %'Skip','Save thresholded DoDs'
    button_Step4b = char(button_Step4b_A(mp));              %'Skip','Do Analysis'
    button_Step4c = char(button_Step4c_A(mp));              %'Skip','Do Analysis'
    
    
    % INPUT FILES
    filename_NewDEM = char(filename_NewDEM_A(mp));
    filename_OldDEM = char(filename_OldDEM_A(mp));
    filename_DoD = char(filename_DoD_A(mp));
    
    filename_NbrhoodEros = char(filename_NbrhoodEros_A(mp));
    filename_NbrhoodDepos = char(filename_NbrhoodDepos_A(mp));
    
    filename_FIS_New = char(filename_FIS_New_A(mp));
    filename_FIS_Old = char(filename_FIS_Old_A(mp));
    
    filename_GeomorphNew = char(filename_GeomorphNew_A(mp));
    filename_GeomorphOld = char(filename_GeomorphOld_A(mp));  
    
end