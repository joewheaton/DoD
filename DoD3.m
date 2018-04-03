%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%------------------- DoD Analysis Beta 3.0 ----------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   Produced by Joseph Wheaton                   %
%                  Copyright (C) 2009 Wheaton                    %
%   Developer can be contacted at Joe.Wheaton@usu.edu or         %
%       Joseph Wheaton                                           %
%       Watershed Sciences                                       %                          
%       Utah State University                                    %
%       5210 Old Main Hill                                       %
%       Logan, UT 84332, USA                                     %
%                                                                %
%   This program is free software; you can redistribute it and/or%
%   modify it under the terms of the GNU General Public License  %
%   as published by the Free Software Foundation; either version %
%   2 of the License, or (at your option) any later version.     %
%                                                                %
%   This program is distributed in the hope that it will be      %
%   useful, but WITHOUT ANY WARRANTY; without even the implied   %
%   warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      %
%   PURPOSE. See the GNU General Public License for more details.%
%                                          	                     %
%   You should have received a copy of the GNU General Public    %
%   License along with this program; if not, write to the Free   %
%   Software Foundation, Inc., 51 Franklin Street, Fifth Floor,  %
%   Boston, MA 02110-1301 USA.                                   %
%                                                                %
%               Last Updated: 01 November, 2009                  %
%                                                                %
%                                                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISIONS

% DoD Analysis 3.0: 01 November 2009
% Cleaned up for distribution and to work in Matlab 7.8 Release 2009a
% This version is working on all pathways tested, but will not be
% maintained from this point forward. This version is being released with
% an ESPL paper so that people can reproduce analyses themselves or tweak 
% the code. The algorithms are being parsed over to an open-source C++
% library, which will be accessible via both a web application and an
% ArcGIS plug-in. See http://www.joewheaton.org for more information.

% DoD Analysis 2.0: 05 August 2007
% Completely redesigned to accommodate 6 different pathways through analyses
% and produce figures, output report and tables.
%
% Sediment Budget 1.1: 28 February 2005
%   Started incorporating changes to FIS into program to allow for the
%   addition of point density as an input. - JMW

% Sediment Budget 1.0: 3 December 2004
%   Fall 2004 AGU results based on this version.
%   FIS only included 4 inputs: point quality, wet/dry, roughness and slope

% REQUIREMENTS:
% -This requires the fuzzy logic toolbox to run a pathway 3 analysis
% -This version was only tested on Matlab 7.8 R2009a


% NOTES:

% Global Variables
DType = 1;  %  DoD Distribution Type: 1 = Gross; 2 = Apriori; 3 = Posterior; 4 = Spatially Uniform (This is a flag exclusively for DoD Distributions)
BatchMode = 0;   % If running in wizard BatchMode = 0 (false), if running in batch mode BatchMode = 1 (true)
numRuns = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-------Introduction----------------------------------------------
    fprintf('Starting DoD Analysis 3.0 BETA \n \n');  

    
    % Determine whether this a batch mode or wizzard mode run
    TheButton = questdlg('Would you like to use the wizard mode or batch mode?',...
        'Mode?','Wizard','Batch','Wizard');
    if strcmp(TheButton,'Wizard')
        BatchMode = 0;
        numRuns = 1;
    elseif strcmp(TheButton,'Batch')
        BatchMode = 1; 
        m_LoadBatchParameters;
        totalBatchTime = 0;
    end
    
    
    
    
    %Message Box
    if(BatchMode == 0)
        h = msgbox('Welcome to DoD Analysis 3.0.  Using a series of dialog boxes, this Wizard will guide you through the steps for analyzing the storage terms for a sediment budget from repeat topographic surveys using the morphological method.','DoD Analysis 3.0','help');
        uiwait(h);
	end
    
