function mts = mtd_replot( thresholds );
%function mts = mtd_replot( thresholds );
%
%Scans the current directory for files containing microtubules-history


if ( nargin < 1 )
    thresholds = [ 0.05, 0.5 ];
end

files = dir('*.mtd');
    
if (size(files,1) == 0)
    fprintf(1, 'no analysis output file *.mtd found in %s\n', pwd);
    response = input('do you want to run the analysis? (Y/N)', 's');
    if ( response == 'Y' )
        mts = mtd_analyse;
    else
        mts = [];
        return;
    end
end
   
%ask the user to chose if there is more than one file:
if (size(files,1) == 1)
    datafile = files(1).name;
else
    [filename, pathname] = uigetfile('*.mtd', 'select "*.mtd" file');
    datafile = [ pathname, filename ];
end
       
fprintf(1, 'displaying data in file %s\n', files(1).name);

%display this data if the file was found:
data=load('-mat', datafile, 'mts');
mts = data.mts;

%redo the threshold:
for ii = 1 : size(mts, 1)
    mts(ii) = mtd_set_phases( mts(ii), thresholds );
end



if ~exist( 'mts', 'var' ) || isempty( mts )
    fprintf(1,'Possible error: Empty analysis file!\n');
else
    fprintf(1, '%i microtubules in file %s\n', size(mts,1), datafile);
    mtd_plot_many( mts, pwd );
    mtd_final_analysis( mts );
end
