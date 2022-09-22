#########  Plot missing data
set xdata time
set grid
set tics out
set xtics rotate
set timefmt "%m/%d/%y %H:%M"
set format x "%m/%d/%y %H:%M"
set xrange  ["07/01/17":"04/30/18"]
set key
plot \
"/mnt/space/workspace/instrument_processing/data/site/100/RAIN/100_RAIN_DATAGAPS.csv" index 2 using 1:($3/60) with impulses title 'Sta 1', \
"/mnt/space/workspace/instrument_processing/data/site/200/RAIN/200_RAIN_DATAGAPS.csv" index 2 using 1:($3/60) with impulses title 'Sta 2', \
"/mnt/space/workspace/instrument_processing/data/site/300/RAIN/300_RAIN_DATAGAPS.csv" index 2 using 1:($3/60) with impulses title 'Sta 3', \
"/mnt/space/workspace/instrument_processing/data/site/400/RAIN/400_RAIN_DATAGAPS.csv" index 2 using 1:($3/60) with impulses title 'Sta 4', \
"/mnt/space/workspace/instrument_processing/data/site/500/RAIN/500_RAIN_DATAGAPS.csv" index 2 using 1:($3/60) with impulses title 'Sta 5', \
"/mnt/space/workspace/instrument_processing/data/site/600/RAIN/600_RAIN_DATAGAPS.csv" index 2 using 1:($3/60) with impulses title 'Sta 6', \
"/mnt/space/workspace/instrument_processing/data/site/700/RAIN/700_RAIN_DATAGAPS.csv" index 2 using 1:($3/60) with impulses title 'Sta 7', \
"/mnt/space/workspace/instrument_processing/data/site/800/RAIN/800_RAIN_DATAGAPS.csv" index 2 using 1:($3/60) with impulses title 'Sta 8', \
"/mnt/space/workspace/instrument_processing/data/site/900/RAIN/900_RAIN_DATAGAPS.csv" index 2 using 1:($3/60) with impulses title 'Sta 9', \
"/mnt/space/workspace/instrument_processing/data/site/10000/RAIN/10000_RAIN_DATAGAPS.csv" index 2 using 1:($3/60) with impulses title 'Sta 10', \
"/mnt/space/workspace/instrument_processing/data/site/1100/RAIN/1100_RAIN_DATAGAPS.csv" index 2 using 1:($3/60) with impulses title 'Sta 11', \
"/mnt/space/workspace/instrument_processing/data/site/1200/RAIN/1200_RAIN_DATAGAPS.csv" index 2 using 1:($3/60) with impulses title 'Sta 12'

plot "100_RAIN_DATAGAPS.csv" index 2 using 1:($3/60/24) with fsteps, \

######### End  Plot missing data

######### Plot all rainfall events at each station 3D
unset key
set view 57,60,1,1
set xlabel "Hours" font "Times, 12"
set ylabel "Number of Storms" font "Times, 12"
set zlabel "Rain (in)" font "Times, 12"
set ticslevel 0.1
set terminal png size 1280,960
set output "/mnt/space/workspace/instrument_processing/data/site/100/gnuplot/100_All_Rainfall_Events.6May18.png"
set title "Station 1"
splot for [in=1:160] "/mnt/space/workspace/instrument_processing/data/site/100/RAIN/100_RAIN_summary.csv" index in using ($0*5/60):3:($4/100) with surface lw 2

set output "/mnt/space/workspace/instrument_processing/data/site/200/gnuplot/200_All_Rainfall_Events.6May18.png"
set title "Station 2"
splot for [in=1:98] "/mnt/space/workspace/instrument_processing/data/site/200/RAIN/200_RAIN_summary.csv" index in using ($0*5/60):3:($4/100) with surface lw 2

set output "/mnt/space/workspace/instrument_processing/data/site/300/gnuplot/300_All_Rainfall_Events.6May18.png"
set title "Station 3"
splot for [in=1:160] "/mnt/space/workspace/instrument_processing/data/site/300/RAIN/300_RAIN_summary.csv" index in using ($0*5/60):3:($4/100) with surface lw 2

