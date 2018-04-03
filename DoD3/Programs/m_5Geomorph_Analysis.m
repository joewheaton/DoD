%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               Geomorphic Analysis 
%       for use with Sediment Budget Analysis 2.0 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   Produced by Joseph Wheaton                   %
%                        September 2007                          %
%                                                                %
%               Last Updated: 29 September, 2007                 
%                                                                %
%                                                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%
% This script gets the user defined classes.
%


    
%------Set No-Data to NaN-------------------------------------
        
if (strcmp(GType,'CoD')  == 1); % Classification of Difference
    % Sort out nodata cells first
    region1=find(newgeomorph == nodata); % Find nodata cells in first array
    region2=find(oldgeomorph == nodata); % Find nodata cell in second array
    nd_cells=union(region1,region2);
    newgeomorph(nd_cells)=nan;
    oldgeomorph(nd_cells)=nan;
    % Sort out data cells next for stats
    region1=find(newgeomorph ~= nodata); % Find nodata cells in first array
    region2=find(oldgeomorph ~= nodata); % Find nodata cell in second array
    d_cells=union(region1,region2);
    nCats = numClasses^2;
else % Single Mask
    nd_cells = find(geomorphMask == nodata);
    d_cells = find(geomorphMask ~= nodata);
    nCats = numClasses;
end
% Total Cells
CNT_Tot = length(d_cells);

    
%------Geomrophic Class Change Calculations-----------------------------------

if BatchMode == 0
    fprintf('\n');
    fprintf('Working... Calculating %u categories of change ... be patient.\n\n',nCats);
end

def = {'150'};
prompt = {'Enter the maximum volume (in cubic meters):'};
dlg_title = 'Choose the vertical scale on the ECDs.';
ans  = inputdlg(prompt,dlg_title,1,def);  
vMax = str2num(ans{1});
            
if (strcmp(GType,'CoD')  == 1); % Classification of Difference
	% Create class grid to save:
    CoDGrid = zeros(nx,ny);
    mNot = find(DoD_Current == nodata);
    CoDGrid(mNot) = nodata;
    a =1;
    for cOld=1:numClasses
        for cNew=1:numClasses
            fprintf('Analysing CoD %u of %u...\n',a, (numClasses^2));
            %----First find cells within mask-------------------------------  
            CoD_DoD = zeros(nx,ny);
            CNT_Class = 0;
            for i=1:ny;              % Begin main gridcell loop (rows)
                for j=1:nx;          % Begin gridcell loop (collumns)
                    if (newgeomorph(j,i) == nodata)
                        CoD_DoD(j,i) = nan;    
                    elseif (newgeomorph(j,i) == cOld);
                        if (oldgeomorph(j,i) == cNew);
                            CoD_DoD(j,i) = DoD_Current(j,i);
                            CoDGrid(j,i) = a; 
                            CNT_Class = CNT_Class+1;
                        else
                            CoD_DoD(j,i) = nan;    
                        end
                    else
                        CoD_DoD(j,i) = nan;
                    end
                end                 % End gridcell loop (collumns)

            end          

            %----Get figure title sorted------------------------------------
            cTitle = strcat(geoClasses{cOld},'\rightarrow',geoClasses{cNew});
            
            if CNT_Class > 0 % ONLY CONTINUE IF THERE ARE SOME IN THIS CoD
                %----Next count number of cells for stats-----------------------
                PCT_AerialClass = 100*(CNT_Class/CNT_Tot);
                %----Preview CoD to be analysed----------------------------------
        
%                 CoD_DoD(mNot) = nan;
%                 figure;
%             Imagesc(CoD_DoD);axis equal;colorbar;
                
                %----Get figure name and path sorted----------------------------
                if(cOld>= 10) 
                    if(cNew>= 10)
                        baseDoDfn = strcat(Dir_GSim,'/DoD_Dist_c',num2str(cOld),'_to_c',num2str(cNew));
                    else
                        baseDoDfn = strcat(Dir_GSim,'/DoD_Dist_c',num2str(cOld),'_to_c0',num2str(cNew));
                    end
                else       
                    if(cNew>= 10)
                        baseDoDfn = strcat(Dir_GSim,'/DoD_Dist_c0',num2str(cOld),'_to_c',num2str(cNew));
                    else
                        baseDoDfn = strcat(Dir_GSim,'/DoD_Dist_c0',num2str(cOld),'_to_c0',num2str(cNew));
                    end
                end
		
                %----Make el. change dist. figures for just this class-----------
