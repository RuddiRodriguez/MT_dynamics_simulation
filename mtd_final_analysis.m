function S = mtd_final_analysis( mts );
%function S = mtd_final_analysis( mts );
%
%calculates in S a bunch of numbers, such as catastrophy frequency, etc.
%also prints a summary of the most important characteristics

S.growth_time  = [];
S.shrink_time  = [];
S.pause_time   = [];

S.growth_speed = [];
S.shrink_speed = [];
S.pause_speed  = [];

S.cata = 0;
S.resc = 0;
S.mouse_clicks = 0;

for ii = 1:size(mts, 1)

    mt = mts( ii, 1 );
    
    S.cata = S.cata + sum( mt.transitions == -1 );
    S.resc = S.resc + sum( mt.transitions ==  1 );
    S.mouse_clicks = S.mouse_clicks + size( mt.time, 1 );
 
    for jj =1:(length( mt.clicks )-1)
        
        time  = mt.clicks(jj+1) - mt.clicks(jj);
        speed = mt.fit(1, jj);
        
        
        switch ( mt.phase(jj) )
            case 1
                S.growth_time   = cat( 1, S.growth_time, time );
                S.growth_speed  = cat( 1, S.growth_speed, speed );
            case -1
                S.shrink_time  = cat( 1, S.shrink_time, time );
                S.shrink_speed = cat( 1, S.shrink_speed, speed );
            case 0
                S.pause_time   = cat( 1, S.pause_time, time );
                S.pause_speed  = cat( 1, S.pause_speed, speed );
        end
        
        
    end
        
end

S.total_pause_time  = sum( S.pause_time );
S.total_growth_time = sum( S.growth_time );
S.total_shrink_time = sum( S.shrink_time );
S.total_observation_time = S.total_pause_time + S.total_growth_time + S.total_shrink_time;

S.total_growth_length = sum( S.growth_time .* S.growth_speed );
S.total_shrink_length = sum( S.shrink_time .* S.shrink_speed );
S.total_pause_length  = sum( S.pause_time .* abs(S.pause_speed));

if ( S.total_growth_time > 0 )
    S.growth_speed_mean = S.total_growth_length / S.total_growth_time;
    S.growth_speed_std = std( S.growth_speed );
else
    S.growth_speed_mean = 0;
    S.growth_speed_std  = 0;
end

if ( S.total_shrink_time > 0 )
    S.shrink_speed_mean = S.total_shrink_length / S.total_shrink_time;
    S.shrink_speed_std = std( S.shrink_speed );
else
    S.shrink_speed_mean = 0;
    S.shrink_speed_std  = 0;
end

if ( S.total_pause_time > 0 )
    S.pause_speed_mean = S.total_pause_length / S.total_pause_time;
    S.pause_speed_std = std( S.pause_speed );
else
    S.pause_speed_mean = 0;
    S.pause_speed_std  = 0;
end

fprintf(1, '%4i Microtubules:', size(mts,1));
fprintf(1, '   total observation time %7.2f sec', S.total_observation_time);
fprintf(1, '   nb of mouse clicks %i\n', S.mouse_clicks);

%fprintf(1, 'average growth speed = %7.4f +/- %7.4f um/s', S.growth_speed_mean, S.growth_speed_std );
%fprintf(1, 'average shrink speed = %7.4f +/- %7.4f um/s', S.shrink_speed_mean, S.shrink_speed_std );

fprintf(1, 'growth: total time = %7.2f sec. length %9.3f um   avg speed %7.3f +/- %7.3f um/s\n', ...
    S.total_growth_time, S.total_growth_length, S.growth_speed_mean, S.growth_speed_std );
fprintf(1, 'shrink: total time = %7.2f sec. length %9.3f um   avg speed %7.3f +/- %7.3f um/s\n',...
    S.total_shrink_time, S.total_shrink_length, S.shrink_speed_mean, S.shrink_speed_std );
fprintf(1, 'pause:  total time = %7.2f sec. length %9.3f um   avg speed %7.3f +/- %7.3f um/s\n',...
    S.total_pause_time, S.total_pause_length, S.pause_speed_mean, S.pause_speed_std );


S.resc_freq      = S.resc / S.total_shrink_time;
S.resc_freq_err  = 1.0 / S.total_shrink_time;

S.cata_freq      = S.cata / S.total_growth_time;
S.cata_freq_err  = 1.0 / S.total_growth_time;


fprintf(1,'cata freq = %7.3f /s (%i events/%7.2f sec)', S.cata_freq, S.cata, S.total_growth_time );
fprintf(1,'resc freq = %7.3f /s (%i events/%7.2f sec)', S.resc_freq, S.resc, S.total_shrink_time );







