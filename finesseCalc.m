close all; clc; clear all;

%% Load data
filename = 'C:\Users\Adam\Documents\My Homework\PHYS 408\phys408OpticalCavity\Cleaned Data.mat';
load(filename);
%% Akshivs Code
% figure(1)
% plot(Time_10cmZoomed,Data_10cmZoomed, '.-');
% hold on
% plot(Time_10cmZoomed,Ramp_10cmZoomed);
% plot(Time_10cm,Data_10cm);
% hold off

%% Change files here
TimeFile = Time_29_5cmZoomed;
DataFile = Data_29_5cmZoomed;
RampFile = Ramp_29_5cmZoomed;

%% not these
VoltageP2P = 50.6;
dV = 0.2;
Frequency = 73.4;
dF = 0.1;
%% Adam finding Finesse and Calibrations
[freq,fourier] = fastFourierTransform(TimeFile,DataFile);

figure(1)
plot(freq,fourier)
hold on

set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
set(0,'defaulttextInterpreter','latex');

xlabel('Frequency (Hz)')
ylabel('Magnitude of FT (dB)')
title('Magnitude vs. Frequency of the Fourier Transformed Signal')
hold off

%% Piezo Calibration
threshold = 1e-4;
timestep = 4e-6;
newTime = correctTimeSeries(TimeFile,timestep,threshold);

% newTime_15cm = zeros(length(Time_15cm),1);
% for i=1:length(Time_15cm)-1
%     deltaTime=Time_15cm(i)-Time_15cm(i+1);
%     if ( abs(deltaTime-timestep) < 1e-4)
%         newTime_15cm(i) = Time_15cm(i);
%     else
%         newTime_15cm(i) = Time_15cm(i-1)+timestep
%     end
% end
% newTime_15cm(end)=newTime_15cm(end-1)+timestep

figure(2)
%plot(delta)
%plot(newTime_15cm)
%findpeaks(DataFile,newTime,'MinPeakWidth',2*timestep,'MaxPeakWidth',1,'Annotate','peaks')
plot(newTime,DataFile)
hold on
plot(newTime,RampFile)

return
%% Uncertainty Calculations
T1 = -0.001566;
T2 = -0.00053;
T3 = 0.000348;
TimePeriod = ((T3-T2)+(T2-T1))/2
dT = abs((T3-T2)-TimePeriod)
% dT = (((T3-T2)-TimePeriod)^2+((T2-T1)-TimePeriod)^2)

% FTFrequency = 480
% dFTF = (520-440)/2 % assume the same for all
% TimePeriod = 1/FTFrequency
% dT = dFTF/FTFrequency*TimePeriod

Slope = VoltageP2P/((1/Frequency)/2)
dSlope = Slope*sqrt((dV/VoltageP2P)^2+(dF/Frequency)^2)
DeltaVoltage = Slope*TimePeriod
dDV = DeltaVoltage*sqrt((dSlope/Slope)^2+(dT/TimePeriod)^2)
lambda_HeNe = 0.6328; %microns
Calibration = lambda_HeNe/2/DeltaVoltage
dC = Calibration*sqrt((dDV/DeltaVoltage)^2)


%% FWHM and Finesse
Ymax = 1.44
HM = Ymax/2
XY_LS1 = [ -0.00157 0.72];
XY_LS2 = [ -0.001566 1.44];
XY_RS1 = [ -0.001564 1.12];
XY_RS2 = [ -0.001562 0.44];

XL = (XY_LS2(1)-XY_LS1(1))/(XY_LS2(2)-XY_LS1(2))*(HM-XY_LS1(2))+XY_LS1(1);
XR = (XY_RS2(1)-XY_RS1(1))/(XY_RS2(2)-XY_RS1(2))*(HM-XY_RS1(2))+XY_RS1(1);

FWHM = XR-XL
dFWHM = sqrt(2)*0.000002;
Finesse = TimePeriod/FWHM
dFinesse = Finesse*sqrt((dFWHM/FWHM)^2+(dT/TimePeriod)^2)

%% Plotting

CavityLength = [15 50 100 150 200 250 295]
FinesseMat = [151.85 242.36 121.64 42.81 54.56 19.44 133.35];
FinesseError = [35.77 93.46 44.02 10.53 15.11 5.3 53.70];
lengthError = 2*ones(length(CavityLength),1);

figure(4)
% plot(CavityLength, FinesseMat, 'o')
e = errorbar(CavityLength, FinesseMat, FinesseError, FinesseError, lengthError, lengthError, 'r.');
hold on 
plot([15 295],[185.53 185.53],'b-','LineWidth', 1.5)
e = errorbar(CavityLength, FinesseMat, FinesseError, FinesseError, lengthError, lengthError, 'r.');
e.LineWidth = 1.5;


set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
set(0,'defaulttextInterpreter','latex');

xlabel('Optical Cavity Length (mm)')
ylabel('Finesse')
title('Finesse vs. Optical Cavity Length (mm)')

legend('Experimental Finesse','Theoretical Finesse','Location','NorthEast')

hold off



constFinesse = 185.85;
lambda = 6.328e-7;
Qfactor =@(L) L/lambda*constFinesse
QfactorMat = 10^7*[0.4 1.9 1.9 1.01 1.72 0.77 6.32]
QfactorError = 10^7*[0.1 0.8 0.7 0.3 0.3 0.2 2.5]

figure(5)
e = errorbar(CavityLength, QfactorMat, QfactorError, QfactorError, lengthError, lengthError, 'r.');
hold on 
plot(CavityLength,feval(Qfactor,CavityLength/1000),'LineWidth', 1.5)
%plot([15 295],[1.2783e7 1.2783e7],'b-','LineWidth', 1.5)
%e = errorbar(CavityLength, FinesseMat, FinesseError, FinesseError, lengthError, lengthError, 'r.');
e.LineWidth = 1.5;

xlim([15,295])
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
set(0,'defaulttextInterpreter','latex');

xlabel('Optical Cavity Length (mm)')
ylabel('Q-Factor')
title('Q-Factor vs. Optical Cavity Length (mm)')

legend('Experimental Q-Factor','Theoretical Q-Factor','Location','NorthEast')

hold off