set output "/mnt/space/workspace/instrument_processing/data/site/400/gnuplot/400_All_Rainfall_Events.6May18.png"
set title "Station 4"
splot for [in=1:160] "/mnt/space/workspace/instrument_processing/data/site/400/RAIN/400_RAIN_summary.csv" index in using ($0*5/60):3:($4/100) with surface lw 2

set output "/mnt/space/workspace/instrument_processing/data/site/500/gnuplot/500_All_Rainfall_Events.6May18.png"
set title "Station 5"
splot for [in=1:160] "/mnt/space/workspace/instrument_processing/data/site/500/RAIN/500_RAIN_summary.csv" index in using ($0*5/60):3:($4/100) with surface lw 2

set output "/mnt/space/workspace/instrument_processing/data/site/600/gnuplot/600_All_Rainfall_Events.6May18.png"
set title "Station 6"
splot for [in=1:160] "/mnt/space/workspace/instrument_processing/data/site/600/RAIN/600_RAIN_summary.csv" index in using ($0*5/60):3:($4/100) with surface lw 2

set output "/mnt/space/workspace/instrument_processing/data/site/700/gnuplot/700_All_Rainfall_Events.6May18.png"
set title "Station 7"
splot for [in=1:160] "/mnt/space/workspace/instrument_processing/data/site/700/RAIN/700_RAIN_summary.csv" index in using ($0*5/60):3:($4/100) with surface lw 2

set output "/mnt/space/workspace/instrument_processing/data/site/800/gnuplot/800_All_Rainfall_Events.6May18.png"
set title "Station 8"
splot for [in=1:160] "/mnt/space/workspace/instrument_processing/data/site/800/RAIN/800_RAIN_summary.csv" index in using ($0*5/60):3:($4/100) with surface lw 2

set output "/mnt/space/workspace/instrument_processing/data/site/900/gnuplot/900_All_Rainfall_Events.6May18.png"
set title "Station 9"
splot for [in=1:160] "/mnt/space/workspace/instrument_processing/data/site/900/RAIN/900_RAIN_summary.csv" index in using ($0*5/60):3:($4/100) with surface lw 2

set output "/mnt/space/workspace/instrument_processing/data/site/10000/gnuplot/10000_All_Rainfall_Events.6May18.png"
set title "Station 10"
splot for [in=1:160] "/mnt/space/workspace/instrument_processing/data/site/10000/RAIN/10000_RAIN_summary.csv" index in using ($0*5/60):3:($4/100) with surface lw 2

set output "/mnt/space/workspace/instrument_processing/data/site/1100/gnuplot/1100_All_Rainfall_Events.6May18.png"
set title "Station 11"
splot for [in=1:160] "/mnt/space/workspace/instrument_processing/data/site/1100/RAIN/1100_RAIN_summary.csv" index in using ($0*5/60):3:($4/100) with surface lw 2

set output "/mnt/space/workspace/instrument_processing/data/site/1200/gnuplot/1200_All_Rainfall_Events.6May18.png"
set title "Station 12"
splot for [in=1:160] "/mnt/space/workspace/instrument_processing/data/site/1200/RAIN/1200_RAIN_summary.csv" index in using ($0*5/60):3:($4/100) with surface lw 2
########## ######### Plot all rainfall events at each station 3D


################ Plot all rainfall events at each station 2d
unset key
set xlabel "Hours" font "Times, 12"
set ticslevel 0.1
set terminal png size 1280,960
set ylabel "Rain (in)"
set output "/mnt/space/workspace/instrument_processing/data/site/100/gnuplot/100_All_Rainfall_Events_2D.6May18.png"
set title "Station 1"
plot for [in=1:160] "/mnt/space/workspace/instrument_processing/data/site/100/RAIN/100_RAIN_summary.csv" i in using ($0*5/60):($4/100) with fsteps

set output "/mnt/space/workspace/instrument_processing/data/site/200/gnuplot/200_All_Rainfall_Events_2D.6May18.png"
set title "Station 2"
plot for [in=1:98] "/mnt/space/workspace/instrument_processing/data/site/200/RAIN/200_RAIN_summary.csv" i in using ($0*5/60):($4/100) with fsteps

