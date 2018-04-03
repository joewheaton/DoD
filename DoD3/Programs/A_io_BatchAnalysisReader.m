

 % Prompts User to select the most recent DEM file name
[filename, pathname]=uigetfile('*.dat','Load the batch analysis configuration file:');    
filename_Batch=[pathname filename];
clear filename pathname;
% Get Header First then Close
fid1=fopen(filename_Batch,'r');      % opens file to fid in read only mode
AnalysisType =fscanf(fid1,'%s',1);   % Reads first row to determine type
ProjDir = fscanf(fid1,'%s',1);        % Reads second row containing path
fclose(fid1);                        % closes the file
clear fid1;
% Use text read to get rest
[Simulations] = textread(filename_Batch,'%s','headerlines',2,'whitespace', '\n'); 