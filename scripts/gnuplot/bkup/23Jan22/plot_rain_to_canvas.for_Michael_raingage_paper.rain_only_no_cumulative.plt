# Mouseable plots embedded in web pages
# can be generated using the svg or HTML5 canvas terminal drivers.
# Richer, Younger, Better Looking version (TM)
## BTW, the time function comes from: http://stackoverflow.com/questions/38704617/gnuplot-variable-xrange-to-plot-only-last-weeks-worth-of-captured-data
set timefmt "%m/%d/%y %H:%M"
set xdata time
set xrange [*:time(0) - 14*24*60*60]

rainname7="/home/fbyne/workspace/instrument_processing/data/site/7000/RAIN/7000_RAIN.txt"
rainname9="/home/fbyne/workspace/instrument_processing/data/site/9000/RAIN/9000_RAIN.txt"
rainname10="/home/fbyne/workspace/instrument_processing/data/site/10000/RAIN/10000_RAIN.txt"
rainname11="/home/fbyne/workspace/instrument_processing/data/site/11000/RAIN/11000_RAIN.txt"

set terminal postscript landscape enhanced color size 8.5,11
#set terminal canvas standalone mousing size 900,1500 jsdir 'http://hydrologicdata.org/rainfall/resources/gnuplot/'
htmlfilename="/home/fbyne/edrive_fbyne/fbyne/personal/raingage_project/gnuplot/Rainfall_at_Station_AllSites.R2.ps"
set output htmlfilename

unset key
set multiplot layout 4,1 rowsfirst upwards                             
set lmargin 8
set bmargin 4
set grid
set tics out
set xdata time
set timefmt "%m/%d/%y %H:%M"
set format x "%m/%d\n %H:%M"
set xtics nomirror rotate
#set xrange [time(0) - 14*24*60*60:*] #without the *, it defaults to last max or min, which we set earlier while trying to find the max/min value
set xrange ["11/01/16":"12/31/16"]
set ytics nomirror
set ylabel "Rain(in/100)"
set x2label "Station 11"
plot rainname11 index 0 using 3:5 with impulses lt 3 lw 2

unset xlabel
unset x2label
unset yrange
set lmargin 8
set bmargin 4
set grid
set tics out
set xdata time
set timefmt "%m/%d/%y %H:%M"
set format x "%m/%d\n %H:%M"
set xtics nomirror rotate
#set xrange [time(0) - 14*24*60*60:*] #without the *, it defaults to last max or min, which we set earlier while trying to find the max/min value
set ytics nomirror
set ylabel "Rain(in/100)"
set x2label "Station 10"
plot rainname10 index 0 using 3:5 with impulses lt 3 lw 2

unset x2label
unset yrange
set lmargin 8
set bmargin 4
set grid
set tics out
set xdata time
set timefmt "%m/%d/%y %H:%M"
set format x "%m/%d\n %H:%M"
set xtics nomirror rotate
#set xrange [time(0) - 14*24*60*60:*] #without the *, it defaults to last max or min, which we set earlier while trying to find the max/min value
set ytics nomirror
set ylabel "Rain(in/100)"
set x2label "Station 9"
plot rainname9 index 0 using 3:5 with impulses lt 3 lw 2

unset x2label
unset yrange
set lmargin 8
set bmargin 4
set grid
set tics out
set xdata time
set timefmt "%m/%d/%y %H:%M"
set format x "%m/%d\n %H:%M"
set xtics nomirror rotate
#set xrange [time(0) - 14*24*60*60:*] #without the *, it defaults to last max or min, which we set earlier while trying to find the max/min value
set ytics nomirror
set ylabel "Rain(in/100)"
set x2label "Station 7"
plot rainname7 index 0 using 3:5 with impulses lt 3 lw 2

unset multiplot

