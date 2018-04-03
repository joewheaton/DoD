%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-------------------DoD Dist Loader  ----------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                      Produced by Joseph Wheaton                %
%                                                                %
%               Last Updated: 27 August, 2007                     %
%                                                                %
%                                                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DESCRIPTION:
% All this program does is load a DoD Distriubtion from a CSV file and save
% it to the correct pathway prefix.

%%%--------CHOOSE THE SIMULATION------------------------------
RootDirectory = pwd;

if(AutoMode == 0)
	if((exist ('Projects')) == 0);
        StartDir = cd('Projects');
	else
        if(indexA == 1)
            StartDir = RootDirectory;
        elseif (indexA > 1)
            cd(Dir_Simulation);
            cd ..;
            StartDir = pwd;
            cd(RootDirectory);
        end
	end
	
	
	Dir_Simulation = uigetdir(StartDir,'Select the simulation that contains the DoD distributions you wish to analyse (typically a sub-directory within the "Simulations" sub-directory of the project):');
else
    Dir_Simulation = fullfile(ProjDir,'Simulations', char(Simulations(indexA)));
end
filename=dir(fullfile(Dir_Simulation,'P*.csv'));

%%%--------FIGURE OUT THE FILE-------------------------------
%[filename, pathname]=uigetfile('*.csv','Select the DoD distribution file to add (csv format)');    
filename_Dist= fullfile(Dir_Simulation, filename.name);


%%%--------SORT OUT THE PATHWAY -----------------------
% See how many collumns are in file:
A = csvread(filename_Dist,1,0);
[r,cols] = size(A);
clear A ;

% Reconstuct the pathWay from name and use number of colluns as a check
pathWay = 0;   

filename = filename.name;

% Now disect the filename
switch filename(1:2);
    case 'P1';
        if(cols == 5)
            pathWay = 1;
        else
           warndlg('Improperly formatted CSV file! Wrong number of columns for pathway 1 (should be 5).','Program closing!');
           return
        end
    case 'P2';
        if(cols == 8)
            pathWay = 2;
        else
           warndlg('Improperly formatted CSV file! Wrong number of columns for pathway 2 (should be 8).','Program closing!');
           return
        end
    case 'P3';
        if(cols == 8)
            pathWay = 3;
        else
           warndlg('Improperly formatted CSV file! Wrong number of columns for pathway 3 (should be 8).','Program closing!');
           return
        end
    case 'P4';
        if(cols == 11)
            pathWay = 4;
        else
           warndlg('Improperly formatted CSV file! Wrong number of columns for pathway 4 (should be 11).','Program closing!');
           return
        end
    case 'P5';
        if(cols == 11)
            pathWay = 5;
        else
           warndlg('Improperly formatted CSV file! Wrong number of columns for pathway 5 (should be 8).','Program closing!');
           return
        end
    case 'P6';
        if(cols == 8)
            pathWay = 6;
        else
           warndlg('Improperly formatted CSV file! Wrong number of columns for pathway 6 (should be 8).','Program closing!');
           return
        end
    otherwise
        warndlg('Improperly formatted CSV file! The filename needs to start with a P1 through P6 prefix to indicate the pathway.','Program closing!');
        return
end


%%%--------ACTUALLY LOAD THE FILE-------------------------------
switch pathWay;
    case 1;
        [bin_CurrentLow, bin_CurrentHigh, p1_AreaSum, p1_VolumeSum, p1_ChangeCount] = textread(filename_Dist, '%6.2f %6.2f %10.3f %10.3f %d','headerlines',1,'delimiter', ',');
    case 2;
        [bin_CurrentLow, bin_CurrentHigh, p1_AreaSum, p1_VolumeSum, p1_ChangeCount, p2_AreaSum, p2_VolumeSum, p2_ChangeCount] = textread(filename_Dist, '%6.2f %6.2f %10.3f %10.3f %d %10.3f %10.3f %d','headerlines',1,'delimiter', ',');
    case 3;
        [bin_CurrentLow, bin_CurrentHigh, p1_AreaSum, p1_VolumeSum, p1_ChangeCount, p3_AreaSum, p3_VolumeSum, p3_ChangeCount] = textread(filename_Dist, '%6.2f %6.2f %10.3f %10.3f %d %10.3f %10.3f %d','headerlines',1,'delimiter', ',');
    case 4;
        [bin_CurrentLow, bin_CurrentHigh, p1_AreaSum, p1_VolumeSum, p1_ChangeCount, p3_AreaSum, p3_VolumeSum, p3_ChangeCount, p4_AreaSum, p4_VolumeSum, p4_ChangeCount] = textread(filename_Dist, '%6.2f %6.2f %10.3f %10.3f %d %10.3f %10.3f %d %10.3f %10.3f %d','headerlines',1,'delimiter', ',');
    case 5;
        [bin_CurrentLow, bin_CurrentHigh, p1_AreaSum, p1_VolumeSum, p1_ChangeCount, p3_AreaSum, p3_VolumeSum, p3_ChangeCount, p4_AreaSum, p4_VolumeSum, p4_ChangeCount] = textread(filename_Dist, '%6.2f %6.2f %10.3f %10.3f %d %10.3f %10.3f %d %10.3f %10.3f %d','headerlines',1,'delimiter', ',');
    case 6;
        [bin_CurrentLow, bin_CurrentHigh, p1_AreaSum, p1_VolumeSum, p1_ChangeCount, p6_AreaSum, p6_VolumeSum, p6_ChangeCount] = textread(filename_Dist, '%6.2f %6.2f %10.3f %10.3f %d %10.3f %10.3f %d','headerlines',1,'delimiter', ',');
