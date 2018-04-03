%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-------------Multiple Distributions Plotter  ----------------
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




figure;
% set(gcf,'position',[10 10 1200 900]);  % sets positing [left bottom width height] (note screen resolution is 1024 x 768)
% set(gcf,'units','centimeters');
% set(gcf,'position',[1 1 24 24]);  % sets positing [left bottom width height] 
% fPos = get(gcf,'position');
    
for k=1:numSims;
    indexA = k;
	

       
    A_io_LoadDist;              % Load up DoD Dist 
    
    % ON FIRST PASS THROUGH SET UP X-AXIS BNDYS AND INCREMENT
    if(k == 1)
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
    end
        
    simNames_A(indexA) = cellstr(simName);
    simTypes_A(indexA) = cellstr(simType);
       
    %%%--------WORK UP PLOT  -----------------------
% 	set(gcf,'position',[50 100 700 500]);
	
	switch pathWay;
        case 1
            %Sort out labels
            lblAreaCut = strcat('Erosion: ', num2str((abs(p1_AreaCut)),'%-10.0f'),' m^{2}');
            lblAreaFill= strcat('Deposition: ', num2str(p1_AreaFill,'%-10.0f'),' m^{2}');
            lblVolCut = strcat('Erosion: -', num2str((abs(p1_VolCut)),'%-10.0f'),' m^{3}');
            lblVolFill = strcat('Deposition: +', num2str(p1_VolFill,'%-10.0f'),' m^{3}');
            lblVolNet = strcat('Net:',' ', num2str(p1_NetVol,'%-10.0f'),' m^{3}');
            lblTitle = RunName;
    
           plotnum =  (k*2)-1;
           type = 1;
           subplot(numSims,2,plotnum); 
                HistSubPlot(midbincv,p1_AreaSum,type,plotnum, ...
                    bin_LowerLimits, bin_UpperLimits,...
                    lblAreaCut,lblAreaFill,...
                    lblVolCut,lblVolFill,lblVolNet,lblTitle);

           plotnum = k*2;   
           type = 2;
           subplot(numSims,2,plotnum);    
                HistSubPlot(midbincv,p1_VolumeSum,type,plotnum, ...
                    bin_LowerLimits, bin_UpperLimits,...
                    lblAreaCut,lblAreaFill,...
                    lblVolCut,lblVolFill,lblVolNet,lblTitle);
        case 2
            %Sort out labels
            lblAreaCut = strcat('Erosion: ', num2str((abs(p1_AreaCut)),'%-10.0f'),' m^{2}');
            lblAreaFill= strcat('Deposition: ', num2str(p1_AreaFill,'%-10.0f'),' m^{2}');
            lblVolCut = strcat('Erosion: -', num2str((abs(p1_VolCut)),'%-10.0f'),' m^{3}');
            lblVolFill = strcat('Deposition: +', num2str(p1_VolFill,'%-10.0f'),' m^{3}');
            lblVolNet = strcat('Net:',' ', num2str(p1_NetVol,'%-10.0f'),' m^{3}');
            lblTitle = RunName;
    
           plotnum =  (k*2)-1;
           type = 2;
           subplot(numSims,2,plotnum); 
                HistSubPlot(midbincv,p1_VolumeSum,type,plotnum, ...
                    bin_LowerLimits, bin_UpperLimits,...
                    lblAreaCut,lblAreaFill,...
                    lblVolCut,lblVolFill,lblVolNet,lblTitle);

                
            %Sort again
            lblAreaCut = strcat('Erosion: ', num2str((abs(p1_AreaCut)),'%-10.0f'),' m^{2}');
            lblAreaFill= strcat('Deposition: ', num2str(p1_AreaFill,'%-10.0f'),' m^{2}');
            lblVolCut = strcat('Erosion: -', num2str((abs(p2_VolCut)),'%-10.0f'),' m^{3}');
            lblVolFill = strcat('Deposition: +', num2str(p2_VolFill,'%-10.0f'),' m^{3}');
            lblVolNet = strcat('Net:',' ', num2str(p2_NetVol,'%-10.0f'),' m^{3}');
            lblTitle = RunName;
           plotnum = k*2;   
           type = 2;
           subplot(numSims,2,plotnum);    
                HistSubPlot(midbincv,p2_VolumeSum,type,plotnum, ...
                    bin_LowerLimits, bin_UpperLimits,...
                    lblAreaCut,lblAreaFill,...
                    lblVolCut,lblVolFill,lblVolNet,lblTitle);
			
        case 3
            %Sort out labels
            lblAreaCut = strcat('Erosion: ', num2str((abs(p1_AreaCut)),'%-10.0f'),' m^{2}');
            lblAreaFill= strcat('Deposition: ', num2str(p1_AreaFill,'%-10.0f'),' m^{2}');
            lblVolCut = strcat('Erosion: -', num2str((abs(p1_VolCut)),'%-10.0f'),' m^{3}');
            lblVolFill = strcat('Deposition: +', num2str(p1_VolFill,'%-10.0f'),' m^{3}');
            lblVolNet = strcat('Net:',' ', num2str(p1_NetVol,'%-10.0f'),' m^{3}');
            lblTitle = RunName;
    
           plotnum =  (k*2)-1;
           type = 2;
           subplot(numSims,2,plotnum); 
                HistSubPlot(midbincv,p1_VolumeSum,type,plotnum, ...
                    bin_LowerLimits, bin_UpperLimits,...
                    lblAreaCut,lblAreaFill,...
                    lblVolCut,lblVolFill,lblVolNet,lblTitle);

                
            %Sort again
            lblVolCut = strcat('Erosion: -', num2str((abs(p3_VolCut)),'%-10.0f'),' m^{3}');
            lblVolFill = strcat('Deposition: +', num2str(p3_VolFill,'%-10.0f'),' m^{3}');
            lblVolNet = strcat('Net:',' ', num2str(p3_NetVol,'%-10.0f'),' m^{3}');
            lblTitle = RunName;
           plotnum = k*2;   
           type = 2;
           subplot(numSims,2,plotnum);    
                HistSubPlot(midbincv,p3_VolumeSum,type,plotnum, ...
                    bin_LowerLimits, bin_UpperLimits,...
                    lblAreaCut,lblAreaFill,...
                    lblVolCut,lblVolFill,lblVolNet,lblTitle);
        case 4
            %Sort out labels
            lblAreaCut = strcat('Erosion: ', num2str((abs(p1_AreaCut)),'%-10.0f'),' m^{2}');
            lblAreaFill= strcat('Deposition: ', num2str(p1_AreaFill,'%-10.0f'),' m^{2}');
            lblVolCut = strcat('Erosion: -', num2str((abs(p3_VolCut)),'%-10.0f'),' m^{3}');
            lblVolFill = strcat('Deposition: +', num2str(p3_VolFill,'%-10.0f'),' m^{3}');
            lblVolNet = strcat('Net:',' ', num2str(p3_NetVol,'%-10.0f'),' m^{3}');
            lblTitle = RunName;
    
           plotnum =  (k*2)-1;
           type = 2;
           subplot(numSims,2,plotnum); 
                HistSubPlot(midbincv,p3_VolumeSum,type,plotnum, ...
                    bin_LowerLimits, bin_UpperLimits,...
                    lblAreaCut,lblAreaFill,...
                    lblVolCut,lblVolFill,lblVolNet,lblTitle);

                
            %Sort again
            lblVolCut = strcat('Erosion: -', num2str((abs(p4_VolCut)),'%-10.0f'),' m^{3}');
            lblVolFill = strcat('Deposition: +', num2str(p4_VolFill,'%-10.0f'),' m^{3}');
            lblVolNet = strcat('Net:',' ', num2str(p4_NetVol,'%-10.0f'),' m^{3}');
            lblTitle = RunName;
           plotnum = k*2;   
           type = 2;
           subplot(numSims,2,plotnum);    
                HistSubPlot(midbincv,p4_VolumeSum,type,plotnum, ...
                    bin_LowerLimits, bin_UpperLimits,...
                    lblAreaCut,lblAreaFill,...
                    lblVolCut,lblVolFill,lblVolNet,lblTitle);        
        case 5
            %Sort out labels
            lblAreaCut = strcat('Erosion: ', num2str((abs(p4_AreaCut)),'%-10.0f'),' m^{2}');
            lblAreaFill= strcat('Deposition: ', num2str(p4_AreaFill,'%-10.0f'),' m^{2}');
            lblVolCut = strcat('Erosion: -', num2str((abs(p4_VolCut)),'%-10.0f'),' m^{3}');
            lblVolFill = strcat('Deposition: +', num2str(p4_VolFill,'%-10.0f'),' m^{3}');
            lblVolNet = strcat('Net:',' ', num2str(p4_NetVol,'%-10.0f'),' m^{3}');
            lblTitle = RunName;
    
