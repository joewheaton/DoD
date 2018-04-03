%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               Geomorphic Class Definition
%       for use with Sediment Budget Analysis 2.0 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   Produced by Joseph Wheaton                   %
%                        September 2007                          %
%                                                                %
%               Last Updated: 29 September, 2007                 
%                                                                %
%                                                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%
% This script gets the user defined classes.

if(BatchMode == 0)
	switch numClasses;
        case 1;
            def = {'Single Class'}
            prompt = {'1:'};
        case 2;
           def = {'Wet','Dry'};
           prompt = {'1:','2:'};   
        case 3;
           def = {'Channel','Bank','Bar'};
           prompt = {'1:','2:','3:'};   
        case 4;
           def = {'Class 1','Class 2','Class 3','Class 4'};
           prompt = {'1:','2:','3:','4:'};
        case 5;
%             def = {'Class 1','Class 2','Class 3','Class 4','Class 5'};
%             def = {'Sand','Gravel','Cobble','Vegetation','Channel and NoData'};
            def = {'Non Spawning Habitat','Very Poor Quality Spawning Habitat','Low Quality Spawning Habitat','Medium Quality Spawning Habitat','High Quality Spawning Habitat'};
            prompt = {'1:','2:','3:','4:','5:'};
        case 6;
            def = {'Outside SHR Placement Area','Non Spawning Habitat','Very Poor Quality Spawning Habitat','Low Quality Spawning Habitat','Medium Quality Spawning Habitat','High Quality Spawning Habitat'};
%            def = {'Class 1','Class 2','Class 3','Class 4','Class 5','Class 6'};
            prompt = {'1:','2:','3:','4:','5:','6:'};
        case 7;
            def = {'Class 1','Class 2','Class 3','Class 4','Class 5','Class 6','Class 7'};
            prompt = {'1:','2:','3:','4:','5:','6:','7:'};
        case 8;
            def = {'Channel Carving','Channel Deepening','Bar Sculpting','Bank Erosion','Questionable Change','Channel Plugging','Channel Filling','Bar Development'};
%             def = {'Class 1','Class 2','Class 3','Class 4','Class 5','Class 6','Class 7','Class 8'};
            prompt = {'1:','2:','3:','4:','5:','6:','7:','8:'};
        case 9;
%             def = {'Class 1','Class 2','Class 3','Class 4','Class 5','Class 6','Class 7','Class 8','Class 9'};
            def = {'Channel Carving','Channel Deepening','Bar Sculpting','Bank Erosion','Questionable Change','Channel Plugging','Channel Filling','Bar Development','Gravel Sheets'};
            prompt = {'1:','2:','3:','4:','5:','6:','7:','8:','9:'};
        case 10;
%             def = {'Bank Erosion','Channel Scour','Eddie Scour','Bar Sculpting','Central Bar Development','Point Bar Development','Pool Filling','Channel Filling','Eddie Deposition','Questionable Area'};
%             def = {'Backwater','Pool','Glide','Run','Riffle','Central Bar','Point Bar','Floodplain','Bank','Engineering Structure'};
            def = {'SHR Placed Gravel','Fluvial Deposition','SHR Induced Erosion','SHR Grading (cut)','Changes to SHR Placed Gravel','Fluvial Scour','Questionable Change','Placed Boulder','Not Resurveyed','SHR Placed Pea Gravel'};
%            def = {'Riffle Crest','Riffle','Chute','Lateral Bar','Point Bar','Central Bar','Pool','Boulders','Run','Pool Exit Slope'};

            prompt = {'1:','2:','3:','4:','5:','6:','7:','8:','9:','10:'};
    end

    dlg_title = 'Enter the classification categories for each integer.';
    answer  = inputdlg(prompt,dlg_title,1,def);
    
    for a=1:(length(answer));
        geoClasses{a} = answer{a};    
        
    end
    
else
    switch numClasses;
        case 2;
        case 3;
        case 4;
        case 5;
        case 6;
        case 7;
        case 8;
        case 9;
        case 10;
	end
end

% Save the categories to a table:

legend_filename= strcat(Dir_GSim, '/',gSimName,'_ClassLegend.csv');
fid25 = fopen(legend_filename, 'w');    
fprintf(fid25,'Class Value, Class Description\n'); 
for n=1:length(geoClasses);                                                      % Begin category loop
    fprintf(fid25,'%d,%s \n', n, geoClasses{n});
end  

fclose(fid25);    %close file
