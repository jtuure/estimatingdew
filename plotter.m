close all
clear
clc

load beysensDew_daily.mat
load beysensDew_dt.mat

figure
hold on
title('daily dew accumulations')
plot(dt1d,cumsum(dh_daily_kumpula))
plot(dt1d,cumsum(dh_daily_hkivantaa))
legend('Kumpula FMI Data','Hki-Vantaa FMI',...
    'Location','northwest')

print(' totalDewBeysensModel', '-dpng', '-r600'); %<-Save as PNG with 600 DPI

figure
hold on
title('daily dew accumulations')
subplot(2,1,1)
bar(dt1d,dh_daily_kumpula,'FaceAlpha',0.3)
legend('Kumpula FMI Data','Location','northwest')
ylim([0 0.3])

subplot(2,1,2)
bar(dt1d,dh_daily_hkivantaa,'FaceAlpha',0.3)
legend('HkiVantaa FMI data','Location','northwest')
print(' dailyDewBeysensModel', '-dpng', '-r600'); %<-Save as PNG with 600 DPI
ylim([0 0.3])

KumpulaTotal = sum(dh_daily_kumpula)
HkivantaaTotal = sum(dh_daily_hkivantaa)

