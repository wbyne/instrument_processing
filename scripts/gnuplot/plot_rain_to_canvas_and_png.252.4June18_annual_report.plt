#tweak of plot info just to produce a few usable items.  Always...

#stations 1, 9, 3
rain_name1 = '/mnt/space/workspace/instrument_processing/data/site/100/RAIN/100_RAIN.txt'
rain_name9 = '/mnt/space/workspace/instrument_processing/data/site/900/RAIN/900_RAIN.txt'
rain_name3 = '/mnt/space/workspace/instrument_processing/data/site/300/RAIN/300_RAIN.txt'
depth_name1 = '/mnt/space/workspace/instrument_processing/data/site/100/DEPTH/100_DEPTH.txt'
depth_name9 = '/mnt/space/workspace/instrument_processing/data/site/900/DEPTH/900_DEPTH.txt'
depth_name3 = '/mnt/space/workspace/instrument_processing/data/site/300/DEPTH/300_DEPTH.txt'
set title "Stations 1, 9, 3 (Crane & Raes)"
set key
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
set xrange ["03/19/18":"03/21/18"]
set ytics nomirror
set ylabel "Rain(in)"
plot rain_name1 index 0 using 3:5 with impulses lt 8 lw 3 title "Sta 1", \
rain_name3 index 0 using 3:5 with impulses lt 10 lw 2 title "Sta 3", \
rain_name9 index 0 using 3:5 with impulses lt 9 lw 1 title "Sta 9"
set format x ""
set bmargin 1
set ylabel "Depth(ft)"
set samples 100
plot depth_name1 index 0 using 3:(($5/100.)-1.25) with lines lt 8 lw 1 title "Sta 1", \
depth_name3 index 0 using 3:(($5/100.)-1) with lines lt 10 lw 2 title "Sta 3", \
depth_name9 index 0 using 3:($5/100.) with lines lt 9 lw 1 title "Sta 9"
set ylabel "Cumulative Rain(in)"
set yrange[11:27]
plot rain_name1 index 0 using 3:(($5/100.)) with lines lt 8 lw 2 smooth cumulative title "Sta 1", \
rain_name3 index 0 using 3:(($5/100.)) with lines lt 10 lw 1 smooth cumulative title "Sta 3", \
rain_name9 index 0 using 3:(($5/100.)) with lines lt 9 lw 1 smooth cumulative title "Sta 9" 
unset multiplot
unset yrange

#Stations 10, 2
rain_name10 = '/mnt/space/workspace/instrument_processing/data/site/10000/RAIN/10000_RAIN.txt'
rain_name2 = '/mnt/space/workspace/instrument_processing/data/site/200/RAIN/200_RAIN.txt'
depth_name10 = '/mnt/space/workspace/instrument_processing/data/site/10000/DEPTH/10000_DEPTH.txt'
depth_name2 = '/mnt/space/workspace/instrument_processing/data/site/200/DEPTH/200_DEPTH.txt'
set title "Stations 10, 2 (Rock)"
set key
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
set xrange ["03/19/18":"03/21/18"]
set ytics nomirror
set ylabel "Rain(in)"
plot rain_name10 index 0 using 3:5 with impulses lt 8 lw 3 title "Sta 10", \
rain_name2 index 0 using 3:5 with impulses lt 10 lw 2 title "Sta 2"
set format x ""
set bmargin 1
set ylabel "Depth(ft)"
set samples 100
plot depth_name10 index 0 using 3:(($5/100.)-1.25) with lines lt 8 lw 1 title "Sta 10", \
depth_name2 index 0 using 3:(($5/100.)-1) with lines lt 10 lw 2 title "Sta 2"
set ylabel "Cumulative Rain(in)"
set yrange[15:30]
plot rain_name10 index 0 using 3:(($5/100.)) with lines lt 8 lw 2 smooth cumulative title "Sta 10", \
rain_name2 index 0 using 3:(($5/100.)) with lines lt 10 lw 1 smooth cumulative title "Sta 2"
unset multiplot
unset yrange

#just station 8
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

#just station 10
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

