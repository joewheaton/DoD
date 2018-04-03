%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 FIS Inputs Loader                     
%       for use with Sediment Budget Analysis 2.0 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               Produced by Joseph Wheaton                       %
%                      August 2007                               %
%                                                                %
%               Last Updated: 3 August 2007                 
%                                                                %
%                                                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%
% This script simply loads the requistite FIS inputs.
%
userFIS_Rough = 0;
userFIS_Slope = 0;
userFIS_3DQ = 0;
userFIS_WetDry = 0;
userFIS_PD = 0;

%Message Box
if(BatchMode == 0)
    h = msgbox('In a moment, you will be prompted to open a series of files to calculate elevation uncertainties in an individual DEM. If you are doing this twice, make sure to load the newer files first, and older files second. All the files should be on the same grid and derived from the same DEM. WARNING! These calculations can take several minutes. As long as MATLAB still reports to be busy, you are probably okay.','DEM Fuzzy Inference System Uncertainty Calculator','help');
    uiwait(h);
else % parse over the right button values depending on which pass (FIScount)
    if FIScount == 0;
       button_Step2b_1 = button_Step2b_1_count0;
       button_Step2b_2 = button_Step2b_2_count0;
       button_Step2b_3 = button_Step2b_3_count0;
       button_Step2b_4 = button_Step2b_4_count0;
       button_Step2b_5 = button_Step2b_5_count0;
        
       filename_FIS_Slope = filename_FIS_Slope_count0;
       filename_FIS_PD = filename_FIS_PD_count0;
       filename_FIS_Rough = filename_FIS_Rough_count0;
       filename_FIS_PQ = filename_FIS_PQ_count0;
       filename_FIS_WetDry = filename_FIS_WetDry_count0;
        

    elseif FIScount == 1;
        
       button_Step2b_1 = button_Step2b_1_count1;
       button_Step2b_2 = button_Step2b_2_count1;
       button_Step2b_3 = button_Step2b_3_count1;
       button_Step2b_4 = button_Step2b_4_count1;
       button_Step2b_5 = button_Step2b_5_count1;
        
       filename_FIS_Slope = filename_FIS_Slope_count1;
       filename_FIS_PD = filename_FIS_PD_count1;
       filename_FIS_Rough = filename_FIS_Rough_count1;
       filename_FIS_PQ = filename_FIS_PQ_count1;
       filename_FIS_WetDry = filename_FIS_WetDry_count1;
        

    end
end

