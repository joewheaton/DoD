%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-------------------Geomorph Dist Loader  ----------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                      Produced by Joseph Wheaton                %
%                                                                %
%               Last Updated: 5 January, 2008                     %
%                                                                %
%                                                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DESCRIPTION:
% All this program does is load a DoD Distriubtion from a CSV file from the
% geomorph analyses and produce a plot using HistPlot.


RootDirectory = pwd;
%%%--------CHOOSE THE SIMULATION------------------------------
[filename, pathname]=uigetfile('*.csv','Select the DoD distribution file to add (csv format)');    
filename_Dist= fullfile(pathname, filename);

% find out how many rows
% See how many collumns are in file:
A = csvread(filename_Dist,1,0);
[r,cols] = size(A);
clear A ;

%%%-------LOAD THE DATA TO APPROPRIATE PLACE
[bin_CurrentLow, bin_CurrentHigh, p1_AreaSum, p1_VolumeSum, p1_ChangeCount] = textread(filename_Dist, '%6.2f %6.2f %10.3f %10.3f %d','headerlines',1,'delimiter', ',');
   
        
%%%--------DO GROSS CALCULATIONS -------------------------------

% CALCULATE GROSS EROSION
p1_AreaCut = sum(p1_AreaSum(1:(r/2)));
p1_VolCut = sum(p1_VolumeSum(1:(r/2)));
% CALCULATE GROSS DEPOSITION
p1_AreaFill = sum(p1_AreaSum(((r/2)+1):r));
p1_VolFill = sum(p1_VolumeSum(((r/2)+1):r));
% CALCULATE NET
p1_NetVol = p1_VolFill - p1_VolCut;

%%%--------MAKE HISTOGRAM PLOT--------------------------------------------------



%------Set the bin dimensions and increment for analysis-------------  
bin_nc =  length(bin_CurrentHigh);


bin_LowerLimits = bin_CurrentLow(1);            % Specify the lower analysis limit
bin_UpperLimits = bin_CurrentHigh(bin_nc);      % Specify the upper analysis limit
bin_increment = bin_CurrentHigh(2) - bin_CurrentHigh(1);    % Specify the bin size increment

 %------Produce Histogram labels -------------------------

%   Define Axis Labels
binbndycv= zeros((bin_nc+1),1);
midbincv= zeros(bin_nc,1);

% initialise
midbincv(1,1) = bin_LowerLimits + (bin_increment/2);
binbndycv(1,1) = bin_LowerLimits;
binbndycv(bin_nc+1,1) = bin_UpperLimits;
for m=2:bin_nc              % Begin bin label loop (rows)
    binbndycv(m,1)=binbndycv((m-1),1) + bin_increment;
    midbincv(m,1)=midbincv((m-1),1) + bin_increment;
end   

    

   
%%%--------WORK UP PLOT  -----------------------
% 	set(gcf,'position',[50 100 700 500]);


%Sort out labels
lblAreaCut = strcat('Erosion: ', num2str((abs(p1_AreaCut)),'%-10.0f'),' m^{2}');
lblAreaFill= strcat('Deposition: ', num2str(p1_AreaFill,'%-10.0f'),' m^{2}');
lblVolCut = strcat('Erosion: -', num2str((abs(p1_VolCut)),'%-10.0f'),' m^{3}');
lblVolFill = strcat('Deposition: +', num2str(p1_VolFill,'%-10.0f'),' m^{3}');
lblVolNet = strcat('Net:',' ', num2str(p1_NetVol,'%-10.0f'),' m^{3}');
lblTitle = 'NotUSED';

%            type = 1;
%            HistPlot(midbincv,p1_AreaSum,type, ...
%                     bin_LowerLimits, bin_UpperLimits,...
%                     lblAreaCut,lblAreaFill,...
%                     lblVolCut,lblVolFill,lblVolNet,lblTitle);

   type = 2;
   HistPlot(midbincv,p1_VolumeSum,type, ...
            bin_LowerLimits, bin_UpperLimits,...
            lblAreaCut,lblAreaFill,...
            lblVolCut,lblVolFill,lblVolNet,lblTitle);
    
  
 % SAVE PLOT
 cd(pathname);
 
 figpos = get(gcf,'Position');
 psize = get(gcf,'PaperSize');
 newpp = [0 0 0 0]; % sets positing [left bottom width height] (note screen resolution is 1024 x 768)
 newpp(3) = psize(1)-0.5;                    % width (subtract half inch off sides of page)
 newpp(4) = newpp(3)*figpos(4)/figpos(3);   % height (calculate the height in terms of page width, as to maintain correct aspect ratio)
 newpp(2) = (psize(2)-newpp(4))/2;          % bottom (center on page vertically)
 newpp(1) = .25;                            % left (border width (1/4")
 set(gcf,'PaperPosition',newpp);
 
 print -dtiff -r300 GeomoprhVolumetricDoDDist;
 
 cd(RootDirectory);