#stations 8, 9, to show Rural vs Suburban
rain_name8 = '/mnt/space/workspace/instrument_processing/data/site/800/RAIN/800_RAIN.txt'
depth_name8 = '/mnt/space/workspace/instrument_processing/data/site/800/DEPTH/800_DEPTH.txt'
rain_name9 = '/mnt/space/workspace/instrument_processing/data/site/900/RAIN/900_RAIN.txt'
depth_name9 = '/mnt/space/workspace/instrument_processing/data/site/900/DEPTH/900_DEPTH.txt'
set title "Stations 8 (Rural)    9 (Suburban)"
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
plot rain_name9 index 0 using 3:5 with impulses lt 3 lw 2, \
rain_name8 index 0 using 3:5 with impulses lt 4 lw 2
set format x ""
set bmargin 1
set ylabel "Depth(ft)"
set samples 65
plot depth_name9 index 0 using 3:($5/100.) with lines lt 8 lw 1, \
depth_name8 index 0 using 3:($5/100.) with lines lt 9 lw 1
set ylabel "Cumulative Rain(in)"
#set yrange[15:25]
plot rain_name9 index 0 using 3:($5/100.) with lines lt 3 lw 2 smooth cumulative , \
rain_name8 index 0 using 3:($5/100.) with lines lt 4 lw 2 smooth cumulative 
unset multiplot
unset yrange

#stations 4, 8 (Spirit)
rain_name4 = '/mnt/space/workspace/instrument_processing/data/site/400/RAIN/400_RAIN.txt'
depth_name4 = '/mnt/space/workspace/instrument_processing/data/site/400/DEPTH/400_DEPTH.txt'
rain_name8 = '/mnt/space/workspace/instrument_processing/data/site/800/RAIN/800_RAIN.txt'
depth_name8 = '/mnt/space/workspace/instrument_processing/data/site/800/DEPTH/800_DEPTH.txt'
#datestart = '"03/19/18"'
#datestop = '"03/24/18"'
set title "Spirit Creek 4 (Jamestown) 8 (Goshen)"
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
#set xrange [datestart:datestop]
set xrange ["03/19/18":"03/24/18"]
set ytics nomirror
set ylabel "Rain(in)"
plot rain_name8 index 0 using 3:5 with impulses lt 3 lw 2, \
rain_name4 index 0 using 3:5 with impulses lt 4 lw 2
set format x ""
set bmargin 1
set ylabel "Depth(ft)"
set samples 65
plot depth_name8 index 0 using 3:($5/100.) with lines lt 8 lw 1, \
depth_name4 index 0 using 3:($5/100.) with lines lt 9 lw 1
set ylabel "Cumulative Rain(in)"
unset yrange
#set yrange[20:35]
plot rain_name8 index 0 using 3:($5/100.) with lines lt 3 lw 2 smooth cumulative , \
rain_name4 index 0 using 3:($5/100.) with lines lt 4 lw 2 smooth cumulative 
unset multiplot
unset yrange

