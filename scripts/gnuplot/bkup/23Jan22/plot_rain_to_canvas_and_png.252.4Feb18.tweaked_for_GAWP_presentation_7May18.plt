#tweak of plot info just to produce a few usable items.  Always...

rain_name = '/mnt/space/workspace/instrument_processing/data/site/100/RAIN/100_RAIN.txt'
depth_name = '/mnt/space/workspace/instrument_processing/data/site/100/DEPTH/100_DEPTH.txt'
set title "Station 1"
unset key
set multiplot layout 3,1 rowsfirst upwards                             
set lmargin 10
set bmargin 8
set grid
set tics out
set xdata time
set timefmt "%m/%d/%y %H:%M"
set format x "%m/%d\n %H:%M"
set xtics nomirror rotate
#set xrange [time(0) - 203*24*60*60:*] #without the *, it defaults to last max or min, which we set earlier while trying to find the max/min value
set xrange ["03/19/18":"03/24/18"]
set ytics nomirror
set ylabel "Rain(in)"
plot rain_name index 0 using 3:5 with impulses lt 3 lw 2
set format x ""
set bmargin 1
set ylabel "Depth(ft)"
set samples 65
plot depth_name index 0 using 3:($5/100.) with lines lt 8 lw 1
set ylabel "Cumulative Rain(in)"
set yrange[24:26]
plot rain_name index 0 using 3:($5/100.) with lines lt 3 lw 2 smooth cumulative 
unset multiplot
unset yrange

rain_name = '/mnt/space/workspace/instrument_processing/data/site/800/RAIN/800_RAIN.txt'
depth_name = '/mnt/space/workspace/instrument_processing/data/site/800/DEPTH/800_DEPTH.txt'
set title "Station 8"
unset key
set multiplot layout 3,1 rowsfirst upwards                             
set lmargin 10
set bmargin 8
set grid
set tics out
set xdata time
set timefmt "%m/%d/%y %H:%M"
set format x "%m/%d\n %H:%M"
set xtics nomirror rotate
#set xrange [time(0) - 203*24*60*60:*] #without the *, it defaults to last max or min, which we set earlier while trying to find the max/min value
set xrange ["03/19/18":"03/24/18"]
set ytics nomirror
set ylabel "Rain(in)"
plot rain_name index 0 using 3:5 with impulses lt 3 lw 2
set format x ""
set bmargin 1
set ylabel "Depth(ft)"
set samples 65
plot depth_name index 0 using 3:($5/100.) with lines lt 8 lw 1
set ylabel "Cumulative Rain(in)"
set yrange[20:25]
plot rain_name index 0 using 3:($5/100.) with lines lt 3 lw 2 smooth cumulative 
unset multiplot
unset yrange

rain_name = '/mnt/space/workspace/instrument_processing/data/site/10000/RAIN/10000_RAIN.txt'
depth_name = '/mnt/space/workspace/instrument_processing/data/site/10000/DEPTH/10000_DEPTH.txt'
set title "Station 10"
unset key
set multiplot layout 3,1 rowsfirst upwards                             
set lmargin 10
set bmargin 8
set grid
set tics out
set xdata time
set timefmt "%m/%d/%y %H:%M"
set format x "%m/%d\n %H:%M"
set xtics nomirror rotate
#set xrange [time(0) - 203*24*60*60:*] #without the *, it defaults to last max or min, which we set earlier while trying to find the max/min value
set xrange ["03/19/18":"03/24/18"]
set ytics nomirror
set ylabel "Rain(in)"
plot rain_name index 0 using 3:5 with impulses lt 3 lw 2
set format x ""
set bmargin 1
set ylabel "Depth(ft)"
set samples 65
plot depth_name index 0 using 3:($5/100.) with lines lt 8 lw 1
set ylabel "Cumulative Rain(in)"
set yrange[30:35]
plot rain_name index 0 using 3:($5/100.) with lines lt 3 lw 2 smooth cumulative 
unset multiplot
unset yrange

rain_name8 = '/mnt/space/workspace/instrument_processing/data/site/800/RAIN/800_RAIN.txt'
depth_name8 = '/mnt/space/workspace/instrument_processing/data/site/800/DEPTH/800_DEPTH.txt'
rain_name10 = '/mnt/space/workspace/instrument_processing/data/site/10000/RAIN/10000_RAIN.txt'
depth_name10 = '/mnt/space/workspace/instrument_processing/data/site/10000/DEPTH/10000_DEPTH.txt'
set title "Stations 8 (Rural)    10 (Suburban)"
unset key
set multiplot layout 3,1 rowsfirst upwards                             
set lmargin 10
set bmargin 8
set grid
set tics out
set xdata time
set timefmt "%m/%d/%y %H:%M"
set format x "%m/%d\n %H:%M"
set xtics nomirror rotate
#set xrange [time(0) - 203*24*60*60:*] #without the *, it defaults to last max or min, which we set earlier while trying to find the max/min value
set xrange ["03/19/18":"03/24/18"]
set ytics nomirror
set ylabel "Rain(in)"
plot rain_name8 index 0 using 3:5 with impulses lt 3 lw 2, \
rain_name10 index 0 using 3:5 with impulses lt 4 lw 2
set format x ""
set bmargin 1
set ylabel "Depth(ft)"
set samples 65
plot depth_name8 index 0 using 3:($5/100.) with lines lt 8 lw 1, \
depth_name10 index 0 using 3:($5/100.) with lines lt 9 lw 1
set ylabel "Cumulative Rain(in)"
set yrange[20:35]
plot rain_name8 index 0 using 3:($5/100.) with lines lt 3 lw 2 smooth cumulative , \
rain_name10 index 0 using 3:($5/100.) with lines lt 4 lw 2 smooth cumulative 
unset multiplot
unset yrange

