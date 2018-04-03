%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   Bin Distribution Limits
%       for use with Sediment Budget Analysis 2.0 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        Produced by Joseph Wheaton & James Brasington           %
%                           December 2004                        %
%                                                                %
%               Last Updated: 28 July 2007                 
%                                                                %
%                                                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%
% This function simply sets the bins for sediment budget distribution
% analyses.his script simply reads FIS error surfaces if the user has already
% created them.
%

% REVISIONS
% Sediment Budget 1.0: 3 December 2004
%   Fall 2004 AGU results based on this version.
% Sediment Budget 2.0: 28 July 2007
%   


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 


%------Set the bin dimensions and increment for analysis------------------
 

    maxDoD = max(max(DoD_Current));
    minDoD = min(min(DoD_Current));
if(BatchMode == 0)
    %   Tell user what maximum cut and fill depths are
    fprintf('Your maximum fill (deposition) is: %f meters\n',maxDoD);
    fprintf('Your maximum cut (erosion) is: %f meters\n\n',minDoD);
    
%   dialog box to prompt user for lowbin and highbin and increment?
    prompt = {'Enter Lower Limit [erosion -meters]:','Enter Upper Limit [depostion +meters]:','Enter Bin Size Increment [meters]'};
    dlg_title = 'ECD Bin Size and Range [in meters]';
    num_lines= 1;
    def     = {'-2.5','2.5','0.05'};
    answer  = inputdlg(prompt,dlg_title,num_lines,def);
    
    bin_LowerLimits = str2num(answer{1});            % Specify the lower analysis limit
    bin_UpperLimits = str2num(answer{2});            % Specify the upper analysis limit
    bin_increment = str2num(answer{3});              % Specify the bin size increment

end
    bin_nc = ((bin_UpperLimits-bin_LowerLimits)/bin_increment);   % Number of bin categories
    cellarea = lx^2;                                 % Area of one grid cell in square meters
    % NOTE THESE STAY THE SAME FOR THE REST OF THE PROGRAM!
    clear prompt dlg_title num_lines def answer;