#some testing here.  Trying to get all of them plotted together.
rain_name1 = '/mnt/space/workspace/instrument_processing/data/site/100/RAIN/100_RAIN.txt'
depth_name1 = '/mnt/space/workspace/instrument_processing/data/site/100/DEPTH/100_DEPTH.txt
rain_name2 = '/mnt/space/workspace/instrument_processing/data/site/200/RAIN/200_RAIN.txt'
depth_name2 = '/mnt/space/workspace/instrument_processing/data/site/200/DEPTH/200_DEPTH.txt
rain_name3 = '/mnt/space/workspace/instrument_processing/data/site/300/RAIN/300_RAIN.txt'
depth_name3 = '/mnt/space/workspace/instrument_processing/data/site/300/DEPTH/300_DEPTH.txt
rain_name4 = '/mnt/space/workspace/instrument_processing/data/site/400/RAIN/400_RAIN.txt'
depth_name4 = '/mnt/space/workspace/instrument_processing/data/site/400/DEPTH/400_DEPTH.txt
rain_name5 = '/mnt/space/workspace/instrument_processing/data/site/500/RAIN/500_RAIN.txt'
depth_name5 = '/mnt/space/workspace/instrument_processing/data/site/500/DEPTH/500_DEPTH.txt
rain_name6 = '/mnt/space/workspace/instrument_processing/data/site/600/RAIN/600_RAIN.txt'
depth_name6 = '/mnt/space/workspace/instrument_processing/data/site/600/DEPTH/600_DEPTH.txt
rain_name7 = '/mnt/space/workspace/instrument_processing/data/site/700/RAIN/700_RAIN.txt'
depth_name7 = '/mnt/space/workspace/instrument_processing/data/site/700/DEPTH/700_DEPTH.txt
rain_name8 = '/mnt/space/workspace/instrument_processing/data/site/800/RAIN/800_RAIN.txt'
depth_name8 = '/mnt/space/workspace/instrument_processing/data/site/800/DEPTH/800_DEPTH.txt
rain_name9 = '/mnt/space/workspace/instrument_processing/data/site/900/RAIN/900_RAIN.txt'
depth_name9 = '/mnt/space/workspace/instrument_processing/data/site/900/DEPTH/900_DEPTH.txt
rain_name10 = '/mnt/space/workspace/instrument_processing/data/site/10000/RAIN/10000_RAIN.txt'
depth_name10 = '/mnt/space/workspace/instrument_processing/data/site/10000/DEPTH/10000_DEPTH.txt
rain_name11 = '/mnt/space/workspace/instrument_processing/data/site/1100/RAIN/1100_RAIN.txt'
depth_name11 = '/mnt/space/workspace/instrument_processing/data/site/1100/DEPTH/1100_DEPTH.txt
rain_name12 = '/mnt/space/workspace/instrument_processing/data/site/1200/RAIN/1200_RAIN.txt'
depth_name12 = '/mnt/space/workspace/instrument_processing/data/site/1200/DEPTH/1200_DEPTH.txt'
#datestart = '"03/19/18"'
#datestop = '"03/24/18"'
set title "All Stations Rainfall (in)"
unset key
set multiplot layout 4,1 rowsfirst upwards                             
set lmargin 10
set bmargin 8
set grid
set tics out
set xdata time
set timefmt "%m/%d/%y %H:%M"
set format x "%m/%d\n %H:%M"
set xtics nomirror rotate
#set xrange [time(0) - 203*24*60*60:*] #without the *, it defaults to last max or min, which we set earlier while trying to find the max/min value
#set xrange [datestart:datestop]
#set xrange ["03/19/18":"03/24/18"]
set ytics nomirror
set ylabel "Sta 1"
plot rain_name1 index 0 using 3:5 with impulses lt 3 lw 2
set ylabel "Sta 2"
plot rain_name2 index 0 using 3:5 with impulses lt 3 lw 2
set ylabel "Sta 3"
plot rain_name3 index 0 using 3:5 with impulses lt 3 lw 2
set ylabel "Sta 4"
plot rain_name4 index 0 using 3:5 with impulses lt 3 lw 2
set ylabel "Sta 5"
plot rain_name5 index 0 using 3:5 with impulses lt 3 lw 2
set ylabel "Sta 6"
plot rain_name6 index 0 using 3:5 with impulses lt 3 lw 2
set ylabel "Sta 7"
plot rain_name7 index 0 using 3:5 with impulses lt 3 lw 2
set ylabel "Sta 8"
plot rain_name8 index 0 using 3:5 with impulses lt 3 lw 2
set ylabel "Sta 9"
plot rain_name9 index 0 using 3:5 with impulses lt 3 lw 2
set ylabel "Sta 10"
plot rain_name10 index 0 using 3:5 with impulses lt 3 lw 2
set ylabel "Sta 11"
plot rain_name11 index 0 using 3:5 with impulses lt 3 lw 2
set ylabel "Sta 12"
plot rain_name12 index 0 using 3:5 with impulses lt 3 lw 2
unset multiplot
unset yrange

