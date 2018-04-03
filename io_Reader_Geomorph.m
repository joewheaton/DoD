%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                      Geomorph Reader
%       for use with Sediment Budget Analysis 2.0 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        Produced by Joseph Wheaton & James Brasington           %
%                           December 2004                        %
%                                                                %
%               Last Updated: 3 December, 2004                  
%                                                                %
%                                                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%
% This script simply reads in the required input files for the geomorphic
% analysis.
%

% REVISIONS
% Sediment Budget 2.0: 3 December 2004
%   Fall 2004 AGU results based on this version.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% ASSUMING THAT DATA ARE STORED IN A NESTED FOLDER WORKING\INPUTS:
cd (Dir_Input);

%------Determine how to load data based on type -------------------------------------------------
if (strcmp(GType,'CoD')  == 1);
    %------Read in Data -------------------------------------------------
    % Read Newer Geomorphic Classification
    
    % Prompts User to select the most recent DEM file name
    if BatchMode == 0
        [filename, pathname]=uigetfile('*.asc','Select the more recent Geomorphic Classificaiton (ARC ascii format)');    
        filename_GeomorphNew=[pathname filename];
	end

    fid=fopen(filename_GeomorphNew,'r');      % opens file to fid in read only mode
    dum1=fscanf(fid,'%s',1);            % assigns first part of header (ncols) to dummy variable dum1 (%s is string notation)
    nx=fscanf(fid,'%u',1);              % stores actual number of collumns to nx (%u is decimal notation)
    dum2=fscanf(fid,'%s',1);            % assigns second line header info (nrows) to dummy variable dum2
    ny=fscanf(fid,'%u',1);              % stores actual number of rows to ny
    dum3=fscanf(fid,'%s',1);            % assigns third line header info (xllcorner) to dummy variable dum3
    xll=fscanf(fid,'%f',1);             % stores actual lower left x coordinate corner to xll (%f is fixed point notation)
    dum4=fscanf(fid,'%s',1);            % assigns fourth line header info (yllcorner) to dummy variable dum4
    yll=fscanf(fid,'%f',1);             % stores actual lower left y coordinate corner to yll
    dum5=fscanf(fid,'%s',1);            % assigns fifth line header info (cellsize) to dummy variable dum5
    lx=fscanf(fid,'%f',1);              % stores cell size in lx
    dum6=fscanf(fid,'%s',1);            % assigns sixth line header info (nodata) to dummy variable dum6
    nodata=fscanf(fid,'%f',1);          % stores the no data ARC tag to nodata
    newgeomorph=fscanf(fid,'%f',[nx,ny]);      % stores all of the cell data in a double array dimensioned according to nx and ny
    fclose(fid);                        % closes the file
    if(BatchMode == 0)
        fprintf('Done reading ARC data.\n');
        fprintf('\n')
	end
    
    % Read Older Geomorphic Classification
    
    % Prompts User to select the older geomorphic classification file name
    if BatchMode == 0
        [filename, pathname]=uigetfile('*.asc','Select the older Geomorphic Classificaiton (ARC ascii format)');    
        filename_GeomorphOld=[pathname filename];
	end

    fid=fopen(filename_GeomorphOld,'r');      % opens file to fid in read only mode
    dum1=fscanf(fid,'%s',1);            % assigns first part of header (ncols) to dummy variable dum1 (%s is string notation)
    nx2=fscanf(fid,'%u',1);              % stores actual number of collumns to nx (%u is decimal notation)
    dum2=fscanf(fid,'%s',1);            % assigns second line header info (nrows) to dummy variable dum2
    ny2=fscanf(fid,'%u',1);              % stores actual number of rows to ny
    dum3=fscanf(fid,'%s',1);            % assigns third line header info (xllcorner) to dummy variable dum3
    xll2=fscanf(fid,'%f',1);             % stores actual lower left x coordinate corner to xll (%f is fixed point notation)
    dum4=fscanf(fid,'%s',1);            % assigns fourth line header info (yllcorner) to dummy variable dum4
    yll2=fscanf(fid,'%f',1);             % stores actual lower left y coordinate corner to yll
    dum5=fscanf(fid,'%s',1);            % assigns fifth line header info (cellsize) to dummy variable dum5
    lx2=fscanf(fid,'%f',1);              % stores cell size in lx
    dum6=fscanf(fid,'%s',1);            % assigns sixth line header info (nodata) to dummy variable dum6
    nodata2=fscanf(fid,'%f',1);          % stores the no data ARC tag to nodata
    oldgeomorph=fscanf(fid,'%f',[nx2,ny2]);      % stores all of the cell data in a double array dimensioned according to nx and ny
    fclose(fid);                        % closes the file
    if(BatchMode == 0)
        fprintf('Done reading ARC data.\n');
        fprintf('\n')
	end
    
    % Check array dimensions are consistent between files 
    if(BatchMode == 0)
        fprintf('Checking to see if dimensions of grid files are consistent... \n');
	end
    if nx2~=nx
        nx2=nx
        warndlg('WARNING!!! The number of collumns were not equal between the two geomorphic classifications. You should quit the program and use compatible DEMs','DEM Incompatibility Warning');
    end
    if ny2~=ny
        ny2=ny
        warndlg('WARNING!!! The number of rows were not equal between the two geomorphic classifications. You should quit the program and use compatible DEMs','DEM Incompatibility Warning');
    end
    if(BatchMode == 0)
        fprintf('Okay. \n');
	end
    
