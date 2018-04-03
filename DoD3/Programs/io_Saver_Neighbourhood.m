%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     Neighbourhood Saver
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
% This script simply saves the Neighbourhood Grid results to a files.
%

% REVISIONS


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % SORT OUT FILE NAME AND PATH:
    cd(Dir_Output);  
    if(userFilePref == 0)
        [filename,pathname]=uiputfile('*.asc','Save the Neighborhood Erosion Grid to a File');    % Select final file name
        neros_file_name=[pathname filename '.asc'];   
    else
        neros_file_name= strcat(Dir_Output, '/',metaD_DateNew,'-',metaD_DateOld,'_nbr_eros.asc');
    end
%------Write the neros file to an ARC ASCII format---------------------

     
        %Write erosion neighbourhood data to a temporary file in ARC format
        fid1= fopen('temp.txt', 'w');
            i=0;
            j=0;
            for i=1:ny;              % Begin main gridcell loop (rows)
                for j=1:nx;          % Begin gridcell loop (collumns)
                    if ((neros(j,i) == nodata) | (neros(j,i) == 0));
                        fprintf(fid1, '%d ',neros(j,i));  
                    else 
                        fprintf(fid1, '%d ',neros(j,i));   
                    end
                end                 % End gridcell loop (collumns)
                fprintf(fid1, '\n');
            end                     % End main gridcell loop (rows)
        fclose(fid1);
     
        fid1 = fopen('temp.txt', 'r');
        fid2 = fopen(neros_file_name, 'w');
        
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

        %------Write the ndepos file to an ARC ASCII format---------------------
        % SORT OUT FILE NAME AND PATH:

        if(userFilePref == 0)
            [filename,pathname]=uiputfile('*.asc','Save the Neighborhood Deposition Grid to a File');    % Select final file name
            ndepos_file_name=[pathname filename '.asc'];   
        else
            ndepos_file_name= strcat(Dir_Output, '/',metaD_DateNew,'-',metaD_DateOld,'_nbr_depos.asc');
        end

     
        %Write deposition neighbourhood data to a temporary file in ARC format
        fid1= fopen('temp.txt', 'w');
            i=0;
            j=0;
            for i=1:ny;              % Begin main gridcell loop (rows)
                for j=1:nx;          % Begin gridcell loop (collumns)
                    if ((ndepos(j,i) == nodata) | (ndepos(j,i) == 0));
                        fprintf(fid1, '%d ',ndepos(j,i));  
                    else    
                        fprintf(fid1, '%d ',ndepos(j,i));   
                    end
                end                 % End gridcell loop (collumns)
                fprintf(fid1, '\n');
            end                     % End main gridcell loop (rows)
        fclose(fid1);
     
        fid1 = fopen('temp.txt', 'r');
        fid2 = fopen(ndepos_file_name, 'w');
        
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