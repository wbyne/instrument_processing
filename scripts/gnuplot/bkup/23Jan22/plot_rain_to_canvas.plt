# Mouseable plots embedded in web pages
# can be generated using the svg or HTML5 canvas terminal drivers.
# stats command produces statistical output instead of graphs
#make sure your plotted dates and years and xrange statements don't overlap and agree 
#  on the actual year, or it won't work with an obtuse error.
clear
set grid
set tics out

#notice the capital Y-->means 4-digit year, and add :%S for seconds, and apparently two digit years default to 1900.  be careful
set xdata time
set timefmt "%m/%d/%y %H:%M"
set format x "%m/%d/%y %H:%M"
#set xrange  ["01/01/15":"06/30/15"] 
set xtics nomirror

set x2data time
set timefmt "%m/%d/%y %H:%M"
set format x2 "%m/%d/%y %H:%M"
#set x2range  ["06/28/2015":"07/04/2015"]  #let it autorange if you can
set x2tics nomirror

set y2range [0:150] reverse  #0:3 works good, but we'll use 4.5 here instead
set y2label "Rainfall Intensity (100th_in/hr)"
set y2tics nomirror

set yrange [0:6]
set ytics nomirror
set ylabel "Rain (in/100)"

set key off #on #turn off the legend

#***********************************
#begin plotting data
#***********************************

#***********
# rainfall
#***********
#plot sin(x)
#pause -1

#set terminal postscript landscape enhanced color dashed "Times" 12
#set terminal pdf size 10,6 #new settings for set size circa 2010???
#set output "Rainfall_and_Level_all_Site_thru_June2015.pdf"
#set terminal png size 1280,960 #new settings for set size circa 2010???
#set output "Rainfall_at_all_stations_thru_June2015.png"
set terminal wxt

set x2label "Rainfall at all stations" font "Times, 12" # \nSummer 2015
plot \
"/home/fbyne/workspace/instrument_processing/data/site/1000/RAIN/1000_RAIN.txt" index 0 using 3:5 axes x1y1 with lines lt 5 lw 2 smooth cumulative, \
"/home/fbyne/workspace/instrument_processing/data/site/1000/RAIN/1000_RAIN.txt" index 0 using 3:5 axes x2y2 with impulses lt 3 lw 2 
#"/home/fbyne/workspace/instrument_processing/data/site/GRU/RAIN/GRU_RAIN.txt" index 0 using 3:5 axes x1y1 with lines lt 4 lw 2 smooth cumulative, \
#"/home/fbyne/workspace/instrument_processing/data/site/GRU/RAIN/GRU_RAIN.txt" index 0 using 3:5 axes x1y1 with impulses lt 1 lw 4 
#"/home/fbyne/workspace/instrument_processing/data/site/000000/RAIN/000000_RAIN.txt" index 0 using 3:5 axes x1y1 with impulses lt 3 lw 1 smooth cumulative
#, \
#"/home/fbyne/workspace/instrument_processing/data/site/001000/RAIN/001000_RAIN.txt" index 0 using 3:5 axes x1y1 with impulses lt 5 lw 1, \


#pause -1
#set terminal canvas standalone mousing
#set x2label "Light and Temp in my Living Room" font "Times, 12" # \nSummer 2015
#set yrange [0:100]
#set ytics nomirror
#set ylabel "Light and Temp in my Living Room (unitless/deg F)"

#set xlabel "Time" font "Times, 12" # \nSummer 2015
#plot \
#"/home/fbyne/workspace/instrument_processing/data/site/001000/LIGHT/001000_LIGHT.txt" index 0 using 3:5 axes x1y1 with lines lt 3 lw 1, \
#"/home/fbyne/workspace/instrument_processing/data/site/001000/TEMP/001000_TEMP.txt" index 0 using 3:5 axes x1y1 with lines lt 5 lw 1

pause -1

