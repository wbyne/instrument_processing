#!/bin/bash

/usr/bin/rsync -e 'ssh -i /home/fbyne/.ssh/gpoz_hydata' /home/fbyne/workspace/instrument_processing/log/screenlog.0 gpoz@hydrologicdata.org:/mnt/space/workspace/instrument_processing/log/
