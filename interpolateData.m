close all;
clear;
clc;
%%
%This interpolates the weather station data for missing data scans and
%missing values or re-times the data to desired time interval
fileNames = {'kumpula.mat';'hkivantaa.mat'};
for i = numel(fileNames)
load(fileNames{i})

%Select start and stop times and timestep
t1 = TT1.timestamp(1);
t2 = TT1.timestamp(end);
dt = 10; %Time step in minutes

%Create a new timestamp vector with dt minute time step
start=datenum(t1);
stop=datenum(t2);
timestep=dt/(60*24);%dt minute timestep
times_num=(start:timestep:stop)';
timestamp_dtmin = datetime(times_num,'ConvertFrom','datenum');

%Exclude the rain parameter from the timetable
RAIN = TT1(:,'rain');
ELSE = removevars(TT1,'rain');

%Re-time using linear interpolation 
% TT2 = retime(ELSE,timestamp_dtmin,'linear');

%Re-time using fill with constant "NaN"
TT2 = retime(ELSE,timestamp_dtmin);



%Re-time using fill with constant for precipitation
TT3 = retime(RAIN,timestamp_dtmin,'fillwithconstant','Constant',0);
rain_viikki = TT3.Variables;

%Re-time using sum for precipitation (use this if you increase the
%timestep
% TT3 = retime(RAIN,timestamp_dtmin,'sum');
% rain_viikki = TT3.Variables;

%Concatenate the re-timed datas
TT1 = addvars(TT2,TT3.rain,'Before','tamb','NewVariableNames','rain');

%create a table from the timetable and save the datas with dynamic
%naming of the workspace variable
T1 = timetable2table(TT1);

[~, fileNameWithoutExt, ~] = fileparts(fileNames{i});
nameParts = strsplit(fileNameWithoutExt, '_');  % Split filename by underscore
matFileName = [nameParts{1}, '.mat'];
xlsFileName = [nameParts{1}, '.xlsx'];

save(matFileName, 'T1','TT1'); %save as workspace variables

%save as spreadsheet table also
writetable(T1,xlsFileName);
end