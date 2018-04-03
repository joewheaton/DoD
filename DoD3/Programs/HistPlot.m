function HistSubPlot(XArray,YArray,type,bin_LowerLimits, bin_UpperLimits,lblAreaCut,lblAreaFill,lblVolCut,lblVolFill,lblVolNet,lblTitle)
%areaSubPlot is a subfunction that returns nothing, but performs the basic
%plotting based on the input argument array to be plotted.
	bar(XArray,YArray,'k');
%     set(gcf,'units','points');
%     fPos = get(gcf,'position');
    switch type;
        case 1 
%             def = {'200'};
% 			prompt = {'Enter the maximum area (in square meters):'};
% 			dlg_title = 'Choose the vertical scale on the ECDs.';
% 			ans  = inputdlg(prompt,dlg_title,1,def);  
% 			YMax = str2num(ans{1});
            YMax = 45000;
			ylabel('Area (m^{2})');
            
        case 2
 	        %YMax = 1000;
            YMax = 100;
%             def = {'200'};
% 			prompt = {'Enter the maximum volume (in cubic meters):'};
% 			dlg_title = 'Choose the vertical scale on the ECDs.';
% 			ans  = inputdlg(prompt,dlg_title,1,def);  
% 			YMax = str2num(ans{1}); 
% 			ylabel('Volume (m^{3})');
            ylabel('Vol. (m^{3})');
     end 
         

%      xlabel('Elevation Change (m)');
     xlabel('El. \Delta (m)');

     axis([bin_LowerLimits bin_UpperLimits 0 YMax]);
     
     % Show Gross Budget
     switch type;
        case 1
         text(-0.97*bin_UpperLimits,0.92*YMax, lblAreaCut,'fontsize',18,'FontName','Veranda');
         text(-0.97*bin_UpperLimits,0.82*YMax, lblAreaFill,'fontsize',18,'FontName','Veranda');
     case 2
         text(-0.97*bin_UpperLimits,0.92*YMax, lblVolCut,'fontsize',20,'FontName','Veranda');
         text(-0.97*bin_UpperLimits,0.82*YMax, lblVolFill,'fontsize',20,'FontName','Veranda');
         text(-0.97*bin_UpperLimits,0.72*YMax, lblVolNet,'fontsize',20,'FontName','Veranda');
     end
%      title(lblTitle)
     
     % Plot Properties
     set(gca,'FontSize',22,'FontName','Veranda');
     set(get(gca,'Xlabel'),'FontSize',24,'FontName','Veranda');
     set(get(gca,'Ylabel'),'FontSize',24,'FontName','Veranda');
     set(get(gca,'Title'),'FontSize',18,'FontName','Veranda','FontWeight','bold');
     set(gca,'XTick',[-2 -1 0 1 2]);
     set(gca,'YTick',[0 (0.5*YMax) YMax]);
    
     
%     set(gca,'units','points');
% %     spWidth = (0.75)*fPos(3);
% %     spLeft =  (0.125)*fPos(3);
% %     spBottom = 0.125*fPos(4);
% %     spHeight = 0.80*fPos(4);
% %     set(gca,'position',[spLeft spBottom spWidth spHeight]);  % sets positing [left bottom width height] 
%     set(gca,'postion',[90 90 210 100]);    