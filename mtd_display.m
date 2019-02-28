function mts = mtd_display( original_files, thresholds )
%function mts = mtd_display( directory_name, thresholds )
%
%display the microtubules present in the current directory, of in the given
%directory.
%the thresholds used to define transitions can be set as arguements
%by defaults, they are [ 0.05 um/s (speed threshold), 0.5 um (length
%threshold)]


if ( nargin < 2 )
    thresholds = [ 0.05, 0.5 ];
end

if ( nargin < 1 )
    original_files = 1;
end


if ( original_files )
    
    %we go and read each file:
    files = dir('*');

    for u = 1:size(files, 1)

        filename = files(u).name;
        %attemtp to load the microtubule trace
        mt = mtd_read_file( filename );

        if isempty( mt )
            %fprintf(1, 'skipping file %s\n', filename);
            continue;
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

else

    files = dir('*.mtd');
    
    if (size(files,1) == 0)
        error('no analysis output file *.mtd found');
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
    fprintf(1, '%i microtubules in file %s\n', size(mts,1), datafile);
   
end


if ~exist( 'mts', 'var' ) || isempty( mts )
    fprintf(1,'No microtubule-files in current directory!\n', pwd);
else
    fprintf(1, '%i microtubule-files in `%s`\n', size(mts,1), pwd);
    mtd_plot_many( mts, pwd);
end

