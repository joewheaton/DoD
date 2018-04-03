%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                    Report Writer
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
% This script writes an output report at the end of DoD_2.
%


%______Visualize the DoD? ____________________-

	if BatchMode == 0
        button = questdlg('Would you like to view the original DEM of Difference?',...
		'Continue Operation','Yes','No','No');
		if strcmp(button,'Yes')
            DoD(nd_cells)= NaN;
            disp('You can modify and save this figure or just close when done.')
            figure;
            imagesc(DoD);axis equal;colorbar;
		elseif strcmp(button,'No')
           disp('Fine. I did not really want to do that anyway.')
		end  
	end


    
%__________________________________________________________________________
% SEDIMENT BUDGET OUTPUT REPORT
    % ASSUMING THAT DATA will be saved IN A NESTED FOLDER WORKING\scenarios:
    cd(Dir_Run);
%______-Produce an Output Report and Metadata File________________
    if(userFilePref == 0)
        [filename,pathname]=uiputfile('*.txt','Save an Output Report and Metadata to a File');    % Select final file name
        Report_file_name=[pathname filename '.txt']; 
    else
        Report_file_name= strcat(Dir_Run, '/DoD_MetaDataReport.txt');
    end    
    when = datestr(now);
    
    fid3 = fopen(Report_file_name, 'w');    %write a file based on user's specificaitons
    if BatchMode == 0
        disp('I am producing your final report');
	end
    %Header Inforamaton

    fprintf(fid3, '__________________DoD (DEM of Difference) Analysis 2.0 Report and Metadata____________________ \n', when);
    fprintf(fid3, '______________________________________________________________________________________________ \n'); 
    fprintf(fid3, '\n');

    fprintf(fid3, 'REPORT TABLE OF CONTENTS  \n');
    fprintf(fid3, '1. ANALYSES PERFORMED  \n');
    fprintf(fid3, '2. USER METADATA  \n');
    fprintf(fid3, '3. INPUT DATA  \n');
    fprintf(fid3, '4. OUTPUT RESULTS  \n');
    fprintf(fid3, '5. TABULAR ELEVATION CHANGE DISTRIBUTIONS OUTPUT  \n');
    fprintf(fid3, '\n');
    fprintf(fid3, '\n');
    fprintf(fid3, '______________________________________________________________________________________________ \n'); fprintf(fid3, '\n');
    fprintf(fid3, '1. ANALYSES PEFORMED:\n');
    fprintf(fid3, 'SIMULATION: %s \n', RunName);
    fprintf(fid3, 'PROJECT: %s \n', Dir_Project);
    fprintf(fid3, '\n');
    fprintf(fid3, 'DEM of Difference between %s and %s \n',metaD_DateNew,metaD_DateOld);
    fprintf(fid3, '\n');

    
    switch pathWay;
        case 1;
            fprintf(fid3, 'This set of analyses followed Pathway 1 (see documentation for explanation). \n');
            fprintf(fid3, '\t Only a basic analysis of the DoD was performed, and no accounting for \n');
            fprintf(fid3, '\t uncertainty was considered. \n');
            fprintf(fid3, '\n');
        case 2;
            fprintf(fid3, 'This set of analyses followed Pathway 2 (see documentation for explanation). \n');
            fprintf(fid3, '\t A basic analysis of the DoD was performed, and the simplest form of accounting \n');
            fprintf(fid3, '\t for uncertainty (using an uniform elevation minimum level of detection threshold) \n');
            fprintf(fid3, '\t was employed.  \n');
            fprintf(fid3, '\n');
        case 3;
            fprintf(fid3, 'This set of analyses followed Pathway 3 (see documentation for explanation). \n');
            fprintf(fid3, '\t A basic analysis of the DoD was performed, and then a more complicated form \n');
            fprintf(fid3, '\t of accounting for uncertainty was employed that considers how spatially variable \n');
            fprintf(fid3, '\t uncertainties in individual DEMs are propagated through into a DoD. These uncertainties \n');
            fprintf(fid3, '\t were estimated using a Fuzzy Inference system. The DoD was then thresholded based on a\n');
            fprintf(fid3, '\t probabilistic confidence interval to produce the final DoD estimate.\n');
            fprintf(fid3, '\n');
        case 4;
            fprintf(fid3, 'This set of analyses followed Pathway 4 (see documentation for explanation). \n');
            fprintf(fid3, '\t A basic analysis of the DoD was performed, and then a more complicated form \n');
            fprintf(fid3, '\t of accounting for uncertainty was employed that considers how spatially variable \n');
            fprintf(fid3, '\t uncertainties in individual DEMs are propagated through into a DoD. These uncertainties \n');
            fprintf(fid3, '\t were estimated using a Fuzzy Inference system. Following this, the spatial coherence of \n');
            fprintf(fid3, '\t patterns of cut and fill was considered. The propagated errors inferred from the FIS  \n');
            fprintf(fid3, '\t were used to estimate an a priori probability of DoD changes being real. Using Bayes \n');
            fprintf(fid3, '\t Theorem, the probability was updated based on the probability of change being real \n');
            fprintf(fid3, '\t from the spatial coherence to provide a final probability of DoD changes being real. \n');
            fprintf(fid3, '\t The DoD was then thresholded based on a probabilistic confidence interval to produce \n');
            fprintf(fid3, '\t the final DoD estimate. \n');
            fprintf(fid3, '\n');
        case 5;
            fprintf(fid3, 'This set of analyses followed Pathway 5 (see documentation for explanation). \n');
            fprintf(fid3, '\t A basic analysis of the DoD was performed, and then a more complicated form \n');
            fprintf(fid3, '\t of accounting for uncertainty was employed that considers how a spatially uniform \n');
            fprintf(fid3, '\t estimate of uncertainties in each individual DEM is propgrated through into a DoD. These\n');
            fprintf(fid3, '\t uncertainties were estimated using user inputs. Following this, the spatial coherence of \n');
            fprintf(fid3, '\t patterns of cut and fill was considered. The propagated errors inferred from the DEMs  \n');
            fprintf(fid3, '\t were used to estimate an a priori probability of DoD changes being real. Using Bayes \n');
            fprintf(fid3, '\t Theorem, the probability was updated based on the probability of change being real \n');
            fprintf(fid3, '\t from the spatial coherence to provide a final probability of DoD changes being real. \n');
            fprintf(fid3, '\t The DoD was then thresholded based on a probabilistic confidence interval to produce \n');
            fprintf(fid3, '\t the final DoD estimate. \n');
            fprintf(fid3, '\n');
        case 6;
            fprintf(fid3, 'This set of analyses followed Pathway 5 (see documentation for explanation). \n');
            fprintf(fid3, '\t A basic analysis of the DoD was performed, and then a more complicated form \n');
            fprintf(fid3, '\t of accounting for uncertainty was employed that considers how a spatially uniform \n');
            fprintf(fid3, '\t estimate of uncertainties in each individual DEM is propgrated through into a DoD. These\n');
            fprintf(fid3, '\t uncertainties were estimated using user inputs. The DoD was then thresholded based on \n');
            fprintf(fid3, '\t a probabilistic confidence interval to produce the final DoD estimate. \n \n');
            fprintf(fid3, '\n');
    end
    
    fprintf(fid3, '\t Date and Time Calculations Performed:, %s \n', when);
    fprintf(fid3, '\t Produced using SedimentBudget_1.m in MatLab.\n');
    fprintf(fid3, '\t Calculations took %6.2f [seconds] to perform.', elapsed);
    fprintf(fid3, '\n');
    fprintf(fid3, '\n');

    % User Entered Metadata
	fprintf(fid3, '______________________________________________________________________________________________ \n'); fprintf(fid3, '\n');    
	fprintf(fid3, '2. USER METADATA: \n');

    fprintf(fid3, 'Description of this set of analysis: \n%s \n', metaD_Desc);
    fprintf(fid3, '\n');
    fprintf(fid3, 'Date of Survey for Newer DEM: %s \n', metaD_DateNew);
    fprintf(fid3, 'Date of Survey for Older DEM: %s \n', metaD_DateOld);
    fprintf(fid3, '\n');
    fprintf(fid3, 'Method of Survey for Newer DEM: %s \n', metaD_MethodNew);
    fprintf(fid3, 'Method of Survey for Older DEM: %s \n', metaD_MethodOld);
    fprintf(fid3, '\n');
    fprintf(fid3, 'User Notes for newer DEM:\n%s \n', metaD_NoteNew);
    fprintf(fid3, 'User Notes for older DEM:\n%s \n', metaD_NoteOld);
    fprintf(fid3, '\n');
    
    % What input files were used
    fprintf(fid3, '______________________________________________________________________________________________ \n'); fprintf(fid3, '\n');
    fprintf(fid3, '3. INPUT DATA: \n');
    if(userDoD == 1)
        fprintf(fid3, 'The newer DEM used was: %s \n', filename_NewDEM);
        fprintf(fid3, 'The older DEM used was: %s \n', filename_OldDEM);        
	else
        fprintf(fid3, 'An existing DoD was loaded from: \n%s \n', filename_DoD); 
	end
    fprintf(fid3, '\n');
    fprintf(fid3, 'The input DEMs had a %6.3f meter grid resolution. %4.2f \n', lx);
    fprintf(fid3, '\n');
    fprintf(fid3, 'Each DEM contained %d rows and %d columns, making for %d grid cells.\n', nx, ny, numcells);
    fprintf(fid3, '\n');
    
    % Output File
    DoD(nd_cells) = nodata;
    numcells = nx*ny;                                          % Total number of cells in the grid
    totalcells = numcells - (length(find(DoD == nodata)));      % Total number of cells with data
    changedcells = length(find(DoD ~= nodata & DoD ~= 0));
    percentchange = (changedcells/totalcells)*100;

    fprintf(fid3, '______________________________________________________________________________________________ \n'); fprintf(fid3, '\n');
    fprintf(fid3, '4. OUTPUT RESULTS:\n');
    if(userDoD == 1)
        fprintf(fid3, 'An ARC compatible ascii DoD output file was written to: \n%s \n', DoD_file_name);
        fprintf(fid3, '\n');
	end
    fprintf(fid3, 'Differences between DEMs were found in %3.2f %% [%d cells] of the %d grid cells with data \n(%d total cells in grid).\n', percentchange, changedcells, totalcells, numcells);
    fprintf(fid3, '\n');       
    
    if(p1_net < 0)
        fprintf(fid3, 'From %s to %s, the gross reach statistics suggest that the reach experienced net degradation. \n', metaD_DateOld, metaD_DateNew);
    elseif(p1_net > 0)
        fprintf(fid3, 'From %s to %s, the gross reach statistics suggest that the reach experienced net aggradation. \n', metaD_DateOld, metaD_DateNew);
    end
    fprintf(fid3, '\n');  

                 
    % Print this no matter what:
    fprintf(fid3, '\t Gross Budget:__________________________________________________________ \n');
	fprintf(fid3, '\t AERIAL RESULT:\n');
	fprintf(fid3, '\t %s \n',p1_lblAreaCut);
	fprintf(fid3, '\t %s \n',p1_lblAreaFill);
	fprintf(fid3, '\n');  
	fprintf(fid3, '\t VOLUMETRIC RESULT:\n');
	fprintf(fid3, '\t %s \n',p1_lblVolCut);
	fprintf(fid3, '\t %s \n',p1_lblVolFill);
	fprintf(fid3, '\t %s \n',p1_lblVolNet);
	fprintf(fid3, '\n');  
    
    if(pathWay ~= 1)
        if(userComplex == 0) % If a simple analysis was performed
            fprintf(fid3, '\t %s:_____________________ \n',p2_lbl);
            fprintf(fid3, 'A minimum level of detection threshold of %s was applied to the DoD and yielded the following:\n',p2_lblThreshold);
			fprintf(fid3, '\t AERIAL RESULT:\n');
			fprintf(fid3, '\t %s (%3.2f %% loss from original)\n',p2_lblAreaCut,p2_cutAreaLossPct);
			fprintf(fid3, '\t %s (%3.2f %% loss from original)\n',p2_lblAreaFill,p2_fillAreaLossPct);
			fprintf(fid3, '\n');  
			fprintf(fid3, '\t VOLUMETRIC RESULT:\n');
			fprintf(fid3, '\t %s (%3.2f %% loss from original)\n',p2_lblVolCut,p2_cutLossPct);
			fprintf(fid3, '\t %s (%3.2f %% loss from original)\n',p2_lblVolFill,p2_fillLossPct);
			fprintf(fid3, '\t %s (%3.2f %% loss from original)\n',p2_lblVolNet,p2_netLossPct);
			fprintf(fid3, '\n');  
                
        elseif(userComplex ==1) % Otherwise..
            if(userFIS)
                spatialVar = 'spatially variable';    
            else
                spatialVar = 'spatially uniform';
            end
            % p3 is produced regardless (Follows paths 3, 4, 5 and 6)
            fprintf(fid3, '\t %s__________________________________________________________ \n',p3_lbl);
            fprintf(fid3, '\t A %s minimum level of detection threshold based on a %s percent confidence interval was applied to \n the DoD and yielded the following:',spatialVar,p3_lblCI);
			fprintf(fid3, '\t AERIAL RESULT:\n');
			fprintf(fid3, '\t %s (%3.2f %% loss from original)\n',p3_lblAreaCut,p3_cutAreaLossPct);
			fprintf(fid3, '\t %s (%3.2f %% loss from original)\n',p3_lblAreaFill,p3_fillAreaLossPct);
			fprintf(fid3, '\n');  
			fprintf(fid3, '\t VOLUMETRIC RESULT:\n');
			fprintf(fid3, '\t %s (%3.2f %% loss from original)\n',p3_lblVolCut,p3_cutLossPct);
			fprintf(fid3, '\t %s (%3.2f %% loss from original)\n',p3_lblVolFill,p3_fillLossPct);
			fprintf(fid3, '\t %s (%3.2f %% loss from original)\n',p3_lblVolNet,p3_netLossPct);
			fprintf(fid3, '\n');     
            
            % p4 is only produced for Bayes paths (paths 4 and 5)
            if(userBayes)
                fprintf(fid3, '\t %s__________________________________________________________ \n',p4_lbl);
                fprintf(fid3, 'A %s minimum level of detection threshold based on a %s percent confidence interval was applied to the DoD and yielded the following:',spatialVar,p4_lblCI);
				fprintf(fid3, '\t AERIAL RESULT:\n');
				fprintf(fid3, '\t %s (%3.2f %% loss from original)\n',p4_lblAreaCut,p4_cutAreaLossPct);
				fprintf(fid3, '\t %s (%3.2f %% loss from original)\n',p4_lblAreaFill,p4_fillAreaLossPct);
				fprintf(fid3, '\n');  
				fprintf(fid3, '\t VOLUMETRIC RESULT:\n');
				fprintf(fid3, '\t %s (%3.2f %% loss from original)\n',p4_lblVolCut,p4_cutLossPct);
				fprintf(fid3, '\t %s (%3.2f %% loss from original)\n',p4_lblVolFill,p4_fillLossPct);
				fprintf(fid3, '\t %s (%3.2f %% loss from original)\n',p4_lblVolNet,p4_netLossPct);
				fprintf(fid3, '\n'); 
            end
        end
    end                    
    
    % Gross Tabular Budget Breakdown
    fprintf(fid3, '______________________________________________________________________________________________ \n'); fprintf(fid3, '\n');
    fprintf(fid3, '5. TABULAR ELEVATION CHANGE DISTRIBUTIONS OUTPUT:\n');

    switch pathWay;
        case 1;
            fprintf(fid3,'\n');
            fprintf(fid3,'Elevation Change     \n');
            fprintf(fid3,'   Low:     High:    Total Area    Total Volume  Number of Cells\n');
            fprintf(fid3,'    [m]      [m]      [m^{2}]        [m^{3}]        [count]  \n');
            fprintf(fid3,'___________________________________________________________________________\n');
           
            %Reinitialize Bin LImits
            bin_CurrentLow = bin_LowerLimits;
            bin_CurrentHigh = bin_LowerLimits+bin_increment;
            
            for m=1:bin_nc;                                                      % Begin category loop
                fprintf(fid3,'%6.2f\t%6.2f\t%10.3f\t%10.3f\t\t%d \n',  bin_CurrentLow, bin_CurrentHigh, p1_AreaSum(m), p1_VolumeSum(m), p1_ChangeCount(m));
	
                % Update bin intervals at end of category loop
                bin_CurrentLow = bin_CurrentLow+bin_increment;
                bin_CurrentHigh = bin_CurrentHigh+bin_increment;
            end
            cd(RootDirectory);
            io_Saver_P1_table;       % Also Save Table to separate file
        case 2;
            fprintf(fid3,'___________________________________________________________________________________________________________________\n');
            fprintf(fid3,'Elevation Change   |                 GROSS DoD                     |        Simple minLoD Thresholded DoD      \n');
            fprintf(fid3,'   Low:     High:  |  Total Area    Total Volume  Number of Cells  |  Total Area    Total Volume  Number of Cells \n');
            fprintf(fid3,'    [m]      [m]   |   [m^{2}]        [m^{3}]        [count]       |   [m^{2}]        [m^{3}]        [count]  \n');
            fprintf(fid3,'___________________________________________________________________________________________________________________ \n');
           
            %Reinitialize Bin LImits
            bin_CurrentLow = bin_LowerLimits;
            bin_CurrentHigh = bin_LowerLimits+bin_increment;
            
            for m=1:bin_nc;                                                      % Begin category loop
                fprintf(fid3,'%6.2f\t%6.2f\t%10.3f\t%10.3f\t%d\t%10.3f\t%10.3f\t%d\n',  bin_CurrentLow, bin_CurrentHigh, p1_AreaSum(m), p1_VolumeSum(m), p1_ChangeCount(m), p2_AreaSum(m), p2_VolumeSum(m), p2_ChangeCount(m));
	
                % Update bin intervals at end of category loop
                bin_CurrentLow = bin_CurrentLow+bin_increment;
                bin_CurrentHigh = bin_CurrentHigh+bin_increment;
            end         
            cd(RootDirectory);
            io_Saver_P2_table;       % Also Save Table to seperate file

        case 3;
            fprintf(fid3,'___________________________________________________________________________________________________________________ \n');
            fprintf(fid3,'Elevation Change   |                 GROSS DoD                     |        FIS minLoD Thresholded DoD      \n');
            fprintf(fid3,'   Low:     High:  |  Total Area    Total Volume  Number of Cells  |  Total Area    Total Volume  Number of Cells \n');
            fprintf(fid3,'    [m]      [m]   |   [m^{2}]        [m^{3}]        [count]       |   [m^{2}]        [m^{3}]        [count]  \n');
            fprintf(fid3,'___________________________________________________________________________________________________________________ \n');
           
            %Reinitialize Bin LImits
            bin_CurrentLow = bin_LowerLimits;
            bin_CurrentHigh = bin_LowerLimits+bin_increment;
            
            for m=1:bin_nc;                                                      % Begin category loop
                fprintf(fid3,'%6.2f\t%6.2f\t%10.3f\t%10.3f\t%d\t%10.3f\t%10.3f\t%d\n',  bin_CurrentLow, bin_CurrentHigh, p1_AreaSum(m), p1_VolumeSum(m), p1_ChangeCount(m), p3_AreaSum(m), p3_VolumeSum(m), p3_ChangeCount(m));
	
                % Update bin intervals at end of category loop
                bin_CurrentLow = bin_CurrentLow+bin_increment;
                bin_CurrentHigh = bin_CurrentHigh+bin_increment;
            end   
            cd(RootDirectory);
            io_Saver_P3_table;       % Also Save Table to seperate file
        case 4;
            fprintf(fid3,'_________________________________________________________________________________________________________________________________________________________________\n');
            fprintf(fid3,'Elevation Change   |                 GROSS DoD                     |        FIS minLoD Thresholded DoD            |    Bayesian Updated minLoD Thresholded DoD      \n');
            fprintf(fid3,'   Low:     High:  |  Total Area    Total Volume  Number of Cells  |  Total Area    Total Volume  Number of Cells |  Total Area    Total Volume  Number of Cells \n');
            fprintf(fid3,'    [m]      [m]   |   [m^{2}]        [m^{3}]        [count]       |   [m^{2}]        [m^{3}]        [count]      |   [m^{2}]        [m^{3}]        [count]  \ \n');
            fprintf(fid3,'_________________________________________________________________________________________________________________________________________________________________\n');
           
            %Reinitialize Bin LImits
            bin_CurrentLow = bin_LowerLimits;
            bin_CurrentHigh = bin_LowerLimits+bin_increment;
            
            for m=1:bin_nc;                                                      % Begin category loop
                fprintf(fid3,'%6.2f\t%6.2f\t%10.3f\t%10.3f\t%d\t%10.3f\t%10.3f\t%d\t%10.3f\t%10.3f\t%d\n',  bin_CurrentLow, bin_CurrentHigh, p1_AreaSum(m), p1_VolumeSum(m), p1_ChangeCount(m), p3_AreaSum(m), p3_VolumeSum(m), p3_ChangeCount(m), p4_AreaSum(m), p4_VolumeSum(m), p4_ChangeCount(m));
	
                % Update bin intervals at end of category loop
                bin_CurrentLow = bin_CurrentLow+bin_increment;
                bin_CurrentHigh = bin_CurrentHigh+bin_increment;
            end    
            cd(RootDirectory);
            io_Saver_P4_table;       % Also Save Table to seperate file
        case 5;
            fprintf(fid3,'_________________________________________________________________________________________________________________________________________________________________\n');
            fprintf(fid3,'Elevation Change   |                 GROSS DoD                     |        SU minLoD Thresholded DoD             |    Bayesian Updated minLoD Thresholded DoD      \n');
            fprintf(fid3,'   Low:     High:  |  Total Area    Total Volume  Number of Cells  |  Total Area    Total Volume  Number of Cells |  Total Area    Total Volume  Number of Cells \n');
            fprintf(fid3,'    [m]      [m]   |   [m^{2}]        [m^{3}]        [count]       |   [m^{2}]        [m^{3}]        [count]      |   [m^{2}]        [m^{3}]        [count]  \ \n');
            fprintf(fid3,'_________________________________________________________________________________________________________________________________________________________________\n');
           
            %Reinitialize Bin LImits
            bin_CurrentLow = bin_LowerLimits;
            bin_CurrentHigh = bin_LowerLimits+bin_increment;
            
            for m=1:bin_nc;                                                      % Begin category loop
                fprintf(fid3,'%6.2f\t%6.2f\t%10.3f\t%10.3f\t%d\t%10.3f\t%10.3f\t%d\t%10.3f\t%10.3f\t%d\n',  bin_CurrentLow, bin_CurrentHigh, p1_AreaSum(m), p1_VolumeSum(m), p1_ChangeCount(m), p3_AreaSum(m), p3_VolumeSum(m), p3_ChangeCount(m), p4_AreaSum(m), p4_VolumeSum(m), p4_ChangeCount(m));
	
                % Update bin intervals at end of category loop
                bin_CurrentLow = bin_CurrentLow+bin_increment;
                bin_CurrentHigh = bin_CurrentHigh+bin_increment;
            end  
            cd(RootDirectory);
            io_Saver_P5_table;       % Also Save Table to seperate file
        case 6;
            fprintf(fid3,'___________________________________________________________________________________________________________________ \n');
            fprintf(fid3,'Elevation Change   |                 GROSS DoD                     |        CI minLoD Thresholded DoD      \n');
            fprintf(fid3,'   Low:     High:  |  Total Area    Total Volume  Number of Cells  |  Total Area    Total Volume  Number of Cells \n');
            fprintf(fid3,'    [m]      [m]   |   [m^{2}]        [m^{3}]        [count]       |   [m^{2}]        [m^{3}]        [count]  \n');
            fprintf(fid3,'___________________________________________________________________________________________________________________ \n');
           
            %Reinitialize Bin LImits
            bin_CurrentLow = bin_LowerLimits;
            bin_CurrentHigh = bin_LowerLimits+bin_increment;
            
            for m=1:bin_nc;                                                      % Begin category loop
                fprintf(fid3,'%6.2f\t%6.2f\t%10.3f\t%10.3f\t%d\t%10.3f\t%10.3f\t%d\n',  bin_CurrentLow, bin_CurrentHigh, p1_AreaSum(m), p1_VolumeSum(m), p1_ChangeCount(m), p3_AreaSum(m), p3_VolumeSum(m), p3_ChangeCount(m));
	
                % Update bin intervals at end of category loop
                bin_CurrentLow = bin_CurrentLow+bin_increment;
                bin_CurrentHigh = bin_CurrentHigh+bin_increment;
            end  
            cd(RootDirectory);
            io_Saver_P6_table;       % Also Save Table to separate file
    end

    
  


    fprintf(fid3, '\n');  
    fprintf(fid3, 'End of File\n');  
    
    fclose(fid3);    %close file
    if BatchMode == 0
        disp('Completed report successfully.');
	end
    

