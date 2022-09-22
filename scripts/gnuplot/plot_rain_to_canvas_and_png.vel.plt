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

#set y2range [0:150] reverse  #0:3 works good, but we'll use 4.5 here instead
#set y2label "Rainfall Intensity (in/5min)"
#set y2tics nomirror

#set yrange [0:20]
set ytics nomirror
set ylabel "Depth (ft), Velocity (fps)"

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
if ((exists("depth_name"))&&(exists("velo_name"))){
plot \
depth_name index 0 using 3:($5/100) axes x1y1 with lines lt 8 lw 1, \
velo_name index 0 using 3:5 axes x1y1 with lines lt 10 lw 1
#, \
#velo_name index 0 using 3:5 axes x2y2 with lines lt 3 lw 2 
set terminal canvas standalone mousing size 900,700 jsdir 'https://www.rainfalldata.com/rainfall/resources/gnuplot/'
set output htmlfilename
plot \
depth_name index 0 using 3:($5/100) axes x1y1 with lines lt 8 lw 1, \
velo_name index 0 using 3:($5/100) axes x1y1 with lines lt 10 lw 1 
#, \
#rain_name index 0 using 3:5 axes x2y2 with impulses lt 3 lw 2 
} 