%                 vMax = 150; % HARD CODE THIS AS APPRORIATE!


                [totalcut,totalfill, net, totalarea_Cut, totalarea_Fill,...
                            ChangeCount, AreaSum, VolumeSum, lblAreaCut, lblAreaFill,...
                            lblVolCut, lblVolFill, lblVolNet] = f_DoDDist(cTitle,baseDoDfn,CoD_DoD,bin_LowerLimits,bin_UpperLimits,bin_increment,bin_nc,cellarea,vMax);
		
                %----Save output table for just this class-----------------------
                
                if(cOld>= 10) 
                    if(cNew>= 10)
                        DoDtable_filename = strcat(Dir_GSim,'/c',num2str(cOld),'_to_c',num2str(cNew),'_ElevDist.csv');
                    else
                        DoDtable_filename = strcat(Dir_GSim,'/c',num2str(cOld),'_to_c0',num2str(cNew),'_ElevDist.csv');
                    end
                else       
                    if(cNew>= 10)
                        DoDtable_filename = strcat(Dir_GSim,'/c0',num2str(cOld),'_to_c',num2str(cNew),'_ElevDist.csv');
                    else
                        DoDtable_filename = strcat(Dir_GSim,'/c0',num2str(cOld),'_to_c0',num2str(cNew),'_ElevDist.csv');
                    end
                end
			   
                    
				fid50 = fopen(DoDtable_filename, 'w');    %write a file based on user's specificaitons
				fprintf(fid50,'Upper Elevation Range (m), Lower Elevation Range (m), Area (m2), Volume (m3), Number of Cells\n');
				%Reinitialize Bin LImits
				bin_CurrentLow = bin_LowerLimits;
				bin_CurrentHigh = bin_LowerLimits+bin_increment;
				
				for m=1:bin_nc;                                                      % Begin category loop
                    fprintf(fid50,'%6.2f,%6.2f,%10.3f,%10.3f,%d\n',  bin_CurrentLow, bin_CurrentHigh, AreaSum(m), VolumeSum(m), ChangeCount(m));
                    % Update bin intervals at end of category loop
                    bin_CurrentLow = bin_CurrentLow+bin_increment;
                    bin_CurrentHigh = bin_CurrentHigh+bin_increment;
				end  
				
				fclose(fid50);    %close file
                
                %----Save values to master array for just this class-----------------------
                
                NamesCoD{a} = cTitle;
                
                % THIS ARRAY HAS EVERYTHING FOR SUMMARY TABLE
                summaryTab(cOld,1,cNew) = cOld;
                summaryTab(cOld,2,cNew) = cNew;
                summaryTab(cOld,3,cNew) = abs(totalcut);
                summaryTab(cOld,4,cNew) = totalfill;
                summaryTab(cOld,5,cNew) = net;
                summaryTab(cOld,6,cNew) = totalarea_Cut;
                summaryTab(cOld,7,cNew) = totalarea_Fill;
                summaryTab(cOld,8,cNew) = CNT_Class;
                summaryTab(cOld,9,cNew) = PCT_AerialClass;
                
                %----Clear values for next round--------------------------------------------
                clear totalcut totalfill net totalarea_Cut totalarea_Fill ChangeCount AreaSum VolumeSum lblAreaCut lblAreaFill lblVolCut lblVolFill lblVolNet;  
                
            else   % NOTHING in this CoD 
                                %----Save values to master array for just this class-----------------------
                
                NamesCoD{a} = cTitle;
                
                % THIS ARRAY HAS EVERYTHING FOR SUMMARY TABLE
                summaryTab(cOld,1,cNew) = cOld;
                summaryTab(cOld,2,cNew) = cNew;
                summaryTab(cOld,3,cNew) = 0;
                summaryTab(cOld,4,cNew) = 0;
                summaryTab(cOld,5,cNew) = 0;
                summaryTab(cOld,6,cNew) = 0;
                summaryTab(cOld,7,cNew) = 0;
                summaryTab(cOld,8,cNew) = 0;
                summaryTab(cOld,9,cNew) = 0;
                
            end
            
            a = a + 1;  % Increment Counter
        end % End inner do - loop
	end % End outter do loop
    
    io_Saver_CoD;
    