% ASSUMING THAT DATA ARE STORED IN A NESTED FOLDER WORKING\INPUTS:
cd (Dir_Input);
    % Read Slope Analysis data
   if(BatchMode == 0)
       if FIScount == 0;
           button_Step2b_1 = questdlg(strcat('Do you have a slope analysis to use for_',metaD_DateNew,'?'),...
		        'FIS Input Data','Yes','No','Yes');
       elseif FIScount == 1;
           button_Step2b_1 = questdlg(strcat('Do you have a slope analysis to use for_',metaD_DateOld,'?'),...
			    'FIS Input Data','Yes','No','Yes');
       end
	end
   if strcmp(button_Step2b_1,'Yes');
        
        if(BatchMode == 0)
            if FIScount == 0;
                [filename, pathname]=uigetfile('*.asc',strcat('Select the_',metaD_DateNew,'  Slope Analysis (ARC ascii format)'));
            elseif FIScount == 1;
                [filename, pathname]=uigetfile('*.asc',strcat('Select the_',metaD_DateOld,'  Slope Analysis (ARC ascii format)'));
            end
            
            filename_FIS_Slope=[pathname filename];
        end
        fid=fopen(filename_FIS_Slope,'r');      % opens file to fid in read only mode
        dum1=fscanf(fid,'%s',1);
        nx5=fscanf(fid,'%u',1);
        dum2=fscanf(fid,'%s',1);
        ny5=fscanf(fid,'%u',1);
        dum3=fscanf(fid,'%s',1);
        xll5=fscanf(fid,'%f',1);
        dum4=fscanf(fid,'%s',1);
        yll5=fscanf(fid,'%f',1);
        dum5=fscanf(fid,'%s',1);
        lx5=fscanf(fid,'%f',1);
        dum6=fscanf(fid,'%s',1);
        nodata5=fscanf(fid,'%f',1);
        slope=fscanf(fid,'%f',[nx5,ny5]);
        fclose(fid);
        if(BatchMode == 0)
            fprintf('Done reading ARC Slope data.\n');
            fprintf('\n');
        end
        
        % Check array dimensions are consistent between files 
        if  nx == nx5 % Use only if loading DEM
            if(BatchMode == 0)
                fprintf('Collumns Okay. \n'); 
            end
        else   
            warndlg('WARNING!!! The number of columns were not equal in your FIS slope input files. You should quit the program and use compatible grids','Grid Incompatibility Warning');
            return
        end
        if ny5 == ny  % Use only if loading DEM
            if(BatchMode == 0)
                fprintf('Rows Okay. \n');
            end
        else   
            warndlg('WARNING!!! The number of rows were not equal in your FIS slope input files. You should quit the program and use compatible grids','Grid Incompatibility Warning');
            return
        end
        userFIS_Slope = 1;
    else            
        cd(RootDirectory);
        warndlg('You can not do an FIS analysis without a slope analysis. This program will quite now.','WARNING!');
        return
    end
    
    % Read Point Density Data
    if(BatchMode == 0)
        if FIScount == 0;
               button_Step2b_2 = questdlg(strcat('Do you have a point density grid to use for_',metaD_DateNew,'?'),...
			        'FIS Input Data','Yes','No','Yes');
       elseif FIScount == 1;
               button_Step2b_2 = questdlg(strcat('Do you have a point density grid to use for_',metaD_DateOld,'?'),...
				    'FIS Input Data','Yes','No','Yes');
       end
    end
   if strcmp(button_Step2b_2,'Yes');
       if(BatchMode == 0) 
            if FIScount == 0;
                [filename, pathname]=uigetfile('*.asc',strcat('Select the_',metaD_DateNew,'  point density surface (ARC ascii format)'));
            elseif FIScount == 1;
                [filename, pathname]=uigetfile('*.asc',strcat('Select the_',metaD_DateOld,'  point density surface (ARC ascii format)'));
            end
            filename_FIS_PD=[pathname filename];
        end
        fid=fopen(filename_FIS_PD,'r');      % opens file to fid in read only mode
        dum1=fscanf(fid,'%s',1);
        nx6=fscanf(fid,'%u',1);
        dum2=fscanf(fid,'%s',1);
        ny6=fscanf(fid,'%u',1);
        dum3=fscanf(fid,'%s',1);
        xll6=fscanf(fid,'%f',1);
        dum4=fscanf(fid,'%s',1);
        yll6=fscanf(fid,'%f',1);
        dum5=fscanf(fid,'%s',1);
        lx6=fscanf(fid,'%f',1);
        dum6=fscanf(fid,'%s',1);
        nodata6=fscanf(fid,'%f',1);
        density=fscanf(fid,'%f',[nx6,ny6]);
        fclose(fid);
        if(BatchMode == 0)
            fprintf('Done reading ARC point density data.\n');
            fprintf('\n');  
        end
        % Check array dimensions are consistent between files 
        if  nx5 == nx6 % Use only if loading DEM
            if(BatchMode == 0)
                fprintf('Collumns Okay. \n'); 
            end
        else   
            warndlg('WARNING!!! The number of columns were not equal in your point density FIS input files. You should quit the program and use compatible grids','Grid Incompatibility Warning');
            return
        end
        if ny5 == ny6  % Use only if loading DEM
            if(BatchMode == 0)
                fprintf('Rows Okay. \n');
            end
        else   
            warndlg('WARNING!!! The number of rows were not equal in your point density FIS input files. You should quit the program and use compatible grids','Grid Incompatibility Warning');
            return
        end
        
        cellarea = lx5^2;                    % Area of one grid cell in square meters
        
        userFIS_PD = 1;
    else            
        cd(RootDirectory);
        warndlg('You can not do an FIS analysis without a roughness analysis. This program will quite now.','WARNING!');
        return
    end
      
