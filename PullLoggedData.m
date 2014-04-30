% Retrieves data stored on the xPC target
scopeID = 10;
clear fsData fsTime
sc=getscope(tg,scopeID); % Get file scope (Id: 2)
fsys = xpctarget.fs; % Connect to the file system
h = fsys.fopen(sc.FileName); % Open the log file
fsysData = fsys.fread(h); % Read the data
fsys.fclose(h); % Close the log file
dataLog = readxpcfile(fsysData); % Convert uint8 data to double
fsTime = dataLog.data(:,end); % Get file scope time log
fsData = dataLog.data(:,1:end-1); % Get file scope data log
figure
plot(fsTime, fsData);% Plot the data
title('RawFileData');
legend('actual', 'measured')
save test.mat fsTime fsData; % Save the data

clear sc fsys h fsysData dataLog scopeID ans