

 ratesmicro = [810 730 0.0032 733 0.0032];
 %spmd
[timesmicro,posmicro] = simulate_MTgrowth_different_phases(600,0,ratesmicro);
 %end
 %timet = getting_var_smpd(times);
  %post = getting_var_smpd(pos);
  
 
plot(timesmicro./60,posmicro)
[speedt,catasfre]=getting_dynamics (timesmicro,posmicro);