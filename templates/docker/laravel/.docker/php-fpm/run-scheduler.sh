##!/usr/bin/env sh

# Start at :30 seconds
WAIT_FOR_MIDDLE_OF_MINUTE=$(( ( 90 - $(date +%S) ) % 60 ))
sleep $WAIT_FOR_MIDDLE_OF_MINUTE

START=$(date +%s%N)
INTERVAL_SECONDS=60
INTERVAL_NANOSECONDS=$(( $INTERVAL_SECONDS * 1000000000 ))
i=1

while true
do
    php /var/www/app/artisan schedule:run &

    CURRENT=$(date +%s%N)
    SINCE_START=$(expr $CURRENT - $START)
    EXPECTED_SINCE_START=$(( x * $INTERVAL_NANOSECONDS ))
    DIFF_ERROR=$(( $EXPECTED_SINCE_START - $SINCE_START ))

    INTERVAL_SECONDS_WITH_CORRECTION=$(echo "$INTERVAL_SECONDS + ( $DIFF_ERROR / 1000000000 )" | bc -l)

    # echo "miliseconds error" $(( $DIFF_ERROR / 1000000 )) " new interval " $INTERVAL_SECONDS_WITH_CORRECTION
    sleep $INTERVAL_SECONDS_WITH_CORRECTION

    x=$(( $x + 1 ))
done
