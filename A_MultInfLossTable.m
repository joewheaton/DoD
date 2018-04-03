%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-------------Multiple Information Loss Tables  ----------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                      Produced by Joseph Wheaton                %
%                                                                %
%               Last Updated: 27 August, 2007                     %
%                                                                %
%                                                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DESCRIPTION:
% 

% Determine whether to load files individually or by batch file
A_io_BatchAnalysisReader;
AutoMode = 1;
numSims = length(Simulations); % PW2
% numSims = 4; % PW3


RootDirectory = pwd;
   
% Start making file:
 table_file_name= strcat(RootDirectory, '/InfLossVolTable_RenameMe.csv');
 table_file_name2= strcat(RootDirectory, '/InfLossAreaTable_RenameMe.csv');

    
fid20 = fopen(table_file_name, 'w');    %write a file based on user's specificaitons
% fid40 = fopen(table_file_name2, 'w');

fprintf(fid20,'Simulation Name, Simulation Type, PW1 Erosion, PW1 Depostion, PW1 Net, PW2 Erosion, PW2 Depostion, PW2 Net, PW1toPW2 Erosion PCTLoss, PW1toPW2 Deposition PCTLoss, PW1toPW2 Net PCTLoss, PW3 Erosion, PW3 Depostion, PW3 Net, PW1toPW3 Erosion PCTLoss, PW1toPW3 Deposition PCTLoss, PW1toPW3 Net PCTLoss, PW4 Erosion, PW4 Depostion, PW4 Net, PW1toPW4 Erosion PCTLoss, PW1toPW4 Deposition PCTLoss, PW1toPW4 Net PCTLoss, PW5 Erosion, PW5 Depostion, PW5 Net, PW1toPW5 Erosion PCTLoss, PW1toPW5 Deposition PCTLoss, PW1toPW5 Net PCTLoss, PW6 Erosion, PW6 Depostion, PW6 Net, PW1toPW6 Erosion PCTLoss, PW1toPW6 Deposition PCTLoss, PW1toPW6 Net PCTLoss \n');





for k=1:numSims;
    indexA = k;
	
       
    A_io_LoadDist;              % Load up DoD Dist 
    
    simNames_A(indexA) = cellstr(simName);
    simTypes_A(indexA) = cellstr(simType);
       
    %%%--------WORK UP PLOT  -----------------------
% 	set(gcf,'position',[50 100 700 500]);
	
	switch pathWay;
        case 1
			fprintf(fid20,'%s, %s, %10.3f, %10.3f, %10.3f, -, -, -, -, -, -, -, -, -, -, -, -, -, -, -, -, -, -, -, -, -, -, -, -, -, -, -, -, -, - \n', simName, simType, p1_VolCut, p1_VolFill, p1_NetVol);

        case 2
			fprintf(fid20,'%s, %s, %10.3f, %10.3f, %10.3f, %10.3f, %10.3f, %10.3f, %10.3f, %10.3f, %10.3f, -, -, -, -, -, -, -, -, -, -, -, -, -, -, -, -, -, -, -, -, -, -, -, -\n', simName, simType, p1_VolCut, p1_VolFill, p1_NetVol, p2_VolCut, p2_VolFill, p2_NetVol, p2_cutLossPct, p2_fillLossPct, p2_netLossPct);

			
        case 3
			fprintf(fid20,'%s, %s, %10.3f, %10.3f, %10.3f, -, -, -, -, -, -, %10.3f, %10.3f, %10.3f, %10.3f, %10.3f, %10.3f, -, -, -, -, -, -, -, -, -, -, -, -, -, -, -, -, - \n', simName, simType, p1_VolCut, p1_VolFill, p1_NetVol, p3_VolCut, p3_VolFill, p3_NetVol, p3_cutLossPct, p3_fillLossPct, p3_netLossPct);

        case 4
			fprintf(fid20,'%s, %s, %10.3f, %10.3f, %10.3f, -, -, -, -, -, -, %10.3f, %10.3f, %10.3f, %10.3f, %10.3f, %10.3f, %10.3f, %10.3f, %10.3f, %10.3f, %10.3f, %10.3f, -, -, -, -, -,-, -, -, -, -, -, - \n', simName, simType, p1_VolCut, p1_VolFill, p1_NetVol, p3_VolCut, p3_VolFill, p3_NetVol, p3_cutLossPct, p3_fillLossPct, p3_netLossPct, p4_VolCut, p4_VolFill, p4_NetVol, p4_cutLossPct, p4_fillLossPct, p4_netLossPct);
    
        case 5
			fprintf(fid20,'%s, %s, %10.3f, %10.3f, %10.3f, -, -, -, -, -, -, %10.3f, %10.3f, %10.3f, %10.3f, %10.3f, %10.3f, -, -, -, -, -, -, %10.3f, %10.3f, %10.3f, %10.3f, %10.3f, %10.3f, -, -, -, -, -, - \n', simName, simType, p1_VolCut, p1_VolFill, p1_NetVol, p3_VolCut, p3_VolFill, p3_NetVol, p3_cutLossPct, p3_fillLossPct, p3_netLossPct, p4_VolCut, p4_VolFill, p4_NetVol, p4_cutLossPct, p4_fillLossPct, p4_netLossPct);

        case 6
			fprintf(fid20,'%s, %s, %10.3f, %10.3f, %10.3f, -, -, -, -, -, -, -, -, -, -, -, -,-, -, -, -, -, -,-, -, -, -, -, -, %10.3f, %10.3f, %10.3f, %10.3f, %10.3f, %10.3f \n', simName, simType, p1_VolCut, p1_VolFill, p1_NetVol, p6_VolCut, p6_VolFill, p6_NetVol, p6_cutLossPct, p6_fillLossPct, p6_netLossPct);
            
	end		


 
	
	
end % ENDS FOR LOOP REPEATING PLOT CREATION


fclose(fid20);    %close file




