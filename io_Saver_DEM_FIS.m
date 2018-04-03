%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       DEM FIS Saver
%       for use with Sediment Budget Analysis 1.1 
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
% This script simply saves the DEM FIS results to a file and writes a report file.
%

% REVISIONS
% Sediment Budget 1.0: 3 December 2004
%   Fall 2004 AGU results based on this version.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % SORT OUT FILE NAME AND PATH:
    cd(Dir_Output);
    
    if(userFilePref == 0)
        [filename,pathname]=uiputfile('*.asc','Save the Output DEM FIS to a File');    % Select final file name
        filename_FIS =[pathname filename '.asc']; 
    else
        if FIScount == 0;
            filename_FIS = strcat(Dir_Output, '/',metaD_DateNew,'_FIS.asc');
        elseif FIScount == 1;
            filename_FIS = strcat(Dir_Output, '/',metaD_DateOld,'_FIS.asc');
        end
        
    end
    
%------Write the DoD file to an ARC ASCII format---------------------
 
    %Write DEM FIS data to a temporary file in ARC format
    fid1= fopen('temp.txt', 'w');
        i=0;
        j=0;
        for i=1:ny;              % Begin main gridcell loop (rows)
            for j=1:nx;          % Begin gridcell loop (collumns)
                if ((UncGrid_FIS(j,i) == nodata));
                    fprintf(fid1, '%d ', UncGrid_FIS(j,i));  
                else    
                    fprintf(fid1, '%6.4f ',UncGrid_FIS(j,i));   
                end
            end                 % End gridcell loop (collumns)
            fprintf(fid1, '\n');
        end                     % End main gridcell loop (rows)
    fclose(fid1);
 
    fid1 = fopen('temp.txt', 'r');
    fid2 = fopen(filename_FIS, 'w');
    
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
 
    
    %-------Prouce an Output Report and Metadata File----------------
    if(userFilePref == 0)
        [filename,pathname]=uiputfile('*.txt','Save an Output Report and Metadata File');    % Select final file name
        filename_Report =[pathname filename '.txt']; 
    else
        if FIScount == 0;
            filename_Report = strcat(Dir_Output, '/',metaD_DateNew,'_FIS_Report.txt');
        elseif FIScount == 1;
            filename_Report = strcat(Dir_Output, '/',metaD_DateOld,'_FIS_Report.txt');

        end
        
    end
    
    when = datestr(now);
    
    fid3 = fopen(filename_Report, 'w');    %write a file
    
    
    %Header Inforamaton
    fprintf(fid3, '--------------DEM FIS Calculations Report and Metadata-------------- \n');
    fprintf(fid3, '-------------------------------------------------------------------- \n');
    fprintf(fid3, '\n');
    
    fprintf(fid3, 'This Fuzzy Inference System Calculation was to estimate elevation uncertainty in \n');
    if FIScount == 0;
        fprintf(fid3, 'a DEM that was surveyed in %s using %s. \n', metaD_DateNew, metaD_MethodNew);
    elseif FIScount == 1;
        fprintf(fid3, 'a DEM that was surveyed in %s using %s. \n ', metaD_DateOld, metaD_MethodOld);
    end
    fprintf(fid3, 'Date and Time Calculations Performed: \t %s \n', when);
    fprintf(fid3, 'Produced using DoD_2.m in MatLab.\n');
    fprintf(fid3, '\n');

    % What input files were used
    fprintf(fid3, 'INPUT DATA:---------------------------------------------------------------- \n');
    %fprintf(fid3, 'The DEM used was: %s \n', dem_filename);
    if(userFIS_Rough == 1)
        fprintf(fid3, 'The roughness surface used was: %s \n', filename_FIS_Rough);
    end
    if(userFIS_3DQ == 1)
        fprintf(fid3, 'The point quality surface used was: %s \n', filename_FIS_PQ);
    end
    if(userFIS_WetDry == 1)
        fprintf(fid3, 'The wet dry surface used was: %s \n', filename_FIS_WetDry);
	end
    if(userFIS_Slope == 1)
        fprintf(fid3, 'The slope analysis used was: %s \n', filename_FIS_Slope);
	end
    if(userFIS_PD == 1)
        fprintf(fid3, 'The point density surface used was: %s \n', filename_FIS_PD);
	end
    fprintf(fid3, '\n');
    fprintf(fid3, 'The input grids had a %6.3f meter grid resolution. %d \n', lx);
    fprintf(fid3, 'Each grid contained %d rows and %d collumns, making for %d grid cells.\n', nx, ny, numcells);
    fprintf(fid3, '\n');
    
    % Output File
    fprintf(fid3, 'OUTPUT DATA:---------------------------------------------------------------- \n');
    fprintf(fid3, 'An ARC compatible ascii Grid of the FIS output surface was written to:\n %s \n', filename_FIS);
    fprintf(fid3, '\n');        
          
    
    % Basic Stats
    fprintf(fid3,'Basic Elevation Uncertainty Statistics:\n');
    fprintf(fid3,'---------------------------------------\n');
    fprintf(fid3,'Average Elevation Uncertainty: %6.3f meters\n', meanFIS);
    fprintf(fid3,'Minimum Elevation Uncertainty: %6.3f meters\n', minFIS);
    fprintf(fid3,'Maximum Elevation Uncertainty: %6.3f meters\n', maxFIS);
    fprintf(fid3,'Standard Deviation of Elevation Uncertainty: %6.3f meters\n', stdFIS);
    fprintf(fid3,'2 x Std. Dev. of Elevation Uncertainty: %6.3f meters\n', (2*stdFIS));
    fprintf(fid3,'3 x Std. Dev. of Elevation Uncertainty: %6.3f meters\n', (3*stdFIS));
    fprintf(fid3, '\n');  
    
    
    fprintf(fid3, '--------------------------------------------------------------------------- \n');
    fprintf(fid3, '\n');  
    fprintf(fid3, 'End of File\n');  
    
    fclose(fid3);    %close file

    % RETURN BACK TO ROOT DIRECTORY
    cd(RootDirectory);