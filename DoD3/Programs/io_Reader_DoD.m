%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           DoD Reader
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
% This function is intended to read in raster data from an existing ARC ascii file.
% It inherits the variable names from the parent program it is run in.
%

% REVISIONS
% Sediment Budget 1.0: 3 December 2004
%   Fall 2004 AGU results based on this version.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% ASSUMING THAT DATA ARE STORED IN A NESTED FOLDER WORKING\INPUTS:
cd (Dir_Input);

%------Read in Data -------------------------------------------------
    % Read DoD data
    
    % Prompts User to select the file name
    if BatchMode == 0
        [filename, pathname]=uigetfile('*.asc','Select a DoD file (ARC ascii format)');    
        filename_DoD=[pathname filename];
	end
    fid=fopen(filename_DoD,'r');        % opens file to fid in read only mode
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
    DoD=fscanf(fid,'%f',[nx,ny]);       % stores all of the cell data in a double array dimensioned according to nx and ny
    fclose(fid);                        % closes the file
    if(BatchMode == 0)
        fprintf('Done reading ARC data.\n');
        fprintf('\n')
	end
    clear dum1 dum2 dum3 dum4 dum5 dum6;
    
    % RETURN BACK TO ROOT DIRECTORY
    cd(RootDirectory);