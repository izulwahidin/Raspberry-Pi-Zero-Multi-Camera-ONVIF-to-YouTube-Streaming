#!/bin/bash

# Load environment variables from .env file
export $(grep -v '^#' .env | xargs)

# Convert the comma-separated camera list into an array
IFS=',' read -r -a CAMS <<< "$CAMERAS"

# Function to get a new YouTube Stream Key
get_youtube_stream_key() {
    RESPONSE=$(curl -s -X POST "https://www.googleapis.com/youtube/v3/liveBroadcasts?part=snippet,status,contentDetails" \
        -H "Authorization: Bearer $OAUTH_TOKEN" \
        -H "Content-Type: application/json" \
        -d '{
          "snippet": {
            "title": "CCTV Live Stream - '$(date +"%Y-%m-%d %H:%M:%S")'",
            "scheduledStartTime": "'$(date -u --iso-8601=seconds)'"
          },
          "status": {
            "privacyStatus": "public"
          },
          "contentDetails": {
            "enableAutoStart": true,
            "enableAutoStop": true
          }
        }')

    STREAM_KEY=$(echo $RESPONSE | jq -r '.id')
    echo "$STREAM_KEY"
}

# Start streaming each camera
for i in "${!CAMS[@]}"; do
    CAMERA_RTSP_URL="${CAMS[$i]}"
    YOUTUBE_STREAM_KEY=$(get_youtube_stream_key)
    YOUTUBE_RTMP_URL="rtmp://a.rtmp.youtube.com/live2/$YOUTUBE_STREAM_KEY"

    ffmpeg -rtsp_transport tcp -i "$CAMERA_RTSP_URL" -c:v libx264 -preset veryfast -b:v "$VIDEO_BITRATE" -maxrate "$VIDEO_BITRATE" -bufsize 3000k \
           -c:a aac -b:a "$AUDIO_BITRATE" -f flv "$YOUTUBE_RTMP_URL" &
done