% MAIN PROGRAM LOOP
for mp=1:numRuns
%     try,
        tic                                             % Start Timer
        %Sort out All Paramters and Paths %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        m_ParameterInitialisation; 
	
        m_FolderManagement;
        if fMQuitter == 1
            return;    
        end
        if BatchMode == 1
            fprintf('Processing simulation %d of %d batch simulations...\n',mp , numRuns);    
        end
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		%-------STEP 1: Aquire DEM of Diference (DoD)---------------------
        if(BatchMode == 0)
            h = msgbox('In this step, a sediment budget between two digital elevation models of the same area, surveyed at different times is calculated or loaded.','Aquire DEM of Difference','help');
            uiwait(h);
		end
        
        userUnc = 0;    % A boolean to flag whether or not user just calculates DoD (0) or considers uncertainty
        userDoD = 0;    % A boolean to flag whether the DoD has been calculated or loaded in this run (1 = true; 0 = false)
        % Choose method to get data
        if(BatchMode == 0)
            button_Step1a = questdlg('Would you like to load an existing DEM of Difference [DoD] or calculate one from two DEMs?',...
			    'Choose Method','Existing DoD','From two DEMs','Help','From two DEMs');
		end
		if strcmp(button_Step1a,'Existing DoD')
            userDoD = 0;
            io_Reader_DoD                               % Calls up io_Reader_DoD.m, which simply loads file to DoD
            numcells = nx*ny;                           % Number of grid cells
            cellarea = lx^2;
            
            nd_cells=find(DoD == nodata);                   % Find nodata cell addresses in DoD
            DoD_Current = DoD;                              % DoD_Current is required by DoD_Distributions.m
            DoD_Current(nd_cells)=nan;                      % Set no data cell to not a number
            cat_string = strcat('Gross Distribution: ', ' ',metaD_DateNew,'-',metaD_DateOld); 
    	    baseDoDfn = strcat(Dir_Run,'/DoD_Dist_Gross');
                        
            m_BinDistributions;                          % Calls up m_BinDistributions.m and uses settings for rest of program
            if(BatchMode == 0)
                fprintf('Working... I have %u cells to process. Be patient.\n',numcells);
            end
            
            % Do DoD distribution analysis and save results for later
            [p1_totalcut,p1_totalfill,p1_net, p1_totalarea_Cut,p1_totalarea_Fill,...
                    p1_ChangeCount,p1_AreaSum,p1_VolumeSum, p1_lblAreaCut,p1_lblAreaFill,...
                    p1_lblVolCut,p1_lblVolFill,p1_lblVolNet] = f_DoDDist(cat_string,baseDoDfn,DoD_Current,bin_LowerLimits,bin_UpperLimits,bin_increment,bin_nc,cellarea);

            
		elseif strcmp(button_Step1a,'From two DEMs')
            userDoD = 1;
            io_Reader_DEM;                              % Calls up io_Reader_DEM.m, which loads a new DEM to newz and old DEM to oldz
            numcells = nx*ny;                           % Number of grid cells
            cellarea = lx^2;
 
            
            region1=find(newz == nodata);               % Find nodata cells in new DEM
            region2=find(oldz == nodata);               % Find nodata cell in old DEM
            nd_cells=union(region1,region2);            % Take union to account for non-overlapping areas
            newz(nd_cells)=nan;                         % Assign no data cells to not a number
            oldz(nd_cells)=nan;                         % Assign no data cells to not a number
                    
            DoD=newz-oldz;                              % Sediment budget calculation
            DoD_Current = DoD;                          % DoD_Current is required by DoD_Distributions.m       
            DoD(nd_cells)=nan;                          % Set no data cell to not a number
            cat_string = strcat('Gross Distribution: ', ' ',metaD_DateNew,'-',metaD_DateOld); 
	        baseDoDfn = strcat(Dir_Run,'/DoD_Dist_Gross');
            
            m_BinDistributions                           % Calls up m_BinDistributions.m and uses settings for rest of program
            if(BatchMode == 0)
                fprintf('Working... I have %u cells to process. Be patient.\n',numcells);
            end
    
            % Do DoD distribution analysis and save results for later
            [p1_totalcut,p1_totalfill,p1_net, p1_totalarea_Cut,p1_totalarea_Fill,...
                    p1_ChangeCount,p1_AreaSum,p1_VolumeSum, p1_lblAreaCut,p1_lblAreaFill,...
                    p1_lblVolCut,p1_lblVolFill,p1_lblVolNet] = f_DoDDist(cat_string,baseDoDfn,DoD_Current,bin_LowerLimits,bin_UpperLimits,bin_increment,bin_nc,cellarea);

            if(BatchMode == 1)
			    if(gcf == 100)
                    close(100); % Close the second plot if it was made
                end
                close(gcf); % Anyway, just close the first plot
                
			end
        %------ KEEP ELEVATION CHANGE DISTRIBUTION DATA FOR REPORTS -------------
        % Store Results for Final Report (As if m_DoD_Distributions is run
        % again by user in next steps, these arrays are over-written)
        % p1 Stands for Pathway 1 (ignore uncertainty ~ gross budget)
        
        
            if(BatchMode == 0)
                button_Step1b = questdlg('You can save this DoD to an ARC compatible file. We can continue with further analyses or you can quit now. Select one of the following options:',...
			        'Save DoD?','Save DoD and Continue','Save DoD and Quit','Continue without saving DoD','Save DoD and Continue');
            end
		    if strcmp(button_Step1b,'Save DoD and Continue')
                DoD(nd_cells)=nodata;                   % Return no data cells back to original value before saving
                io_Saver_DoD                            % Allows user to save DoD for later use
            elseif strcmp(button_Step1b, 'Save DoD and Quit')
                DoD(nd_cells)=nodata;                   % Return no data cells back to original value before saving
                io_Saver_DoD                            % Allows user to save DoD for later use
                return
            elseif strcmp(button_Step1b, 'Continue without saving DoD')
                disp('As you wish.')
                userDoD = 0;
            end
		elseif strcmp(button_Step1a,'Help')
           disp('Asking for help is the first step to admitting you have a problem. Help is not so helpful in this BETA version.... sorry.')
           h = msgbox('You need to either load an existing DoD or calculate one from scratch. If you calculate one from scratch, make sure the grids are of the same size. This program will end now.','Help','help');
           uiwait(h);
           return
		end
        if(BatchMode == 0)
            button_Step1c = questdlg('You can continue with various types of uncertainty analyses or just skip ahead and report the gross budget. Select one of the following options:',...
                'Consider Uncertainty in DoD?','Continue','Skip','Continue'); 
		end
        if strcmp(button_Step1c,'Continue')
            userUnc = 1;                     
        elseif strcmp(button_Step1c, 'Skip')
            userUnc = 0;
            pathWay = 1;
        end
        
        Dod(nd_cells)= NaN;                          % reset for later analyses
	
        % REPORT TIMING
        elapsed=toc;
        total_elapsed = elapsed;
        if(BatchMode == 0)
            fprintf('DoD step finished. Calculation Time %5.2f [seconds]\n',elapsed);
            fprintf('Total calculation time: %5.2f [seconds]\n',total_elapsed);
        else
            close(gcf);
        end
        elapsed=0;
        
        userComplex = 0;    % A boolean to determine if user takes a simple (0) or more complicated path to considering uncertainty (1)
        if userUnc == 1;
            if(BatchMode == 0)   
                button_Step1d = questdlg('The simplest way to consider uncertainty in a DoD is to just apply an elevation difference threshold. You can do this by clicking on Simple below. However, this program offers a host of more sophisticated techinques as well.',...
                    'How do you want to proceed with uncertainty analysis?','Simple','More Sophisticated','More Sophisticated');
            end
            if strcmp(button_Step1d,'Simple')
                userComplex = 0;
                m_UniformClassify;
                pathWay = 2;
                % NOW SKIP AHEAD TO FINAL STEP 6  (Output Report)
		
            elseif strcmp(button_Step1d,'More Sophisticated')
				userComplex = 1;
				%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
				%-------STEP 2: DEM Uncertainty Representation Technique -----------
                        % Intro
                        if(BatchMode == 0)
                            h = msgbox('There are various ways to consider how DEM uncertainty propagates into a DoD. This program allows you to choose between a standard spatially uniform model of DEM uncertainty versus a spatially variable model estimated from a fuzzy logic inference system. In both cases, DEM uncertainty in an individual DEM surface representation is estimated. The fuzzy rule system can be modified based on empirical data and or expert knowledge. In this version, five spatially variable types of data which influence uncertainty are considered: roughness, slope, instrument recorded point quality and whether the surface is subaqueous or dry.','Uncertainty in Individual DEMs','help');
                            uiwait(h);
                        end
				
                        userFIS = 0;     % A boolian to flag whether the FIS has been run (1 = true; 0 = false)
                        FIScount = 0;    % If 0, new FIS, if 1 old FIS
                        % Choose method to get data
                        if(BatchMode == 0)
                            button_Step2a = questdlg('Here you need to decide whether you want to consider a spatially variable uncertainty in DEMs  or a spatially uniform uncertainty. The spatially variable model uses a fuzzy inference system.',...
							    'Step 2 of 6: Choose DEM Uncertainty Representation Technique:','Spatially Variable','Spatially Uniform','Spatially Variable');
                        end
                        if strcmp(button_Step2a,'Spatially Variable');
                            if(BatchMode == 0)
                                button_Step2b = questdlg('If you have already prepared FIS surfaces, you can load them; otherwise you can create new FIS surfaces.',...
                                    'Load or Calculate an FIS:','Load Existing FIS','Create New FIS','Load Existing FIS');
                            end
                            if strcmp(button_Step2b,'Load Existing FIS')
                                userFIS = 1;
                                io_Reader_FIS_DEM;                      % Calls up io_Reader_FIS_DEM.m which simply loads data required in later steps
                                
                            elseif strcmp(button_Step2b, 'Create New FIS');
                                userFIS = 1;
                                tic;
                                m_2DEM_FIS;                             % Calls up m_2DEM_FIS.m to produce the data for the first surface
                                newzqual = UncGrid_FIS;                 % Stores calculation for use later by DoD_Uncertainty.m
                                clear UncGrid_FIS;                      % Clears this variable so 2DEM_FIS can run again.
                                
                                if(BatchMode == 0)
                                    h = msgbox('Congratulations, you produced the uncertainty grid for the newer DEM. You now need to repeat the process for the older DEM.','Just to explain what is going on:','help');
                                    uiwait(h);
                                end
                                
                                FIScount =1;
                                m_2DEM_FIS;                             % Calls up m_2DEM_FIS.m to produce the data for the second surface
                                oldzqual = UncGrid_FIS;                 % Stores calculation for use later by DoD_Uncertainty.m
                                clear UncGrid_FIS;                      % Clears this variable so 2DEM_FIS can run again.
                                
                                
                                 % REPORT TIMING
                                elapsed=toc;
                                total_elapsed = elapsed+total_elapsed;
                                if(BatchMode == 0)
                                    fprintf('Individual DEM Uncertainty Step Finished. Calculation Time %5.2f [seconds]\n',elapsed);
                                    fprintf('Total calculation time: %5.2f [seconds]\n',total_elapsed);  
                                end
                                elapsed=0;
                            end
                        elseif strcmp(button_Step2a, 'Spatially Uniform');
                            userFIS = 0;
                            % THEN SET UP SPATILALY UNIFORM ANALYSIS!
                            if(BatchMode == 0)
                                prompt = {strcat('For ',metaD_DateNew,' DEM, [+/- meters]'),strcat('For ',metaD_DateOld,' DEM, [+/- meters]')};    
		%                         prompt = {'For More Recent DEM, [+/- meters]','For Older DEM, [+/- meters]'};
                                dlg_title = 'Define spatially uniform elevation uncertainties.';
                                num_lines= 1;
                                def     = {'0.20','0.20'};
                                answer  = inputdlg(prompt,dlg_title,num_lines,def);
							
                                thresholdNew = str2num(answer{1});       % Specify the lower analysis limit for New DEM
                                thresholdOld = str2num(answer{2});       % Specify the lower analysis limit for Old DEM
                            end
                            
                            % Create and populate threshold grids for use in  m_3SpatialCohenrence.m
                            oldzqual = ones(nx,ny);
                            newzqual = ones(nx,ny);
                            oldzqual(nd_cells) = NaN;
                            newzqual(nd_cells) = NaN;
                            oldzqual = oldzqual.*thresholdOld;
                            newzqual = newzqual.*thresholdNew;
                 
                        end
                        
				
				%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
				%-------STEP 3: Spatial Coherence Bayesian Updating ----------
                        % Intro
                        userBayes = 0;  %  A Boolean to flag whether the Bayesian Updating has been run (1 = true; 0 = false)
                        if(BatchMode == 0)
                            h = msgbox('This part of the program assesses whether the DEM of Difference exhibits spatial coherence in patterns of erosion and deposition. It attempts to recover information from the a priori probabilistic uncertainty surface for the DoD defined by the previous step through applying a spatial neighbourhood filter and Bayes Theorem to update this probabilistic surface.','Step 3 of 6: Spatial Coherence in DoD - Bayesian Updating','help');
                            uiwait(h);
                        
                            button_Step3a = questdlg('Do you want to continue with further analyses or stop the program here?',...
            					'Spatial Coherence in DoD - Bayesian Updating','Do Spatial Coherence Analysis','Skip Spatial Coherence Analysis','Do Spatial Coherence Analysis');
                        end
                        if strcmp(button_Step3a,'Do Spatial Coherence Analysis');
                            userBayes = 1;
                            tic;
                            m_3SpatialCoherence;                          % Calls up m_3SpatialCoherence.m program
                            
                            % REPORT TIMING
                            elapsed=toc;
                            total_elapsed = elapsed+total_elapsed;
                            if(BatchMode == 0)
                                fprintf('Spatial Coherence Step Finished. Calculation Time %5.2f [seconds]\n',elapsed);
                                fprintf('Total calculation time: %5.2f [seconds]\n',total_elapsed);  
                            end
                            elapsed=0;
                            
                            
						elseif strcmp(button_Step3a,'Skip Spatial Coherence Analysis');
                           userBayes = 0;
                        end
				%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
				%-------STEP 4: Apply Threshold ----------------
                       %-----Define Pathways---------
                        % pathways will be based entirely on user inputs
                        % upto this point
                        
						pathWay = 0;   % PathWay will be case switch between six paths, which define various pathways through the program (to determine how to produce report)
						
						if(userUnc == 0)
                            pathWay = 1;    % Ignore Uncertainty
						else
                            if(userComplex == 0)
                                pathWay = 2; % Only Consider Uncertainty in DoD
                            else
                                if(userFIS == 1 & userBayes == 0)
                                    pathWay = 3;    % Consider Uncertainty in DEMs -> Spatially Variable FIS -> Threshold Probabability
                                elseif(userFIS == 1 & userBayes == 1)
                                    pathWay = 4;    % Consider Uncertainty in DEMs -> Spatially Variable FIS -> Bayesian  Neighbourhood -> Threshold Probability
                                elseif(userFIS == 0 & userBayes == 1)
                                    pathWay = 5;    % Consider Uncertainty in DEMs -> Spatially Uniform -> Bayesian  Neighbourhood ->  Threshold Probability
                                elseif(userFIS == 0 & userBayes == 0)
                                    pathWay = 6;    % Consider Uncertainty in DEMs -> Spatially Uniform -> Threshold Probability
                                end
                            end
						end        
                
                
                        % Intro
                        if(BatchMode == 0)
                            h = msgbox('This step applies the minimum level of detection threshold calculated in previous steps to the DoD.','Applying the Thresholds to DoD','help');
                            uiwait(h);
                        end
                        
                        tic
                        
                        m_4ThresholdClassification;
				
                        % REPORT TIMING
                        elapsed=toc;
                        total_elapsed = elapsed+total_elapsed;
                        if(BatchMode == 0)
                            fprintf('Applying Thresholds Step Finished. Calculation Time %5.2f [seconds]\n',elapsed);
                            fprintf('Total calculation time: %5.2f [seconds]\n',total_elapsed);  
                        end
                        elapsed=0;
                        
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            end % END OF MORE SOPHISTICATED BLOCK FROM STEP 1
        end % END OF NON UNCERTAINTY FROM STEP 1
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		%-------STEP 5: Geomorphic Interpretation of DoD------------------
            userGeomoprh = 0;   % A boolian to flag whether the geomorphic interpretation has been run (1 = true; 0 = false)
            
            if BatchMode == 0
                button_Step5a = questdlg('If you have classified each survey or the DoD, we can segregate the DoD by these masks to aid in its interpretation.',...
                    'Masking of DoD.','Do Mask Analysis','Skip','Do Mask Analysis');
            end
            if strcmp(button_Step5a,'Do Mask Analysis');
                userGeomorph = 1;
                tic

                fromDoD2 = 1;
                m_5Geomorph;
                            
                if(BatchMode == 1)
				    if(gcf == 100)
                        close(100); % Close the second plot if it was made
                    end
                    close(gcf); % Anyway, just close the first plot
                    
				end
                
