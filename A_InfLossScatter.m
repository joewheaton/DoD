%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-----------------Gross Information Loss Analysis  ----------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                      Produced by Joseph Wheaton                %
%                                                                %
%               Last Updated: 27 August, 2007                     %
%                                                                %
%                                                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DESCRIPTION:
% 

%Message Box
h = msgbox('Welcome to Gross DoD Information Loss Analysis.  Using a series of dialog boxes, this wizard will allow you to intercompare information loss between simulations for a particular difference interval.','DoD Information Loss','help');
uiwait(h);

addAnother = 1;
indexA = 1;

% Determine whether to load files individually or by batch file
TheButton = questdlg('Would you like to manually load each simulation to compare individually or have you prepared a batch file?',...
    'Mode?','Manual','Batch','Batch');
if strcmp(TheButton,'Manual')
    AutoMode = 0;
elseif strcmp(TheButton,'Batch')
    AutoMode = 1; 
    A_io_BatchAnalysisReader;
end

while addAnother == 1
    
    A_io_LoadDist;              % Load up DoD Dist 
    
     simNames_A(indexA) = cellstr(simName);
     simTypes_A(indexA) = cellstr(simType);
   
     % Assing to Arrays
    
        % Do p1 calcs no matter what
            % CALCULATE GROSS EROSION
            p1_AreaCut_A(indexA) = p1_AreaCut;
            p1_VolCut_A(indexA) = p1_VolCut;
            % CALCULATE GROSS DEPOSITION
            p1_AreaFill_A(indexA) =   p1_AreaFill;
            p1_VolFill_A(indexA) =   p1_VolFill;
            % CALCULATE NET
            p1_NetVol_A(indexA) =  p1_NetVol;
	
	switch pathWay;
        case 2;
            % CALCULATE GROSS EROSION
            p2_AreaCut_A(indexA) =  p2_AreaCut;
            p2_VolCut_A(indexA) =  p2_VolCut;
            % CALCULATE GROSS DEPOSITION
            p2_AreaFill_A(indexA) = p2_AreaFill;
            p2_VolFill_A(indexA) = p2_VolFill;
            % CALCULATE NET
            p2_NetVol_A(indexA) = p2_NetVol;
            
            % Calculate Percent Loss
            p2_cutAreaLossPct_A(indexA) = p2_cutAreaLossPct;
            p2_fillAreaLossPct_A(indexA) = p2_fillAreaLossPct;
            
            p2_cutLossPct_A(indexA) = p2_cutLossPct;
            p2_fillLossPct_A(indexA) = p2_fillLossPct;
            p2_netLossPct_A(indexA) = p2_netLossPct;
            
            % THRESHOLD
            p2_Threshold_DoD_A(indexA) = p2_Threshold_DoD;
            
        case 3;
            % CALCULATE GROSS EROSION
            p3_AreaCut_A(indexA) = p3_AreaCut;
            p3_VolCut_A(indexA) = p3_VolCut;
            % CALCULATE GROSS DEPOSITION
            p3_AreaFill_A(indexA) = p3_AreaFill;
            p3_VolFill_A(indexA) = p3_VolFill;
            % CALCULATE NET
            p3_NetVol_A(indexA) = p3_NetVol;
            
            % Calculate Percent Loss
            p3_cutAreaLossPct_A(indexA) = p3_cutAreaLossPct;
            p3_fillAreaLossPct_A(indexA) = p3_fillAreaLossPct;
            
            p3_cutLossPct_A(indexA) = p3_cutLossPct;
            p3_fillLossPct_A(indexA) = p3_fillLossPct;
            p3_netLossPct_A(indexA) = p3_netLossPct;
            
            % CONFIDENCE INTERVAL
            p3_CI_A(indexA) = p3_CI;
            
        case 4;
            % CALCULATE GROSS EROSION
            p3_AreaCut_A(indexA) = p3_AreaCut;
            p3_VolCut_A(indexA) = p3_VolCut;
            
            p4_AreaCut_A(indexA) = p4_AreaCut;
            p4_VolCut_A(indexA) = p4_VolCut;
            % CALCULATE GROSS DEPOSITION
            p3_AreaFill_A(indexA) = p3_AreaFill;
            p3_VolFill_A(indexA) = p3_VolFill;
            
            p4_AreaFill_A(indexA) = p4_AreaFill;
            p4_VolFill_A(indexA) = p4_VolFill;
            % CALCULATE NET
            p3_NetVol_A(indexA) = p3_NetVol;
            p4_NetVol_A(indexA) = p4_NetVol;
            % Calculate Percent Loss
            p3_cutAreaLossPct_A(indexA) = p3_cutAreaLossPct;
            p3_fillAreaLossPct_A(indexA) =  p3_fillAreaLossPct;
            
            p4_cutAreaLossPct_A(indexA) = p4_cutAreaLossPct;
            p4_fillAreaLossPct_A(indexA) = p4_fillAreaLossPct;
            
            p3_cutLossPct_A(indexA) = p3_cutLossPct;
            p3_fillLossPct_A(indexA) = p3_fillLossPct;
            p3_netLossPct_A(indexA) = p3_netLossPct;
            
            p4_cutLossPct_A(indexA) = p4_cutLossPct;
            p4_fillLossPct_A(indexA) = p4_fillLossPct;
            p4_netLossPct_A(indexA) = p4_netLossPct;
            
            % CONFIDENCE INTERVAL
            p4_CI_A(indexA) = p4_CI;
            p4_lowe_A(indexA) = p4_lowe;          
            p4_upe_A(indexA) = p4_upe             
            p4_lowd_A(indexA) = p4_lowd;           
            p4_upd_A(indexA) = p4_upd; 
        
        case 5;
            % CALCULATE GROSS EROSION
            p5_AreaCut_A(indexA) = p5_AreaCut;
            p5_VolCut_A(indexA) = p5_VolCut;
            % CALCULATE GROSS DEPOSITION
            p5_AreaFill_A(indexA) = p5_AreaFill;
            p5_VolFill_A(indexA) = p5_VolFill;
            % CALCULATE NET
            p5_NetVol_A(indexA) = p5_NetVol;
            
            % Calculate Percent Loss
            p5_cutAreaLossPct_A(indexA) = p5_cutAreaLossPct;
            p5_fillAreaLossPct_A(indexA) = p5_fillAreaLossPct;
            
            p5_cutLossPct_A(indexA) = p5_cutLossPct;
            p5_fillLossPct_A(indexA) = p5_fillLossPct;
            p5_netLossPct_A(indexA) = p5_netLossPct;
            
            
        case 6;
            % CALCULATE GROSS EROSION
            p6_AreaCut_A(indexA) = p6_AreaCut;
            p6_VolCut_A(indexA) = p6_VolCut;
            % CALCULATE GROSS DEPOSITION
            p6_AreaFill_A(indexA) = p6_AreaFill;
            p6_VolFill_A(indexA) = p6_VolFill;
            % CALCULATE NET
            p6_NetVol_A(indexA) = p6_NetVol;
            
            % Calculate Percent Loss
            p6_cutAreaLossPct_A(indexA) = p6_cutAreaLossPct;
            p6_fillAreaLossPct_A(indexA) = p6_fillAreaLossPct;
            
            p6_cutLossPct_A(indexA) = p6_cutLossPct;
            p6_fillLossPct_A(indexA) = p6_fillLossPct;
            p6_netLossPct_A(indexA) = p6_netLossPct;
	end
    
    
    if AutoMode == 0
        button = questdlg('Do you wish to add another simulation Dod distribution for analysis?',...
           'Load More?','Yes','No','Yes'); 
        
        if strcmp(button,'Yes')
            addAnother = 1; 
            indexA = indexA + 1;
        elseif strcmp(button, 'No')
            addAnother = 0;
        end
    else
        if (indexA < length(Simulations))
            addAnother = 1;
            indexA = indexA + 1;
        else
            addAnother = 0;
        end
    end