else % Single Mask
    for c=1:numClasses
        %----First find cells within mask-------------------------------  
        cAdd = find(geomorphMask == c); 
        cNot = find(geomorphMask ~= c);
        %----Next count number of cells for stats-----------------------
        CNT_Class = 0;
        CNT_Class = length(cAdd);
        if(CNT_Class > 0)
            PCT_AerialClass = 100*(CNT_Class/CNT_Tot);
            %----Adjust DoD to be analysed----------------------------------
            CoD_DoD = DoD_Current;
            CoD_DoD(cNot) = nan;
            
            
            %----et figure title sorted-------------------------------------
            cTitle = geoClasses{c};
        
            %----Get figure name and path sorted----------------------------
            if(c>= 10) baseDoDfn = strcat(Dir_GSim,'/DoD_Dist_c',num2str(c));
            else       baseDoDfn = strcat(Dir_GSim,'/DoD_Dist_c0',num2str(c));
            end
	
            %----Make el. change dist. figures for just this class-----------
%             vMax = 350; % HARD CODE THIS AS APPRORIATE!


            [totalcut,totalfill, net, totalarea_Cut, totalarea_Fill,...
                        ChangeCount, AreaSum, VolumeSum, lblAreaCut, lblAreaFill,...
                        lblVolCut, lblVolFill, lblVolNet] = f_DoDDist(cTitle,baseDoDfn,CoD_DoD,bin_LowerLimits,bin_UpperLimits,bin_increment,bin_nc,cellarea,vMax);
	
            %----Save output table for just this class-----------------------
           
            if(c>= 10) DoDtable_filename = strcat(Dir_GSim,'/c',num2str(c),'_ElevDist.csv');
            else       DoDtable_filename = strcat(Dir_GSim,'/c0',num2str(c),'_ElevDist.csv');
            end
		   
                
			fid50 = fopen(DoDtable_filename, 'w');    %write a file based on user's specificaitons
			fprintf(fid50,'Upper Elevation Range (m), Lower Elevation Range (m), Area (m2), Volume (m3), Number of Cells\n');
			%Reinitialize Bin LImits
			bin_CurrentLow = bin_LowerLimits;
			bin_CurrentHigh = bin_LowerLimits+bin_increment;
			
			for m=1:bin_nc;                                                      % Begin category loop
                fprintf(fid50,'%6.2f,%6.2f,%10.3f,%10.3f,%d\n',  bin_CurrentLow, bin_CurrentHigh, AreaSum(m), VolumeSum(m), ChangeCount(m));
                % Update bin intervals at end of category loop
                bin_CurrentLow = bin_CurrentLow+bin_increment;
                bin_CurrentHigh = bin_CurrentHigh+bin_increment;
			end  
			
			fclose(fid50);    %close file
            
            %----Save values to master array for just this class-----------------------
            
            NamesCoD{c} = cTitle;
            % THIS ARRAY HAS EVERYTHING FOR SUMMARY TABLE
            summaryTab(c,1) = c;
            summaryTab(c,2) = abs(totalcut);
            summaryTab(c,3) = totalfill;
            summaryTab(c,4) = net;
            summaryTab(c,5) = totalarea_Cut;
            summaryTab(c,6) = totalarea_Fill;
            summaryTab(c,7) = CNT_Class;
            summaryTab(c,8) = PCT_AerialClass;
            
            %----Clear values for next round--------------------------------------------
            clear totalcut totalfill net totalarea_Cut totalarea_Fill ChangeCount AreaSum VolumeSum lblAreaCut lblAreaFill lblVolCut lblVolFill lblVolNet;
        else 
               %----Save values to master array for just this class-----------------------
                
                NamesCoD{a} = cTitle;
                
                % THIS ARRAY HAS EVERYTHING FOR SUMMARY TABLE
                summaryTab(c,1) = c;
                summaryTab(c,2) = 0;
                summaryTab(c,3) = 0;
                summaryTab(c,4) = 0;
                summaryTab(c,5) = 0;
                summaryTab(c,6) = 0;
                summaryTab(c,7) = 0;
                summaryTab(c,8) = 0;
        end
	end
    
end


%------------SUMMARY RESULTS------------------------------

%----Summary Table----------------------------------------