% Read Roughness data
   if(BatchMode == 0)
        if FIScount == 0;
           button_Step2b_3 = questdlg(strcat('Do you have a roughness grid to use for_',metaD_DateNew,'?'),...
		        'FIS Input Data','Yes','No','Yes');
       elseif FIScount == 1;
           button_Step2b_3 = questdlg(strcat('Do you have a roughness grid to use for_',metaD_DateOld,'?'),...
			    'FIS Input Data','Yes','No','Yes');
       end
	end
    if strcmp(button_Step2b_3,'Yes');
        if(BatchMode == 0)
            if FIScount == 0;
                [filename, pathname]=uigetfile('*.asc',strcat('Select the_',metaD_DateNew,'  roughness surface (ARC ascii format)'));
            elseif FIScount == 1;
                [filename, pathname]=uigetfile('*.asc',strcat('Select the_',metaD_DateOld,'  roughness surface (ARC ascii format)'));
            end
            filename_FIS_Rough=[pathname filename];
        end
        %addpath('pathname');
        fid=fopen(filename_FIS_Rough,'r');      % opens file to fid in read only mode
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
        roughness=fscanf(fid,'%f',[nx2,ny2]);
        fclose(fid);
        if(BatchMode == 0)
            fprintf('Done reading ARC roughness data.\n');
            fprintf('\n');
        end
        % Check array dimensions are consistent between files 
        if  nx5 == nx2 % Use only if loading DEM
            if(BatchMode == 0)
                fprintf('Collumns Okay. \n');
            end
        else   
            warndlg('WARNING!!! The number of columns were not equal in your FIS roughness input files. You should quit the program and use compatible grids','Grid Incompatibility Warning');
            return
        end
        if ny5 == ny2  % Use only if loading DEM
            if(BatchMode == 0)
                fprintf('Rows Okay. \n'); 
            end
        else   
            warndlg('WARNING!!! The number of rows were not equal in your FIS roughness input files. You should quit the program and use compatible grids','Grid Incompatibility Warning');
            return
        end
        userFIS_Rough = 1;
    else
        userFIS_Rough = 0;
    end
 userFIS_Rough = 0;
 
