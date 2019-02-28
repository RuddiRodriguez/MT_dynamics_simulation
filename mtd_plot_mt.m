function mtd_plot_mt( mt, offset )
% function mtd_plot_mt( mt, offset )
%
% make a plot for a nice single microtubule, 
% with the data associated to it: phases/transitions
% if offset is used, the plot is added to the current figure

if ( nargin < 1 )
    warning('missing first argument: mt-history file: use mtd_read_file() first');
    mt = mtd_read_file;
end

max_length = 50;

zoom=1;
if ( nargin < 2 )
    offset = 0;
    clf;
    hold on;
    axis([ min(mt.time), max(mt.time), 0, max_length ]);
    zoom=2;
end

%display the original data with some color coding:
for jj = 1 : size(mt.length, 1) - 1
        
    switch( mt.micro_state(jj,1) )
        case 1
            color = 'bo';
        case -1
            color = 'go';
        case 0
            color = 'ko';
    end
        
    plot( offset+mt.time(jj:jj+1,1), mt.length(jj:jj+1,1), color, 'MarkerSize', zoom*3, 'LineWidth', 1 );    
        
end


%display the mouse clicks (which define the piecewise linear fit)
if (isfield( mt, 'clicks' ))
        
    for ii=2:length(mt.clicks)
        
        xl = mt.clicks(ii-1);
        xr = mt.clicks(ii);
        
        yl = mt.fit_length(ii-1);
        yr = mt.fit_length(ii);
        
        plot( offset+xl, yl, 'ko', 'MarkerSize', zoom*3, 'MarkerFaceColor', 'k');
        %plot( offset+[xl, xr], [yl, yr], 'k:' );
        
        if isfield( mt, 'fit' )
            yl = polyval( mt.fit(:,ii-1), xl );
            yr = polyval( mt.fit(:,ii-1), xr );
            plot( offset+[xl, xr], [yl, yr], 'k:' );
        end
        
        
        if (isfield( mt, 'phase' ))
            switch ( mt.phase(ii-1) )
                case 1
                    plot( offset+[xl, xr], [1, 1], 'b-', 'LineWidth', 7 );
                case -1
                    plot( offset+[xl, xr], [1, 1], 'g-', 'LineWidth', 7 );
                case 0
                    %nothing
            end
        end
    end

    plot( offset+xr, yr, 'ko', 'MarkerSize', zoom*3, 'MarkerFaceColor', 'k');
    
    if (isfield( mt, 'transitions' ))
        for ii=2:length(mt.clicks)
                
            xr = mt.clicks(ii);
            yr = mt.fit_length(ii);
        
            switch ( mt.transitions(ii) )
                case 1
                    plot( offset+xr, 1, 'k^', 'MarkerSize', zoom*15, 'MarkerFaceColor', 'b');
                    plot( offset+[xr, xr], [1, max_length], 'k:');
                case -1
                    plot( offset+xr, 1, 'kv', 'MarkerSize', zoom*15, 'MarkerFaceColor', 'g');
                    plot( offset+[xr, xr], [1, max_length], 'k:');
            end
            
        end
    end
     
end

