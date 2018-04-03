%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     DoD Distributions
%       for use with Sediment Budget Analysis 2.0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        Produced by Joseph Wheaton & James Brasington           %
%                                                                %
%               Last Updated: 18 April, 2007                     %
%                                                                %
%                                                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%
% This function calculates histograms based on Bin_Distributions
% and DoD calculated as sediment budget

% Input Arguments:
% -distTitle
% -fileName
% -DoD_Current
% -bin_LowerLimits
% -bin_UpperLimits
% -bin_increment
% -bin_nc
% -cellarea
% -highVol

% Returns:
% totalcut_current: Total volume of cut for reach
% totalfill_current: Total volume of fill for reach
% net_current: Net volumetric difference for reach
% totalarea_Cut_current: 2
% totalarea_Fill_current: 2
%         
% bin_ChangeCount: changed count distribution for reach
% bin_AreaSum: surface area distribution for reach
% bin_absVolumeSum: volumetric distribuiton for reach
%         
% lblAreaCut: A text string of final area of cut stats
% lblAreaFill: A text string of final area of fill stats
% lblVolCut: A text string of final vol of cut stats
% lblVolFill: A text string of final vol of fill stats
% lblVolNet: A text string of final net vol stats

% REVISIONS
% Sediment Budget 1.0: 3 December 2004
%   Fall 2004 AGU results based on this version.

%22 April 2005- JMW added figure saving capability and formatting to plot



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
function [totalcut_current,totalfill_current,net_current,...
        totalarea_Cut_current,totalarea_Fill_current,...
        bin_ChangeCount,bin_AreaSum,bin_absVolumeSum,...
        lblAreaCut,lblAreaFill,lblVolCut,lblVolFill,lblVolNet] = f_DoDDist(distTitle,fileName,DoD_Current,bin_LowerLimits,bin_UpperLimits,bin_increment,bin_nc,cellarea,highVol)



% Verify correct number of arguments
error(nargchk(8,9,nargin));

if nargin<9
    highVol = 0; % Define after DoD calculation
end

% %------Set the bin dimensions and increment for analysis-------------  
   
    % Intialize starting bin range
    bin_CurrentLow = bin_LowerLimits;
    bin_CurrentHigh = bin_LowerLimits+bin_increment;
    
    % Initialize the output table collumn vectors
    bin_LowCat = zeros(bin_nc,1);       % lower bin category limits
    bin_HighCat = zeros(bin_nc,1);      % upper bin category limits
    bin_ChangeCount = zeros(bin_nc,1);  % number of cells in bin
    bin_AreaSum = zeros(bin_nc,1);      % total area (sum) of bin

    bin_VolumeSum = zeros(bin_nc,1);    % total volume (sum) of bin   

    
%------Bin Elevation Change Calculations-----------------------------------   
  
    for k=1:bin_nc;                                                      % Begin category loop
       % Requires that program calling up this assigns the DoD of interest
       % to DoD current
       address = find((DoD_Current >= bin_CurrentLow) & (DoD_Current < bin_CurrentHigh));   % finds cell addresses in current bin
       
       bin_ChangeCount(k,1) = size(address,1);                            % counts number of cells in current bin
       bin_AreaSum(k,1) = bin_ChangeCount(k)*cellarea;                    
       bin_VolumeSum(k,1) = (sum(DoD_Current(address)))*cellarea;         

       % Add in check near zero to deal with small erroneous rounding
       % errors
       if((bin_CurrentHigh + bin_increment < 0) & (bin_CurrentHigh + bin_increment > -0.00001))    
           bin_CurrentLow = bin_CurrentLow+bin_increment;
           bin_CurrentHigh = 0;
       elseif(bin_CurrentHigh == 0)  % Next pass through  
           bin_CurrentLow = 0;
           bin_CurrentHigh = bin_increment;
       else
           % Update bin intervals at end of category loop
           bin_CurrentLow = bin_CurrentLow+bin_increment;
           bin_CurrentHigh = bin_CurrentHigh+bin_increment;
       end
    end                                                                 % End category loop

    bin_absVolumeSum = abs(bin_VolumeSum);                              % Non-negative Volumes
    
    
    
%------Calculate Net Sediment Budget--------------------------------
    totalarea_Cut_current = sum(bin_AreaSum(1:(bin_nc/2),1));
    totalarea_Fill_current = sum(bin_AreaSum(1+(bin_nc/2):bin_nc,1));

    totalcut_current = sum(bin_VolumeSum(1:(bin_nc/2),1));                      % Sums up total cut volume
    totalfill_current = sum(bin_VolumeSum((1+(bin_nc/2)):bin_nc,1));            % Sums up total fill volume
    net_current = totalcut_current+totalfill_current;                           % Calculates Net Difference
    totalVol_current = totalcut_current + totalfill_current;
    
    %Sort out labels
    lblAreaCut = strcat('Total Area of Erosion:',' ', num2str((abs(totalarea_Cut_current)),'%-10.1f'),' m^{2}');
    lblAreaFill= strcat('Total Area of Deposition:',' ', num2str(totalarea_Fill_current,'%-10.1f'),' m^{2}');
    lblVolCut = strcat('Total Volume of Erosion:',' ', num2str((abs(totalcut_current)),'%-10.1f'),' m^{3}');
    lblVolFill = strcat('Total Volume of Deposition:',' ', num2str(totalfill_current,'%-10.1f'),' m^{3}');
    lblVolNet = strcat('Net Volume:',' ', num2str(net_current,'%-10.1f'),' m^{3}');
    
