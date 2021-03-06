%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           Neighborhood Analysis Reader
%       for use with Sediment Budget Analysis 2.0 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               Produced by Joseph Wheaton                       %
%                      August 2007                               %
%                                                                %
%               Last Updated: 2 August 2007                 
%                                                                %
%                                                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%
% This script simply reads neighbourhood analysis grids if the user has already
% created them. This function is intended to read in raster data from
% an existing ARC ascii file. It inherits the variable names from the 
% parent program it is run in.
%

% REVISIONS
% Sediment Budget 1.0: 3 December 2004
%   Fall 2004 AGU results based on this version.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 


% ASSUMING THAT DATA ARE STORED IN A NESTED FOLDER WORKING\INPUTS:
cd (Dir_Input);


        cd(Dir_Input);
        % Prompts User to select the Erosion Neighbourhood file name
        if BatchMode == 0
            [filename, pathname]=uigetfile('*.asc','Select the Erosion Neighbourhood grid (ARC ascii format)');    
            filename_NbrhoodEros=[pathname filename];
        end
        %addpath('pathname');
        fid=fopen(filename_NbrhoodEros,'r');      % opens file to fid in read only mode
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
        neros=fscanf(fid,'%f',[nx,ny]);  % stores all of the cell data in a double array dimensioned according to nx and ny
        fclose(fid);                        % closes the file
        if(BatchMode == 0)
            fprintf('Done reading ARC data.\n');
            fprintf('\n')
        end
             
	% Read Deposition Neighbourhood data
        if BatchMode == 0
            [filename, pathname]=uigetfile('*.asc','Select the Deposition Neighbourhood grid (ARC ascii format)');    
            filename_NbrhoodDepos=[pathname filename];
        end
        fid=fopen(filename_NbrhoodDepos,'r');      % opens file to fid in read only mode
        dum1=fscanf(fid,'%s',1);
        nx2=fscanf(fid,'%u',1);
        dum2=fscanf(fid,'%s',1);
        ny2=fscanf(fid,'%u',1);
        dum3=fscanf(fid,'%s',1);
        xll2=fscanf(fid,'%f',1);
        dum4=fscanf(fid,'%s',1);
        yll2=fscanf(fid,'%f',1);
        dum5=fscanf(fid,'%s',1);
        lx2=fscanf(fid,'%f',1);
        dum6=fscanf(fid,'%s',1);
        nodata2=fscanf(fid,'%f',1);
        ndepos=fscanf(fid,'%f',[nx2,ny2]);
        fclose(fid);
        if(BatchMode == 0)
            fprintf('Done reading ARC data.\n');
            fprintf('\n');
        end
        
	% Check array dimensions are consistent between files 
    if(BatchMode == 0)    
        fprintf('Checking to see if dimensions of grid files are consistent... \n');
	end
        if nx2~=nx
            nx2=nx
            warndlg('WARNING!!! The number of collumns were not equal between the two neighbourhood grids. You should quit the program and use compatible DEMs','DEM Incompatibility Warning');
            return
        end
        if ny2~=ny
            ny2=ny
            warndlg('WARNING!!! The number of rows were not equal between the two neighbourhood grids. You should quit the program and use compatible DEMs','DEM Incompatibility Warning');
            return
        end
        if(BatchMode == 0)
            fprintf('Okay. \n')
        end
        clear dum1 dum2 dum3 dum4 dum5 dum6;
        cd(RootDirectory);