% 						%------Geomorphic Analysis based on original DoD--------------------------------------------------
%                         if BatchMode == 0
%                             button_Step5b = questdlg('Do you want to conduct the segregation of the budget based on the geomorphic classification for the Original DoD?',...
%                                 'Step 5 of 6 (a): Geomorphic Interpretation of DoD.','Yes','Skip','Yes');
%                         end
%                         if strcmp(button_Step5b,'Yes');
%                             m_5Geomorph;                                   % Calls up geomorph.m to run geomorphic analyses
%                         end            
		
%                         if(userBayes == 1)
%                             
% 							%------Geomorphic Analysis based on a Priori DoD--------------------------------------------------
%                             if BatchMode == 0
%                                 button_Step5c = questdlg('Do you want to conduct the segregation of the budget based on the geomorphic classification for the a Priori DoD?',...
%                                     'Step 5 of 6 (b): Geomorphic Interpretation of DoD.','Yes','Skip','Yes');
%                             end
%                             if strcmp(button_Step5c,'Yes');
%                                 DoD = prior_DoD;
%                                 m_Geomorph;                                   % Calls up geomorph.m to run geomorphic analyses
%                             end    
% 					
%                       		%------Geomorphic Analysis based on Posterior DoD--------------------------------------------------
%                             if BatchMode == 0
%                                 button_Step5d = questdlg('Do you want to conduct the segregation of the budget based on the geomorphic classification for the Posterior DoD?',...
%                                     'Step 5 of 6 (c): Geomorphic Interpretation of DoD.','Yes','Skip','Yes');
%                             end
%                             if strcmp(button_Step5d,'Yes');
%                                 DoD = post_DoD;
%                                 m_Geomorph;                                   % Calls up geomorph.m to run geomorphic analyses
% 	
%                             end
%                             
%                         end    
                % REPORT TIMING
                elapsed=toc;
                total_elapsed = elapsed+total_elapsed;
                if(BatchMode == 0)
                    fprintf('Budget Segregation Step Finished. Calculation Time %5.2f [seconds]\n',elapsed);
                    fprintf('Total calculation time: %5.2f [seconds]\n',total_elapsed);  
                end
                elapsed=0;
                

            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		%-------STEP 6: Write Output Reports-------------------------------
                % Intro
            
            if(BatchMode == 0)
                h = msgbox('Now that all of the analyses you selected are complete, you can view the DoD and some output reports will be automatically written.','Step 6 of 6: Write Reports','help');
                uiwait(h);
            end
            
            
        %-------Prouce an Output Report and Metadata File----------------
		% REPORT TIMING
		elapsed=toc;
		total_elapsed = elapsed+total_elapsed;
		if(BatchMode == 0)
            fprintf('Total calculation time for %s: %5.2f [seconds]\n',RunName,total_elapsed);
            fprintf('Run %s complete. \n', RunName);
		else
            totalBatchTime = totalBatchTime + (total_elapsed/60);
            fprintf('%s (run %d of %d) is complete.\n',RunName,mp,numRuns);  
            fprintf('Simulation calculation time: %5.2f seconds\n',total_elapsed);   
            if(mp < numRuns)
                fprintf('Total Batch Job Time so far: %8.2f minutes\n\n',totalBatchTime);
            end
            total_elapsed = 0;
        end
	
        m_ReportWriter;
        
%     catch,
%         if BatchMode == 0
%             warndlg('Run ended abnormally!','!! Warning !!')    
%         else
%             fprintf('Run %d ended abnormally!!!, The program will atempt to run the next simulation in the batch file.\n \n',mp);
%         end
%     end
    
end % END MAIN PROGRAM LOOP
if BatchMode == 0
    disp('Program Completed Successfully');
else
    fprintf('Batch Job Completed Successfully in: %5.2f minutes.\n',totalBatchTime);
end

