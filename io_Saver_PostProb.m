%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         Post (posteror) Probability Distriubtion Saver
%       for use with Sediment Budget Analysis 2.0 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        Produced by Joseph Wheaton & James Brasington           %
%                    August 2007                      %
%                                                                %
%               Last Updated: 2 August 2007                  
%                                                                %
%                                                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%
% sort out Nodata
postp(nd_cells) = nodata;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
    % SORT OUT FILE NAME AND PATH:
    cd(Dir_Output);
    if(userFilePref == 0)       
        [filename,pathname]=uiputfile('*.asc','Save the a priori probability distribution to file');    % Select final file name
        postp_file_name=[pathname filename '.asc'];   
    else
        postp_file_name= strcat(Dir_Output, '/',metaD_DateNew,'-',metaD_DateOld,'_PostProb.asc');
    end
%------Write  file to an ARC ASCII format---------------------

        
        postp(nd_cells)=nodata;       
		%Write a posti data to a temporary file in ARC format
            fid1= fopen('temp.txt', 'w');
                i=0;
                j=0;
                for i=1:ny;              % Begin main gridcell loop (rows)
                    for j=1:nx;          % Begin gridcell loop (collumns)
                        if ((postp(j,i) == nodata) || (DoD(j,i) == 0));
                            fprintf(fid1, '-9999 ');  
                        elseif((postp(j,i) >= -1) && (postp(j,i) <= 1))   
                            fprintf(fid1, '%6.4f ',postp(j,i));   
                        else
                            fprintf(fid1, '-9999 ');
                        end
                        
                    end                 % End gridcell loop (collumns)
                    fprintf(fid1, '\n');
                end                     % End main gridcell loop (rows)
            fclose(fid1);
            
            
            fid1 = fopen('temp.txt', 'r');
            fid2 = fopen(postp_file_name, 'w');
                
            %% Write header in final file
            fprintf(fid2,'ncols \t %d \n', nx);
            fprintf(fid2,'nrows \t %d \n', ny);
            fprintf(fid2,'xllcorner \t %d \n', xll);
            fprintf(fid2,'yllcorner \t %d \n', yll);
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