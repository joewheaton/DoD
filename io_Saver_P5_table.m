
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                        Table Saver
%       for use with Sediment Budget Analysis 2.0 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                      Produced by Joseph Wheaton                %
%                           August 2007                          %
%                                                                %
%                   Last Updated: 02 August 2007                 
%                                                                %
%                                                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%
% This function simply saves a table (for later use) of the elevation
% change distributions based on the Simulation Path chosen by user.

% ASSUMING THAT DATA will be saved IN A NESTED FOLDER WORKING\scenarios:
cd(Dir_Run);
%-------Prouce an Output Report and Metadata File----------------
if(userFilePref == 0)
    [filename,pathname]=uiputfile('*.csv','Save an Output Table to a File');    % Select final file name
    table_file_name=[pathname filename '.csv']; 
else
    table_file_name= strcat(Dir_Run, '/P5DoD_ElevDist.csv');
end    
    
fid20 = fopen(table_file_name, 'w');    %write a file based on user's specificaitons
 
fprintf(fid20,'Upper Elevation Range (m), Lower Elevation Range (m), Gross Total Area (m2), Gross Total Volume (m3), Gross Number of Cells, SU minLoD Total Area (m2), SU minLoD Total Volume (m3), SU minLoD Number of Cells, SC minLoD Total Area (m2), SC minLoD Total Volume (m3), SC minLoD Number of Cells \n');


%Reinitialize Bin LImits
bin_CurrentLow = bin_LowerLimits;
bin_CurrentHigh = bin_LowerLimits+bin_increment;

for m=1:bin_nc;                                                      % Begin category loop
%     fprintf(fid20,'%6.2f,%6.2f,%10.3f,%10.3f,%d,%10.3f,%10.3f,%d,%10.3f\n',  bin_CurrentLow, bin_CurrentHigh, p1_AreaSum(m), p1_VolumeSum(m), p1_ChangeCount(m), p4_AreaSum(m), p4_VolumeSum(m), p4_ChangeCount(m));
    fprintf(fid20,'%6.2f,%6.2f,%10.3f,%10.3f,%d,%10.3f,%10.3f,%d,%10.3f,%10.3f,%d\n',  bin_CurrentLow, bin_CurrentHigh, p1_AreaSum(m), p1_VolumeSum(m), p1_ChangeCount(m), p3_AreaSum(m), p3_VolumeSum(m), p3_ChangeCount(m), p4_AreaSum(m), p4_VolumeSum(m), p4_ChangeCount(m));
    % Update bin intervals at end of category loop
    bin_CurrentLow = bin_CurrentLow+bin_increment;
    bin_CurrentHigh = bin_CurrentHigh+bin_increment;
end  

fclose(fid20);    %close file