elseif (strcmp(GType,'Mask')  == 1);
    %------Read in Data -------------------------------------------------
    % Read Mask Classification
    
    % Prompts User to select the most recent DEM file name
    if BatchMode == 0
        [filename, pathname]=uigetfile('*.asc','Select the geomorphic mask file (ARC ascii format)');    
        filename_GeomorphMask=[pathname filename];
	end

    fid=fopen(filename_GeomorphMask,'r');      % opens file to fid in read only mode
    dum1=fscanf(fid,'%s',1);            % assigns first part of header (ncols) to dummy variable dum1 (%s is string notation)
    nx=fscanf(fid,'%u',1);              % stores actual number of collumns to nx (%u is decimal notation)
    dum2=fscanf(fid,'%s',1);            % assigns second line header info (nrows) to dummy variable dum2
    ny=fscanf(fid,'%u',1);              % stores actual number of rows to ny
    dum3=fscanf(fid,'%s',1);            % assigns third line header info (xllcorner) to dummy variable dum3
    xll=fscanf(fid,'%f',1);             % stores actual lower left x coordinate corner to xll (%f is fixed point notation)
    dum4=fscanf(fid,'%s',1);            % assigns fourth line header info (yllcorner) to dummy variable dum4
    yll=fscanf(fid,'%f',1);             % stores actual lower left y coordinate corner to yll
    dum5=fscanf(fid,'%s',1);            % assigns fifth line header info (cellsize) to dummy variable dum5
    lx=fscanf(fid,'%f',1);              % stores cell size in lx
    dum6=fscanf(fid,'%s',1);            % assigns sixth line header info (nodata) to dummy variable dum6
    nodata=fscanf(fid,'%f',1);          % stores the no data ARC tag to nodata
    geomorphMask=fscanf(fid,'%f',[nx,ny]);      % stores all of the cell data in a double array dimensioned according to nx and ny
    fclose(fid);                        % closes the file
    if(BatchMode == 0)
        fprintf('Done reading ARC data.\n');
        fprintf('\n')
	end
    
end

% RETURN BACK TO ROOT DIRECTORY
cd(RootDirectory);

%------Determine number of classes -------------------------------------------------
    % Assumes only 1,2,3... 10 are avaialble classes
    
if (strcmp(GType,'CoD')  == 1);
    grid = newgeomorph;
else
    grid = geomorphMask;
end

Tst = isempty(find(grid == 10));
if(Tst == 0)
    numClasses = 10;
else
    Tst = isempty(find(grid == 9));
    if(Tst == 0)
        numClasses = 9;
	else
		Tst = isempty(find(grid == 8));
        if(Tst == 0)
            numClasses = 8;
		else
			Tst = isempty(find(grid == 7));
            if(Tst == 0)
                numClasses = 7;
			else
				Tst = isempty(find(grid == 6));
                if(Tst == 0)
                    numClasses = 6;
				else
					Tst =  isempty(find(grid == 5));
                    if(Tst == 0)
                        numClasses = 5;
					else
						Tst = isempty(find(grid == 4));
                        if(Tst == 0)
                            numClasses = 4;
						else
							Tst = isempty(find(grid == 3));
                            if(Tst == 0)
                                numClasses = 3;
							else
							    Tst = isempty(find(grid == 2));
                                if(Tst == 0)
                                    numClasses = 2;
                                else
                                    Tst = isempty(find(grid == 1));
                                    if(Tst == 0)
                                        numClasses = 1;
                                    else
                                        warndlg('Your input classification grids did not contain any positive integers less than 10 and the classification will not work.','WARNING!!!') 
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
	end
end
clear Tst
clear grid;
