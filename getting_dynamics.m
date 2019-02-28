function [speedt,catasfre]=getting_dynamics (timesmicro,posmicro)

lengmm = smooth (posmicro,0.01,'moving' );
count = 0; detach = 0;tube = 0 ;
% zerosposm1 = find (posm==intial_pos);
% zerosposm2 = find (posm==0);
% zerosposm = [zerosposm1 zerosposm2];
[pks,locs]  = findpeaks (lengmm,'MinPeakProminence',0.20);
timespeaks= (timesmicro(locs));

DataInv = 1.01*max(lengmm ) - lengmm ;
[Minima,MinIdx] = findpeaks(DataInv,'MinPeakProminence',0.20);
Minima = lengmm (MinIdx);
timespeaksmin= (timesmicro(MinIdx));
%findpeaks (lengmm,'MinPeakProminence',0.20);
speedt=0
for i=1:length(locs)
    if i ==1
    xdata = [0 timespeaks(i)]
    grotime(i) = (xdata(end)-xdata(1))./1;
    ydata=  [0 pks(i)] 
    speedt (i) =(( ydata(end)-ydata(1))./(xdata(end)-xdata(1))).*60;
    else
       
        
       xdata = [timespeaksmin(i-1) timespeaks(i)]
    ydata=  [lengmm(MinIdx(i)) pks(i)] 
    grotime(i) = (xdata(end)-xdata(1))./1;
    speedt (i) =(( ydata(end)-ydata(1))./(xdata(end)-xdata(1))).*60;
    end
end
catasfre = numel(pks)./(sum(grotime))