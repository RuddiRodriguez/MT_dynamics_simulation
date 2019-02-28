function [mnumber] = position_transition_family_reaction_bisection (arrayrates,globalrate,r1)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
arrayratesnozeros = arrayrates(:);
 arrayratesnozeros = arrayratesnozeros(arrayratesnozeros~=0);

    
   % mnumber = 1;
  epsilon = 0.02;
 sumalpha=0;
low=1;
high =length(arrayratesnozeros);
mnumber = fix(high+low)/2.0;
sumalpha=(sum(arrayratesnozeros(1:mnumber))/globalrate);    
    
    
    %sumalpha = arrayratesnozeros(1)/globalrate;
    while abs((r1)-sumalpha) >= epsilon
       % mnumber = mnumber + 1;
       
        if (sum(arrayratesnozeros(1:mnumber))/globalrate) < r1
            low = mnumber;
        else
            high = mnumber;
        end
        mnumber = fix((high+low)/2.0);
        sumalpha=(sum(arrayratesnozeros(1:mnumber))/globalrate);
    end
end