end

%%%--------GET NECESSARY PARAMETERS FROM THE BATCH PARAMETER FILE-------------------------------
batchParameter_FileName = fullfile(Dir_Simulation,'BatchParameters.csv');    
[Dir_Project_A, RunName_A, metaD_Desc_A, metaD_DateNew_A, metaD_DateOld_A, metaD_MethodNew_A, metaD_MethodOld_A, metaD_NoteNew_A, metaD_NoteOld_A, userFilePref_A, bin_LowerLimits_A, bin_UpperLimits_A, bin_increment_A, button_Step1a_A, button_Step1b_A, button_Step1c_A, button_Step1d_A, button_Step2a_A, button_Step2b_A, button_Step2c_A, thresholdNew_A, thresholdOld_A, button_Step3a_A, button_Step3b_A, button_Step3c_A, button_Step3d_A, button_Step3e_A, lowe_A, upe_A, lowd_A, upd_A, button_Step5a_A, button_Step5b_A, button_Step5c_A, button_Step5d_A, threshold_A, button_Step2b_6_A, button_Step2b_1_count0_A, button_Step2b_2_count0_A, button_Step2b_3_count0_A, button_Step2b_4_count0_A, button_Step2b_5_count0_A, button_Step2b_1_count1_A, button_Step2b_2_count1_A, button_Step2b_3_count1_A, button_Step2b_4_count1_A, button_Step2b_5_count1_A, filename_FIS_Slope_count0_A, filename_FIS_PD_count0_A, filename_FIS_Rough_count0_A,  filename_FIS_PQ_count0_A, filename_FIS_WetDry_count0_A, filename_FIS_Slope_count1_A, filename_FIS_PD_count1_A, filename_FIS_Rough_count1_A, filename_FIS_PQ_count1_A, filename_FIS_WetDry_count1_A, CI_A, button_Step4a_A, button_Step4b_A, button_Step4c_A, filename_NbrhoodEros_A, filename_NbrhoodDepos_A, filename_FIS_New_A, filename_FIS_Old_A, filename_GeomorphNew_A, filename_GeomorphOld_A, filename_NewDEM_A, filename_OldDEM_A,  filename_DoD_A] = textread(batchParameter_FileName,'%s %s %s %s %s %s %s %s %s %u %f %f %f %s %s %s %s %s %s %s %f %f %s %s %s %s %s %u %u %u %u %s %s %s %s %f %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %f %s %s %s %s %s %s %s %s %s %s %s %s','headerlines',1,'delimiter', ',');  

%%%--------DO GROSS CALCULATIONS -------------------------------

% Do p1 calcs no matter what
        % CALCULATE GROSS EROSION
        p1_AreaCut = sum(p1_AreaSum(1:(r/2)));
        p1_VolCut = sum(p1_VolumeSum(1:(r/2)));
        % CALCULATE GROSS DEPOSITION
        p1_AreaFill = sum(p1_AreaSum(((r/2)+1):r));
        p1_VolFill = sum(p1_VolumeSum(((r/2)+1):r));
        % CALCULATE NET
        p1_NetVol = p1_VolFill - p1_VolCut;
        
        RunName = RunName_A;