end

%%%--------WORK UP PLOT  -----------------------
    
figure;

set(gcf,'position',[50 100 700 500]);

switch pathWay;
    case 1
       
    case 2
        

            
% 		plot(p2_Threshold_DoD_A,p2_cutLossPct_A,':rv');
% 		hold on
% 		plot(p2_Threshold_DoD_A,p2_fillLossPct_A,':b^');
% 		hold on
% 		plot(p2_Threshold_DoD_A,p2_netLossPct_A,':kd');
        
        plot(p2_Threshold_DoD_A,p2_VolCut_A,':rv',...   
                'MarkerSize', 5,...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor','r');
		hold on
		plot(p2_Threshold_DoD_A,p2_VolFill_A,':b^',...   
                'MarkerSize', 5,...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor','b');
		hold on
		plot(p2_Threshold_DoD_A,p2_NetVol_A,':kd',...   
                'MarkerSize', 5,...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor','y');
		
%         [AXa,H1a,H2a] = plotyy(p2_Threshold_DoD_A,p2_VolCut_A,...
%             p2_Threshold_DoD_A,p2_cutLossPct_A,'plot');
%         
%         set(get(AXa(1),'Ylabel'),'String','Volume of Sediment (m^{3})','FontSize',10,'FontName','Veranda')
%         set(get(AXa(2),'Ylabel'),'String','Percent Loss From Original','FontSize',10,'FontName','Veranda')
%         set(H1a,'LineStyle',':', 'Marker','v', 'Color','r',...
%                 'MarkerSize', 5,...
%                 'MarkerEdgeColor','k',...
%                 'MarkerFaceColor','r');
%         set(H2a,'LineStyle','-.', 'Marker','v', 'Color','r',...
%                 'MarkerSize', 5,...
%                 'MarkerEdgeColor','k',...
%                 'MarkerFaceColor','r');
%         hold on
%         
%         [AXb,H1b,H2b] = plotyy(p2_Threshold_DoD_A,p2_VolFill_A,...
%             p2_Threshold_DoD_A,p2_fillLossPct_A,'plot');
%         
%         set(H1b,'LineStyle',':', 'Marker','^', 'Color','b',...   
%                 'MarkerSize', 5,...
%                 'MarkerEdgeColor','k',...
%                 'MarkerFaceColor','b');
%         set(H2b,'LineStyle','-.', 'Marker','^', 'Color','b',... 
%                 'MarkerSize', 5,...
%                 'MarkerEdgeColor','k',...
%                 'MarkerFaceColor','b');
%         hold on
% 
%         [AXc,H1c,H2c] = plotyy(p2_Threshold_DoD_A,p2_NetVol_A,...
%             p2_Threshold_DoD_A,p2_netLossPct_A,'plot');
%         
%         set(H1c,'LineStyle',':', 'Marker','d', 'Color','k',...   
%                 'MarkerSize', 5,...
%                 'MarkerEdgeColor','k',...
%                 'MarkerFaceColor','y');
%         set(H2c,'LineStyle','-.', 'Marker','d', 'Color','k',...   
%                 'MarkerSize', 5,...
%                 'MarkerEdgeColor','k',...
%                 'MarkerFaceColor','y');
%         hold on
        
	
            
    
        % Plot Properties
		set(gca,'FontSize',9,'FontName','Veranda');
        ylabel('Volume of Sediment (m^{3})','FontSize',10,'FontName','Veranda');    
        xlabel('Minimum Level of Detection Elevation Threshold (m)','FontSize',10,'FontName','Veranda');
        legend('Erosion','Deposition','Net');
% 		axis([0 0.5 0 100]);

		
		

		
       
       
    case 3
        
    case 4
        
    case 5
        
    case 6
end

