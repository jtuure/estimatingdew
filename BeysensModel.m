%Author Juuso Tuure, juuso.tuure@helsinki.fi 11.7.2019
%Based on Beysens, D., 2016. Estimating dew yield worldwide from a few meteo data. Atmospheric Research 167, 146–155. https://doi.org/10.1016/j.atmosres.2015.07.018
close all;
clc;
clear;

%Variables needed
% N - cloud cover [Okta]
% windspeed [m/s]
% tamb - air temperature [degree C]
% rh - air relative humidity [%]
% rain - precipitation [mm]
% tdew  dew point temperature [degree C]



load hkivantaa.mat
timestamp_hkivantaa = T1.timestamp;
tamb_hkivantaa= T1.tamb;
tdew_hkivantaa= T1.tdew;
rain_hkivantaa= T1.rain;
rh_hkivantaa= T1.rh;
windspeed_hkivantaa= T1.windspeed;
N_hkivantaa= T1.N;
clear TT TT1

load kumpula.mat
timestamp_kumpula = T1.timestamp;
tamb_kumpula = T1.tamb;
tdew_kumpula= T1.tdew;
rain_kumpula= T1.rain;
rh_kumpula= T1.rh;
windspeed_kumpula= T1.windspeed;
N_kumpula= T1.N;
clear TT TT1



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Constants used in the calculation%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Elevations (m.a.s.l) of the measurement sites [km]:
H_kumpula = 43/1000;
H_hkivantaa = 50/1000;

windcutoff = 4.4; %Cut off value for windspeed  [m/s].
beta = 0.37; %Condensation rate–temperature correlation parameter [kg/h/W](Beysens 2016)
dt = 10; %Time step of the data [min]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calculatoins according to the Beysens (2016) model %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dh_dt_kumpula = dewBeysens(tdew_kumpula,tamb_kumpula,N_kumpula,windspeed_kumpula,windcutoff,beta,H_kumpula,dt);
dh_dt_hkivantaa = dewBeysens(tdew_hkivantaa,tamb_hkivantaa,N_hkivantaa,windspeed_hkivantaa,windcutoff,beta,H_hkivantaa,dt);



for i = 1:length(dh_dt_kumpula)
    if rain_kumpula(i,1) > 0 %IF there is rain, there is no dew condensation
        dh_dt_kumpula(i,1) = 0;
    end
    
    if rain_hkivantaa(i,1) > 0 %IF there is rain, there is no dew condensation
        dh_dt_hkivantaa(i,1) = 0;
    end
    
end

%Calculate daily dew accumulation with the timestep dt used for modelling
dh_daily_kumpula = dailySum(dh_dt_kumpula,dt);
dh_daily_hkivantaa = dailySum(dh_dt_hkivantaa,dt);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Saving the calculated data %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Replace NaN-values with 0
dh_dt_kumpula(isnan(dh_dt_kumpula)) = 0;
dh_daily_kumpula(isnan(dh_daily_kumpula)) = 0;
dh_dt_hkivantaa(isnan(dh_dt_hkivantaa)) = 0;
dh_daily_hkivantaa(isnan(dh_daily_hkivantaa)) = 0;


%Re-naming for saving
dtmin = timestamp_kumpula; %Timestamp array with dt minutes timestep
dt1d = dailyMin(datenum(dtmin),dt);%Timestamp array with 1 day timestep
dt1d = datetime(dt1d, 'ConvertFrom','datenum');


%Write the data in excel spreadsheets
%Write excel files as outputs for the
Tdt = [dh_dt_kumpula,dh_dt_hkivantaa];
Tdaily = [dh_daily_kumpula,dh_daily_hkivantaa];
Tdt = array2table(Tdt);
Tdaily = array2table(Tdaily);

Tdt = addvars(Tdt,dtmin,'Before','Tdt1');
Tdaily = addvars(Tdaily,dt1d,'Before','Tdaily1');

Tdt.Properties.VariableNames = {'timestampDatetime','dewKumpula', 'dewHkivantaa'};
Tdaily.Properties.VariableNames = {'timestampDatetime','dewKumpula','dewHkivantaa'};

writetable(Tdt,'beysensDew_dt.xlsx')
writetable(Tdaily,'beysensDew_daily.xlsx')

%Save the calculated dew yields from workspace as .mat
save 'beysensDew_daily.mat' 'dt1d' 'dh_daily_kumpula' 'dh_daily_hkivantaa'
save 'beysensDew_dt.mat' 'dtmin' 'dh_dt_kumpula' 'dh_dt_hkivantaa'

KumpulaTotal = sum(dh_daily_kumpula)
HkivantaaTotal = sum(dh_dt_hkivantaa)