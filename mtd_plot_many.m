function mtd_plot_many( mts, name );
%function mtd_plot_many( mts, name );
%
%make a plot, showing many microtubules (given in mts)
%this calls mtd_plot_mt() for all the member of the array 'mts'

if ( nargin < 1 )
    error('missing first argument: mts-histories');
end


if ( nargin < 2 )
    name = 'undefined';
end

figure( 'name', name );
hold on;


nb_lines = 0;
page_width = 500;
scale = 1.5;


offset = 0;
max_offset = 0;

for ii = 1 : size( mts, 1 )

    duration = max( mts(ii).time ) - min( mts(ii).time );
    
    if ( offset+duration > page_width )
        set_axis( offset, nb_lines, scale );
        h = axes;
        hold on;
        offset = 0;
        nb_lines = nb_lines + 1;
    end
    
    mtd_plot_mt( mts(ii), offset-min(mts(ii).time) );
    offset = offset + duration;
    plot( [ offset, offset ], [ 0, 50 ], 'k-' );
            
    if ( offset > max_offset )
        max_offset = offset;
    end

end

set_axis( offset, nb_lines, scale );

fig_pos= [ 30, 30, scale * max_offset + 60, scale * ( nb_lines + 1 ) * 80 + 40 ];
set( gcf, 'units', 'pixels' )
set( gcf, 'position', fig_pos );
text( 0, 60, name, 'FontSize', 14, 'Interpreter', 'none', 'FontWeight', 'bold' );
%setprint;
drawnow;

return;




function set_axis( offset, nb_lines, scale )
        
axis_size = [ 30, 30 + scale * 70 * nb_lines, scale * offset, scale * 60 ];
axis([ 0, offset, 0, 50 ]);
set( gca, 'units', 'pixels' )
set( gca, 'position', axis_size );
set( gca, 'XTick', [0:50:offset] );

return;
