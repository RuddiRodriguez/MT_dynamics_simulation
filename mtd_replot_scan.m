function mts = mtd_replot( thresholds );
%function mts = mtd_replot( thresholds );
%
%Scans the current directory for directories containing microtubules-history
%For example, if you have set your files like this:
%   Condition1/Monday/MT1.txt
%   Condition1/Monday/MT2.txt
%   Condition1/Tuesday/MT1.txt
%   Condition1/Tuesday/MT2.txt
%...
%   Condition2/Monday/MT1.txt
%   Condition2/Monday/MT2.txt
%   Condition2/Monday/MT3.txt
%   Condition2/Tuesday/MT1.txt
% you should run 'mtd_scan' in Condition1 and Condition2.


if ( nargin < 1 )
    thresholds = [ 0.05, 0.5 ];
end

parent_dir = pwd;
files      = dir('*');
empty      = 1;

%get the file where MT histories are recorded:
for u=1:size(files, 1)
    
    cd(parent_dir);
    dirname = files(u).name;
   
    %skip invisible files:
    if ( ~ isdir( dirname ) | dirname(1) == '.' )
        continue;
    end
    cd( dirname );
    empty = 0;
   
    mtn = mtd_replot( thresholds );
    
    if isempty( mtn )
        %fprintf(1, 'Possible error: no analysis found in directory %s\n', dirname);
        continue;
    end
    
    %merge it with the one already available:
    if ~exist( 'mts', 'var' )
        mts = mtn;
    else
        mts = cat( 1, mts, mtn );
    end

end

if ( empty )
    fprintf(1,'Error: no directories present here!\n');
    return;
end

if ~exist( 'mts', 'var' ) || isempty( mts )
    fprintf(1,'Possible error: empty analyse file!\n');
else
    cd( parent_dir );
    fprintf(1,'-----------TOTAL------------\n');
    mtd_plot_many( mts, ['joined in ' pwd] );
    mtd_final_analysis( mts );
end