%____________________________________________________________________-

% Write Batch Parameterisation File

    Batch_file_name= strcat(Dir_Run, '/BatchParameters.csv');

    


   
    
    fid5 = fopen(Batch_file_name, 'w');    
    fprintf(fid5,'Dir_Project,RunName,metaD_Desc,metaD_DateNew,metaD_DateOld,metaD_MethodNew,metaD_MethodOld,metaD_NoteNew,metaD_NoteOld,userFilePref,bin_LowerLimits,bin_UpperLimits,bin_increment,button_Step1a,button_Step1b,button_Step1c,button_Step1d,button_Step2a,button_Step2b,button_Step2c,thresholdNew,thresholdOld,button_Step3a,button_Step3b,button_Step3c,button_Step3d,button_Step3e,lowe,upe,lowd,upd,button_Step5a,button_Step5b,button_Step5c,button_Step5d,threshold,button_Step2b_6,button_Step2b_1_count0,button_Step2b_2_count0,button_Step2b_3_count0,button_Step2b_4_count0,button_Step2b_5_count0,button_Step2b_1_count1,button_Step2b_2_count1,button_Step2b_3_count1,button_Step2b_4_count1,button_Step2b_5_count1,filename_FIS_Slope_count0,filename_FIS_PD_count0,filename_FIS_Rough_count0,filename_FIS_PQ_count0,filename_FIS_WetDry_count0,filename_FIS_Slope_count1,filename_FIS_PD_count1,filename_FIS_Rough_count1,filename_FIS_PQ_count1,filename_FIS_WetDry_count1,CI,button_Step4a,button_Step4b,button_Step4c,filename_NbrhoodEros,filename_NbrhoodDepos,filename_FIS_New,filename_FIS_Old,filename_GeomorphNew,filename_GeomorphOld, filename_NewDEM, filename_OldDEM,filename_DoD \n');  


