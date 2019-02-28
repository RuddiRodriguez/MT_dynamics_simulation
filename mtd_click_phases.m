function mt = mtd_click_phases( mt, thresholds, limits )    
%function mt = mtd_click_phases( mt, thresholds, limits )    
%
%used to let the user click on the microtubules time-length profile,
%to define the regions of growth/shrinkage, and transitions.
%
%optional argument limits define the time-limits where the mt-history will 
%be analysed

if ( nargin < 1 )
   mt = mtd_read_file;
end


if ( nargin < 2 )
    thresholds = [ 0.05, 0.5 ];
end

if ( nargin < 3 )
    limits = [ min(mt.time), max(mt.time) ];
end

%initialize the clicks:
mt.clicks(1,1) = limits(1);
mt.clicks(1,2) = limits(2);
clicks_buffer = [];
redraw = 1;

while( 1 )
    
    if ( redraw )
        %show the file being process in figure name
        if isfield( mt, 'filename' )
            set(gcf, 'Name', mt.filename);
        end
        %detect phase and transitions:
        mt = mtd_set_phases( mt, thresholds );
        %plot the result:
        mtd_plot_mt( mt );
        redraw = 0;
    end
    
    k = waitforbuttonpress;
       
    switch( k )
        case 1  %key pressed detected
            
            switch( get( gcf, 'CurrentCharacter') )
                case ' ' %exit if space bar is pressed;
                    return;
                case 'c' %reset all points
                    mt.clicks = [ limits(1), limits(2) ];
                    redraw = 1;
                case 'x' %replot
                    mtd_plot_mt( mt );
                case 'r' %refine, step-by-step
                    mt.clicks = sort( cat( 2, mt.clicks, clicks_buffer ));
                    clicks_buffer=[];
                    mt.clicks = mtd_refine_clicks( mt );
                    redraw = 1;
                case 'q' %quit
                    mt.user_cancel = 2;
                    return;
                case 'b' %back to previous tube
                    mt.user_cancel = 1;
                    return;
            end
           
        case 0       % button down detected       
            
            p = get(gca,'CurrentPoint');      
            plot( p(1,1), p(2,2), 'k+', 'MarkerSize', 10);
            new_click = p(1,1);
            %fprintf(1, 'new click = %.5f\n', new_click );

            if ( new_click < limits(1) ) new_click = limits(1); end
            if ( new_click > limits(2) ) new_click = limits(2); end
            
            switch ( get(gcf, 'SelectionType') )
                case 'normal'
                    clicks_buffer = cat( 2, clicks_buffer, [new_click] );
                    %include the new points in the mt sectionning:
                    newclicks = sort( cat( 2, mt.clicks, clicks_buffer ) );
                    
                    %call refine until it converges to something stable:
                    iterations=0;
                    while ( iterations < 10 )
                        iterations = iterations + 1;
                        mt.clicks  = newclicks;
                        newclicks  = mtd_refine_clicks( mt );
                        if (length(mt.clicks) == length(newclicks)) && all( mt.clicks == newclicks )
                            break;
                        end
                        mt.clicks  = newclicks;
                    end
                    clicks_buffer=[];
                    redraw = 1;

                case 'extend'  %shift is pressed
                    clicks_buffer = cat( 2, clicks_buffer, [new_click] );
                    
                case 'alt'     %alt or right mouse button is pressed
                    %remove the closest point
                    [V, ii] = min( abs(mt.clicks - new_click));
                    if ( V < 1 ) && ( ii ~= 1 ) && ( ii ~= length(mt.clicks))
                        indx = setdiff([1:length(mt.clicks)], [ii]);
                        mt.clicks = mt.clicks(indx);
                    end
                    redraw = 1;
            end
    end
    
end

