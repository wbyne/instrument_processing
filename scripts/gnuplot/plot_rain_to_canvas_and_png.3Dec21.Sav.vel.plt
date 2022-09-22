# Mouseable plots embedded in web pages
# can be generated using the svg or HTML5 canvas terminal drivers.
# Richer, Younger, Better Looking version (TM)
## BTW, the time function comes from: http://stackoverflow.com/questions/38704617/gnuplot-variable-xrange-to-plot-only-last-weeks-worth-of-captured-data
set terminal unknown
set timefmt "%m/%d/%y %H:%M"
set xdata time
set xrange [*:time(0) - 14*24*60*60]
#i'm assuming rain_name exists. might be a bad idea, but ...
#false plot to get some stats info on the timeseries.  stats doesn't work on timeseries data
plot rain_name index 0 using 3:(($5/100.)) with lines lt 3 lw 2 smooth cumulative
maxy = GPVAL_Y_MAX-2 #GPVAL_Y_MAX adds a little to the Y_MAX because it's the extents
set terminal canvas standalone mousing size 900,1100 jsdir 'https://www.rainfalldata.com/rainfall/resources/gnuplot/'
set output htmlfilename
#set terminal qt
if ((exists("rain_name"))&&(exists("depth_name"))&&(exists("temp_name"))&&(exists("wtr_tmp_name"))&&(exists("cond_name"))&&(exists("tmp_rtc_name"))&&(exists("velo_name"))) {
unset key
set multiplot layout 8,1 rowsfirst upwards                             
set lmargin 14
set bmargin 8
set grid
set tics out
set xdata time
set timefmt "%m/%d/%y %H:%M"
set format x "%m/%d\n %H:%M"
set xtics nomirror rotate
set xrange [time(0) - 14*24*60*60:*] #without the *, it defaults to last max or min, which we set earlier while trying to find the max/min value
set ytics nomirror
set ylabel "Rain(in)"
plot rain_name index 0 using 3:5 with impulses lt 3 lw 2
set format x ""
set bmargin 1
set ylabel "Depth(ft)"
set samples 65
plot depth_name index 0 using 3:($5/100.) with lines lt 8 lw 1
set ylabel "Velo(fps)"
#set samples 65
plot velo_name index 0 using 3:($5/100.) with lines lt 8 lw 1
set ylabel "Temp(F)"
plot temp_name index 0 using 3:5 with lines lt 10 lw 1 
set ylabel "WtrTemp(F)"
plot wtr_tmp_name index 0 using 3:5 with lines lt 5 lw 1 
set ylabel "Cond(ppt)"
plot cond_name index 0 using 3:5 with lines lt 6 lw 1 
set ylabel "TempRTC(F)"
plot tmp_rtc_name index 0 using 3:5 with lines lt 7 lw 1 
set ylabel "TotalRain(in)"
set yrange[maxy:*]
plot rain_name index 0 using 3:($5/100.) with lines lt 3 lw 2 smooth cumulative 
unset multiplot
}

#Using the ternary operator from the gnuplot manual:
#One trick is to use the ternary ?: operator to  filter data:
#plot 'file' using 1:($3>10 ? $2 : 1/0)
#If 3>10, then plots 1, otherwise nothing b/c 1/0 is undefined.

#set xrange [*:time(0) - 14*24*60*60]
#might be able to use xrange [*:-1-4032].  didn't try it yet.
#stats "/mnt/space/workspace/instrument_processing/data/site/7000/RAIN/7000_RAI#N.txt" index 0 using 3:($5/100.)
#stats aren't supported in timedata mode