set output "/mnt/space/workspace/instrument_processing/data/site/300/gnuplot/300_All_Rainfall_Events_2D.6May18.png"
set title "Station 3"
plot for [in=1:100] "/mnt/space/workspace/instrument_processing/data/site/300/RAIN/300_RAIN_summary.csv" i in using ($0*5/60):($4/100) with fsteps

set output "/mnt/space/workspace/instrument_processing/data/site/400/gnuplot/400_All_Rainfall_Events_2D.6May18.png"
set title "Station 4"
plot for [in=1:100] "/mnt/space/workspace/instrument_processing/data/site/400/RAIN/400_RAIN_summary.csv" i in using ($0*5/60):($4/100) with fsteps

set output "/mnt/space/workspace/instrument_processing/data/site/500/gnuplot/500_All_Rainfall_Events_2D.6May18.png"
set title "Station 5"
plot for [in=1:100] "/mnt/space/workspace/instrument_processing/data/site/500/RAIN/500_RAIN_summary.csv" i in using ($0*5/60):($4/100) with fsteps

set output "/mnt/space/workspace/instrument_processing/data/site/600/gnuplot/600_All_Rainfall_Events_2D.6May18.png"
set title "Station 6"
plot for [in=1:100] "/mnt/space/workspace/instrument_processing/data/site/600/RAIN/600_RAIN_summary.csv" i in using ($0*5/60):($4/100) with fsteps

set output "/mnt/space/workspace/instrument_processing/data/site/700/gnuplot/700_All_Rainfall_Events_2D.6May18.png"
set title "Station 7"
plot for [in=1:100] "/mnt/space/workspace/instrument_processing/data/site/700/RAIN/700_RAIN_summary.csv" i in using ($0*5/60):($4/100) with fsteps

set output "/mnt/space/workspace/instrument_processing/data/site/800/gnuplot/800_All_Rainfall_Events_2D.6May18.png"
set title "Station 8"
plot for [in=1:100] "/mnt/space/workspace/instrument_processing/data/site/800/RAIN/800_RAIN_summary.csv" i in using ($0*5/60):($4/100) with fsteps

set output "/mnt/space/workspace/instrument_processing/data/site/900/gnuplot/900_All_Rainfall_Events_2D.6May18.png"
set title "Station 9"
plot for [in=1:100] "/mnt/space/workspace/instrument_processing/data/site/900/RAIN/900_RAIN_summary.csv" i in using ($0*5/60):($4/100) with fsteps

set output "/mnt/space/workspace/instrument_processing/data/site/10000/gnuplot/10000_All_Rainfall_Events_2D.6May18.png"
set title "Station 10"
plot for [in=1:100] "/mnt/space/workspace/instrument_processing/data/site/10000/RAIN/10000_RAIN_summary.csv" i in using ($0*5/60):($4/100) with fsteps

set output "/mnt/space/workspace/instrument_processing/data/site/1100/gnuplot/1100_All_Rainfall_Events_2D.6May18.png"
set title "Station 11"
plot for [in=1:100] "/mnt/space/workspace/instrument_processing/data/site/1100/RAIN/1100_RAIN_summary.csv" i in using ($0*5/60):($4/100) with fsteps

set output "/mnt/space/workspace/instrument_processing/data/site/1200/gnuplot/1200_All_Rainfall_Events_2D.6May18.png"
set title "Station 12"
plot for [in=1:100] "/mnt/space/workspace/instrument_processing/data/site/1200/RAIN/1200_RAIN_summary.csv" i in using ($0*5/60):($4/100) with fsteps
############### ################ Plot all rainfall events at each station 2d

