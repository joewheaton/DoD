%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         Classification of Uncertainty Analysis
%       for use with Sediment Budget Analysis 1.1 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        Produced by James Brasington & Joseph Wheaton           %
%                           December 2004                        %
%                                                                %
%               Last Updated: 1 March, 2005                  
%                                                                %
%                                                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%
% This script converts the uncertainty analyses into a probablistic format
% using a t-test. This allows the user to specify a confidence interval at
% which to view the results.
%

% REVISIONS
% Sediment Budget 1.0: 3 December 2004
%   Fall 2004 AGU results based on this version.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%  
% if(BatchMode == 0)
%     % dialog box to setup loop for confidence interval threshold analysis?
%     prompt = {'Enter a positive interger for the number of different confidence interval threshold analyses you would like to perform:'};
%     dlg_title = 'Uncertainty Analysis Confidence Interval Selection';
%     num_lines= 1;
%     def     = {'1'};
%     answer  = inputdlg(prompt,dlg_title,num_lines,def);
%         
%     CI_Num = str2num(answer{1});
%     
%     clear answer def num_lines dlg_title prompt;
% end
    
	%------Initialize Variables-----------------------------------
    if(userBayes == 0); % If Spatial Coherence was skipped, need to do some calculations
        %------Calculate propagated DoD error from FIS and label as a priori probability-------    
	    if(BatchMode == 0)
            fprintf('Working... Caluculating Propagated DoD errors ... be patient.\n\n');
        end
	
        perror=sqrt((newzqual.^2)+(oldzqual.^2)); % calculate prop error (quality grids ARE the FIS or Spatially Uniform inputs from step 2!)
        check=find(perror == 0);                  % check perror for zeros
        perror(check)=0.0001;                     % set 0 perror to low value
        tscore=(DoD./perror);                     % calculate t score for difference from zero             
%         io_Saver_TScore;                          % saves T-Score to grid if wanted... TEMP
        cells=find(tscore > -10000);              % find data cells   
        temp_t=(tscore(cells));                   % calc vector of absolute t score for cells
        temp_t=tcdf(temp_t,1000);                 % convert t scores to p with large deg. freedom
        tscore(cells)=temp_t;                     % update t score grid as probs
        signed_priorp=2*(tscore-0.5);             % rescale tscore to -1 - 1 (true e - true d)
        priorp=abs(signed_priorp);                % absolute p of change - taken to be prior prob
        prior=signed_priorp;
    elseif(userBayes == 1) % Spatial Coherence done, so all is fine
        prior=signed_priorp;
        post=postp;
    end

    