%            if(rem(k,2) == 0)
%                 plotnum = k*2; 
%            else
                plotnum =  k; 
%            end
           type = 2;
           subplot(numSims/2,2,plotnum); 
                HistSubPlot(midbincv,p4_VolumeSum,type,plotnum, ...
                    bin_LowerLimits, bin_UpperLimits,...
                    lblAreaCut,lblAreaFill,...
                    lblVolCut,lblVolFill,lblVolNet,lblTitle);

            
        case 6
            %Sort out labels
            lblAreaCut = strcat('Erosion: ', num2str((abs(p1_AreaCut)),'%-10.0f'),' m^{2}');
            lblAreaFill= strcat('Deposition: ', num2str(p1_AreaFill,'%-10.0f'),' m^{2}');
            lblVolCut = strcat('Erosion: -', num2str((abs(p1_VolCut)),'%-10.0f'),' m^{3}');
            lblVolFill = strcat('Deposition: +', num2str(p1_VolFill,'%-10.0f'),' m^{3}');
            lblVolNet = strcat('Net:',' ', num2str(p1_NetVol,'%-10.0f'),' m^{3}');
            lblTitle = RunName;
    
           plotnum =  (k*2)-1;
           type = 2;
           subplot(numSims,2,plotnum); 
                HistSubPlot(midbincv,p1_VolumeSum,type,plotnum, ...
                    bin_LowerLimits, bin_UpperLimits,...
                    lblAreaCut,lblAreaFill,...
                    lblVolCut,lblVolFill,lblVolNet,lblTitle);

                
            %Sort again
            lblVolCut = strcat('Erosion: -', num2str((abs(p6_VolCut)),'%-10.0f'),' m^{3}');
            lblVolFill = strcat('Deposition: +', num2str(p6_VolFill,'%-10.0f'),' m^{3}');
            lblVolNet = strcat('Net:',' ', num2str(p6_NetVol,'%-10.0f'),' m^{3}');
            lblTitle = RunName;
           plotnum = k*2;   
           type = 2;
           subplot(numSims,2,plotnum);    
                HistSubPlot(midbincv,p6_VolumeSum,type,plotnum, ...
                    bin_LowerLimits, bin_UpperLimits,...
                    lblAreaCut,lblAreaFill,...
                    lblVolCut,lblVolFill,lblVolNet,lblTitle);              
	end		


 
	
	
end % ENDS FOR LOOP REPEATING PLOT CREATION

%      set(gcf,'Units','inches','PaperUnits','inches')
%      figpos = get(gcf,'Position');
%      psize = get(gcf,'PaperSize');
%      newpp = [0 0 0 0]; % sets positing [left bottom width height] (note screen resolution is 1024 x 768)
%      newpp(3) = psize(1)-0.5;                    % width (subtract half inch off sides of page)
%      newpp(4) = newpp(3)*figpos(4)/figpos(3);   % height (calculate the height in terms of page width, as to maintain correct aspect ratio)
%      newpp(2) = (psize(2)-newpp(4))/2;          % bottom (center on page vertically)
%      newpp(1) = .25;                            % left (border width (1/4")
%      set(gcf,'PaperPosition',newpp);
%      
%      print -dtiff -r600 DoDDist;