% Read 3D Point Quality data
   if(BatchMode == 0)
       if FIScount == 0;
           button_Step2b_4 = questdlg(strcat('Do you have any 3D point or instrument quality data (typically from GPS) to use for_',metaD_DateNew,'?'),...
		        'FIS Input Data','Yes','No','Yes');
       elseif FIScount == 1;
           button_Step2b_4 = questdlg(strcat('Do you have any 3D point or instrument quality data (typically from GPS) to use for_',metaD_DateOld,'?'),...
			    'FIS Input Data','Yes','No','Yes');
       end
	end
   if strcmp(button_Step2b_4,'Yes');
       if(BatchMode == 0) 
           if FIScount == 0;
                [filename, pathname]=uigetfile('*.asc',strcat('Select the_',metaD_DateNew,'  3D Point Quality Surface (ARC ascii format)'));
            elseif FIScount == 1;
                [filename, pathname]=uigetfile('*.asc',strcat('Select the_',metaD_DateOld,'  3D Point Quality Surface (ARC ascii format)'));
            end
            filename_FIS_PQ=[pathname filename];
        end

        fid=fopen(filename_FIS_PQ,'r');      % opens file to fid in read only mode
        dum1=fscanf(fid,'%s',1);
        nx3=fscanf(fid,'%u',1);
        dum2=fscanf(fid,'%s',1);
        ny3=fscanf(fid,'%u',1);
        dum3=fscanf(fid,'%s',1);
        xll3=fscanf(fid,'%f',1);
        dum4=fscanf(fid,'%s',1);
        yll3=fscanf(fid,'%f',1);
        dum5=fscanf(fid,'%s',1);
        lx3=fscanf(fid,'%f',1);
        dum6=fscanf(fid,'%s',1);
        nodata3=fscanf(fid,'%f',1);
        pointquality=fscanf(fid,'%f',[nx3,ny3]);
        fclose(fid);
        if(BatchMode == 0)
            fprintf('Done reading ARC Point Quality data.\n');
            fprintf('\n'); 
        end
        % Check array dimensions are consistent between files 
        if  nx5 == nx3 % Use only if loading DEM
            if(BatchMode == 0)
                fprintf('Collumns Okay. \n'); 
            end
        else   
            warndlg('WARNING!!! The number of columns were not equal in your FIS 3D Point Quality input files. You should quit the program and use compatible grids','Grid Incompatibility Warning');
            return
        end
        if ny5 == ny3  % Use only if loading DEM
            if(BatchMode == 0)
                fprintf('Rows Okay. \n'); 
            end
        else   
            warndlg('WARNING!!! The number of rows were not equal in your FIS 3D Point Quality input files. You should quit the program and use compatible grids','Grid Incompatibility Warning');
            return
        end        
        userFIS_3DQ = 1;
    else
        userFIS_3DQ = 0;
    end
    
        
        
    % Read Wet Dry data
   if(BatchMode == 0) 
       if FIScount == 0;
           button_Step2b_5 = questdlg(strcat('Do you have a wet/dry grid (where dry is 0 and wet is water depth) to use for_',metaD_DateNew,'?'),...
		        'FIS Input Data','Yes','No','Yes');
       elseif FIScount == 1;
           button_Step2b_5 = questdlg(strcat('Do you have a wet/dry grid (where dry is 0 and wet is water depth) to use for_',metaD_DateOld,'?'),...
			    'FIS Input Data','Yes','No','Yes');
       end    
   end
   if strcmp(button_Step2b_5,'Yes');
        if(BatchMode == 0) 
           if FIScount == 0;
                [filename, pathname]=uigetfile('*.asc',strcat('Select the_',metaD_DateNew,'  Wet Dry data (ARC ascii format)'));
            elseif FIScount == 1;
                [filename, pathname]=uigetfile('*.asc',strcat('Select the_',metaD_DateOld,'  Wet Dry data (ARC ascii format)'));
            end
            filename_FIS_WetDry=[pathname filename];
        end
        fid=fopen(filename_FIS_WetDry,'r');      % opens file to fid in read only mode
        dum1=fscanf(fid,'%s',1);
        nx4=fscanf(fid,'%u',1);
        dum2=fscanf(fid,'%s',1);
        ny4=fscanf(fid,'%u',1);
        dum3=fscanf(fid,'%s',1);
        xll4=fscanf(fid,'%f',1);
        dum4=fscanf(fid,'%s',1);
        yll4=fscanf(fid,'%f',1);
        dum5=fscanf(fid,'%s',1);
        lx4=fscanf(fid,'%f',1);
        dum6=fscanf(fid,'%s',1);
        nodata4=fscanf(fid,'%f',1);
        wetdry=fscanf(fid,'%f',[nx4,ny4]);
        fclose(fid);
        if(BatchMode == 0)
            fprintf('Done reading ARC Wet Dry data.\n');
            fprintf('\n');
        end
        % Check array dimensions are consistent between files 
        if  nx5 == nx4 % Use only if loading DEM
            if(BatchMode == 0)
                fprintf('Collumns Okay. \n'); 
            end
        else   
            warndlg('WARNING!!! The number of columns were not equal in your wet dry FIS input files. You should quit the program and use compatible grids','Grid Incompatibility Warning');
            return
        end
        if ny5 == ny4  % Use only if loading DEM
            if(BatchMode == 0)
                fprintf('Rows Okay. \n'); 
            end
        else   
            warndlg('WARNING!!! The number of rows were not equal in your wet dry FIS input files. You should quit the program and use compatible grids','Grid Incompatibility Warning');
            return
        end        
        
        
        userFIS_WetDry = 1;
    else
        userFIS_WetDry = 0;
    end  

    
