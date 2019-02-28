function mt = mtd_read_file(filename)
%function mt = mtd_read_file(filename)
%
%read a file containing the history of a microtubule:
%the file should be ASCII, and contain two columns: time, length
%ATTENTION: units are important:
%         time should be given in seconds
%         length in micro-meters
%
%it returns [] if the file is not valid

if (nargin == 0)
    [filename, pathname] = uigetfile('*.*', 'select microtubule-file');
    filename = [ pathname, filename ];
end

%by default, we will return an empty array:
mt=[];

if isdir(filename)
    return;
end

if filename(1) == '.'
    return;
end

[pathstr, name, ext] = fileparts(filename);

%check if the file has a disabled name:
if strcmp(ext, '.skip')
    return;
end

%skip output files from this analysis
if strcmp(ext,  '.mtd')
    return;
end

%read the data:
mt.filename     = filename;

try
    data=load('-ascii', filename);
    mt.time         = data(:,1);
    mt.length       = data(:,2);
    mt.micro_state  = mtd_set_micro_states( mt );
catch
    fprintf(1,'Error reading/processing file %s\n', filename );
    mt = [];
end


return;