#testing two raingages together
rain_name10 = '/mnt/space/workspace/instrument_processing/data/site/10000/RAIN/10000_RAIN.txt'
rain_name2 = '/mnt/space/workspace/instrument_processing/data/site/200/RAIN/200_RAIN.txt'
rain_name1 = '/mnt/space/workspace/instrument_processing/data/site/100/RAIN/100_RAIN.txt'
rain_name3 = '/mnt/space/workspace/instrument_processing/data/site/300/RAIN/300_RAIN.txt'
rain_name9 = '/mnt/space/workspace/instrument_processing/data/site/900/RAIN/900_RAIN.txt'
rain_name12 = '/mnt/space/workspace/instrument_processing/data/site/1200/RAIN/1200_RAIN.txt'
rain_name7 = '/mnt/space/workspace/instrument_processing/data/site/700/RAIN/700_RAIN.txt'
rain_name5 = '/mnt/space/workspace/instrument_processing/data/site/500/RAIN/500_RAIN.txt'
rain_name6 = '/mnt/space/workspace/instrument_processing/data/site/600/RAIN/600_RAIN.txt'
rain_name11 = '/mnt/space/workspace/instrument_processing/data/site/1100/RAIN/1100_RAIN.txt'
rain_name4 = '/mnt/space/workspace/instrument_processing/data/site/400/RAIN/400_RAIN.txt'
rain_name8 = '/mnt/space/workspace/instrument_processing/data/site/800/RAIN/800_RAIN.txt'
#datestart = '"03/19/18"'
#datestop = '"03/24/18"'
unset title 
unset key
set multiplot layout 2,1 rowsfirst upwards                             
set lmargin 10
set bmargin 4
set grid
set tics out
set xdata time
set timefmt "%m/%d/%y %H:%M"
set format x "%m/%d\n %H:%M"
set xtics nomirror rotate
#set xrange [time(0) - 203*24*60*60:*] #without the *, it defaults to last max or min, which we set earlier while trying to find the max/min value
#set xrange [datestart:datestop]
#set xrange ["03/19/18":"03/24/18"]
set yrange [0:50]
set ytics nomirror
set ylabel "Sta 10"
plot rain_name10 index 0 using 3:5 with impulses lt 3 lw 2
set bmargin 1
set format x ""
set ylabel "Sta 2"
set title "All Stations Rainfall (in)"
plot rain_name2 index 0 using 3:5 with impulses lt 3 lw 2
unset multiplot
unset yrange

#First Six raingages together, Last Half 2017
set terminal png size 1280,960
set output "/mnt/space/workspace/instrument_processing/data/site/ALLDATA/gnuplot/All_Rainfall_Events_first_six_July_through_Dec17_multiplot.10June18.png"
rain_name10 = '/mnt/space/workspace/instrument_processing/data/site/10000/RAIN/10000_RAIN.txt'
rain_name2 = '/mnt/space/workspace/instrument_processing/data/site/200/RAIN/200_RAIN.txt'
rain_name1 = '/mnt/space/workspace/instrument_processing/data/site/100/RAIN/100_RAIN.txt'
rain_name3 = '/mnt/space/workspace/instrument_processing/data/site/300/RAIN/300_RAIN.txt'
rain_name9 = '/mnt/space/workspace/instrument_processing/data/site/900/RAIN/900_RAIN.txt'
rain_name12 = '/mnt/space/workspace/instrument_processing/data/site/1200/RAIN/1200_RAIN.txt'
rain_name7 = '/mnt/space/workspace/instrument_processing/data/site/700/RAIN/700_RAIN.txt'
rain_name5 = '/mnt/space/workspace/instrument_processing/data/site/500/RAIN/500_RAIN.txt'
rain_name6 = '/mnt/space/workspace/instrument_processing/data/site/600/RAIN/600_RAIN.txt'
rain_name11 = '/mnt/space/workspace/instrument_processing/data/site/1100/RAIN/1100_RAIN.txt'
rain_name4 = '/mnt/space/workspace/instrument_processing/data/site/400/RAIN/400_RAIN.txt'
rain_name8 = '/mnt/space/workspace/instrument_processing/data/site/800/RAIN/800_RAIN.txt'
#datestart = '"03/19/18"'
#datestop = '"03/24/18"'
unset title 
unset key
set multiplot layout 6,1 rowsfirst upwards                             
set lmargin 10
set bmargin 4
set grid
set tics out
set xdata time
set timefmt "%m/%d/%y %H:%M"
set format x "%m/%d\n %H:%M"
set xtics nomirror rotate
#set xrange [time(0) - 203*24*60*60:*] #without the *, it defaults to last max or min, which we set earlier while trying to find the max/min value
#set xrange [datestart:datestop]
set xrange ["07/01/17":"12/31/17"]
set yrange [0:50]
set ytics nomirror
set ylabel "Sta 10"
plot rain_name10 index 0 using 3:5 with impulses lt 3 lw 2
set bmargin 1
set format x ""
set ylabel "Sta 2"
plot rain_name2 index 0 using 3:5 with impulses lt 3 lw 2
set ylabel "Sta 1"
plot rain_name1 index 0 using 3:5 with impulses lt 3 lw 2
set ylabel "Sta 3"
plot rain_name3 index 0 using 3:5 with impulses lt 3 lw 2
set ylabel "Sta 9"
plot rain_name9 index 0 using 3:5 with impulses lt 3 lw 2
set title "All Stations Rainfall (in)"
set ylabel "Sta 12"
plot rain_name12 index 0 using 3:5 with impulses lt 3 lw 2
unset multiplot
unset yrange

