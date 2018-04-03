%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Neighbourhood Index  Spatial Classifier
%       for use with Sediment Budget Analysis 2.0 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                      Produced by Joseph Wheaton                %
%                           July 2007                            %
%                                                                %
%               Last Updated: 28 July 2007                 
%                                                                %
%                                                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%
% Script to build neighboughood index spatial classifier 

% DO SPATIAL CLASSIFICATION

% Loop through grid and do 5x5 moving window loop for each cell

for i=1:ny;              % Begin main gridcell loop (rows)
    for j=1:nx;          % Begin gridcell loop (collumns)
        if ((DoD(j,i) ~= nodata) & (DoD(j,i) ~= 0));

            % 5x5 Convolution (Moving Window)
            ecount = 0;
            dcount = 0;
            for iy=1:5;         %  rows
                if(((i+iy-3) > 0) & ((i+iy-3) <= ny)); % Make sure not off grid (top or bottom)
                    for jx=1:5; % collumns
                         if(((j+jx-3) > 0) & ((j+jx-3) <= nx)); % Make sure not off grid (left or right)       
                            if(DoD_Current((j+jx-3),(i+iy-3)) < 0); % Count as Erosion
                               ecount = ecount + 1;    
                            elseif(DoD_Current((j+jx-3),(i+iy-3)) > 0); % Count as Deposition
                               dcount = dcount + 1;
                            end
                         end
                    end                     
                end
            end
            
            % Record ecount and dcount
            neros(j,i) = ecount;
            ndepos(j,i) = dcount;
        end
    end                 % End gridcell loop (collumns)
end                     % End main gridcell loop (rows)
   

% for i=1:ny;              % Begin main gridcell loop (rows)
%     for j=1:nx;          % Begin gridcell loop (collumns)
%         if ((DoD(j,i) ~= nodata) & (DoD(j,i) ~= 0));
% 
%             % 7x7 Convolution (Moving Window)
%             ecount = 0;
%             dcount = 0;
%             for iy=1:5;         %  rows
%                 if(((i+iy-4) > 0) & ((i+iy-3) <= ny)); % Make sure not off grid (top or bottom)
%                     for jx=1:7; % collumns
%                          if(((j+jx-4) > 0) & ((j+jx-4) <= nx)); % Make sure not off grid (left or right)       
%                             if(DoD_Current((j+jx-4),(i+iy-4)) < 0); % Count as Erosion
%                                ecount = ecount + 1;    
%                             elseif(DoD_Current((j+jx-4),(i+iy-4)) > 0); % Count as Deposition
%                                dcount = dcount + 1;
%                             end
%                          end
%                     end                     
%                 end
%             end
%             
%             % Record ecount and dcount
%             neros(j,i) = ecount;
%             ndepos(j,i) = dcount;
%         end
%     end                 % End gridcell loop (collumns)
% end                     % End main gridcell loop (rows)