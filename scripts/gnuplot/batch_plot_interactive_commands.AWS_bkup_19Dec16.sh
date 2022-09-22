#from : http://stackoverflow.com/questions/12328603/how-to-pass-command-line-argument-to-gnuplot
#also, same page:
#if (!exists("filename") instead of if ! exists("filename")
#You can input variables via switch -e
#$ gnuplot -e "filename='foo.data'" foo.plg
#In foo.plg you can then use that variable
#$ cat foo.plg 
#plot filename
#pause -1
#!/bin/bash
mypath="/mnt/space/workspace/instrument_processing/data/site/"
myscript="/mnt/space/workspace/instrument_processing/scripts/gnuplot/plot_rain_to_canvas_and_png.plt"
for myfiles in 7000 9000 10000 11000
#7000: RAIN, DEPTH, TEMP
do
gnuplot -e "rain_name='< tail -n 8640 "$mypath""$myfiles"/RAIN/"$myfiles"_RAIN.txt'" -e "title='Weather_Data_at_Station_$myfiles'" -e "filename='"$mypath""$myfiles"/gnuplot/Rainfall_at_Station_$myfiles.png'" -e "htmlfilename='"$mypath""$myfiles"/gnuplot/Rainfall_at_Station_$myfiles.html'" -e "depth_name='"$mypath""$myfiles"/DEPTH/"$myfiles"_DEPTH.txt'" -e "temp_name='"$mypath""$myfiles"/TEMP/"$myfiles"_TEMP.txt'" $myscript
done
#25000: RAIN, TEMP_RTC
gnuplot -e "rain_name='/home/fbyne/workspace/instrument_processing/data/site/25000/RAIN/25000_RAIN.txt'" -e "title='Weather_Data_at_Station_25000'" -e "filename='/home/fbyne/workspace/instrument_processing/data/site/25000/gnuplot/Rainfall_at_Station_25000.png'" -e "htmlfilename='/home/fbyne/workspace/instrument_processing/data/site/25000/gnuplot/Rainfall_at_Station_25000.html'" -e "temp_name='/home/fbyne/workspace/instrument_processing/data/site/25000/TEMP_RTC/25000_TEMP_RTC.txt'" /home/fbyne/workspace/instrument_processing/scripts/gnuplot/plot_rain_to_canvas_and_png.plt
