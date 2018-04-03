function HistSubPlot(XArray,YArray,type,plotnum,bin_LowerLimits, bin_UpperLimits,lblAreaCut,lblAreaFill,lblVolCut,lblVolFill,lblVolNet,lblTitle)
%areaSubPlot is a subfunction that returns nothing, but performs the basic
%plotting based on the input argument array to be plotted.
	bar(XArray,YArray,'k');

    
    switch type;
        case 1 
            YMax = 45000;
			ylabel('Area (m^{2})');

        case 2
 	        YMax = 150;
            %YMax = 600;
			ylabel('Volume (m^{3})');
     end 
         

%      xlabel('Elevation Change (m)');
     axis([bin_LowerLimits bin_UpperLimits 0 YMax]);
     
     % Show Gross Budget
     switch type;
        case 1
         text(-0.95*bin_UpperLimits,0.92*YMax, lblAreaCut,'fontsize',7,'FontName','Veranda');
         text(-0.95*bin_UpperLimits,0.82*YMax, lblAreaFill,'fontsize',7,'FontName','Veranda');
     case 2
         text(-0.95*bin_UpperLimits,0.92*YMax, lblVolCut,'fontsize',7,'FontName','Veranda');
         text(-0.95*bin_UpperLimits,0.82*YMax, lblVolFill,'fontsize',7,'FontName','Veranda');
         text(-0.95*bin_UpperLimits,0.72*YMax, lblVolNet,'fontsize',7,'FontName','Veranda');
     end
%      title(lblTitle)
     
     % Plot Properties
     set(gca,'FontSize',8,'FontName','Veranda');
     set(get(gca,'Xlabel'),'FontSize',9,'FontName','Veranda');
     set(get(gca,'Ylabel'),'FontSize',9,'FontName','Veranda');
     set(get(gca,'Title'),'FontSize',9,'FontName','Veranda','FontWeight','bold');

     % Label
	
     switch plotnum
         case 1
             PlotLabel = 'A';
         case 2
             PlotLabel = 'B';
         case 3
             PlotLabel = 'C';
         case 4
             PlotLabel = 'D';
         case 5
             PlotLabel = 'E';
         case 6
             PlotLabel = 'F';
         case 7
             PlotLabel = 'G';
         case 8
              PlotLabel = 'H';
         case 9
              PlotLabel = 'I';
         case 10
              PlotLabel = 'J';
         case 11
              PlotLabel = 'K';
         case 12
              PlotLabel = 'L';
         case 13
              PlotLabel = 'M';    
         case 14
              PlotLabel = 'N';
     end
       
     text(-1.2*bin_UpperLimits,-0.15*(max(YMax)), PlotLabel,'fontsize',12,'FontName','Veranda','FontWeight','bold');
     
