        % SORT OUT FILE NAME AND PATH:

        tscore_name=strcat(Dir_Output, '/',metaD_DateNew,'-',metaD_DateOld,'_TScore.asc');

%------Write  file to an ARC ASCII format---------------------

    
		%Write a priori data to a temporary file in ARC format
            fid1= fopen('temp.txt', 'w');
                i=0;
                j=0;
                for i=1:ny;              % Begin main gridcell loop (rows)
                    for j=1:nx;          % Begin gridcell loop (collumns)
                        if ((tscore(j,i) == nodata) | (tscore(j,i) == 0));
                            fprintf(fid1, '-9999 ');  
                        else
                            fprintf(fid1, '%6.4f ',tscore(j,i));   
                        end
                    end                 % End gridcell loop (collumns)
                    fprintf(fid1, '\n');
                end                     % End main gridcell loop (rows)
            fclose(fid1);
            
            
            fid1 = fopen('temp.txt', 'r');
            fid2 = fopen(tscore_name, 'w');
                
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