%   fprintf('The DEM used was: %s \n', dem_filename);
%     fprintf('The roughness surface used was: %s \n', rougness_filename);
%     fprintf('The point quality surface used was: %s \n', pointquality_filename);
%     fprintf('The wet dry surface used was: %s \n', wetdry_filename);
%     fprintf('The slope analysis used was: %s \n', slope_filename); 
%     fprintf('The point density surface used was: %s \n', density_filename); 
    
    clear dum1 dum2 dum3 dum 4 dum5 dum6;
    
       % RETURN BACK TO ROOT DIRECTORY
    cd(RootDirectory);
    

    
    % DETERMINE FIS TYPE

    if(userFIS_Rough == 1 & userFIS_3DQ == 1 & userFIS_WetDry == 1)
        FIStype = 'DEM_FIS_v2.fis';
    elseif(userFIS_Rough == 0 & userFIS_3DQ == 1 & userFIS_WetDry == 0)
        FIStype = 'ZFIS_PD_SLP_PQ.fis';
%     elseif(userFIS_Rough == 1 & userFIS_3DQ == 1 & userFIS_WetDry == 1)
%         FIStype = 'DEM_FIS_v2.fis';    
    else    % Must just be Slope and PD
       FIStype = 'ZFIS_PD_SLP.fis';
    end

    % Save filenames for ouptut report!
    
    if FIScount == 0;
       button_Step2b_1_count0 = button_Step2b_1;
       button_Step2b_2_count0 = button_Step2b_2;
       button_Step2b_3_count0 = button_Step2b_3;
       button_Step2b_4_count0 = button_Step2b_4;
       button_Step2b_5_count0 = button_Step2b_5;

       filename_FIS_Slope_count0 = filename_FIS_Slope;
       filename_FIS_PD_count0 = filename_FIS_PD;
       
       if(userFIS_Rough == 1)
           filename_FIS_Rough_count0 = filename_FIS_Rough; 
        else
           filename_FIS_Rough_count0 = 'NA';
        end
       
       
       if(userFIS_3DQ == 1)
          filename_FIS_PQ_count0 = filename_FIS_PQ;
        else
           filename_FIS_PQ_count0 = 'NA';
        end
       
      
        if(userFIS_WetDry == 1)
           filename_FIS_WetDry_count0 = filename_FIS_WetDry;
        else
           filename_FIS_WetDry_count0 = 'NA';
        end

    elseif FIScount == 1;
        button_Step2b_1_count1 = button_Step2b_1;
        button_Step2b_2_count1 = button_Step2b_2;
        button_Step2b_3_count1 = button_Step2b_3;
        button_Step2b_4_count1 = button_Step2b_4;
        button_Step2b_5_count1 = button_Step2b_5;       
        
        filename_FIS_Slope_count1 = filename_FIS_Slope;
        filename_FIS_PD_count1 = filename_FIS_PD;
     
        if(userFIS_Rough == 1)
           filename_FIS_Rough_count1 = filename_FIS_Rough; 
        else
           filename_FIS_Rough_count1 = 'NA';
        end
       
       
       if(userFIS_3DQ == 1)
          filename_FIS_PQ_count1 = filename_FIS_PQ;
        else
           filename_FIS_PQ_count1 = 'NA';
        end
       
      
        if(userFIS_WetDry == 1)
           filename_FIS_WetDry_count1 = filename_FIS_WetDry;
        else
           filename_FIS_WetDry_count1 = 'NA';
        end
    end