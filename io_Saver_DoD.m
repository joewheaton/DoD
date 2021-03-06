%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           DoD Saver
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
% This script simply saves the DoD results to a file.
%

% REVISIONS
% Sediment Budget 1.0: 3 December 2004
%   Fall 2004 AGU results based on this version.


% Sediment Budget 1.1: 1 March 2005
%   Discovered problem with output format of llcorner cells. The %d write
%   format was not saving in a consistent decimal notation and sometimes
%   even using an exponential notation. The problem was the introductoin of
%   minor rounding errors. This has been revised to used fixed point
%   notation %f format that maintains the 4 decimal places that ARC ascii
%   grids do.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
    % SORT OUT FILE NAME AND PATH:
    cd(Dir_Output);
    if(userFilePref == 0)       
        [filename,pathname]=uiputfile('*.asc','Save the Output DEM of Difference to a File');    % Select final file name
        DoD_file_name=[pathname filename '.asc'];   
    else
        DoD_file_name= strcat(Dir_Output, '/',metaD_DateNew,'-',metaD_DateOld,'_DoD.asc');
    end
%------Write the DoD file to an ARC ASCII format---------------------

     
        %Write DoD data to a temporary file in ARC format
        fid1= fopen('temp.txt', 'w');
            i=0;
            j=0;
            for i=1:ny;              % Begin main gridcell loop (rows)
                for j=1:nx;          % Begin gridcell loop (collumns)
                    if ((DoD(j,i) == nodata) | (DoD(j,i) == 0));
                        fprintf(fid1, '%d ',DoD(j,i));  
                    else    
                        fprintf(fid1, '%6.4f ',DoD(j,i));   
                    end
                end                 % End gridcell loop (collumns)
                fprintf(fid1, '\n');
            end                     % End main gridcell loop (rows)
        fclose(fid1);
     
        fid1 = fopen('temp.txt', 'r');
        fid2 = fopen(DoD_file_name, 'w');
        
        %% Write header in final file
        fprintf(fid2,'ncols \t %d \n', nx);
        fprintf(fid2,'nrows \t %d \n', ny);
        fprintf(fid2,'xllcorner \t %10.4f \n', xll);
        fprintf(fid2,'yllcorner \t %10.4f \n', yll);
        fprintf(fid2,'cellsize \t %d \n', lx);
        fprintf(fid2,'NODATA_value \t %d \n', nodata);
        
        while ~feof(fid1),
            st = fgetl(fid1);
            fprintf(fid2,'%s\n',st);
        end
        fclose(fid1); fclose(fid2);
        delete ('temp.txt');

    % RETURN BACK TO ROOT DIRECTORY
    cd(RootDirectory);