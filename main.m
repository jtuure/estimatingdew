close all hidden; clear; clc;
%Author: Juuso Tuure, juuso.tuure@helsinki.fi 7.8.2023

run('fmiWeatherdataloader.m') % Loads the raw data files downloaded from FMI
run('interpolateData.m') % Interpolates missing datapoints
run('BeysensModel.m') % Runs the model and saves results in Excel spreadsheets
run('plotter.m') % Plots the cumulated and daily dews