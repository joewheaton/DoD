
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Bayesian Probablistic DoD Spatial Classifier
%       for use with Sediment Budget Analysis 2.0 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        Produced by James Brasington & Joseph Wheaton           %
%                           December 2004                        %
%                                                                %
%               Last Updated: 28 July 2007                 
%                                                                %
%                                                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%
% Script to classify DoD using DEM cell error estimates and eros and depos
% neighbourhood surfaces
%
% User Inputs: DoD file, two z_error surfaces, two (eros/depos) neighbourhood grids
% Parameters:  Weighting thresholds for neighbourhood grids
% Outputs:     Probabalistic DoD (confidence eros or depos)

% REVISIONS
% Sediment Budget 1.0: 3 December 2004
%   Fall 2004 AGU results based on this version.

% Sediment Budget 2.0: 28 July 2007
%   Updated to calculate the neighbourhood grids within program 



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


   
%------Neighbourhood Grids-----------------------------------------
if(BatchMode == 0)
    h = msgbox('Next, information on the number of cells surrounding each cell that are erosional or depositional is needed. We call this a neighbourhood grid.','STEP 3: Spatial Coherence Bayesian Updating','help');
    uiwait(h);
end
    
    
    
    % Choose method to get data
    if(BatchMode == 0)
        button_Step3b = questdlg('Would you like to load an existing neighbourhood grid or calculate one from the DEM of Difference [DoD]?',...
		'Choose Method','Existing Grid','Calculate','Help','Calculate');
    end
	if strcmp(button_Step3b,'Existing Grid')
        io_Reader_Neighbourhood;        % Loads to neighbourhood grids
        
	elseif strcmp(button_Step3b,'Calculate')
        % Initialize
        neros = zeros(nx,ny);     % The neighbourhood erosion grid
        ndepos = zeros(nx,ny);    % The negihborhood eposition grid
        nd_cells = find(DoD == nodata);
        neros(nd_cells) = nodata;
        ndepos(nd_cells) = nodata;
        
        m_3NeighbourhoodClass          % Calls up m_3NeighbourhoodClass.m, which prepares the grids

        if(BatchMode == 0)
            button_Step3c = questdlg('You can save these neighbourhood grids to ARC compatible file. Select one of the following options:',...
	    	    'Save Neighbourhood Analysis?','Save and Continue','Continue without Saving','Save and Continue');
        end 
        if strcmp(button_Step3c,'Save and Continue')
            io_Saver_Neighbourhood                             % Allows user to save Neighbourhood Grids for later use
        elseif strcmp(button_Step3c, 'Continue without saving DoD')
            disp('As you wish.')
        end
	elseif strcmp(button_Step3b,'Help')
       disp('Asking for help is the first step to admitting you have a problem. I suggest a career change.')
       h = msgbox('You need to either load existing neighbourhood grids or calculate them from scratch. This program will end now.','Help','help');
       uiwait(h);
       return
	end

    
%------Set No-Data back to NaN-------------------------------------
    
    region1=find(newzqual < 0); % Find nodata cells in first array
    region2=find(oldzqual < 0); % Find nodata cell in second array
    nd_cells=union(region1,region2);
    
    newzqual(nd_cells)=nan;
    oldzqual(nd_cells)=nan;
    neros(nd_cells)=nan;
    ndepos(nd_cells)=nan;
    dod(nd_cells)=nan;  
    
    % Divide DoD up into erosion cells and deposition cells
    ecells=find(DoD < 0);
    dcells=find(DoD > 0);

%------Calculate propagated DoD error and a priori probability-------    
    if(BatchMode == 0)
        fprintf('Working... Caluculating Propagated DoD errors ... be patient.\n\n');
	end

    perror=sqrt((newzqual.^2)+(oldzqual.^2)); % calculate prop error (quality grids ARE the FIS inputs!)
    check=find(perror == 0);                  % check perror for zeros
    perror(check)=0.0001;                     % set 0 perror to low value
    tscore=(DoD./perror);                     % calculate t score for difference from zero             
    cells=find(tscore > -10000);              % find data cells   
    temp_t=(tscore(cells));                   % calc vector of absolute t score for cells
    temp_t=tcdf(temp_t,1000);                 % convert t scores to p with large deg. freedom
    tscore(cells)=temp_t;                     % update t score grid as probs
    signed_priorp=2*(tscore-0.5);             % rescale tscore to -1 - 1 (true e - true d)
    priorp=abs(signed_priorp);                % absolute p of change - taken to be prior prob
    
