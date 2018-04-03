% Stand-alone run of Geomorph
    BatchMode = 0;
    % FIND OUT PROJECT
    RootDirectory = pwd;
    start_path = strcat(RootDirectory,'/Projects');
    Dir_Project = uigetdir(start_path,'Select the project (a directory) with the simulation to analyse:');
    Dir_Input = strcat(Dir_Project,'/Input');
    Dir_Sim = strcat(Dir_Project,'/Simulations');    

    % CHOOSE SIMULATION TO ANALYSE
    cd(Dir_Sim);
    Dir_Run = uigetdir(Dir_Sim,'Select the run or simulation (a directory) to perform a geomorphic analysis on:');
    
    % FIGURE OUT PATHWAY
    
        filename=dir(fullfile(Dir_Run,'P*.csv'));
		
		%%%--------FIGURE OUT THE FILE-------------------------------
		%[filename, pathname]=uigetfile('*.csv','Select the DoD distribution file to add (csv format)');    
		filename_Dist= fullfile(Dir_Run, filename.name);
		
		
		%%%--------SORT OUT THE PATHWAY -----------------------
		% See how many collumns are in file:
		A = csvread(filename_Dist,1,0);
		[r,cols] = size(A);
		clear A ;
		
		% Reconstuct the pathWay from name and use number of colluns as a check
		pathWay = 0;   
		
		filename = filename.name;
		
		% Now disect the filename
		switch filename(1:2);
            case 'P1';
                if(cols == 5)
                    pathWay = 1;
                else
                   warndlg('Improperly formatted CSV file! Wrong number of columns for pathway 1 (should be 5).','Program closing!');
                   return
                end
            case 'P2';
                if(cols == 8)
                    pathWay = 2;
                else
                   warndlg('Improperly formatted CSV file! Wrong number of columns for pathway 2 (should be 8).','Program closing!');
                   return
                end
            case 'P3';
                if(cols == 8)
                    pathWay = 3;
                else
                   warndlg('Improperly formatted CSV file! Wrong number of columns for pathway 3 (should be 8).','Program closing!');
                   return
                end
            case 'P4';
                if(cols == 11)
                    pathWay = 4;
                else
                   warndlg('Improperly formatted CSV file! Wrong number of columns for pathway 4 (should be 11).','Program closing!');
                   return
                end
            case 'P5';
                if(cols == 11)
                    pathWay = 5;
                else
                   warndlg('Improperly formatted CSV file! Wrong number of columns for pathway 5 (should be 8).','Program closing!');
                   return
                end
            case 'P6';
                if(cols == 8)
                    pathWay = 6;
                else
                   warndlg('Improperly formatted CSV file! Wrong number of columns for pathway 6 (should be 8).','Program closing!');
                   return
                end
            otherwise
                warndlg('Improperly formatted CSV file! The filename needs to start with a P1 through P6 prefix to indicate the pathway.','Program closing!');
                return
		end

    % LOAD DoD
    cd(RootDirectory);
    io_Reader_DoD                               % Calls up io_Reader_DoD.m, which simply loads file to DoD
    numcells = nx*ny;                           % Number of grid cells
    cellarea = lx^2;
    DoD_Current = DoD;
    
    nd_cells=find(DoD == nodata);                   % Find nodata cell addresses in DoD
    DoD_Current(nd_cells)=nan;                      % Set no data cell to not a number
    
    % Specify Bins
    if(BatchMode == 0)
        m_BinDistributions;                          % Calls up m_BinDistributions.m and uses settings for rest of program
    end
    
    fromDoD2 = 0;
    m_5Geomorph;
    
    % MAKE SURE THESE ARE DEFINED for stand-alone:


    
    % MAKE SURE THESE ARE DEFINED FOR BATCH
    % BatchMode=1;
    % gSimName
    % GType