fprintf(fid5,'%s,%s,%s,%s,%s,%s,%s,%s,%s,%u,%4.2f,%4.2f,%4.2f,%s,%s,%s,%s,%s,%s,%s,%4.2f,%4.2f,%s,%s,%s,%s,%s,%u,%u,%u,%u,%s,%s,%s,%s,%4.2f,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%4.2f,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n',...
    Dir_Project, RunName, metaD_Desc, metaD_DateNew, metaD_DateOld, metaD_MethodNew, metaD_MethodOld, metaD_NoteNew, metaD_NoteOld, ...
    userFilePref, bin_LowerLimits, bin_UpperLimits, bin_increment, ...
    button_Step1a, button_Step1b, button_Step1c, button_Step1d, button_Step2a, button_Step2b, button_Step2c, ...
    thresholdNew, thresholdOld, ...
    button_Step3a, button_Step3b, button_Step3c, button_Step3d, button_Step3e, ...
    lowe, upe, lowd, upd, ...
    button_Step5a, button_Step5b, button_Step5c, button_Step5d, ...
    threshold, ...
    button_Step2b_6, button_Step2b_1_count0, button_Step2b_2_count0, button_Step2b_3_count0, ...
    button_Step2b_4_count0, button_Step2b_5_count0, button_Step2b_1_count1, button_Step2b_2_count1, ...
    button_Step2b_3_count1, button_Step2b_4_count1, button_Step2b_5_count1, filename_FIS_Slope_count0, ...
    filename_FIS_PD_count0, filename_FIS_Rough_count0,  filename_FIS_PQ_count0, filename_FIS_WetDry_count0, ...
    filename_FIS_Slope_count1, filename_FIS_PD_count1, filename_FIS_Rough_count1, filename_FIS_PQ_count1, ...
    filename_FIS_WetDry_count1, ...
    CI, ...
    button_Step4a, button_Step4b, button_Step4c, filename_NbrhoodEros, filename_NbrhoodDepos, filename_FIS_New, ...
    filename_FIS_Old, filename_GeomorphNew, filename_GeomorphOld, filename_NewDEM, filename_OldDEM,  filename_DoD);  

    
    
    fclose(fid5);    %close file
      
    % RETURN BACK TO ROOT DIRECTORY
    cd(RootDirectory);
    
% end program

