%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                        Spatially Uniform
%               Classification of Uncertainty Analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        Produced by James Brasington & Joseph Wheaton           %
%                       December 2004                            %
%                                                                %
%               Last Updated: 2 August 2007                  
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
% DoD Analysis 2.0: 2 August 2007
%   Modified for inclusion in DoD Analyiss 2.0

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%------Initialize Variables and Select threshold z for Change Calculations-----------------------------------
    
    % dialog box to prompt user for lowbin and highbin and increment?
if(BatchMode == 0)
    prompt = {'Enter threshold z value for DoD Classification, [metres]'};
    dlg_title = 'Threshold Change Selection';
    num_lines= 1;
    def     = {'0.25'};
    answer  = inputdlg(prompt,dlg_title,num_lines,def);
    
    threshold = str2num(answer{1});       % Specify the lower analysis limit
end
    cellarea = lx^2;                      % Area of one grid cell in square meters
    
 
%----------------------------------------------------------------------

% Set all cells below threshold to Nodata and union these with boundary
% no_data to give new arrays containing only DoD values of interest
     
     AD_uniform=find(-threshold <= DoD & DoD < threshold);
        
     AD_uniform=union(AD_uniform,nd_cells);

     uniform_DoD=DoD;
     uniform_DoD(AD_uniform)=nan;
     
     % Save Grid
     io_Saver_uniform_DoD;
%----------------------------------------------------------------------
      
% Budget analysis of threshold Classification

     DoD_Current = uniform_DoD;                                                     % DoD_Current is required by DoD_Distributions.m
     cat_string = strcat('Uniform Threshold Classification: ', ' ',metaD_DateNew,'-',metaD_DateOld);   % Label for DoD_Distributions.m 
     baseDoDfn = strcat(Dir_Run,'/DoD_Dist_PW2');     % Base filename

     
     if BatchMode == 0
         fprintf('Working... I have %u cells to process. Be patient.\n',numcells);
     end
  
    % Do DoD distribution analysis and save results for later
    [p2_totalcut,p2_totalfill,p2_net, p2_totalarea_Cut,p2_totalarea_Fill,...
            p2_ChangeCount,p2_AreaSum,p2_VolumeSum, p2_lblAreaCut,p2_lblAreaFill,...
            p2_lblVolCut,p2_lblVolFill,p2_lblVolNet] = f_DoDDist(cat_string,baseDoDfn,DoD_Current,bin_LowerLimits,bin_UpperLimits,bin_increment,bin_nc,cellarea);

    if(BatchMode == 1)
	    if(gcf == 100)
            close(100); % Close the second plot if it was made
        end
        close(gcf); % Anyway, just close the first plot
        
	end

  %------ KEEP ELEVATION CHANGE DISTRIBUTION DATA FOR REPORTS -------------
    % Store Results for Final Report (As if m_DoD_Distributions is run
    % again by user in next steps, these arrays are over-written)
    % p2 Stands for Pathway 2 (ignore uncertainty ~ gross budget)

    p2_cutLossPct =  100*((p1_totalcut - p2_totalcut)/ p1_totalcut);
    p2_fillLossPct = 100*((p1_totalfill - p2_totalfill)/p1_totalfill);
    p2_netLossPct = 100*((p1_net - p2_net)/p1_net);
    p2_cutAreaLossPct = 100*((p1_totalarea_Cut - p2_totalarea_Cut)/p1_totalarea_Cut);
    p2_fillAreaLossPct = 100*((p1_totalarea_Fill - p2_totalarea_Fill)/p1_totalarea_Fill);
    p2_lbl = cat_string;
    p2_lblThreshold = strcat((num2str(threshold,'%3.2f')),' m');                 %
    
    Dod(nd_cells)= NaN;                          % reset for later analyses
    
    


    