#First Six raingages together, First Half 2018
set terminal png size 1280,960
set output "/mnt/space/workspace/instrument_processing/data/site/ALLDATA/gnuplot/All_Rainfall_Events_first_six_Jan_through_Apr18_multiplot.10June18.png"
rain_name10 = '/mnt/space/workspace/instrument_processing/data/site/10000/RAIN/10000_RAIN.txt'
rain_name2 = '/mnt/space/workspace/instrument_processing/data/site/200/RAIN/200_RAIN.txt'
rain_name1 = '/mnt/space/workspace/instrument_processing/data/site/100/RAIN/100_RAIN.txt'
rain_name3 = '/mnt/space/workspace/instrument_processing/data/site/300/RAIN/300_RAIN.txt'
rain_name9 = '/mnt/space/workspace/instrument_processing/data/site/900/RAIN/900_RAIN.txt'
rain_name12 = '/mnt/space/workspace/instrument_processing/data/site/1200/RAIN/1200_RAIN.txt'
rain_name7 = '/mnt/space/workspace/instrument_processing/data/site/700/RAIN/700_RAIN.txt'
rain_name5 = '/mnt/space/workspace/instrument_processing/data/site/500/RAIN/500_RAIN.txt'
rain_name6 = '/mnt/space/workspace/instrument_processing/data/site/600/RAIN/600_RAIN.txt'
rain_name11 = '/mnt/space/workspace/instrument_processing/data/site/1100/RAIN/1100_RAIN.txt'
rain_name4 = '/mnt/space/workspace/instrument_processing/data/site/400/RAIN/400_RAIN.txt'
rain_name8 = '/mnt/space/workspace/instrument_processing/data/site/800/RAIN/800_RAIN.txt'
#datestart = '"03/19/18"'
#datestop = '"03/24/18"'
unset title 
unset key
set multiplot layout 6,1 rowsfirst upwards                             
set lmargin 10
set bmargin 4
set grid
set tics out
set xdata time
set timefmt "%m/%d/%y %H:%M"
set format x "%m/%d\n %H:%M"
set xtics nomirror rotate
#set xrange [time(0) - 203*24*60*60:*] #without the *, it defaults to last max or min, which we set earlier while trying to find the max/min value
#set xrange [datestart:datestop]
set xrange ["01/01/18":"04/30/18"]
set yrange [0:50]
set ytics nomirror
set ylabel "Sta 10"
plot rain_name10 index 0 using 3:5 with impulses lt 3 lw 2
set bmargin 1
set format x ""
set ylabel "Sta 2"
plot rain_name2 index 0 using 3:5 with impulses lt 3 lw 2
set ylabel "Sta 1"
plot rain_name1 index 0 using 3:5 with impulses lt 3 lw 2
set ylabel "Sta 3"
plot rain_name3 index 0 using 3:5 with impulses lt 3 lw 2
set ylabel "Sta 9"
plot rain_name9 index 0 using 3:5 with impulses lt 3 lw 2
set title "All Stations Rainfall (in)"
set ylabel "Sta 12"
plot rain_name12 index 0 using 3:5 with impulses lt 3 lw 2
unset multiplot
unset yrange