################ Plot all rainfall events together 2d
set output "/mnt/space/workspace/instrument_processing/data/site/ALLDATA/All_Rainfall_Events_2D.6May18.png"
set title "All Stations"
plot for [in=1:100] "/mnt/space/workspace/instrument_processing/data/site/100/RAIN/100_RAIN_summary.csv" i in using ($0*5/60):($4/100) with impulses, \
"/mnt/space/workspace/instrument_processing/data/site/200/RAIN/200_RAIN_summary.csv" i in using ($0*5/60):($4/100) with impulses, \
"/mnt/space/workspace/instrument_processing/data/site/300/RAIN/300_RAIN_summary.csv" i in using ($0*5/60):($4/100) with impulses, \
"/mnt/space/workspace/instrument_processing/data/site/400/RAIN/400_RAIN_summary.csv" i in using ($0*5/60):($4/100) with impulses, \
"/mnt/space/workspace/instrument_processing/data/site/500/RAIN/500_RAIN_summary.csv" i in using ($0*5/60):($4/100) with impulses, \
"/mnt/space/workspace/instrument_processing/data/site/600/RAIN/600_RAIN_summary.csv" i in using ($0*5/60):($4/100) with impulses, \
"/mnt/space/workspace/instrument_processing/data/site/700/RAIN/700_RAIN_summary.csv" i in using ($0*5/60):($4/100) with impulses, \
"/mnt/space/workspace/instrument_processing/data/site/800/RAIN/800_RAIN_summary.csv" i in using ($0*5/60):($4/100) with impulses, \
"/mnt/space/workspace/instrument_processing/data/site/900/RAIN/900_RAIN_summary.csv" i in using ($0*5/60):($4/100) with impulses, \
"/mnt/space/workspace/instrument_processing/data/site/10000/RAIN/10000_RAIN_summary.csv" i in using ($0*5/60):($4/100) with impulses, \
"/mnt/space/workspace/instrument_processing/data/site/1100/RAIN/1100_RAIN_summary.csv" i in using ($0*5/60):($4/100) with impulses, \
"/mnt/space/workspace/instrument_processing/data/site/1200/RAIN/1200_RAIN_summary.csv" i in using ($0*5/60):($4/100) with impulses
################ Plot all rainfall events together 2d

############### Plot each station cumulative
unset key
set terminal png size 1280,960

set output "/mnt/space/workspace/instrument_processing/data/site/100/gnuplot/100_All_Rainfall_Events_Cumulative.6May18.png"
set title "Station 1"
plot for [in=1:160] "/mnt/space/workspace/instrument_processing/data/site/100/RAIN/100_RAIN_summary.csv" i in using ($0*5/60):($4/100) with lines smooth cumulative ls 6 lw 2

set output "/mnt/space/workspace/instrument_processing/data/site/200/gnuplot/200_All_Rainfall_Events_Cumulative.6May18.png"
set title "Station 2"
plot for [in=1:98] "/mnt/space/workspace/instrument_processing/data/site/200/RAIN/200_RAIN_summary.csv" i in using ($0*5/60):($4/100) with lines smooth cumulative ls 6 lw 2

set output "/mnt/space/workspace/instrument_processing/data/site/300/gnuplot/300_All_Rainfall_Events_Cumulative.6May18.png"
set title "Station 3"
plot for [in=1:100] "/mnt/space/workspace/instrument_processing/data/site/300/RAIN/300_RAIN_summary.csv" i in using ($0*5/60):($4/100) with lines smooth cumulative ls 6 lw 2

set output "/mnt/space/workspace/instrument_processing/data/site/400/gnuplot/400_All_Rainfall_Events_Cumulative.6May18.png"
set title "Station 4"
plot for [in=1:100] "/mnt/space/workspace/instrument_processing/data/site/400/RAIN/400_RAIN_summary.csv" i in using ($0*5/60):($4/100) with lines smooth cumulative ls 6 lw 2

set output "/mnt/space/workspace/instrument_processing/data/site/500/gnuplot/500_All_Rainfall_Events_Cumulative.6May18.png"
set title "Station 5"
plot for [in=1:100] "/mnt/space/workspace/instrument_processing/data/site/500/RAIN/500_RAIN_summary.csv" i in using ($0*5/60):($4/100) with lines smooth cumulative ls 6 lw 2

set output "/mnt/space/workspace/instrument_processing/data/site/600/gnuplot/600_All_Rainfall_Events_Cumulative.6May18.png"
set title "Station 6"
plot for [in=1:100] "/mnt/space/workspace/instrument_processing/data/site/600/RAIN/600_RAIN_summary.csv" i in using ($0*5/60):($4/100) with lines smooth cumulative ls 6 lw 2