%------Calculate Neighbourhood Weights-------------------------------
% 
% Note calculations are based on a 5x5 convolution window

    %   dialog box to prompt user for lowbin and highbin and increment?
    if(BatchMode == 0)
        h = msgbox('The calculation of neighbourhood weights are based on a 5x5 convolution window. You can set the threshold values for whether the change is real. If you are not sure what to do here, just use the defaults.','Spatial Neighbourhood Analysis','help');
        uiwait(h);
	
        prompt = {'Enter the upper analysis limit for erosion [# of cells]','Enter the lower analysis limit erosion [# of cells]', 'Enter the upper analysis limit for depostion [# of cells]','Enter the lower analysis limit deposition [# of cells]'};
        dlg_title = 'Spatial Neighbourhood Analysis Parameters';
        num_lines= 1;
        def     = {'15','25','15','25'};
        answer  = inputdlg(prompt,dlg_title,num_lines,def);
        
        lowe = str2num(answer{1});           % set lower threshold sum value = p = 0
        upe = str2num(answer{2});            % define upper threshold sum value = p = 1
        lowd = str2num(answer{3});           % set lower threshold sum value = p = 0
        upd = str2num(answer{4});            % define upper threshold sum value = p = 1
    
        fprintf('Working... Calculating neighbourhood Weights ... be patient.\n\n');
    end
    
    we=ones(nx,ny);				            % create erosion probability grid	
    we(nd_cells)=nan;				        % set nodata values to NaN
    we1=find(neros < lowe);			        % sum < lower threshold = 0
    we2=find(lowe <= neros & neros <= upe);	% linear rescale sum values to probability
    we(we1)=0;
    we(we2)=(neros(we2)-lowe)/(upe-lowe);
    
    wd=ones(nx,ny);                         % as above but for deposition neighbourhood
    wd(nd_cells)=nan;

    wd1=find(ndepos < lowd);
    wd2=find(lowd <= ndepos & ndepos <= upd);
    wd(wd1)=0;
    wd(wd2)=(ndepos(wd2)-lowd)/(upd-lowd);
    
%------Bayesian updating of prior probs using neighbourhood weights-------
if(BatchMode == 0)
    fprintf('Working... Calculating Bayesian Probabilities ... be patient.\n\n');
end

% a priori probability = priorp (0-1) not signed for eros or depos
% two update grids - we = erosion weights (0-1) defined for erosion cells
% and wd = deposition weights (0-1) defined for depos cells

% create a posteriori and temporary calculation grids
 
    postp=ones(nx,ny);		% create a posteriori grid
    postp(nd_cells)=nan;	% set nodata cells to NaN
    postp1=ones(nx,ny);		% create temp grid 1
    postp2=ones(nx,ny);		% create temp grid 2	
    priorp_no=1-priorp;
    
    
% calculate probabilities of no change, 1-p of change

    we_no=1-we;			    % prop of no change from erosion neighbourhood
    wd_no=1-wd;			    % prop of no change from deposition neighbourhood
    
    % OPTIONAL: Make a grid for conditional probability calculated by SC
    sc_cp=ones(nx,ny);
    sc_cp(nd_cells)=nan;
    sc_cp(ecells)=-we(ecells);
    sc_cp(dcells)=wd(dcells);
    io_Saver_SC_CondProb;
    
% a posterior update

    postp1(ecells)=(priorp(ecells).*we(ecells));
    postp2(ecells)=(priorp(ecells).*we(ecells))+(priorp_no(ecells).*we_no(ecells));
    check=find(postp2(ecells) == 0);
    postp2(ecells(check))=0.000001;
    postp(ecells)=postp1(ecells)./postp2(ecells);
    postp(ecells)= postp(ecells).*(-1);
    
    postp1(dcells)=(priorp(dcells).*wd(dcells));
    postp2(dcells)=(priorp(dcells).*wd(dcells))+(priorp_no(dcells).*wd_no(dcells));
    check=find(postp2(dcells) == 0);
    postp2(dcells(check))=0.000001;
    postp(dcells)=postp1(dcells)./postp2(dcells);
    
    toc;
	elapsed=toc;
	if(BatchMode == 0)
		fprintf('Finished calculations and output files. Calculation Time %5.2f [seconds]\n',elapsed)  
	end
 
    if(BatchMode == 0)
        %Message Box
	    h = msgbox('We are done with the calculations. Next you will be asked what part of the DoD uncertainty calculations you want to visualize the results of and/or save to ARC compatible files.','DoD Classifier Finished','help');
        uiwait(h);
	end

    

 
%---------------------------------------------------------------------
    if(BatchMode == 0)
		button = questdlg('Would you like to view plots of the a priori and post priori distributions?',...
		'Continue Operation','Yes','No','No');
		if strcmp(button,'Yes')
            disp('Creating figures')
            figure;
            Imagesc(signed_priorp);axis equal;colorbar;
            figure;
            Imagesc(postp);axis equal;colorbar;
        end    
	end
%---------------------------------------------------------------------
	if BatchMode == 0
        button_Step3d = questdlg('Would you like to save the a priori distribution to an ARC compatible ascii file?',...
		    'Continue Operation','Yes','No','Yes');
	end
	if strcmp(button_Step3d,'Yes')
%         priorp(ecells)= priorp(ecells).*(-1);           % make erosional cells negative probabilities
        io_Saver_PriorProb;
    end

%---------------------------------------------------------------------
    if BatchMode == 0
        button_Step3e = questdlg('Would you like to save the posterior distribution to an ARC compatible ascii file?',...
		    'Continue Operation','Yes','No','Yes');
	end
    if strcmp(button_Step3e,'Yes')
        io_Saver_PostProb; 
	end

%---------------------------------------------------------------------
   
   
% end program

