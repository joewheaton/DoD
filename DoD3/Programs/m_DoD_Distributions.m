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

%

% REVISIONS
% Sediment Budget 1.0: 3 December 2004
%   Fall 2004 AGU results based on this version.

%22 April 2005- JMW added figure saving capability and formatting to plot



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 


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
       
%        bin_ChangeCount(k,1) = size(address,1);                            % counts number of cells in current bin
       dummyCount = size(address,1);                            % counts number of cells in current bin
       bin_ChangeCount(k,1) = dummyCount;
       
%        bin_AreaSum(k,1) = bin_ChangeCount(k)*cellarea;                    % calculates total area of cells in current bin
       dummyArea = bin_ChangeCount(k)*cellarea;                    
       bin_AreaSum(k,1) = dummyArea;
       
%        bin_VolumeSum(k,1) = (sum(DoD_Current(address)))*cellarea;         % calculates total volume of cells in current bin
       dummyVol = (sum(DoD_Current(address)))*cellarea;         
       bin_VolumeSum(k,1) = dummyVol;         
          
       
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
    
    %Sort out labels
    lblAreaCut = strcat('Total Area of Erosion:',' ', num2str((abs(totalarea_Cut_current)),'%-10.1f'),' m^{2}');
    lblAreaFill= strcat('Total Area of Deposition:',' ', num2str(totalarea_Fill_current,'%-10.1f'),' m^{2}');
    lblVolCut = strcat('Total Volume of Erosion:',' ', num2str((abs(totalcut_current)),'%-10.1f'),' m^{3}');
    lblVolFill = strcat('Total Volume of Deposition:',' ', num2str(totalfill_current,'%-10.1f'),' m^{3}');
    lblVolNet = strcat('Net Volume:',' ', num2str(net_current,'%-10.1f'),' m^{3}');
    
    if(BatchMode == 0)
        fprintf('Stats for %s\n', cat_string);
        
        fprintf('Total Cut = %8.3f cubic meters\n',(abs(totalcut_current)))
        fprintf('Total Fill = %8.3f cubic meters\n',(abs(totalfill_current)))
        fprintf('Net Difference = %8.3f cubic meters\n',(abs(net_current)))
	end
    
 %------Produce Volumetric Historgram Figure -------------------------
    
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
%         binbndycv(m,1)=bin_LowerLimits+(bin_increment*m);
%         midbincv(m,1)=binbndycv((m-1),1)+(bin_increment/2);
    end
    
    
    % Split into erosion and deposition (for colouring) THIS PART WORKS BUT
    % DOES NOT PLOT CORRECTLY SO SKIPPING FOR NOW
    
%      % First x-Axis
%       eMidBinCV = midbincv(1:(bin_nc/2),1);
%       dMidBinCV = midbincv((1+(bin_nc/2)):bin_nc,1);
%       % Areas
%       eBinAreaSum = bin_AreaSum(1:(bin_nc/2),1);
%       dBinAreaSum = bin_AreaSum((1+(bin_nc/2)):bin_nc,1);
%       %Volumes
%       ebinAbsVolumeSum = bin_absVolumeSum(1:(bin_nc/2),1);
%       dbinAbsVolumeSum = bin_absVolumeSum((1+(bin_nc/2)):bin_nc,1);
      
    
    figure;
    set(gcf,'position',[50 100 700 500]);  % sets positing [left bottom width height] (note screen resolution is 1024 x 768)

     %Subplot of Counts:
%     subplot(3,1,1);
%      bar(midbincv,bin_ChangeCount);
%      xlabel('Elevation Change (m)');
%      ylabel('Counts');
%      axis([bin_LowerLimits bin_UpperLimits 0 (1.05*(max(bin_ChangeCount)))]);
%      title(cat_string,'DEM of Difference Distributions',
%      'FontWeight','bold');
     
     
%     Subplot of Percentage Areas:

%      %subplot(3,1,1)    % Only if plotting all 3
%      bar(midbincv,percentchange)
%      xlabel('Elevation Change (m)')
%      ylabel('Counts')
%      axis([bin_LowerLimits bin_UpperLimits 0 100])

     
     subplot(2,1,1);
     %subplot(3,1,2)    % Only if plotting all 3
     bar(midbincv,bin_AreaSum,'k');
