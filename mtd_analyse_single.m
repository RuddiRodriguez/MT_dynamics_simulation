function mt = mtd_analyse_single( filename )
% function mt = mtd_analyse_single( filename )
%
% mainly a test version, to read and analyse a single microtubule profile

if (nargin == 0)
    [filename, pathname] = uigetfile('*', 'select file');
    filename = [ pathname, filename ];
end

if isfloat(filename)
    filename=sprintf('%i', round(filename));
end
 

mt = mtd_read_file( filename );
if isempty( mt )
    error('file was not recognized as a valid MT history');
end

mt = mtd_click_phases( mt );


