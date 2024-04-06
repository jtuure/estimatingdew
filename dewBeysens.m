%This function calculates dew accumulation as in the model in the paper by
%Beysens (2016).
%Parameters needed for the calculation:
%1. tdew - dew point temperature [degree C]
%2. tamb - air temperature [degree C]
%3. N - cloud cover [Okta]
%4. windspeed - windspeed [m/s]
%5. windcutoff - windcutoff constant

%For daily accumulation dh/dt (1440 minutes in a day so 1440/dt timesteps in a day)
function dewBeysens = dewBeysens(tdew,tamb,N,windspeed,windcutoff,beta,H,dt)

dewBeysens = (((beta*skyemis(tdew,H).*cloudeffect(tdew,N)))...
    + alpha(tdew,tamb).*windeffect(windspeed,windcutoff))/(1440/dt);

%According to Beysens (2016) condensation can't be negative (i.e. evaporation is ignored)
dewBeysens(dewBeysens <= 0) = 0;

%The alpha constant Condensation rate–temperature correlation parameter [kg·h?1·m?2·K?1]
function alpha = alpha(tdew,tamb)
alpha = 0.06*(tdew-tamb);
end

%Sky emissivity (K^4) empirically derived equation from Berger et al. 1992. Clear sky radiation as a function of altitude. Renewable Energy 2, 139–157. https://doi.org/10.1016/0960-1481(92)90100-H
function skyemis = skyemis(tdew,H)
    skyemis = 1+0.204323*H - 0.0238893*H^2 -(18.0132 - 1.04963*H + 0.21891*H^2)...
        *(10^-3).*tdew;
end

%The effect of clouds
function cloudeffect = cloudeffect(tdew,N)
cloudeffect = (((tdew+273.15)./285).^4).*(1-N./8); %The effect of cloud cover
end

%The effect of wind
function windeffect = windeffect(windspeed,windcutoff)
windeffect  = 1+100*(1-exp(-(windspeed/windcutoff).^20)); %Effect of wind
end
end