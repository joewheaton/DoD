%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                      Geomorph Classifier
%       for use with Sediment Budget Analysis 2.0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        Produced by Joseph Wheaton & James Brasington           %
%                                                                %
%               Last Updated: 29 September, 2007                 %
%                                                                %
%                                                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%
% This function reads in geomorphic classification grids and 
% and uses a rule system to determine what category of change has
% resulted from the old to the new grid. It then works in conjunction
% with a DoD calculated elsewhere, to segregate the results by
% these new categories of change. 
%

% REVISIONS
% Sediment Budget 1.0: 3 December 2004
%   Fall 2004 AGU results based on this version.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%------Put everything in a Geomorph Folder -------------------------------------
% Within Run, check to see if Output_Rasters Folder already Exists
cd (Dir_Run);
if((exist ('Geomorph')) == 0);
    mkdir 'Geomorph';
end
Dir_Geomorph = strcat(Dir_Run,'/Geomorph');

%------Assign name and place for this set of geomorphic analyses-----------------

if(BatchMode == 0)
    prompt = {'Enter a title for this set of geomorphic analyses:'};    
    dlg_title = 'Geomorphic Analysis Name';
    num_lines= 1;
    def     = {'CoD_A'};
    answer  = inputdlg(prompt,dlg_title,num_lines,def);

    gSimName = answer{1};       
end
    Dir_GSim = strcat(Dir_Geomorph,'/',gSimName);
    cd (Dir_Geomorph);
	if((exist(gSimName,'dir')) == 0);
        mkdir (gSimName);
	end

cd(RootDirectory);

%------Choose what type of mask to apply -------------------------------------

if BatchMode == 0
    button_StepGType = questdlg('You can either apply a classification of difference analysis (CoD) or simple mask analaysis.',...
        'Choose Type of Geomorphic Segregation:','CoD','Mask','Mask');
end
if strcmp(button_StepGType,'Mask');
    GType = 'Mask';
elseif strcmp(button_StepGType,'CoD');
    GType = 'CoD';
end    

% Load Masks
io_Reader_Geomorph;

%Define Categories
m_5Geomorph_Classes;
        
%------Choose what Dod to apply  mask to-------------------------------------
    % pathWay will either be defined in DoD_2.m or loaded from batch file
	
%     if BatchMode == 0
%         button_Step5b = questdlg('You can run the geomorphic analysis on the original unthresholded DoD, on the thresholded DoD or on both.',...
%             'Choose what DoD to segregate.','Unthresholded DoD','Thresholded DoD','Both');
% 	end
    
if (fromDoD2 == 1)
	switch pathWay;
        case 1
            DoD_Current = DoD;
        case 2
		    DoD_Current = uniform_DoD;
        case 3
            DoD_Current = prior_DoD;
        case 4
            DoD_Current = post_DoD;
        case 5
            DoD_Current = post_DoD;
        case 6
            DoD_Current = prior_DoD;
	end	
end

% Do suite of analyses
m_5Geomorph_Analysis;

   
    

   

