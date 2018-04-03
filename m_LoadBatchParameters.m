%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 Load Batch Parameters
%       for use with Sediment Budget Analysis 2.0 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   Produced by Joseph Wheaton                   %
%                        August 2007                             %
%                                                                %
%               Last Updated: 8 August 2007                 
%                                                                %
%                                                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%
% This program loads 
%




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 

% ASSUMING THAT DATA ARE STORED IN A NESTED FOLDER WORKING\INPUTS:


%------Read in Data -------------------------------------------------

[filename, pathname]=uigetfile('*.csv',strcat('Load your batch configuration file'));    
filename_BatchConfig=[pathname filename];

% TRY OPENING AND CLOSING 
%%% NOTE... Very bizare, for some reason if I try to open a
%%% batchParameters.csv file without having opened it in excel and saved it
%%% or without opening and closing it below, it crashes on reading the data
%%% in on the next command. So yes, this does look unneccesasry, but for
%%% whatever reason fixes my problem...

fid=fopen(filename_BatchConfig,'r'); 
fclose(fid);
    
% [Dir_Project_A, RunName_A, metaD_Desc_A, metaD_DateNew_A, metaD_DateOld_A, metaD_MethodNew_A, metaD_MethodOld_A, metaD_NoteNew_A, metaD_NoteOld_A, userFilePref_A, bin_LowerLimits_A, bin_UpperLimits_A, bin_increment_A, button_Step1a_A, button_Step1b_A, button_Step1c_A, button_Step1d_A, button_Step2a_A, button_Step2b_A, button_Step2c_A, thresholdNew_A, thresholdOld_A, button_Step3a_A, button_Step3b_A, button_Step3c_A, button_Step3d_A, button_Step3e_A, lowe_A, upe_A, lowd_A, upd_A, button_Step5a_A, button_Step5b_A, button_Step5c_A, button_Step5d_A, threshold_A, button_Step2b_6_A, button_Step2b_1_count0_A, button_Step2b_2_count0_A, button_Step2b_3_count0_A, button_Step2b_4_count0_A, button_Step2b_5_count0_A, button_Step2b_1_count1_A, button_Step2b_2_count1_A, button_Step2b_3_count1_A, button_Step2b_4_count1_A, button_Step2b_5_count1_A, filename_FIS_Slope_count0_A, filename_FIS_PD_count0_A, filename_FIS_Rough_count0_A,  filename_FIS_PQ_count0_A, filename_FIS_WetDry_count0_A, filename_FIS_Slope_count1_A, filename_FIS_PD_count1_A, filename_FIS_Rough_count1_A, filename_FIS_PQ_count1_A, filename_FIS_WetDry_count1_A, CI_A, button_Step4a_A, button_Step4b_A, button_Step4c_A, filename_NbrhoodEros_A, filename_NbrhoodDepos_A, filename_FIS_New_A, filename_FIS_Old_A, filename_GeomorphNew_A, filename_GeomorphOld_A, filename_NewDEM_A, filename_OldDEM_A,  filename_DoD_A] = textread(filename_BatchConfig,'%s %s %s %s %s %s %s %s %s %u %4.2f %4.2f %4.2f %s %s %s %s %s %s %s %4.2f %4.2f %s %s %s %s %s %u %u %u %u %s %s %s %s %4.2f %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %4.2f %s %s %s %s %s %s %s %s %s %s %s %s','headerlines',1,'delimiter', ',');  
[Dir_Project_A, RunName_A, metaD_Desc_A, metaD_DateNew_A, metaD_DateOld_A, metaD_MethodNew_A, metaD_MethodOld_A, metaD_NoteNew_A, metaD_NoteOld_A, userFilePref_A, bin_LowerLimits_A, bin_UpperLimits_A, bin_increment_A, button_Step1a_A, button_Step1b_A, button_Step1c_A, button_Step1d_A, button_Step2a_A, button_Step2b_A, button_Step2c_A, thresholdNew_A, thresholdOld_A, button_Step3a_A, button_Step3b_A, button_Step3c_A, button_Step3d_A, button_Step3e_A, lowe_A, upe_A, lowd_A, upd_A, button_Step5a_A, button_Step5b_A, button_Step5c_A, button_Step5d_A, threshold_A, button_Step2b_6_A, button_Step2b_1_count0_A, button_Step2b_2_count0_A, button_Step2b_3_count0_A, button_Step2b_4_count0_A, button_Step2b_5_count0_A, button_Step2b_1_count1_A, button_Step2b_2_count1_A, button_Step2b_3_count1_A, button_Step2b_4_count1_A, button_Step2b_5_count1_A, filename_FIS_Slope_count0_A, filename_FIS_PD_count0_A, filename_FIS_Rough_count0_A,  filename_FIS_PQ_count0_A, filename_FIS_WetDry_count0_A, filename_FIS_Slope_count1_A, filename_FIS_PD_count1_A, filename_FIS_Rough_count1_A, filename_FIS_PQ_count1_A, filename_FIS_WetDry_count1_A, CI_A, button_Step4a_A, button_Step4b_A, button_Step4c_A, filename_NbrhoodEros_A, filename_NbrhoodDepos_A, filename_FIS_New_A, filename_FIS_Old_A, filename_GeomorphNew_A, filename_GeomorphOld_A, filename_NewDEM_A, filename_OldDEM_A,  filename_DoD_A] = textread(filename_BatchConfig,'%s %s %s %s %s %s %s %s %s %u %f %f %f %s %s %s %s %s %s %s %f %f %s %s %s %s %s %u %u %u %u %s %s %s %s %f %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %f %s %s %s %s %s %s %s %s %s %s %s %s','headerlines',1,'delimiter', ',');  

    

    
% FIND OUT HOW MANY SIMULATIONS
numRuns = length(Dir_Project_A);