Geotable_filename = strcat(Dir_GSim,'/',gSimName,'_Summary.csv');


    
fid80 = fopen(Geotable_filename, 'w');    %write a file 
if (strcmp(GType,'CoD')  == 1);
	% First calculate total erosion, deposition and total volumes:
	totEV = 0;
	totDV = 0;
    for cOld=1:numClasses
        for cNew=1:numClasses
            totEV = totEV + summaryTab(cOld,3,cNew);
            totDV = totDV + summaryTab(cOld,4,cNew);
        end
    end
   
    totV = totEV + totDV;
    
    % File Header
    fprintf(fid80,'CoD Name, From, To, Aerial Percentage of Total, Volumetric Percentage of Total, Volumetric Percentage of Erosion Total, Volumetric Percentage of Deposition Total, Erosion Volume, Deposition Volume, Total Volume, Net Volume Difference, Erosion Area, Deposition Area \n');
	
    % Substance
    k=1;
    for cOld=1:numClasses
        for cNew=1:numClasses
            fprintf(fid80,'%s,%u,%u,%2.2f,%2.2f,%2.2f,%2.2f,%10.3f,%10.3f,%10.3f,%10.3f,%10.3f,%10.3f \n',NamesCoD{k},...
                summaryTab(cOld,1,cNew), summaryTab(cOld,2,cNew),...
                summaryTab(cOld,9,cNew), 100*((summaryTab(cOld,3,cNew) + summaryTab(cOld,4,cNew))/ totV),...
                100*(summaryTab(cOld,3,cNew)/totEV), 100*(summaryTab(cOld,4,cNew)/totDV),...
                summaryTab(cOld,3,cNew), summaryTab(cOld,4,cNew),...
                (summaryTab(cOld,3,cNew) + summaryTab(cOld,4,cNew)), summaryTab(cOld,5,cNew),...
                summaryTab(cOld,6,cNew), summaryTab(cOld,7,cNew));
            
            % Build percentage arrays for pie charts
            pctE(k) = 100*(summaryTab(cOld,3,cNew)/totEV);
            pctD(k) = 100*(summaryTab(cOld,4,cNew)/totDV);
            
            % Update indexing
           k= k+1;
       end
	end  
else % MASK ONLY
    % First calculate total erosion, deposition and total volumes:
    totEV = 0;
	totDV = 0;
    for c=1:nCats; 
        totEV = totEV + summaryTab(c,2);
        totDV = totDV + summaryTab(c,3);
	end
    totV = totEV + totDV;
    
    % File Header
    fprintf(fid80,'Class Name, Class Index, Aerial Percentage of Total, Volumetric Percentage of Total, Volumetric Percentage of Erosion Total, Volumetric Percentage of Deposition Total, Erosion Volume, Deposition Volume, Total Volume, Net Volume Difference, Erosion Area, Deposition Area \n');
	
    pctE = zeros(nCats);
    pctD = zeros(nCats);
    
    % Substance
	for c=1:nCats; 
        fprintf(fid80,'%s,%u,%2.2f,%2.2f,%2.2f,%2.2f,%10.3f,%10.3f,%10.3f,%10.3f,%10.3f,%10.3f \n',NamesCoD{c},...
            c, summaryTab(c,8), 100*((summaryTab(c,2) + summaryTab(c,3))/ totV),...
            100*(summaryTab(c,2)/totEV), 100*(summaryTab(c,3)/totDV),...
            summaryTab(c,2), summaryTab(c,3),...
            (summaryTab(c,2) + summaryTab(c,3)), summaryTab(c,4),...
            summaryTab(c,7), summaryTab(c,6));
        
            % Build percentage arrays for pie charts
            pctE(c) = 100*(summaryTab(c,2)/totEV);
            pctD(c) = 100*(summaryTab(c,3)/totDV);
    end 
end

fclose(fid80);    %close file

%----PieChart---------------------------------------------

%     figure;
%     set(gcf,'position',[50 100 1000 500]);  % sets positing [left bottom width height] (note screen resolution is 1024 x 768)
% 
%     
%      subplot(1,2,1);
%         pie(pctE);
%         title('Erosion Percentages');
%         set(gca,'FontSize',12,'FontName','Veranda');
%         set(get(gca,'Title'),'FontSize',14,'FontName','Veranda','FontWeight','bold');
%         legend(NamesCoD,3);
%         legend('boxoff');
%         
%      subplot(1,2,2);
%         pie(pctD);
%         title('Deposition Percentages');
%         set(get(gca,'Title'),'FontSize',14,'FontName','Veranda','FontWeight','bold');
%         colormap bone;
%         set(gca,'FontSize',12,'FontName','Veranda');
%         legend(NamesCoD,3);
%         legend('boxoff');
%         
%         
%      % Sort out filename
%      figPiefilename = strcat(Dir_GSim,'\',gSimName,'_PieChart');
%      % Save a tiff and jpeg
%      f_save2graphic(figPiefilename,gcf,200,'-dtiff');
%      f_save2graphic(figPiefilename,gcf,300,'-djpeg');
        
        
        