set output "/mnt/space/workspace/instrument_processing/data/site/700/gnuplot/700_All_Rainfall_Events_Cumulative.6May18.png"
set title "Station 7"
plot for [in=1:100] "/mnt/space/workspace/instrument_processing/data/site/700/RAIN/700_RAIN_summary.csv" i in using ($0*5/60):($4/100) with lines smooth cumulative ls 6 lw 2

set output "/mnt/space/workspace/instrument_processing/data/site/800/gnuplot/800_All_Rainfall_Events_Cumulative.6May18.png"
set title "Station 8"
plot for [in=1:100] "/mnt/space/workspace/instrument_processing/data/site/800/RAIN/800_RAIN_summary.csv" i in using ($0*5/60):($4/100) with lines smooth cumulative ls 6 lw 2

set output "/mnt/space/workspace/instrument_processing/data/site/900/gnuplot/900_All_Rainfall_Events_Cumulative.6May18.png"
set title "Station 9"
plot for [in=1:100] "/mnt/space/workspace/instrument_processing/data/site/900/RAIN/900_RAIN_summary.csv" i in using ($0*5/60):($4/100) with lines smooth cumulative ls 6 lw 2

set output "/mnt/space/workspace/instrument_processing/data/site/10000/gnuplot/10000_All_Rainfall_Events_Cumulative.6May18.png"
set title "Station 10"
plot for [in=1:100] "/mnt/space/workspace/instrument_processing/data/site/10000/RAIN/10000_RAIN_summary.csv" i in using ($0*5/60):($4/100) with lines smooth cumulative ls 6 lw 2

set output "/mnt/space/workspace/instrument_processing/data/site/1100/gnuplot/1100_All_Rainfall_Events_Cumulative.6May18.png"
set title "Station 11"
plot for [in=1:100] "/mnt/space/workspace/instrument_processing/data/site/1100/RAIN/1100_RAIN_summary.csv" i in using ($0*5/60):($4/100) with lines smooth cumulative ls 6 lw 2

set output "/mnt/space/workspace/instrument_processing/data/site/1200/gnuplot/1200_All_Rainfall_Events_Cumulative.6May18.png"
set title "Station 12"
plot for [in=1:100] "/mnt/space/workspace/instrument_processing/data/site/1200/RAIN/1200_RAIN_summary.csv" i in using ($0*5/60):($4/100) with lines smooth cumulative ls 6 lw 2

############### end Plot each station cumulative


############### Plot all events at each station cumulative
unset key
plot for [in=1:100] "/mnt/space/workspace/instrument_processing/data/site/100/RAIN/100_RAIN_summary.csv" i in using ($0*5/60):($4/100) with lines smooth cumulative ls 1 lw 1 
replot for [in=1:100] "/mnt/space/workspace/instrument_processing/data/site/200/RAIN/200_RAIN_summary.csv" i in using ($0*5/60):($4/100) with lines smooth cumulative ls 2 lw 1 
replot for [in=1:100] "/mnt/space/workspace/instrument_processing/data/site/300/RAIN/300_RAIN_summary.csv" i in using ($0*5/60):($4/100) with lines smooth cumulative ls 3 lw 1 
replot for [in=1:100] "/mnt/space/workspace/instrument_processing/data/site/400/RAIN/400_RAIN_summary.csv" i in using ($0*5/60):($4/100) with lines smooth cumulative ls 4 lw 1 
replot for [in=1:100] "/mnt/space/workspace/instrument_processing/data/site/500/RAIN/500_RAIN_summary.csv" i in using ($0*5/60):($4/100) with lines smooth cumulative ls 5 lw 1 
replot for [in=1:100] "/mnt/space/workspace/instrument_processing/data/site/600/RAIN/600_RAIN_summary.csv" i in using ($0*5/60):($4/100) with lines smooth cumulative ls 6 lw 1 
replot for [in=1:100] "/mnt/space/workspace/instrument_processing/data/site/700/RAIN/700_RAIN_summary.csv" i in using ($0*5/60):($4/100) with lines smooth cumulative ls 7 lw 1 
replot for [in=1:100] "/mnt/space/workspace/instrument_processing/data/site/800/RAIN/800_RAIN_summary.csv" i in using ($0*5/60):($4/100) with lines smooth cumulative ls 8 lw 1 
replot for [in=1:100] "/mnt/space/workspace/instrument_processing/data/site/900/RAIN/900_RAIN_summary.csv" i in using ($0*5/60):($4/100) with lines smooth cumulative ls 9 lw 1 
replot for [in=1:100] "/mnt/space/workspace/instrument_processing/data/site/1000/RAIN/10000_RAIN_summary.csv" i in using ($0*5/60):($4/100) with lines smooth cumulative ls 10 lw 1 
replot for [in=1:100] "/mnt/space/workspace/instrument_processing/data/site/1100/RAIN/1100_RAIN_summary.csv" i in using ($0*5/60):($4/100) with lines smooth cumulative ls 11 lw 1 
#replot for [in=1:100] "/mnt/space/workspace/instrument_processing/data/site/1200/RAIN/1200_RAIN_summary.csv" i in using ($0*5/60):($4/100) with lines smooth cumulative ls 12 lw 1 


