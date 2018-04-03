%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   FOLDER MANAGEMENT
%       for use with Sediment Budget Analysis 2.0 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                      Produced by Joseph Wheaton                %
%                           August 2007                          %
%                                                                %
%                   Last Updated: 02 August 2007                 
%                                                                %
%                                                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%
% This function simply sets up all the appropriate paths to store and
% retrieve information from the project and individual simulation. It also
% collects some basic metadata for the simulation from the user.

%-------SET PROJECT PATHS---------------------  
    fMQuitter = 0;
    RootDirectory = pwd;
    
    % Check for Project Folders creates if not there.
    if((exist ('Projects')) == 0);
        mkdir 'Projects';
    end
    % Store 
    % SET REFERENCE PATHS
%     start_path = strcat(RootDirectory,'\Projects');
    start_path = strcat(RootDirectory,'/Projects');
    if(BatchMode == 0)
        Dir_Project = uigetdir(start_path,'Either select or create a project directory');
	end
    
    Dir_Input = strcat(Dir_Project,'/Input');
    Dir_Sim = strcat(Dir_Project,'/Simulations');    

    % Check for input directory  and simulation directory in project
    cd(Dir_Project);

    if exist (Dir_Input) == 0
        mkdir 'Input';
    end
    
    if exist (Dir_Sim) == 0
        mkdir 'Simulations';
    end
    
    % MAKE SIMULATION SUBFOLDERS
    cd(Dir_Sim);
    
    if(BatchMode == 0)
        %Message Box
        button_FM1 = questdlg('Within your project directory you should now have an input folder and a simulation folder. Your input files can be anywhere, but this program will default to look for them first in your input folder. All analyses will be output to a folder within the Simulation folder with your simulation name (next dialog). Do you want to continue to the next step, or quit and move your input files to the input folder?',...
		    'Notice!','Continue','Quit','Continue');
        if strcmp(button_FM1,'Quit')
            cd(RootDirectory);
            fMQuitter = 1;
            return
        end
    
        prompt = {'Enter the name for this set of analyses:'};
        dlg_title = 'Simulation Name';
        num_lines= 1;
        def     = {'Analysis 1'};
        RunName  = inputdlg(prompt,dlg_title,num_lines,def);
        RunName = char(RunName);
	end
    
   % Check to see if Run already exists
    if exist  (RunName) == 0
        mkdir (RunName)    
    else
        if(BatchMode == 0)
            button_FM2 = questdlg('A simulation already exists with this name! Do you want to continue and overwrite these files or try a different name? ',...
		    'WARNING!','Continue','Different Name','Quit','Different Name');
		    if strcmp(button_FM2,'Continue')
	
            elseif strcmp(button_FM2, 'Different Name')
                prompt = {'Enter the name for this set of analyses:'};
                dlg_title = 'Simulation Name';
                num_lines= 1;
                def     = {'Analysis 1'};
                RunName  = inputdlg(prompt,dlg_title,num_lines,def);
                % MAKE FILE        
                if exist  (RunName) == 0
                    mkdir (RunName)
                end
                
                clear prompt dlg_title num_lines def;
            elseif strcmp(button20, 'Quit')
                return
            end
        end
    end
   
    
    
    
    % Within Run, check to see if Output_Rasters Folder already Exists
    cd (RunName);
    Dir_Run = pwd;
    if((exist ('Output_Rasters')) == 0);
        mkdir 'Output_Rasters';
    end
	Dir_Output = strcat(Dir_Sim,'/',RunName,'/Output_Rasters');
	
    % ORIGINALLY HAD LOTS OF SUB-DIRECTORIES... NOT NECCESSARY!
% 	cd(Dir_Output);
%         % Check for output sub-directories
% 	
% 	
% 	Dir_NormalOutput = strcat(Dir_Output,'\1_Normal');
% 	Dir_UniformOutput = strcat(Dir_Output,'\2_Uniform');
% 	Dir_FISOutput = strcat(Dir_Output,'\3_FIS');
% 	Dir_BayesianOutput = strcat(Dir_Output,'\4_Bayesian');
% 	Dir_GeomorphOutput = strcat(Dir_Output,'\5_Geomorph');
% 	
% 	if exist (Dir_NormalOutput) == 0
%         mkdir '\1_Normal';
% 	end
% 	
% 	if exist (Dir_UniformOutput) == 0
%         mkdir '\2_Uniform';
% 	end
% 	
% 	if exist (Dir_FISOutput) == 0
%         mkdir '\3_FIS';
% 	end
% 	
% 	if exist (Dir_BayesianOutput) == 0
%         mkdir '\4_Bayesian';
% 	end
% 	
% 	if exist (Dir_GeomorphOutput) == 0
%         mkdir '\5_Geomorph';
% 	end
	
	
	cd(RootDirectory);
    
    % GET SOME META DATA FROM USER
    if(BatchMode == 0)
        %   dialog box to prompt user for lowbin and highbin and increment?
        prompt = {'Description of this simulation or set of analyses:','Date of more recent survey:','Date of older survey:','Method of more recent survey [GPS,TS,TLS,LiDAR,AP]','Method of older survey [GPS,TS,TLS,LiDAR,AP]','Notes on more recent survey', 'Notes on older survey'};
        dlg_title = 'Simulation Metadata (Used in output reports)';
        numlines = [5; 1; 1; 1; 1; 3; 3];
        def     = {'Gross DoD (no uncertainty analysis)','2006','2005','GPS','GPS','None','None'};
        answer  = inputdlg(prompt,dlg_title,numlines,def);
        
        % STORE DATA
        metaD_Desc = char(answer{1});
        metaD_DateNew = char(answer{2});  
        metaD_DateOld = char(answer{3});  
        metaD_MethodNew = char(answer{4});  
        metaD_MethodOld = char(answer{5});  
        metaD_NoteNew = char(answer{6});  
        metaD_NoteOld = char(answer{7});  
        
        
        %FIND OUT USER PREFERENCE FOR NAMING FILES
        userFilePref = 0;
        button_FM3 = questdlg('By default, this program will assign file names and save outputs to the appropriate project directories (STRONGLY RECCOMENDED). If you prefer to specify the name and path of all output files individually as you go (slower) you can choose to "Specify My Own" below; otherwise choose "Use Defaults".',...
        'File Output Settings','Use Defaults','Specify My Own','Use Defaults');
        if strcmp(button_FM3,'Use Defaults')
            userFilePref = 1;
        elseif strcmp(button_FM3, 'Specify My Own')
            userFilePref = 0;
        end
        
        
        % Get rid of garbage
        clear button20 prompt dlg_title num_lines def answer start_path prompt numlines num_lines;
    else
        userFilePref = 1;
    end