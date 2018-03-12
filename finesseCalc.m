close all; clc;

% figure(1)
% plot(Time_10cmZoomed,Data_10cmZoomed, '.-');
% hold on
% plot(Time_10cmZoomed,Ramp_10cmZoomed);
% plot(Time_10cm,Data_10cm);
% hold off

threshold = 1e-4;
timestep = 4e-6;
newTime1_15cm = correctTimeSeries(Time1_15cm,timestep,threshold);

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
findpeaks(Data1_15cm,newTime1_15cm,'MinPeakWidth',2*timestep,'MaxPeakWidth',1,'Annotate','peaks')
hold on
plot(newTime1_15cm,Ramp1_15cm)

