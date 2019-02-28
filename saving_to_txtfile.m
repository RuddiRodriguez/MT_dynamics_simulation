path = pwd ;    % your path here 
mkdir resultsf
filename = 'results.txt' ;   % text file name 
file = fullfile (path, 'resultsf', filename) ;  % make filename  with path  
    save(file,'vector','-ascii');
 