function make_s_function(fileName)
% 1) Capture old directory.
oldDirectory = pwd;

% 2) CD To this directory. 3) Compile based on what OS is being used and
[filePath, ~, fileExt] = fileparts(mfilename('fullpath'));

cd(fileparts(filePath));

% check if file exists.
if exist(fileName, 'file') ~= 2
    error(['File "',fileName,'" does not appear to exist.']);
end

if ispc
    compileForWindows(fileName)
    
elseif isunix
    % Linux-based compiling instructions . There is no
    % linux-based XPC Target machine (yet), but this is helpful to include
    % seperately for testing purposes on a Linux computer.
    
    compileForLinux(fileName)
    
elseif ismac
    warning(...
        ['Compiling has not been explicitly developed ', ...
        'for the OSx platform. Use this at your own risk.\n']);
    
    compileForLinux(fileName)
else
    error('Unknown operating system.');
end

% Return to old directory when compiling is complete, because MATLAB
% doesn't do it for you.

cd(oldDirectory);

end

% HELPER FUNCTIONS

% Compiles a given s-function for Windows
function compileForWindows(fileName)
fprintf(['Compiling "', fileName, '" for Windows... please wait.\n']);

end

% Compiles a given s-function for Linux.
function compileForLinux(fileName)
fprintf(['Compiling "',fileName,'"for Linux... please wait.\n']);
end