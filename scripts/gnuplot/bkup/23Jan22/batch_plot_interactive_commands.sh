#!/bin/bash
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

echo $0 

mypath="/mnt/space/workspace/instrument_processing/data/site/"
myscript="/mnt/space/workspace/instrument_processing/scripts/gnuplot/plot_rain_to_canvas_and_png.plt"
myscriptR2="/mnt/space/workspace/instrument_processing/scripts/gnuplot/plot_rain_to_canvas_and_png.19Dec16.plt"
myscript28R2="/mnt/space/workspace/instrument_processing/scripts/gnuplot/plot_rain_to_canvas_and_png.28.4Feb18.plt"
myscript84R2="/mnt/space/workspace/instrument_processing/scripts/gnuplot/plot_rain_to_canvas_and_png.84.4Feb18.plt"
myscript168R2="/mnt/space/workspace/instrument_processing/scripts/gnuplot/plot_rain_to_canvas_and_png.168.4Feb18.plt"
myscript252R2="/mnt/space/workspace/instrument_processing/scripts/gnuplot/plot_rain_to_canvas_and_png.252.4Feb18.plt"

for myfiles in 600 5000 5100 5200 7500 7600 7900 9000 #100 200 300 400 500 600 700 800 900 1000 1100 1200 3000 3100 3200 3300 3400 3500 3600 5000 5100 5200 5300 5500 5900

	       
#if [ $# -gt 0 ]; then
#    echo "Your command line contains $# arguments"
#else
#    echo "Your command line contains no arguments"
#fi

	       
do
if [ ! -d "$mypath/$myfiles/gnuplot" ]
then
    mkdir -p "$mypath/$myfiles/gnuplot"
fi

echo "plotting : "$myfiles
#4032 is the past 14 days in 5 minute increments
gnuplot -e "rain_name='< tail -n 4032 "$mypath""$myfiles"/RAIN/"$myfiles"_RAIN.txt'" -e "title='Weather_Data_at_Station_$myfiles'" -e "filename='"$mypath""$myfiles"/gnuplot/Rainfall_at_Station_$myfiles.png'" -e "htmlfilename='"$mypath""$myfiles"/gnuplot/Rainfall_at_Station_$myfiles.html'" -e "depth_name='"$mypath""$myfiles"/DEPTH/"$myfiles"_DEPTH.txt'" -e "temp_name='"$mypath""$myfiles"/TEMP/"$myfiles"_TEMP.txt'" $myscript
echo "finished : " $myfiles " : R1"
gnuplot -e "rain_name='< tail -n 4032 "$mypath""$myfiles"/RAIN/"$myfiles"_RAIN.txt'" -e "title='Weather_Data_at_Station_$myfiles'" -e "filename='"$mypath""$myfiles"/gnuplot/Rainfall_at_Station_$myfiles.R2.png'" -e "htmlfilename='"$mypath""$myfiles"/gnuplot/Rainfall_at_Station_$myfiles.R2.html'" -e "depth_name='"$mypath""$myfiles"/DEPTH/"$myfiles"_DEPTH.txt'" -e "temp_name='"$mypath""$myfiles"/TEMP/"$myfiles"_TEMP.txt'" $myscriptR2
echo "finished : " $myfiles " : R2"


#8064 is 28 days of 5 minute increments (monthly)
gnuplot -e "rain_name='< tail -n 8064 "$mypath""$myfiles"/RAIN/"$myfiles"_RAIN.txt'" -e "title='Weather_Data_at_Station_$myfiles'" -e "filename='"$mypath""$myfiles"/gnuplot/Rainfall_at_Station_$myfiles.28.png'" -e "htmlfilename='"$mypath""$myfiles"/gnuplot/Rainfall_at_Station_$myfiles.28.html'" -e "depth_name='"$mypath""$myfiles"/DEPTH/"$myfiles"_DEPTH.txt'" -e "temp_name='"$mypath""$myfiles"/TEMP/"$myfiles"_TEMP.txt'" $myscript
echo "finished : " $myfiles " : R1 Monthly"
gnuplot -e "rain_name='< tail -n 8064 "$mypath""$myfiles"/RAIN/"$myfiles"_RAIN.txt'" -e "title='Weather_Data_at_Station_$myfiles'" -e "filename='"$mypath""$myfiles"/gnuplot/Rainfall_at_Station_$myfiles.28.R2.png'" -e "htmlfilename='"$mypath""$myfiles"/gnuplot/Rainfall_at_Station_$myfiles.28.R2.html'" -e "depth_name='"$mypath""$myfiles"/DEPTH/"$myfiles"_DEPTH.txt'" -e "temp_name='"$mypath""$myfiles"/TEMP/"$myfiles"_TEMP.txt'" $myscript28R2
echo "finished : " $myfiles " : R2 Monthly"

#24192 is 84 days of 5 minute increments (quarterly)
gnuplot -e "rain_name='< tail -n 24192 "$mypath""$myfiles"/RAIN/"$myfiles"_RAIN.txt'" -e "title='Weather_Data_at_Station_$myfiles'" -e "filename='"$mypath""$myfiles"/gnuplot/Rainfall_at_Station_$myfiles.84.R2.png'" -e "htmlfilename='"$mypath""$myfiles"/gnuplot/Rainfall_at_Station_$myfiles.84.R2.html'" -e "depth_name='"$mypath""$myfiles"/DEPTH/"$myfiles"_DEPTH.txt'" -e "temp_name='"$mypath""$myfiles"/TEMP/"$myfiles"_TEMP.txt'" $myscript84R2
echo "finished : " $myfiles " : R2 Quarterly"

#48384 is 168 days of 5 minute increments (biannual)
gnuplot -e "rain_name='< tail -n 48384 "$mypath""$myfiles"/RAIN/"$myfiles"_RAIN.txt'" -e "title='Weather_Data_at_Station_$myfiles'" -e "filename='"$mypath""$myfiles"/gnuplot/Rainfall_at_Station_$myfiles.168.R2.png'" -e "htmlfilename='"$mypath""$myfiles"/gnuplot/Rainfall_at_Station_$myfiles.168.R2.html'" -e "depth_name='"$mypath""$myfiles"/DEPTH/"$myfiles"_DEPTH.txt'" -e "temp_name='"$mypath""$myfiles"/TEMP/"$myfiles"_TEMP.txt'" $myscript168R2
echo "finished : " $myfiles " : R2 Biannual"

#58464 is 203 days of 5 minute increments (long enough to capture july as of today)
gnuplot -e "rain_name='< tail -n 58464 "$mypath""$myfiles"/RAIN/"$myfiles"_RAIN.txt'" -e "title='Weather_Data_at_Station_$myfiles'" -e "filename='"$mypath""$myfiles"/gnuplot/Rainfall_at_Station_$myfiles.252.R2.png'" -e "htmlfilename='"$mypath""$myfiles"/gnuplot/Rainfall_at_Station_$myfiles.252.R2.html'" -e "depth_name='"$mypath""$myfiles"/DEPTH/"$myfiles"_DEPTH.txt'" -e "temp_name='"$mypath""$myfiles"/TEMP/"$myfiles"_TEMP.txt'" $myscript252R2
echo "finished : " $myfiles " : R2 9Months"

done