%     for m = 1:CI_Num
%         if(CI_Num > 1)
%             disp('WARNING! I can not save elevation change distriubtion figures automatically when more than one cofidence interval is analysed. If you want to keep these figures, you will need to save them manually!');    
%         end
		%------Select CI for Analysis Class Change Calculations-----------------------------------
         if(BatchMode == 0)
            % dialog box to prompt user for lowbin and highbin and increment?
            prompt = {'Enter Confindence Interval for DoD Classification, [0-1]'};
            dlg_title = 'Uncertainty Analysis Confidence Interval Selection';
            num_lines= 1;
            def     = {'0.95'};
            answer  = inputdlg(prompt,dlg_title,num_lines,def);
		
            cellarea = lx^2;               % Area of one grid cell in square meters
            CI = str2num(answer{1});       % Specify the lower analysis limit
            
         
            clear answer def num_lines dlg_title prompt;
        end
        
        CI_label = num2str((100*CI),'%3.1f');
		%----------------------------------------------------------------------
		
		% Set all cells below threshold to Nodata and union these with boundary
		% no_data to give new arrays containing only DoD values of interest
             
            if(userBayes == 1); % If Bayesian Updating was  done
                 AD_post_ND=find(-CI < post & post < CI);
                 AD_post_ND=union(AD_post_ND,nd_cells);
                 post_DoD=DoD;
                 post_DoD(AD_post_ND)=nodata;
            end
            
            % Do prior anyway (FIS)
             AD_prior_ND=find(-CI < prior & prior < CI);
             AD_prior_ND=union(AD_prior_ND,nd_cells);
             prior_DoD=DoD;
             prior_DoD(AD_prior_ND)=nodata;
             
             
		%------Save a priori and posterior DoD classification     
            if(BatchMode == 0) 
                button_Step4a = questdlg('The probability surfaces have been used to filter the DoD. You can save these thresholded DoDs to an ARC compatible ascii file for later use or continue without saving.',...
				    'Save Files?','Save thresholded DoDs','Skip','Save thresholded DoDs');
            end
		    if strcmp(button_Step4a,'Save thresholded DoDs')
                if(userBayes == 1); % If Bayesian Updating was  done
                    post_DoD(nd_cells)=nodata;  
                end
                prior_DoD(nd_cells)=nodata;  
                io_Saver_uncertain_DoD;                     

            end     
        
         % set back to nan for later analyses
         prior_DoD(AD_prior_ND)=nan;
         if(userBayes == 1); % If Bayesian Updating was  done
             post_DoD(AD_post_ND)=nan;
         end
		%----------------------------------------------------------------------
		% Budget analysis of Prior Classification (Based on FIS)
		    if(BatchMode == 0) 
                switch pathWay
                    case 3
                        button_Step4b = questdlg('You can do a gross reach scale analysis of the FIS thresholded DoD. This analysis produces an elevation change distribution of the thresholded DoD.',...
				            'Elevation Change Distribution?','Do Analysis','Skip','Do Analysis');
                    case 4
                       button_Step4b = questdlg('You can do a gross reach scale analysis of the a priori FIS thresholded DoD. This analysis produces an elevation change distribution of the thresholded DoD. ',...
				            'Elevation Change Distribution?','Do Analysis','Skip','Do Analysis'); 
                    case 5
                       button_Step4b = questdlg('You can do a gross reach scale analysis of the a priori spatially uniform thresholded DoD. This analysis produces an elevation change distribution of the thresholded DoD. ',...
				            'Elevation Change Distribution?','Do Analysis','Skip','Do Analysis'); 
                    case 6
                      button_Step4b = questdlg('You can do a gross reach scale analysis of the spatially uniform thresholded DoD. This analysis produces an elevation change distribution of the thresholded DoD. ',...
				            'Elevation Change Distribution?','Do Analysis','Skip','Do Analysis'); 
                end
            end
            if strcmp(button_Step4b,'Do Analysis')
                 DoD_Current = prior_DoD;                                                   % DoD_Current is required by DoD_Distributions.m
                 switch pathWay
                    case 3
                        cat_string = strcat('FIS Thresholded DoD: ', ' ',metaD_DateNew,'-',metaD_DateOld);  
                        baseDoDfn = strcat(Dir_Run,'/DoD_Dist_FIS');
                    case 4
                        cat_string = strcat('FIS Thresholded DoD: ', ' ',metaD_DateNew,'-',metaD_DateOld);  
                        baseDoDfn = strcat(Dir_Run,'/DoD_Dist_FIS');                        
                    case 5
                        cat_string = strcat('Spatially Uniform Thresholded DoD: ', ' ',metaD_DateNew,'-',metaD_DateOld);  
                        baseDoDfn = strcat(Dir_Run,'/DoD_Dist_SU');                     
                    case 6
                        cat_string = strcat('Spatially Uniform Thresholded DoD: ', ' ',metaD_DateNew,'-',metaD_DateOld);  
                        baseDoDfn = strcat(Dir_Run,'/DoD_Dist_SU');                      
                end
              

                % Do DoD distribution analysis and save results for later
                [p3_totalcut,p3_totalfill,p3_net, p3_totalarea_Cut,p3_totalarea_Fill,...
                        p3_ChangeCount,p3_AreaSum,p3_VolumeSum, p3_lblAreaCut,p3_lblAreaFill,...
                        p3_lblVolCut,p3_lblVolFill,p3_lblVolNet] = f_DoDDist(cat_string,baseDoDfn,DoD_Current,bin_LowerLimits,bin_UpperLimits,bin_increment,bin_nc,cellarea);

                if(BatchMode == 1)
				    if(gcf == 100)
                        close(100); % Close the second plot if it was made
                    end
                    close(gcf); % Anyway, just close the first plot
                    
				end

                %------ KEEP ELEVATION CHANGE DISTRIBUTION DATA FOR REPORTS -------------

                p3_cutLossPct =  100*((p1_totalcut - p3_totalcut)/ p1_totalcut);
                p3_fillLossPct = 100*((p1_totalfill - p3_totalfill)/p1_totalfill);
                p3_netLossPct = 100*((p1_net - p3_net)/p1_net);
                p3_cutAreaLossPct = 100*((p1_totalarea_Cut - p3_totalarea_Cut)/p1_totalarea_Cut);
                p3_fillAreaLossPct = 100*((p1_totalarea_Fill - p3_totalarea_Fill)/p1_totalarea_Fill);
                p3_lbl = cat_string;
                p3_lblCI = CI_label;
                

            end
		
                
		
		%----------------------------------------------------------------------
		% Budget analysis of Posteriori Classification (Based on Spatial
		% Coherence Update)
		    if(userBayes == 1); % If Bayesian Updating was  done
                if(BatchMode == 0)
                    button_Step4c = questdlg('You can do a gross reach scale analysis of the posterior thresholded DoD (based on the spatial contiguity index). This analysis produces an elevation change distribution of the thresholded DoD. ',...
					            'Elevation Change Distribution?','Do Analysis','Skip','Do Analysis'); 
                end
                if strcmp(button_Step4c,'Do Analysis')
                    DoD_Current = post_DoD;                                                    % DoD_Current is required by DoD_Distributions.m
                    switch pathWay
                        case 4
                            baseDoDfn = strcat(Dir_Run,'/DoD_Dist_SC');   
                        case 5
                            baseDoDfn = strcat(Dir_Run,'/DoD_Dist_SC');   
                    end
                    
                    cat_string = strcat('Bayesian-updaed S.C. Thresholded DoD: ', ' ',metaD_DateNew,'-',metaD_DateOld);  

                    if(BatchMode == 0)
                        disp('Starting gross reach scale analysis of posteriori DoD')  
                        fprintf('Working... I have %u cells to process. Be patient.\n',numcells);       
                    end
              
                    % Do DoD distribution analysis and save results for later
                    [p4_totalcut,p4_totalfill,p4_net, p4_totalarea_Cut,p4_totalarea_Fill,...
                        p4_ChangeCount,p4_AreaSum,p4_VolumeSum, p4_lblAreaCut,p4_lblAreaFill,...
                        p4_lblVolCut,p4_lblVolFill,p4_lblVolNet] = f_DoDDist(cat_string,baseDoDfn,DoD_Current,bin_LowerLimits,bin_UpperLimits,bin_increment,bin_nc,cellarea);

                    if(BatchMode == 1)
					    if(gcf == 100)
                            close(100); % Close the second plot if it was made
                        end
                        close(gcf); % Anyway, just close the first plot
                        
					end

                       
                    %------ KEEP ELEVATION CHANGE DISTRIBUTION DATA FOR REPORTS -------------
                    p4_cutLossPct =  100*((p1_totalcut - p4_totalcut)/ p1_totalcut);
                    p4_fillLossPct = 100*((p1_totalfill - p4_totalfill)/p1_totalfill);
                    p4_netLossPct = 100*((p1_net - p4_net)/p1_net);
                    p4_cutAreaLossPct = 100*((p1_totalarea_Cut - p4_totalarea_Cut)/p1_totalarea_Cut);
                    p4_fillAreaLossPct = 100*((p1_totalarea_Fill - p4_totalarea_Fill)/p1_totalarea_Fill);
                    p4_lbl = cat_string;
                    p4_lblCI = CI_label;    
            

                end    
            end

%      end    % END LOOP



    