switch pathWay;
    case 2;
        % CALCULATE GROSS EROSION
        p2_AreaCut = sum(p2_AreaSum(1:(r/2)));
        p2_VolCut = sum(p2_VolumeSum(1:(r/2)));
        % CALCULATE GROSS DEPOSITION
        p2_AreaFill = sum(p2_AreaSum(((r/2)+1):r));
        p2_VolFill = sum(p2_VolumeSum(((r/2)+1):r));
        % CALCULATE NET
        p2_NetVol = p2_VolFill - p2_VolCut;
        
        % Calculate Percent Loss
        p2_cutAreaLossPct = 100 * (p2_AreaCut/p1_AreaCut);
        p2_fillAreaLossPct = 100 * (p2_AreaFill/p1_AreaFill);
        
        p2_cutLossPct =  100 * (1 -(p2_VolCut/p1_VolCut));
        p2_fillLossPct = 100 * (1 -(p2_VolFill/p1_VolFill));
        p2_netLossPct = 100 * (1 -(p2_NetVol/p1_NetVol));
        
        % THRESHOLD
        p2_Threshold_DoD = threshold_A;
        
    case 3;
        % CALCULATE GROSS EROSION
        p3_AreaCut = sum(p3_AreaSum(1:(r/2)));
        p3_VolCut = sum(p3_VolumeSum(1:(r/2)));
        % CALCULATE GROSS DEPOSITION
        p3_AreaFill = sum(p3_AreaSum(((r/2)+1):r));
        p3_VolFill = sum(p3_VolumeSum(((r/2)+1):r));
        % CALCULATE NET
        p3_NetVol = p3_VolFill - p3_VolCut;
        
        % Calculate Percent Loss
        p3_cutAreaLossPct = 100 * (p3_AreaCut/p1_AreaCut);
        p3_fillAreaLossPct = 100 * (p3_AreaFill/p1_AreaFill);
        
        p3_cutLossPct =  100 * (p3_VolCut/p1_VolCut);
        p3_fillLossPct = 100 * (p3_VolFill/p1_VolFill);
        p3_netLossPct = 100 * (p3_NetVol/p1_NetVol);
        
        % CONFIDENCE INTERVAL
        p3_CI = CI_A;
        
    case 4;
        % CALCULATE GROSS EROSION
        p3_AreaCut = sum(p3_AreaSum(1:(r/2)));
        p3_VolCut = sum(p3_VolumeSum(1:(r/2)));
        
        p4_AreaCut = sum(p4_AreaSum(1:(r/2)));
        p4_VolCut = sum(p4_VolumeSum(1:(r/2)));
        % CALCULATE GROSS DEPOSITION
        p3_AreaFill = sum(p3_AreaSum(((r/2)+1):r));
        p3_VolFill = sum(p3_VolumeSum(((r/2)+1):r));
        
        p4_AreaFill = sum(p4_AreaSum(((r/2)+1):r));
        p4_VolFill = sum(p4_VolumeSum(((r/2)+1):r));
        % CALCULATE NET
        p3_NetVol = p3_VolFill - p3_VolCut;
        p4_NetVol = p4_VolFill - p4_VolCut;
        % Calculate Percent Loss
        p3_cutAreaLossPct = 100 * (p3_AreaCut/p1_AreaCut);
        p3_fillAreaLossPct = 100 * (p3_AreaFill/p1_AreaFill);
        
        p4_cutAreaLossPct = 100 * (p4_AreaCut/p1_AreaCut);
        p4_fillAreaLossPct = 100 * (p4_AreaFill/p1_AreaFill);
        
        p3_cutLossPct =  100 * (p3_VolCut/p1_VolCut);
        p3_fillLossPct = 100 * (p3_VolFill/p1_VolFill);
        p3_netLossPct = 100 * (p3_NetVol/p1_NetVol);
        
        p4_cutLossPct =  100 * (p4_VolCut/p1_VolCut);
        p4_fillLossPct = 100 * (p4_VolFill/p1_VolFill);
        p4_netLossPct = 100 * (p4_NetVol/p1_NetVol);
        
        % CONFIDENCE INTERVAL
        p4_CI = CI_A;
        p4_lowe = lowe_A;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
        p4_upe = upe_A;             
        p4_lowd = lowd_A;           
        p4_upd = upd_A; 
        
    case 5;
        % CALCULATE GROSS EROSION
        p3_AreaCut = sum(p3_AreaSum(1:(r/2)));
        p3_VolCut = sum(p3_VolumeSum(1:(r/2)));
        
        p4_AreaCut = sum(p4_AreaSum(1:(r/2)));
        p4_VolCut = sum(p4_VolumeSum(1:(r/2)));
        % CALCULATE GROSS DEPOSITION
        p3_AreaFill = sum(p3_AreaSum(((r/2)+1):r));
        p3_VolFill = sum(p3_VolumeSum(((r/2)+1):r));
        
        p4_AreaFill = sum(p4_AreaSum(((r/2)+1):r));
        p4_VolFill = sum(p4_VolumeSum(((r/2)+1):r));
        % CALCULATE NET
        p3_NetVol = p3_VolFill - p3_VolCut;
        p4_NetVol = p4_VolFill - p4_VolCut;
        % Calculate Percent Loss
        p3_cutAreaLossPct = 100 * (p3_AreaCut/p1_AreaCut);
        p3_fillAreaLossPct = 100 * (p3_AreaFill/p1_AreaFill);
        
        p4_cutAreaLossPct = 100 * (p4_AreaCut/p1_AreaCut);
        p4_fillAreaLossPct = 100 * (p4_AreaFill/p1_AreaFill);
        
        p3_cutLossPct =  100 * (p3_VolCut/p1_VolCut);
        p3_fillLossPct = 100 * (p3_VolFill/p1_VolFill);
        p3_netLossPct = 100 * (p3_NetVol/p1_NetVol);
        
        p4_cutLossPct =  100 * (p4_VolCut/p1_VolCut);
        p4_fillLossPct = 100 * (p4_VolFill/p1_VolFill);
        p4_netLossPct = 100 * (p4_NetVol/p1_NetVol);
        
        % CONFIDENCE INTERVAL
        p4_CI = CI_A;
        p4_lowe = lowe_A;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
        p4_upe = upe_A;             
        p4_lowd = lowd_A;           
        p4_upd = upd_A; 
        
    case 6;
        % CALCULATE GROSS EROSION
        p6_AreaCut = sum(p6_AreaSum(1:(r/2)));
        p6_VolCut = sum(p6_VolumeSum(1:(r/2)));
        % CALCULATE GROSS DEPOSITION
        p6_AreaFill = sum(p6_AreaSum(((r/2)+1):r));
        p6_VolFill = sum(p6_VolumeSum(((r/2)+1):r));
        % CALCULATE NET
        p6_NetVol = p6_VolFill - p6_VolCut;
        
        % Calculate Percent Loss
        p6_cutAreaLossPct = 100 * (p6_AreaCut/p1_AreaCut);
        p6_fillAreaLossPct = 100 * (p6_AreaFill/p1_AreaFill);
        
        p6_cutLossPct =  100 * (p6_VolCut/p1_VolCut);
        p6_fillLossPct = 100 * (p6_VolFill/p1_VolFill);
        p6_netLossPct = 100 * (p6_NetVol/p1_NetVol);
        
        % CONFIDENCE INTERVAL
        p6_CI = CI_A;
        p6_thresholdNew = thresholdNew_A;
        p6_thresholdOld = thresholdOld_A;
