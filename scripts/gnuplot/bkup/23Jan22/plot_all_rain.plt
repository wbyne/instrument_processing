#make sure your plotted dates and years and xrange statements don't overlap and agree 
#  on the actual year, or it won't work with an obtuse error.
clear
set grid
set tics out

#notice the capital Y-->means 4-digit year, and add :%S for seconds, and apparently two digit years default to 1900.  be careful
set xdata time
set timefmt "%m/%d/%Y %H:%M"
set format x "%m/%d/%Y %H:%M"
set xrange  ["01/01/2015":"06/30/2015"] 
set xtics nomirror

set x2data time
set timefmt "%m/%d/%Y %H:%M"
set format x2 "%m/%d/%Y %H:%M"
set x2range  ["01/01/2015":"06/30/2015"]  #let it autorange if you can
set x2tics 

set y2range [0:4.5] reverse  #0:3 works good, but we'll use 4.5 here instead
set y2label "Rainfall Intensity (in/hr)\n Rainfall (in)"
set y2tics nomirror

set yrange [0:6]
set ytics nomirror
set ylabel "Rain (in/100)"

set key off #turn off the legend

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
"/home/fbyne/workspace/instrument_processing/data/site/000000/RAIN/000000_RAIN.txt" index 0 using 3:5 axes x1y1 with lines lt 3 lw 1
#"/home/fbyne/workspace/instrument_processing/data/site/001000/RAIN/001000_RAIN.txt" index 0 using 3:5 axes x1y1 with lines lt 5 lw 1, \
#"/home/fbyne/workspace/instrument_processing/data/site/001000/RAIN/001000_RAIN.txt" index 0 using 3:5 axes x1y1 with lines lt 4 lw 2
#"/home/fbyne/workspace/instrument_processing/data/Wes/Rock_Creek_at_Stevens_Creek_WB_Jan15.csv" index 0 using 1:4 axes x2y2 with steps lt 4 lw 3 , \

#pause -1

#set output "Rainfall_and_Level_Rock_Creek_Bertram_thru_June2015.png"
#set x2label "Rainfall and Level at Rock Creek at Bertram Rd" font "Times, 12"
#plot \
#"/home/fbyne/workspace/instrument_processing/data/Wes/Rock_Creek_at_Bertram_Road_WB_Jan15.csv" index 0 using 1:3 axes x1y1 with lines lt 3 lw 1, \
#pause -1

#set output "Rainfall_and_Level_Raes_Creek_Merrick_thru_June2015.png"
#set x2label "Rainfall and Level at Raes Creek at Merrick Place" font "Times, 12"
#plot \
#"/home/fbyne/workspace/instrument_processing/data/Wes/Raes_Creek_at_Merrick_Place_WB_Jan15.csv" index 0 using 1:3 axes x1y1 with lines lt 3 lw 1, \
#"/home/fbyne/workspace/instrument_processing/data/Wes/Raes_Creek_at_Merrick_Plac
#pause -1

#set output "Rainfall_and_Level_Raes_Creek_Frontage_thru_June2015.png"
#set x2label "Rainfall and Level at Crane Creek at Frontage Rd" font "Times, 12"
#plot \
"/home/fbyne/workspace/instrument_processing/data/Wes/Cranes_Creek_at_Frontage_Rd_WB_Apr15.csv" index 0 using 1:3 axes x1y1 with lines lt 3 lw 1, \

#pause -1