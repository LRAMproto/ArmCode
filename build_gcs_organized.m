function build_gcs_organized()
% Written by David Rebhuhn, 10-24-2014
%
% This function builds the currently selected SIMULINK system with the
% SIMULINK real time coder, saving all generated code to a sub-directory
% called 'ProjectBuildFiles'. This does this independently of what the
% present working directory (pwd) is in order to minimize the number of
% times useless or redundant files are generated.
%
% Put this in the directory you want to generate
% ProjectBuildFiles/YOURPROJECT into. This function will automatically
% generate a folder with your compiled code in it named after the system.

oldDirectory = pwd;
project_name = gcs;

[filePath, ~, ~] = fileparts(mfilename('fullpath'));

% The following function locates all of the build files for a given model
% to a sub folder of this program. This feature helps avoid building
% project files where we don't want them.

saveDir = fullfile(filePath, 'ProjectBuildFiles',project_name);

disp(['Saving to ',saveDir]);

% Creates a sub-folder in builds if it needs to be created

if exist(saveDir,'dir') ~= 7
    mkdir(saveDir)
end

addpath(saveDir);

% Changes directory to this folder
cd(saveDir);

try
    % Builds the last selected system.
    rtwbuild(gcs);
    
catch err
    % Returns to the original directory in the event of a failure.
    cd(oldDirectory);
    rethrow(err);
end
% Returns to the original directory.
cd(oldDirectory);

end

