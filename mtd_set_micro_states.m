function state = mtd_set_micro_states( mt );
%function state = mtd_set_micro_states( mt );
%
%set the instantaneous growth/shrinkage state of a microtubule
%This is used to set the color of the points for the plot of
%microtubule-history.

len = size( mt.length, 1 );
state = zeros( len, 1 );
    
for jj = 1:(len-1)
        
    delta_length = mt.length(jj+1,1) - mt.length(jj,1);
    delta_time = mt.time(jj+1,1) - mt.time(jj,1);
    
    instant_speed = delta_length / delta_time;
    
    if ( instant_speed > 0 ) 
        state(jj, 1) = 1;
    end
    if ( instant_speed < 0 )
        state(jj, 1) = -1;
    end
         
end

%basic filtering to suppress some noise:
for jj = 1:(len-2)
        
    if ( state(jj:jj+2, 1) == [ -1; 1; -1 ] ) & ( mt.length(jj+3,1) < mt.length(jj,1) ) 
        state(jj:jj+2, 1) = [ -1; -1; -1 ];
    end

    if ( state(jj:jj+2, 1) == [ 1; -1; 1 ] ) & ( mt.length(jj+3,1) > mt.length(jj,1) ) 
        state(jj:jj+2, 1) = [ 1; 1; 1 ];
    end

         
end    