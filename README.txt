Macro to analyse microtubule dynamic instability:
F. Nedelec, 2005

Input:
files with two columns containing: 
  time in seconds   -   length of microtubules in micro-meters

Output: number of catastrophes, rescues, speed of growth, etc. in a two-state model.


Usage :
1. start matlab
2. change current directory to the directory containing MT-history files
3. check that your files are readible by 'mtd_read_mt':
    type 'mtd_read_mt', and select your file. The output should like:

ans = 

       filename: '/Users/nedelec/experiments/deltaclip/5'
           time: [21x1 double]
         length: [21x1 double]
    micro_state: [21x1 double]


4. run 'mtd_display' to display (& check) all the files
5. run 'mtd_analyse'  to analyse the data.


Optionally:
6. run 'mtd_replot'  to review your analysis


7. run 'mtd_replot_scan' to combine multiple directories in a single plot
it should be run in the directory containing directories containing files.