%      bar(eMidBinCV,eBinAreaSum,'r'); % Just erosion
%      h1 = gca;
%      h2 = axes('Position',get(h1,'Position'));
%      bar(dMidBinCV,dBinAreaSum,'b'); % Just deposition
% %      set(h2,'YAxisLocation','right','Color','none','XTickLabel',[]);
% %      set(h2,'XLim',get(h1,'XLim'),'Layer','top');

     xlabel('Elevation Change (m)');
     ylabel('Area (m^{2})');
     axis([bin_LowerLimits bin_UpperLimits 0 (1.05*(max(bin_AreaSum)))]);
     title(cat_string)
     
     % Plot Properties
     set(gca,'FontSize',11,'FontName','Veranda');
	 set(get(gca,'Xlabel'),'FontSize',12,'FontName','Veranda');
	 set(get(gca,'Ylabel'),'FontSize',12,'FontName','Veranda');
	 set(get(gca,'Title'),'FontSize',14,'FontName','Veranda','FontWeight','bold');
     
     
     % Show Gross Budget
     text(-0.95*bin_UpperLimits,0.95*(max(bin_AreaSum)), lblAreaCut,'fontsize',9,'FontName','Veranda');
     text(-0.95*bin_UpperLimits,0.85*(max(bin_AreaSum)), lblAreaFill,'fontsize',9,'FontName','Veranda');
     
     % Label
     text(-1.2*bin_UpperLimits,-0.15*(max(bin_AreaSum)), 'A','fontsize',16,'FontName','Veranda','FontWeight','bold');
     
%      subplot(3,1,3);
     subplot(2,1,2);
     bar(midbincv,bin_absVolumeSum,'k');
%      bar(eMidBinCV,ebinAbsVolumeSum,'r'); % Just erosion
%      h1 = gca;
%      h2 = axes('Position',get(h1,'Position'));
%      bar(dMidBinCV,dbinAbsVolumeSum,'b'); % Just deposition
%      set(h2,'YAxisLocation','right','Color','none','XTickLabel',[]);
%      set(h2,'XLim',get(h1,'XLim'),'Layer','top');
     
     xlabel('Elevation Change (m)');
     ylabel('Volume (m^{3})');
     axis([bin_LowerLimits bin_UpperLimits 0 (1.05*(max(bin_absVolumeSum)))]);
     %axis([bin_LowerLimits bin_UpperLimits 0 400]);
     
     
     % Plot Properties
     set(gca,'FontSize',11,'FontName','Veranda');
	 set(get(gca,'Xlabel'),'FontSize',12,'FontName','Veranda');
	 set(get(gca,'Ylabel'),'FontSize',12,'FontName','Veranda');
	 set(get(gca,'Title'),'FontSize',14,'FontName','Veranda','FontWeight','bold');
     
     % Show Gross Budget
     text(-0.95*bin_UpperLimits,0.95*(max(bin_absVolumeSum)), lblVolCut,'fontsize',9,'FontName','Veranda');
     text(-0.95*bin_UpperLimits,0.85*(max(bin_absVolumeSum)), lblVolFill,'fontsize',9,'FontName','Veranda');
     text(-0.95*bin_UpperLimits,0.75*(max(bin_absVolumeSum)), lblVolNet,'fontsize',9,'FontName','Veranda');
     
     % Label
     text(-1.2*bin_UpperLimits,-0.15*(max(bin_absVolumeSum)), 'B','fontsize',16,'FontName','Veranda','FontWeight','bold');
     
%	 saveas(gcf,[setuppath,'reach_geomorph_distribution.jpg'],'jpg') ;  
    % get and set paper properties for printing
     set(gcf,'Units','inches','PaperUnits','inches')
     figpos = get(gcf,'Position');
     psize = get(gcf,'PaperSize');
     newpp = [0 0 0 0]; % sets positing [left bottom width height] (note screen resolution is 1024 x 768)
     newpp(3) = psize(1)-0.5;                    % width (subtract half inch off sides of page)
     newpp(4) = newpp(3)*figpos(4)/figpos(3);   % height (calculate the height in terms of page width, as to maintain correct aspect ratio)
     newpp(2) = (psize(2)-newpp(4))/2;          % bottom (center on page vertically)
     newpp(1) = .25;                            % left (border width (1/4")
     set(gcf,'PaperPosition',newpp);
    
          
     % Set Path to save images in
     
    
cd(Dir_Run);
switch Dtype;                                        
    % DoD Distribution Type: 1 = Gross; 2 = Apriori; 3 = Posterior; 4 =
    % Spatially Uniform; 5 = Geomorph
    case 1;
         print -djpeg -r300 DoD_Dist_Gross ;     
         if BatchMode == 0
             print -dill -r300 DoD_Dist_Gross;
         end
    case 2;
%          if(CI_Num == 1)
             print -djpeg -r300 DoD_Dist_Prior;      
             if BatchMode == 0
                 print -dill -r300 DoD_Dist_Prior;    
             end
%          end
     case 3;
%         if(CI_Num == 1)
             print -djpeg -r300 DoD_Dist_Post;      
             if BatchMode == 0
                 print -dill -r300 DoD_Dist_Post;
             end
%         end
     case 4;
         print -djpeg -r300 DoD_Dist_Uniform ;
         if BatchMode == 0
             print -dill -r300 DoD_Dist_Uniform;
         end
     otherwise
         print -djpeg -r300 Rename_Me_Figure  ;    
         print -dill -r300 Rename_Me_Figure ;

end
    

 
if(BatchMode == 1)
    close(gcf);
end

cd(RootDirectory);

    