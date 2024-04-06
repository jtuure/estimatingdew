%Author: Juuso Tuure, juuso.tuure@helsinki.fi 7.8.2023

%This script reads FMI (Finnish Meteorological Institute) weather data as .csv files extracts the following parameters:
% timestamp - datetime time
% tamb - ambient temperature [degree C]
% tdew - dewpoint temperature [degree C]
% rain - percipitation [mm]
% windspeed - windspeed [m/s]
% N - cloud cover [Okta]

%combines the data from the separate .csv files and finally, stores the data as Matlab workspace variable and .xlsx
%spreadsheet with dynamic filenaming 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all; %Close all windows
clear; %Clear the Work space
clc; %Clear the command window

% Put here your weather data file names
%fileNames = {'hkivantaa_1.csv', 'hkivantaa_2.csv', 'hkivantaa_3.csv'};
fileNames = {'hkivantaa_1.csv', 'hkivantaa_2.csv', 'hkivantaa_3.csv';...
    'kumpula_1.csv', 'kumpula_2.csv', 'kumpula_3.csv'};
%%
[h,w] = size(fileNames);
for j = 1:h
% Load and process each CSV file
for i = 1:w
    
    % Load the CSV file
    T = readtable(fileNames{j,i});
    
    year = string(T.Year);
    month = string(T.m);
    day = string(T.d);
    clock = string(T.Time);
    
    %Convert the cells to a string
    timeasstring = strcat(month, '/', day, '/', string(year), {' '}, clock);
    
    %Convert the string array to datetime array
    timestamp = datetime(timeasstring, 'InputFormat','MM/dd/yyyy HH:mm');
    
    %Extract only necessary parameter arrays
    %If array type = String -> Convert to Double
    rain = convertToDoubleArray(T.PrecipitationAmount_mm_);
    tamb = convertToDoubleArray(T.AirTemperature_degC_);
    rh = convertToDoubleArray(T.RelativeHumidity___);
    windspeed = convertToDoubleArray(T.WindSpeed_m_s_);
    tdew = convertToDoubleArray(T.Dew_pointTemperature_degC_);
    N = convertToDoubleArray(T.CloudAmount_1_8_);
    
    % Conditioning the data
    %If it was not possible to determine the cloud cover (N = 9) then N = 8.
    N(N == 9) = 8;
    
    %Precipitation is measured only once per hour-> NaN-values between the scans are converted to 0
    rain(isnan(rain)) = 0;
    
    %Store the extracted variables for later combining
    extractedParameters{i} = [rain,tamb,rh,windspeed,N,tdew];
    extractedTimestamps{i} = timestamp;
end

%% Combine the extracted variables and timestamps into one (time)table
% and re-name the table variables
T1 = array2table(cat(1, extractedParameters{:}));
timestamp = cat(1,extractedTimestamps{:});
T1 = addvars(T1,timestamp,'Before','Var1');
T1.Properties.VariableNames =  ["timestamp", "rain","tamb",...
    "rh","windspeed","N","tdew"];

clear extractedParameters extractedTimestamps

%Omit duplicate rows
T1 = unique(T1);

%Convert Table to Time Table and save them as .mat variables with the same
TT1 = table2timetable(T1);

%% Create the .mat file name from the CSV file name (without extension)
[~, fileNameWithoutExt, ~] = fileparts(fileNames{j,i});
nameParts = strsplit(fileNameWithoutExt, '_');  % Split filename by underscore
matFileName = [nameParts{1}, '.mat'];
xlsFileName = [nameParts{1}, '.xlsx'];

save(matFileName, 'T1','TT1'); %save as workspace variables

%Print as spreadsheet table also
writetable(T1,xlsFileName);
end