%     if(BatchMode == 0)
%         fprintf('Stats for %s\n', cat_string);
%         
%         fprintf('Total Cut = %8.3f cubic meters\n',(abs(totalcut_current)))
%         fprintf('Total Fill = %8.3f cubic meters\n',(abs(totalfill_current)))
%         fprintf('Net Difference = %8.3f cubic meters\n',(abs(net_current)))
% 	end

% Check to make sure there is something to plot
chkr = find(bin_AreaSum == 0);
if (length(chkr) == bin_nc)
    
else
 %------Produce 1st Historgram Figure (of area and volume with scaling bassed off maximum) -------------------------
    
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
    
    if nargin == 9
        figure(4);
	else
        figure;
	end
    set(gcf,'position',[50 100 700 500]);  % sets positing [left bottom width height] (note screen resolution is 1024 x 768)

    
     subplot(2,1,1);
         bar(midbincv,bin_AreaSum,'k');
         xlabel('Elevation Change (m)');
         ylabel('Area (m^{2})');
%          yMax = 500;
         yMax = 1.05*(max(bin_AreaSum));
         axis([bin_LowerLimits bin_UpperLimits 0 yMax]);
         title(distTitle)
         
         % Plot Properties
         set(gca,'FontSize',11,'FontName','Veranda');
		 set(get(gca,'Xlabel'),'FontSize',12,'FontName','Veranda');
		 set(get(gca,'Ylabel'),'FontSize',12,'FontName','Veranda');
		 set(get(gca,'Title'),'FontSize',14,'FontName','Veranda','FontWeight','bold');
         
         
         % Show Gross Budget
         text(-0.95*bin_UpperLimits,0.92*yMax, lblAreaCut,'fontsize',9,'FontName','Veranda');
         text(-0.95*bin_UpperLimits,0.82*yMax, lblAreaFill,'fontsize',9,'FontName','Veranda');
         
         % Label
         text(-1.2*bin_UpperLimits,-0.15*yMax, 'A','fontsize',16,'FontName','Veranda','FontWeight','bold');
         
     subplot(2,1,2);
         bar(midbincv,bin_absVolumeSum,'k');
         xlabel('Elevation Change (m)');
         ylabel('Volume (m^{3})');
%          yMax = 175;
         yMax = 1.05*(max(bin_absVolumeSum));
         axis([bin_LowerLimits bin_UpperLimits 0 yMax]);
         if (nargin < 8 & highVol == 0)
            highVol = 1.05*(max(bin_absVolumeSum));    
         end
             %axis([bin_LowerLimits bin_UpperLimits 0 400]);
	
         % Plot Properties
         set(gca,'FontSize',11,'FontName','Veranda');
		 set(get(gca,'Xlabel'),'FontSize',12,'FontName','Veranda');
		 set(get(gca,'Ylabel'),'FontSize',12,'FontName','Veranda');
		 set(get(gca,'Title'),'FontSize',14,'FontName','Veranda','FontWeight','bold');
         
         % Show Gross Budget
         text(-0.95*bin_UpperLimits,0.92*yMax, lblVolCut,'fontsize',9,'FontName','Veranda');
         text(-0.95*bin_UpperLimits,0.82*yMax, lblVolFill,'fontsize',9,'FontName','Veranda');
         text(-0.95*bin_UpperLimits,0.72*yMax, lblVolNet,'fontsize',9,'FontName','Veranda');
         
         % Label
         text(-1.2*bin_UpperLimits,-0.15*yMax, 'B','fontsize',16,'FontName','Veranda','FontWeight','bold');
         

     % Sort out filename
     figADfilename = strcat(fileName,'_AV');
     % Save a tiff and jpeg
     f_save2graphic(figADfilename,gcf,600,'-dtiff');
     f_save2graphic(figADfilename,gcf,300,'-djpeg');

     

   %------Produce 2nd Historgram Figure (of just volume with uniform scaling) -------------------------
  
   if nargin == 9   % Only produce if uniform scale provided as optional input parameter
	    figure(100);
            set(gcf,'units','centimeters');
            set(gcf,'position',[1 1 14 10]);  % sets positing [left bottom width height] 
            
            bar(midbincv,bin_absVolumeSum,'k');
            
            YMax = highVol;
			ylabel('Vol. (m^{3})');
			xlabel('El. \Delta (m)');
			axis([bin_LowerLimits bin_UpperLimits 0 YMax]);
            title(distTitle) 

             text(-0.97*bin_UpperLimits,0.92*YMax, lblVolCut,'fontsize',10,'FontName','Veranda');
             text(-0.97*bin_UpperLimits,0.82*YMax, lblVolFill,'fontsize',10,'FontName','Veranda');
             text(-0.97*bin_UpperLimits,0.72*YMax, lblVolNet,'fontsize',10,'FontName','Veranda');

            
             % Plot Properties
             set(gca,'FontSize',12,'FontName','Veranda');
             set(get(gca,'Xlabel'),'FontSize',14,'FontName','Veranda');
             set(get(gca,'Ylabel'),'FontSize',14,'FontName','Veranda');
             set(get(gca,'Title'),'FontSize',14,'FontName','Veranda','FontWeight','bold');
             set(gca,'XTick',[-2 -1 0 1 2]);
             set(gca,'YTick',[0 (0.5*YMax) YMax]);
             
                  % Sort out filename
     figADfilename = strcat(fileName,'_Vol');
     % Save a tiff and jpeg
     f_save2graphic(figADfilename,gcf,400,'-dtiff');
     f_save2graphic(figADfilename,gcf,300,'-djpeg');
   end
end