end

%%%-------SORT OUT SIMULATION NAME--------------------
[pathstr,name,ext,versn] = fileparts(filename_Dist);

[pathA, numP] = explode(pathstr,'/');   % NOTE use of explode function (downloaded from Matlab site)!
simName = char(pathA(numP));
simType = name;


% CLEAR ALL GARBAGE
clear pathstr name ext versn path numP;
clear Dir_Project_A RunName_A metaD_Desc_A metaD_DateNew_A metaD_DateOld_A; 
clear metaD_MethodNew_A metaD_MethodOld_A metaD_NoteNew_A metaD_NoteOld_A;
clear userFilePref_A bin_LowerLimits_A bin_UpperLimits_A bin_increment_A;
clear button_Step1a_A button_Step1b_A button_Step1c_A button_Step1d_A button_Step2a_A; 
clear button_Step2b_A button_Step2c_A thresholdNew_A thresholdOld_A button_Step3a_A; 
clear button_Step3b_A button_Step3c_A button_Step3d_A button_Step3e_A lowe_A upe_A;
clear lowd_A upd_A button_Step5a_A button_Step5b_A button_Step5c_A button_Step5d_A;
clear threshold_A button_Step2b_6_A button_Step2b_1_count0_A button_Step2b_2_count0_A;
clear button_Step2b_3_count0_A button_Step2b_4_count0_A button_Step2b_5_count0_A;
clear button_Step2b_1_count1_A button_Step2b_2_count1_A button_Step2b_3_count1_A;
clear button_Step2b_4_count1_A button_Step2b_5_count1_A filename_FIS_Slope_count0_A;
clear filename_FIS_PD_count0_A filename_FIS_Rough_count0_A  filename_FIS_PQ_count0_A;
clear filename_FIS_WetDry_count0_A filename_FIS_Slope_count1_A filename_FIS_PD_count1_A;
clear filename_FIS_Rough_count1_A filename_FIS_PQ_count1_A filename_FIS_WetDry_count1_A;
clear CI_A button_Step4a_A button_Step4b_A button_Step4c_A filename_NbrhoodEros_A;
clear filename_NbrhoodDepos_A filename_FIS_New_A filename_FIS_Old_A filename_GeomorphNew_A;
clear filename_GeomorphOld_A filename_NewDEM_A filename_OldDEM_A  filename_DoD_A;  



cd(RootDirectory);

fprintf('%s Loaded and analysed!\n',simName);