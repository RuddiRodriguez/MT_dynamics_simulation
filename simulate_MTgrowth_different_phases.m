function [times,pos] = simulate_MTgrowth_different_phases(t_final,inipos,rates)
% simulation of MT growth with 'rates' kon and koff starting from position
% 'inipos' until time 't_fin al' is reached -uses Gillespie algorithm
% outputs two vectors with times and positions
% initialise:
close all
t = 0;
% time variable
pos = inipos;
% new position
times = 0;
% all times
state =0;
ratesg = rates(1:3);
ratessh = rates(4:5);
%growth or shrinkage phase

    rateg = sum(ratesg);
    probg = ratesg/rateg;

    ratess = sum(ratessh);
    probss = ratessh/ratess;

% sum of on and off rates

figure (1)
m=0;
% vector with rel. probabilities of on and off rate% simulate
while t <= t_final
    
    if state ==0
        r1= rand(1,2);
        tau=(1./rateg).*log(1./r1(1));
        % tau = exprnd(1/rateg);
%         [mintau,Imintau] = min (tau);
    else
        r1= rand(1,2);
       tau=(1./ratess).*log(1./r1(1));
       %  tau = exprnd(1/ratess);
%         [mintau,Imintau] = min (tau);
    end
    % sojourn time -faster
    t = t + tau;   
    % update time
    if t > t_final
        t = t_final;
        % end of loop
        pos = [pos; pos(end)];
        % reapeat last position
        times = [times, t];
        % final time is exactly t_final
        break;
    else
        
        if state==0
            [mnumber] = position_transition_family_reaction (ratesg,rateg,r1(2));
            switch mnumber
                case 1
                    new_pos = pos(end) + 0.000615;
                    state=0;
                case 2
                    new_pos = pos(end) - 0.000615;
                    state=0;
                case 3
                    new_pos = pos(end) + 0;
                    state=1;
            end
            
        else
            [mnumber] = position_transition_family_reaction (ratessh,ratess,r1(2));
            switch mnumber
                case 1
                    decre = rates(4).*tau;
                    new_pos = pos(end) - decre;
                    state=1;
                case 2
                    new_pos = pos(end) - 0;
                    state=0;
                
            end
        end
        
        
    end
    if new_pos<0
    new_pos=0;
    state=0;
end
    pos = [pos;new_pos];        
% update vector with all positions
times = [times, t]; 
    % update vector with
    m= m+1;
if (mod(m,18000) == 0)
    fprintf('%4.2f\n',times(end));
        fprintf('%4.2f\n',t_final-times(end));
% plot (times,pos);hold on 
drawnow;
end
end