#second Six, July through Dec 2017
set terminal png size 1280,960
set output "/mnt/space/workspace/instrument_processing/data/site/ALLDATA/gnuplot/All_Rainfall_Events_second_six_July_through_Dec17_multiplot.10June18.png"
rain_name7 = '/mnt/space/workspace/instrument_processing/data/site/700/RAIN/700_RAIN.txt'
rain_name5 = '/mnt/space/workspace/instrument_processing/data/site/500/RAIN/500_RAIN.txt'
rain_name6 = '/mnt/space/workspace/instrument_processing/data/site/600/RAIN/600_RAIN.txt'
rain_name11 = '/mnt/space/workspace/instrument_processing/data/site/1100/RAIN/1100_RAIN.txt'
rain_name4 = '/mnt/space/workspace/instrument_processing/data/site/400/RAIN/400_RAIN.txt'
rain_name8 = '/mnt/space/workspace/instrument_processing/data/site/800/RAIN/800_RAIN.txt'
unset title 
unset key
set multiplot layout 6,1 rowsfirst upwards                             
set lmargin 10
set bmargin 4
set grid
set tics out
set xdata time
set timefmt "%m/%d/%y %H:%M"
set format x "%m/%d\n %H:%M"
set xtics nomirror rotate
set xrange ["07/01/17":"12/31/17"]
set yrange [0:50]
set ytics nomirror
set ylabel "Sta 7"
plot rain_name7 index 0 using 3:5 with impulses lt 3 lw 2
set bmargin 1
set format x ""
set ylabel "Sta 5"
plot rain_name5 index 0 using 3:5 with impulses lt 3 lw 2
set ylabel "Sta 6"
plot rain_name6 index 0 using 3:5 with impulses lt 3 lw 2
set ylabel "Sta 11"
plot rain_name11 index 0 using 3:5 with impulses lt 3 lw 2
set ylabel "Sta 4"
plot rain_name4 index 0 using 3:5 with impulses lt 3 lw 2
set title "All Stations Rainfall (in)"
set ylabel "Sta 8"
plot rain_name8 index 0 using 3:5 with impulses lt 3 lw 2
unset multiplot
unset yrange

#second Six, Jan through Apr 2018
set terminal png size 1280,960
set output "/mnt/space/workspace/instrument_processing/data/site/ALLDATA/gnuplot/All_Rainfall_Events_second_six_Jan_through_Apr18_multiplot.10June18.png"
rain_name7 = '/mnt/space/workspace/instrument_processing/data/site/700/RAIN/700_RAIN.txt'
rain_name5 = '/mnt/space/workspace/instrument_processing/data/site/500/RAIN/500_RAIN.txt'
rain_name6 = '/mnt/space/workspace/instrument_processing/data/site/600/RAIN/600_RAIN.txt'
rain_name11 = '/mnt/space/workspace/instrument_processing/data/site/1100/RAIN/1100_RAIN.txt'
rain_name4 = '/mnt/space/workspace/instrument_processing/data/site/400/RAIN/400_RAIN.txt'
rain_name8 = '/mnt/space/workspace/instrument_processing/data/site/800/RAIN/800_RAIN.txt'
unset title 
unset key
set multiplot layout 6,1 rowsfirst upwards                             
set lmargin 10
set bmargin 4
set grid
set tics out
set xdata time
set timefmt "%m/%d/%y %H:%M"
set format x "%m/%d\n %H:%M"
set xtics nomirror rotate
set xrange ["07/01/17":"12/31/17"]
set yrange [0:50]
set ytics nomirror
set ylabel "Sta 7"
plot rain_name7 index 0 using 3:5 with impulses lt 3 lw 2
set bmargin 1
set format x ""
set ylabel "Sta 5"
plot rain_name5 index 0 using 3:5 with impulses lt 3 lw 2
set ylabel "Sta 6"
plot rain_name6 index 0 using 3:5 with impulses lt 3 lw 2
set ylabel "Sta 11"
plot rain_name11 index 0 using 3:5 with impulses lt 3 lw 2
set ylabel "Sta 4"
plot rain_name4 index 0 using 3:5 with impulses lt 3 lw 2
set title "All Stations Rainfall (in)"
set ylabel "Sta 8"
plot rain_name8 index 0 using 3:5 with impulses lt 3 lw 2
unset multiplot
unset yrange
