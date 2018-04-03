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
numplots = 1;
% numplots = 6; % PW2
% numplots = 4; % PW3
figure;
set(gcf,'position',[10 10 400 800]);  % sets positing [left bottom width height] (note screen resolution is 1024 x 768)
for k=1:numplots;
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
                if(indexA == 1)
                    % CALCULATE GROSS EROSION
                    p2_AreaCut_A(1) =  p1_AreaCut;
                    p2_VolCut_A(1) =  p1_VolCut;
                    % CALCULATE GROSS DEPOSITION
                    p2_AreaFill_A(1) = p1_AreaFill;
                    p2_VolFill_A(1) = p1_VolFill;
                    % CALCULATE NET
                    p2_NetVol_A(1) = p1_NetVol;
                     
                    % THRESHOLD
                    p2_Threshold_DoD_A(1) = 0;
                end
                
                % CALCULATE GROSS EROSION
                p2_AreaCut_A(indexA+1) =  p2_AreaCut;
                p2_VolCut_A(indexA+1) =  p2_VolCut;
                % CALCULATE GROSS DEPOSITION
                p2_AreaFill_A(indexA+1) = p2_AreaFill;
                p2_VolFill_A(indexA+1) = p2_VolFill;
                % CALCULATE NET
                p2_NetVol_A(indexA+1) = p2_NetVol;
                
                % Calculate Percent Loss
                p2_cutAreaLossPct_A(indexA+1) = p2_cutAreaLossPct;
                p2_fillAreaLossPct_A(indexA+1) = p2_fillAreaLossPct;
                
                p2_cutLossPct_A(indexA+1) = p2_cutLossPct;
                p2_fillLossPct_A(indexA+1) = p2_fillLossPct;
                p2_netLossPct_A(indexA+1) = p2_netLossPct;
                
                % THRESHOLD
                p2_Threshold_DoD_A(indexA+1) = p2_Threshold_DoD;
                
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
                p4_upe_A(indexA) = p4_upe;             
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
        
	
	
	set(gcf,'position',[50 100 700 500]);
	
	switch pathWay;
        case 1
           
        case 2
            
            subplot(3,2,k);     
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
			

        
            % Plot Properties
			set(gca,'FontSize',8,'FontName','Veranda');
            ylabel('Volume of Sediment (m^{3})','FontSize',10,'FontName','Veranda');    
            xlabel('_{Min}LoD Elevation Threshold (m)','FontSize',9,'FontName','Veranda');
            legend('Erosion','Deposition','Net');
	 		axis([0 0.5 -5000 15000]);
	
		 % Label
         switch k
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
         end
           
         text(-0.075,-8000, PlotLabel,'fontsize',12,'FontName','Veranda','FontWeight','bold');
         
			
        case 3
            subplot(2,2,k);     
            plot(p3_CI_A,p3_VolCut_A,':rv',...   
                    'MarkerSize', 5,...
                    'MarkerEdgeColor','k',...
                    'MarkerFaceColor','r');
			hold on
			plot(p3_CI_A,p3_VolFill_A,':b^',...   
                    'MarkerSize', 5,...
                    'MarkerEdgeColor','k',...
                    'MarkerFaceColor','b');
			hold on
			plot(p3_CI_A,p3_NetVol_A,':kd',...   
                    'MarkerSize', 5,...
                    'MarkerEdgeColor','k',...
                    'MarkerFaceColor','y');
			% Now plot gross for reference
            hold on
            plot(p3_CI_A,p1_VolCut_A,'rv',...
                'MarkerSize', 3,...
                    'MarkerEdgeColor','r',...
                    'MarkerFaceColor','k');
            hold on
            plot(p3_CI_A,p1_VolFill_A,'b^',...
                'MarkerSize', 3,...
                    'MarkerEdgeColor','b',...
                    'MarkerFaceColor','k');
            hold on
            plot(p3_CI_A,p1_NetVol_A,'d',...
                'MarkerSize', 3,...
                    'MarkerEdgeColor','y',...
                    'MarkerFaceColor','k');
                
                
        
            % Plot Properties
			set(gca,'FontSize',8,'FontName','Veranda');
            ylabel('Volume of Sediment (m^{3})','FontSize',10,'FontName','Veranda');    
            xlabel('Minimum Level of Detection Elevation Threshold (m)','FontSize',9,'FontName','Veranda');
            legend('Erosion','Deposition','Net');
	 		axis([0 0.5 -5000 15000]);
	
		 % Label
         switch k
             case 1
                 PlotLabel = 'A';
             case 2
                 PlotLabel = 'B';
             case 3
                 PlotLabel = 'C';
             case 4
                 PlotLabel = 'D';

         end
           
         text(0.4,-8000, PlotLabel,'fontsize',12,'FontName','Veranda','FontWeight','bold');         
        case 4
%             subplot(2,2,k);     
            %  plot gross for reference
            plot(p4_CI_A,p1_VolCut_A,'-r');
            hold on
            plot(p4_CI_A,p1_VolFill_A,'-b');
            hold on
            plot(p4_CI_A,p1_NetVol_A,'-k');
			hold on
            % Then Plot Thresholded Values
            plot(p4_CI_A,p3_VolCut_A,'rv',...   
                    'MarkerSize', 5,...
                    'MarkerEdgeColor','k',...
                    'MarkerFaceColor','r');
			hold on
			plot(p4_CI_A,p3_VolFill_A,'b^',...   
                    'MarkerSize', 5,...
                    'MarkerEdgeColor','k',...
                    'MarkerFaceColor','b');
			hold on
			plot(p4_CI_A,p3_NetVol_A,'kd',...   
                    'MarkerSize', 5,...
                    'MarkerEdgeColor','k',...
                    'MarkerFaceColor','y');
                			

        
            % Plot Properties
			set(gca,'FontSize',14,'FontName','Veranda');
            ylabel('Volume of Sediment (m^{3})','FontSize',16,'FontName','Veranda');    
            xlabel('C.I. Threshold','FontSize',16,'FontName','Veranda');
            legend('Gross Erosion','Gross Deposition','Gross Net','Thresholded Erosion',...
                'Thresholded Deposition','Thresholded Net',0);
            % FESHIE
%             yUpLim = 13000;
%             yLowLim = -5000;
%             yRange = yUpLim - yLowLim;
%             xUpLim = 1.0;
%             xLowLim = 0.5;
%             xRange = xUpLim - xLowLim;
            
            %Sulphur Creeek
            yUpLim = 2500;
            yLowLim = -500;
            yRange = yUpLim - yLowLim;
            xUpLim = 1.0;
            xLowLim = 0.5;
            xRange = xUpLim - xLowLim;
            
            axis([xLowLim xUpLim yLowLim yUpLim]);
	
		 % Label
         switch k
             case 1
                 PlotLabel = 'A';
             case 2
                 PlotLabel = 'B';
             case 3
                 PlotLabel = 'C';
             case 4
                 PlotLabel = 'D';

         end
           
%          text((xLowLim - (0.2*xRange)),(yLowLim - (0.15*yRange)), PlotLabel,'fontsize',16,'FontName','Veranda','FontWeight','bold');        
        case 5
            
        case 6
	end
end % ENDS FOR LOOP REPEATING PLOT CREATION
