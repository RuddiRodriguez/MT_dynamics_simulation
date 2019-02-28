function mts = mtd_analyse( directory_name, thresholds )
%function mts = mtd_analyse( directory_name, thresholds )
%
%analyse sequentially all the microtubules present in the current directory
%using mtd_read_file(file) for all files in the directory
%the data is finaly saved in a file called MT*.mtd, where * is the date

if ( nargin > 1 ) & ( isdir( directory_name))
    cd(directory_name);
else
    directory_name = pwd;
end

if ( nargin < 2 )
    thresholds = [0.05, 0.5];
end

mts = [];

figure;

files = dir('*');

u = 0;
%get the file where histories are recorded:
while ( u < size(files, 1) )
    
    u = u + 1;
    filename = files(u).name;

    if ( 0 == files(u).isdir ) && ( filename(1) ~= '.' )

        %load the microtubule trace
        mt = mtd_read_file( filename );

        if isempty( mt )
            fprintf(1, 'skipping file %s\n', filename);
            continue;
        end

        %get the phases from our nice user:
        mt = mtd_click_phases( mt, thresholds );

        if (isfield( mt, 'user_cancel' ))
            switch( mt.user_cancel )
                case 1 %back to previous tube
                    u = u - 2;
                    continue;
                case 2 %quit immediately
                    break;
                case 3 %skip this microtubule
                    mt.skipme = 1;
                    continue;
            end
        end


        if ~exist( 'mts', 'var' )
            mts = mt;
        else
            if ( u > size( mts, 1 ) )
                mts = cat( 1, mts, mt );
            else
                mts(u) = mt;
            end
        end


    end

end

close;

if ~exist( 'mts', 'var' ) || isempty( mts )
    fprintf(1,'Possible error: Empty analysis data!\n');
else
    mts
    mtd_plot_many( mts, directory_name );
    mtd_final_analysis( mts );

    %save to disk:
    savefile=sprintf('MT%s.mtd', date);
    save(savefile, 'mts');
    %can be recovered by:   mts=load('-mat', savefile, 'mts');

    fprintf(1, '%i microtubules have been saved in %s\n', size(mts,1), savefile);
end