#replot for [in=160:160] "/mnt/space/workspace/instrument_processing/data/site/100/RAIN/100_RAIN_summary.csv" i in using ($0*5/60):($4/100) with lines smooth cumulative ls 1 lw 1 title "Sta 1"


plot for [in=1:120] "300_RAIN_summary.csv" i in using ($0*5/60):($4/100) with filledcurve lw 2

set term pdfcairo

######### plot depth and rain per event
set yrange [0:5]
plot for [in=1:12] "/mnt/space/workspace/instrument_processing/data/site/100/ALLDATA/100_ALLDATA_CONDENSED.csv" i in using ($0*5/60):($4/100) with lines smooth cumulative
replot for [in=1:12] "/mnt/space/workspace/instrument_processing/data/site/100/ALLDATA/100_ALLDATA_CONDENSED.csv" i in using ($0*5/60):($7/100) with lines 

plot for [in=1:12] "/mnt/space/workspace/instrument_processing/data/site/100/ALLDATA/100_ALLDATA_CONDENSED.csv" i in using ($0*5/60):($4/100) with impulses, \
"/mnt/space/workspace/instrument_processing/data/site/100/ALLDATA/100_ALLDATA_CONDENSED.csv" i in using ($0*5/60):($7/100) with lines 

plot for [in=1:12] "/mnt/space/workspace/instrument_processing/data/site/100/ALLDATA/100_ALLDATA_CONDENSED.csv" i in using ($0*5/60):($7/100) with lines 

plot for [in=1:1] "/mnt/space/workspace/instrument_processing/data/site/100/ALLDATA/100_ALLDATA_CONDENSED.csv" i in using ($4):($7/100) with lines smooth cumulative

############### Plot depth vs rain for all stations
unset key
set terminal png size 1280,960

set output "/mnt/space/workspace/instrument_processing/data/site/100/gnuplot/100_Depth_vs_Rain.png"
set title "Station 1"
set xlabel "Cumulative Rain (in)"
set ylabel "Cumulative Depth (ft)'
plot for [in=0:0] "/mnt/space/workspace/instrument_processing/data/site/100/ALLDATA/100_ALLDATA_CONDENSED.csv" i in using ($8/100):($9/100) with points #lines smooth cumulative

set output "/mnt/space/workspace/instrument_processing/data/site/200/gnuplot/200_Depth_vs_Rain.png"
set title "Station 2"
set xlabel "Cumulative Rain (in)"
set ylabel "Cumulative Depth (ft)'
plot for [in=0:0] "/mnt/space/workspace/instrument_processing/data/site/200/ALLDATA/200_ALLDATA_CONDENSED.csv" i in using ($8/100):($9/100) with points #lines smooth cumulative

set output "/mnt/space/workspace/instrument_processing/data/site/300/gnuplot/300_Depth_vs_Rain.png"
set title "Station 3"
set xlabel "Cumulative Rain (in)"
set ylabel "Cumulative Depth (ft)'
plot for [in=0:0] "/mnt/space/workspace/instrument_processing/data/site/300/ALLDATA/300_ALLDATA_CONDENSED.csv" i in using ($8/100):($9/100) with points #lines smooth cumulative

