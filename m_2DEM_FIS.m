%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       FUZZY INFERENCE SYSTEM for individual DEMs
%       for use with Sediment Budget Analysis 2.0 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        Produced by Joseph Wheaton & James Brasington           %
%                           December 2004                        %
%                                                                %
%               Last Updated: 2 August 2007                      %
%                                                                %
%                                                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%
% This script uses a fuzzy inference system to estimate spatially variable
% elevation uncertainties in an individual DEM. It can run as a stand alone
% or be called up from SedimentBudget_1.m, which also propagates 
% elevation uncertainties from two indivdual DEMs (the outputs of
% this program) and calculates the resulting elevation uncertainty 
% in a DEM of Diference calculation.
%
% User Inputs: two different ARC ascii DEMs
% Parameters:  
% Outputs:     
%
% Created by Joe Wheaton and James Brasington
% on 30 November 2004
% Last Updated: 30 November 2004

% REVISIONS
% Sediment Budget 1.0: 3 December 2004
%   Fall 2004 AGU results based on this version.
%   FIS only included 4 inputs: point quality, wet/dry, roughness and slope

% Sediment Budget 1.1: 28 February 2005
%   Started incorporating changes to FIS into program to allow for the
%   addition of point density as an input. - JMW

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Initialise User Switches
userFIS_Rough = 0;      % Boolean to flag up whehter or not this sort of FIS input was used
userFIS_Slope = 0;
userFIS_3DQ = 0;
userFIS_WetDry = 0;
userFIS_PD = 0;
FIStype = 'ZFIS_PD_SLP_PQ.fis';


    if(BatchMode == 0)
        fprintf('Beginning DEM Uncertainty Calculations\n \n');  
	end
%    tic
    io_Reader_FIS_Inputs;                       % Loads FIS inputs
    
% Call up the *.fis file produced from the fuzzy logic toolbox
    % This will only run if the Fuzzy Logic Toolbox is loaded
    % The fuzzy rule system can be modified using the toolbox
	a = readfis(FIStype);  
    
% --------Evaluate the inputs using the fuzzy inference system------------

% Initialize Grid
    
    UncGrid_FIS = zeros(nx,ny);   % The actual uncertainty surface based on FIS
    numcells = nx*ny;             % This constant is the number of cells in grid
    changedcells = 0;               % This counter counts the number of cells that have changed
    
    i=0;
    j=0;
% New Vectorized Code to perform FIS Calculations

% Asign NAN to nodata cells in each grid

    if(userFIS_Rough == 1)
        roughnessdata = find(roughness ~= nodata);
        roughnessnodata = find(roughness == nodata);
        roughness(roughnessnodata) = nan;
	end
    if(userFIS_3DQ == 1)
        pointqualitydata = find(pointquality ~= nodata);
        pointqualitynodata = find(pointquality == nodata);
        pointquality(pointqualitynodata) = nan;
	end
    if(userFIS_WetDry == 1)
        wetdrydata = find(wetdry ~= nodata);
        wetdrynodata = find(wetdry == nodata);
        wetdry(wetdrynodata) = nan;
	end
    % ALWAYS LOAD SLOPE AND DENSITY DATA
    slopedata = find(slope ~= nodata);
    slopenodata = find(slope == nodata);
    slope(slopenodata) = nan;
    
    densitydata = find(density ~= nodata);
    densitynodata = find(density == nodata);
    denisty(densitynodata) = nan;
    
    switch FIStype
        case 'DEM_FIS_v2.fis'
            % Make sure there is no calculation for any cell without data
            nodata_cells = union((union((union(slopenodata,wetdrynodata)),(union(pointqualitynodata,roughnessnodata)))), densitynodata);
            data_cells = intersect((intersect((intersect(slopedata,wetdrydata)),(intersect(pointqualitydata,roughnessdata)))), densitydata);
           
            UncGrid_FIS = zeros(nx,ny);
            
            % FIS calculation 
            UncGrid_FIS(data_cells)=evalfis([wetdry(data_cells) roughness(data_cells) pointquality(data_cells) slope(data_cells) density(data_cells)], a);   
            UncGrid_FIS(nodata_cells)= NaN;
 
        case 'ZFIS_PD_SLP.fis'
            % Make sure there is no calculation for any cell without data
            nodata_cells = union(slopenodata,densitynodata);
            data_cells = intersect(slopedata,densitydata);
           
            UncGrid_FIS = zeros(nx,ny);
            
            % FIS calculation 
            UncGrid_FIS(data_cells)=evalfis([slope(data_cells) density(data_cells)], a);   
            UncGrid_FIS(nodata_cells)= NaN;
        case 'ZFIS_PD_SLP_PQ.fis'
            % Make sure there is no calculation for any cell without data
            nodata_cells = union(pointqualitynodata,(union(slopenodata,densitynodata)));
            data_cells = intersect(pointqualitydata,(intersect(slopedata,densitydata)));
           
            UncGrid_FIS = zeros(nx,ny);
            
            % FIS calculation 
            UncGrid_FIS(data_cells)=evalfis([pointquality(data_cells) slope(data_cells) density(data_cells)], a);   
            UncGrid_FIS(nodata_cells)= NaN;
    end

       
%------Calculate Basic Stats----------------------------------------------------------    
    statFISGrid = UncGrid_FIS(data_cells);

    meanFIS = mean(statFISGrid);        % Mean of elevation uncertainty
    stdFIS = std(statFISGrid);           % Standard Deviation of elevation uncertainty
    minFIS = min(min(UncGrid_FIS));           % Min of elevation uncertainty
    maxFIS = max(max(UncGrid_FIS));           % Max of elevation uncertainty

    % Revert Back to nodata
    UncGrid_FIS(nodata_cells)= nodata;
%------Write the FIS Uncertainty Surface to an ARC ASCII file format---------------------

    if(BatchMode == 0)
        button_Step2b_6 = questdlg('You can save this FIS uncertainty grid to an ARC compatible file and store a metadata report. We can continue with futher or analyses or you can quit now. Select one of the following options:',...
            'Save FIS?','Save and Continue','Save and Quit','Help','Save and Continue');
	end
    if strcmp(button_Step2b_6,'Save and Continue')
        io_Saver_DEM_FIS;                           % Saves the FIS to an ascii file
    elseif strcmp(button_Step2b_6, 'Save and Quit')
        io_Saver_DEM_FIS;                           % Saves the FIS to an ascii file
        return
    elseif strcmp(button_Step2b_6, 'Help')
       h = msgbox('What could you possibly need help with here? This program will end now just to annoy you.','Help','help');
       uiwait(h);
       return
    end
    
    % clear all the unnecessary stuff
    clear button3 roughnessdata roughnessnodata roughness pointqualitydata pointqualitynodata pointquality;
    clear wetdrydata wetdrynodata wetdrynodata slopedata slopenodata slope;

    
    




