function mt = mtd_set_phases( mt, thresholds )
% function mt = mtd_set_phases( mt, thresholds )
%
% the threshold should be [speed_threshold (um/s),  length_threshold (um)]
% by default, [0.05, 0.5]

if ( nargin < 2 )
    thresholds = [0.05, 0.5];
else
    if any( size( thresholds ) ~= [ 1, 2 ] )
        error('thresholds should be an array of size 1,2');
    end
    if any( thresholds < 0 )
        error('values of thresholds should be positive');
    end
end


if isempty( thresholds )
    error('invalid thresholds given as second argument');
end

mt.fit           = zeros( size(mt.clicks)+[1,-1] );
mt.transitions   = zeros( size(mt.clicks) );
mt.phase         = zeros( size(mt.clicks)-[1,0] );

phase                = 0;
assembly_speed       = 0;
phase_old_meaningful = 0;


len = length(mt.clicks);
for ii=1:len-1
    
    [nbp, coefs] = analyse_section(mt, mt.clicks(ii), mt.clicks(ii+1));
    mt.fit(:,ii) = coefs';
    
    assembly_speed  = coefs(1);
    assembly_length = coefs(1) * (mt.clicks(ii+1) - mt.clicks(ii));

    if ( phase ~= 0 )
        phase_old_meaningful = phase;
    end

    phase = 0;
    %test for growth:
    if ( assembly_speed > thresholds(1) ) & ( assembly_length > thresholds(2) )
        phase = 1;
    end
    %test for shrinkage:
    if ( assembly_speed < -thresholds(1) ) & ( assembly_length < -thresholds(2) )
        phase = -1;
    end

    mt.phase(ii) = phase;

    %test for state transitions:
    transition_type = 0;
    if (phase * phase_old_meaningful == -1)
        transition_type = phase;
    end
    mt.transitions(ii) = transition_type;

end


%interpolate for the length at the exact click position:
mt.fit_length(1) = polyval( mt.fit(:,1), mt.clicks(1) );
for ii=1:len-2
    fit1 = polyval( mt.fit(:,ii), mt.clicks(ii+1) );
    fit2 = polyval( mt.fit(:,ii+1), mt.clicks(ii+1) );
    mt.fit_length(ii+1) = ( fit1 + fit2 ) / 2;
end
mt.fit_length(len) = polyval( mt.fit(:,len-1), mt.clicks(len) );


return;



function [nb_points, coefs] = analyse_section( mt, click1, click2 )

%fprintf(1,'segment %i %i', left, right);

if ( click1 > click2 )
    error('misordered section in analyse_section');
end
coefs = [0, 0];

%we take only the points inside the segments:
left  = find( mt.time >= click1, 1, 'first');
right = find( mt.time <= click2, 1,  'last');
if isempty( left ) || isempty( right )
    nb_points = 0;
    return;
end
nb_points = right - left + 1;
if ( nb_points < 2 )
    return;
end

interval_time   = mt.time([left:right]);
interval_length = mt.length([left:right]);
coefs = polyfit( interval_time, interval_length, 1 );

return