set output "/mnt/space/workspace/instrument_processing/data/site/400/gnuplot/400_Depth_vs_Rain.png"
set title "Station 4"
set xlabel "Cumulative Rain (in)"
set ylabel "Cumulative Depth (ft)'
plot for [in=0:0] "/mnt/space/workspace/instrument_processing/data/site/400/ALLDATA/400_ALLDATA_CONDENSED.csv" i in using ($8/100):($9/100) with points #lines smooth cumulative

set output "/mnt/space/workspace/instrument_processing/data/site/500/gnuplot/500_Depth_vs_Rain.png"
set title "Station 5"
set xlabel "Cumulative Rain (in)"
set ylabel "Cumulative Depth (ft)'
plot for [in=0:0] "/mnt/space/workspace/instrument_processing/data/site/500/ALLDATA/500_ALLDATA_CONDENSED.csv" i in using ($8/100):($9/100) with points #lines smooth cumulative

set output "/mnt/space/workspace/instrument_processing/data/site/600/gnuplot/600_Depth_vs_Rain.png"
set title "Station 6"
set xlabel "Cumulative Rain (in)"
set ylabel "Cumulative Depth (ft)'
plot for [in=0:0] "/mnt/space/workspace/instrument_processing/data/site/600/ALLDATA/600_ALLDATA_CONDENSED.csv" i in using ($8/100):($9/100) with points #lines smooth cumulative

set output "/mnt/space/workspace/instrument_processing/data/site/700/gnuplot/700_Depth_vs_Rain.png"
set title "Station 7"
set xlabel "Cumulative Rain (in)"
set ylabel "Cumulative Depth (ft)'
plot for [in=0:0] "/mnt/space/workspace/instrument_processing/data/site/700/ALLDATA/700_ALLDATA_CONDENSED.csv" i in using ($8/100):($9/100) with points #lines smooth cumulative

set output "/mnt/space/workspace/instrument_processing/data/site/800/gnuplot/800_Depth_vs_Rain.png"
set title "Station 8"
set xlabel "Cumulative Rain (in)"
set ylabel "Cumulative Depth (ft)'
plot for [in=0:0] "/mnt/space/workspace/instrument_processing/data/site/800/ALLDATA/800_ALLDATA_CONDENSED.csv" i in using ($8/100):($9/100) with points #lines smooth cumulative

set output "/mnt/space/workspace/instrument_processing/data/site/900/gnuplot/900_Depth_vs_Rain.png"
set title "Station 9"
set xlabel "Cumulative Rain (in)"
set ylabel "Cumulative Depth (ft)'
plot for [in=0:0] "/mnt/space/workspace/instrument_processing/data/site/900/ALLDATA/900_ALLDATA_CONDENSED.csv" i in using ($8/100):($9/100) with points #lines smooth cumulative

set output "/mnt/space/workspace/instrument_processing/data/site/10000/gnuplot/10000_Depth_vs_Rain.png"
set title "Station 10"
set xlabel "Cumulative Rain (in)"
set ylabel "Cumulative Depth (ft)'
plot for [in=0:0] "/mnt/space/workspace/instrument_processing/data/site/10000/ALLDATA/10000_ALLDATA_CONDENSED.csv" i in using ($8/100):($9/100) with points #lines smooth cumulative

set output "/mnt/space/workspace/instrument_processing/data/site/1100/gnuplot/1100_Depth_vs_Rain.png"
set title "Station 11"
set xlabel "Cumulative Rain (in)"
set ylabel "Cumulative Depth (ft)'
plot for [in=0:0] "/mnt/space/workspace/instrument_processing/data/site/1100/ALLDATA/1100_ALLDATA_CONDENSED.csv" i in using ($8/100):($9/100) with points #lines smooth cumulative

set output "/mnt/space/workspace/instrument_processing/data/site/1200/gnuplot/1200_Depth_vs_Rain.png"
set title "Station 12"
set xlabel "Cumulative Rain (in)"
set ylabel "Cumulative Depth (ft)'
plot for [in=0:0] "/mnt/space/workspace/instrument_processing/data/site/1200/ALLDATA/1200_ALLDATA_CONDENSED.csv" i in using ($8/100):($9/100) with points #lines smooth cumulative
