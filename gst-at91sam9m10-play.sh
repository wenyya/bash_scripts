DISPLAY=:0.0

if [ -f $1 ]; then
    echo Video file : $1
else
    echo File $1 does not exist
    exit 1
fi

# Get container type
CONTAINER=`gst-typefind $1 | awk -F " - " '{print $NF}'`

#For mpeg 
TEMP=`echo $CONTAINER | grep "video/mpeg,"`

if [ "$TEMP" != "" ]; then
	   CONTAINER=video/x-mpeg
fi

case "$CONTAINER" in
    video/x-ms-asf)
	    DEMUX=asfdemux
	    ;;
	video/x-msvideo)
	    DEMUX=avidemux
	    ;;
	video/x-mpeg)
	    DEMUX=mpegdemux
	    ;;
	video/quicktime)
	    DEMUX=qtdemux
	    ;;
	*)
	echo File type $CONTAINER is not supported
	exit 1
esac

#Play video
CMD="gst-launch filesrc location=$1 ! $DEMUX name=demux \
demux.video_00 ! queue ! x170 output=RGB16 inbuf-thresh=50000 output_width=480 output_height=272 ! ximagesink display=$DISPLAY \
demux.audio_00 ! queue ! decodebin ! osssink "

echo gst-launch command line:
echo $CMD

RET=`exec $CMD`

gpe-question --question "$RET" --buttons icons1:"Ok

