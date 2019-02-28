function clean = mtd_refine_clicks( mt )
% function clean = mtd_refine_clicks( mt )
%
% this is called by mtd_click_phases to refine the segmentation of time
% of the microtubule history.
% mt should have a field .clicks containing the time of segmentation
% for example [ 0, 10, 24, 30 ] means that time is splitted as:
% [0,10] , [10, 24], and [24, 30].
% in each of the time segment, the time-length points will be fitted
% linearly. The intersections of the fit-lines will define the new
% segmentation, after removal of points which are too close (if there are
% less than two data-point in any segment, it is removed, as this does not 
% allow a fit to be determined)
% 
% it returns a refined time-segmentation, preserving the min and max of
% time-points in mt.clicks

%the minimum number of points to fit a line
minimum_nb_points = 2;

mt.clicks = remove_points_too_close( mt, minimum_nb_points );
%disp([ 'click ', sprintf('  %5.1f', mt.clicks)]);

coefs=[0, 0];
minc = min(mt.clicks);
maxc = max(mt.clicks);

refined = mt.clicks;

for ii=2:length(mt.clicks)
        
    coefs_old = coefs;
    [nb_points, coefs] = analyse_section( mt, mt.clicks(ii-1), mt.clicks(ii));
    
    if ( ii > 2 )
        %intersection of the two lines:
        new = ( coefs(2) - coefs_old(2) ) / ( coefs_old(1) - coefs(1) );
        if ( new < minc ) new = minc; end
        if ( new > maxc ) new = maxc; end
        
        new_y     = polyval( coefs, new );
        plot( new, new_y, 'ko');
        refined(ii-1) = new;
    end
    
end

mt.clicks = refined;
clean = remove_points_too_close( mt, minimum_nb_points );

%disp(['clean ', sprintf('  %5.1f', clean)]);

return;



%suppress the points which are too close
function C = remove_points_too_close( mt, min_nb_points )

    clean = 0;
    C = sort(mt.clicks);
    %disp([ 'c-up1 ', sprintf('  %5.1f', P)]);
    
    while ( clean == 0 )
        clean = 1;
        for ii = 2 : length(C)-1
            [nbp1, coefs] = analyse_section( mt, C(ii-1), C(ii));
            [nbp2, coefs] = analyse_section( mt, C(ii), C(ii+1));
            if (( nbp1 < min_nb_points ) || ( nbp2 < min_nb_points ))
                %we remove point  ii:
                indx = setdiff([1:length(C)], [ii]);
                C = C(indx);
                clean = 0;
                break;
            end
        end
    end

return




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
