function [mnumber] = position_transition_family_reaction (arrayrates,globalrate,r1)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
arrayratesnozeros = arrayrates(:);
    
    mnumber = 1;
    
    sumalpha = arrayratesnozeros(1)/globalrate;
    while (r1) >= (sumalpha)
        mnumber = mnumber + 1;
        sumalpha = sumalpha + arrayratesnozeros(mnumber)/globalrate;
    end
end
