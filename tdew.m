

function output = tdew(t, rh)
%Constants for calculating the saturated vapor pressure (psat)
%Constants taken from Sokhansanj, S. and Jayas, D.S. 2007.
%Drying of Foodstuffs. In: Mujumdar, A.S. Handbook of Industrial drying. 3rd ed. New York (NY): CRC Press. p. 526.
R = 22105649.25; 
A = -27405.526; 
B = 97.5413; 
C = -0.146244; 
d = 0.00012558; 
E = -0.000000048502; 
F = 4.34903; 
G = 0.0039381; 


%constansts for dewpoint temperature calculation taken
%from "Vaisala - humidity conversion formulas"
tn = 240.7263;
m = 7.591386;
a = 6.116441;


%Calculate  the saturated vapor pressure at temperature T
T = t + 273.15;
pwsat = R * exp((A + B.*T+ C.* T.^ 2 + d.* T.^ 3 + E.* T.^ 4) ./ (F.*T - G.*T.^ 2));

%Calculate the vapor pressure at air relative humimdity rh
pw = (pwsat.*(rh./100))/100; %here the vapor pressure is as hPa thaths why /100

%Calculate the dew point at temperature t and relative humidity rh
%tdew = tn./((m./log10(pw./a))-1); %This is the vaisala way.

tdew = (245.3.*log(pw./6.112))./(17.67-log(pw./6.112));
output = tdew;
end
