# Mouseable plots embedded in web pages
# can be generated using the svg or HTML5 canvas terminal drivers.
# stats command produces statistical output instead of graphs
#make sure your plotted dates and years and xrange statements don't overlap and agree 
#  on the actual year, or it won't work with an obtuse error.
#clear ###commenting this out removed the display call that was given AWS errors.fwb.13Aug16
set grid
set tics out

#notice the capital Y-->means 4-digit year, and add :%S for seconds, and apparently two digit years default to 1900.  be careful
set xdata time
set timefmt "%m/%d/%y %H:%M"
set format x "%m/%d/%y %H:%M"
#set xrange  ["01/01/15":"06/30/15"] 
set xtics nomirror rotate
set xrange [time(0) - 30*24*60*60:]

set x2data time
set timefmt "%m/%d/%y %H:%M"
set format x2 "%m/%d/%y"# %H:%M"
#set x2range  ["06/28/2015":"07/04/2015"]  #let it autorange if you can
set x2tics nomirror
set x2range [time(0) - 30*24*60*60:]

set y2range [0:150] reverse  #0:3 works good, but we'll use 4.5 here instead
set y2label "Rainfall Intensity (in/5min)"
set y2tics nomirror

#set yrange [0:20]
set ytics nomirror
set ylabel "Rain (100*in), Depth (100*ft), temp (F)"

set key on #turn off the legend

#***********************************
#begin plotting data
#***********************************

#***********
# rainfall
#***********
#plot sin(x)
#pause -1

set terminal png size 1280,960 #new settings for set size circa 2010???
set output filename
#set terminal wxt

set x2label title font "Times, 12" # \ntitle
if ((exists("rain_name"))&&(exists("depth_name"))&&(exists("temp_name"))){
plot \
rain_name index 0 using 3:5 axes x1y1 with lines lt 5 lw 2 smooth cumulative, \
depth_name index 0 using 3:5 axes x1y1 with lines lt 8 lw 1, \
temp_name index 0 using 3:5 axes x1y1 with lines lt 10 lw 1, \
rain_name index 0 using 3:5 axes x2y2 with impulses lt 3 lw 2 
set terminal canvas standalone mousing size 900,700 jsdir 'http://hydrologicdata.org/rainfall/resources/gnuplot/'
set output htmlfilename
plot \
rain_name index 0 using 3:5 axes x1y1 with lines lt 5 lw 2 smooth cumulative, \
depth_name index 0 using 3:5 axes x1y1 with lines lt 8 lw 1, \
temp_name index 0 using 3:5 axes x1y1 with lines lt 10 lw 1, \
rain_name index 0 using 3:5 axes x2y2 with impulses lt 3 lw 2 
} 
if ((exists("rain_name"))&&(!exists("depth_name"))&&(exists("temp_name"))) {
plot \
rain_name index 0 using 3:5 axes x1y1 with lines lt 5 lw 2 smooth cumulative, \
temp_name index 0 using 3:5 axes x1y1 with lines lt 10 lw 1, \
rain_name index 0 using 3:5 axes x2y2 with impulses lt 3 lw 2 
set terminal canvas standalone mousing size 900,700 jsdir 'http://hydrologicdata.org/rainfall/resources/gnuplot/'
set output htmlfilename
plot \
rain_name index 0 using 3:5 axes x1y1 with lines lt 5 lw 2 smooth cumulative, \
temp_name index 0 using 3:5 axes x1y1 with lines lt 10 lw 1, \
rain_name index 0 using 3:5 axes x2y2 with impulses lt 3 lw 2 
} 

if ((exists("rain_name"))&&(!exists("depth_name"))&&(!exists("temp_name"))) {
plot \
rain_name index 0 using 3:5 axes x1y1 with lines lt 5 lw 2 smooth cumulative, \
rain_name index 0 using 3:5 axes x2y2 with impulses lt 3 lw 2 
set terminal canvas standalone mousing size 900,700 jsdir 'http://hydrologicdata.org/rainfall/resources/gnuplot/'
set output htmlfilename
plot \
rain_name index 0 using 3:5 axes x1y1 with lines lt 5 lw 2 smooth cumulative, \
rain_name index 0 using 3:5 axes x2y2 with impulses lt 3 lw 2 
}

#set terminal png size 1280,960

set terminal unknown
set timefmt "%m/%d/%y %H:%M"
set xdata time
set xrange [*:time(0) - 14*24*60*60]

plot "/home/fbyne/workspace/instrument_processing/data/site/7000/RAIN/7000_RAIN.txt" index 0 using 3:(($5/100.)) with lines lt 3 lw 2 smooth cumulative
maxy = GPVAL_Y_MAX-2 #GPVAL_Y_MAX adds a little to the Y_MAX because it's the extents
set terminal canvas standalone mousing size 900,700 jsdir 'http://hydrologicdata.org/rainfall/resources/gnuplot/'
set output "./plotting_test.html"
#set terminal qt
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
set xrange [time(0) - 14*24*60*60:*] #without the *, it defaults to last max or min, which we set earlier while trying to find the max/min value
set ytics nomirror
set ylabel "Rain(in)"
plot "/home/fbyne/workspace/instrument_processing/data/site/7000/RAIN/7000_RAIN.txt" index 0 using 3:5 with impulses lt 3 lw 2
set format x ""
set bmargin 1
set ylabel "Depth(ft)"
set samples 65
plot "/home/fbyne/workspace/instrument_processing/data/site/7000/DEPTH/7000_DEPTH.txt" index 0 using 3:($5/100.) with lines lt 8 lw 1
set ylabel "Temp(F)"
plot "/home/fbyne/workspace/instrument_processing/data/site/7000/TEMP/7000_TEMP.txt" index 0 using 3:5 with lines lt 10 lw 1 
set ylabel "Cumulative Rain(in)"
set yrange[maxy:*]
plot "/home/fbyne/workspace/instrument_processing/data/site/7000/RAIN/7000_RAIN.txt" index 0 using 3:($5/100.) with lines lt 3 lw 2 smooth cumulative 
unset multiplot

Using the ternary operator from the gnuplot manual:
One trick is to use the ternary ?: operator to  filter data:
plot 'file' using 1:($3>10 ? $2 : 1/0)
If 3>10, then plots 1, otherwise nothing b/c 1/0 is undefined.

set xrange [*:time(0) - 14*24*60*60]
might be able to use xrange [*:-1-4032].  didn't try it yet.
stats "/home/fbyne/workspace/instrument_processing/data/site/7000/RAIN/7000_RAIN.txt" index 0 using 3:($5/100.)
stats aren't supported in timedata mode

set format x "%m/%d/%y %H:%M"
plot "/home/fbyne/workspace/instrument_processing/data/site/7000/RAIN/7000_RAIN.txt" index 0 using 3:($5/100.) with lines lt 3 lw 2 smooth cumulative
maxy = 