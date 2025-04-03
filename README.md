# Raspberry Pi Zero Multi-Camera ONVIF to YouTube Streaming

This project sets up a **Raspberry Pi Zero** to stream multiple ONVIF CCTV camera feeds to YouTube using **FFmpeg**. The script ensures automatic restarts every 10 hours and after power failures.

---

## Features

- **Supports multiple ONVIF cameras** (RTSP streams)
- **Automatically creates a new YouTube stream every 10 hours**
- **Restarts after a power failure**
- **Uses open-source tools** (FFmpeg, Curl, jq)
- **Optimized for Raspberry Pi Zero (low resource usage)**
- **Uses .env for easy configuration**

---

## Installation

### 1. Install Dependencies

```sh
sudo apt update && sudo apt upgrade -y
sudo apt install ffmpeg curl jq cron git -y
```

### 2. Clone the Repository

```sh
git clone https://github.com/YOUR_USERNAME/raspberry-pi-onvif-youtube-stream.git
cd raspberry-pi-onvif-youtube-stream
```

### 3. Create and Configure `.env`

Create a `.env` file for storing API keys and camera details.

```sh
touch .env
nano .env
```

Add the following:

```ini
# YouTube API Credentials
YOUTUBE_API_KEY=your_youtube_api_key
OAUTH_TOKEN=your_oauth_token

# Streaming Settings
STREAM_DURATION=36000  # 10 hours in seconds
VIDEO_BITRATE=1500k
AUDIO_BITRATE=128k

# ONVIF Camera RTSP URLs (comma-separated)
CAMERAS=rtsp://camera1_ip:554/onvif1,rtsp://camera2_ip:554/onvif1,rtsp://camera3_ip:554/onvif1
```

Save the file (**CTRL+X → Y → Enter**).

### 4. Make the Script Executable

```sh
chmod +x multi_stream.sh
```

---

## Running the Script

To start streaming manually:

```sh
./multi_stream.sh
```

To check for errors:

```sh
tail -f /var/log/syslog
```

---

## Automating Stream Restart

To ensure the stream restarts **every 10 hours** and **after power loss**, set up a cron job:

```sh
crontab -e
```

Add these lines:

```
@reboot /home/pi/raspberry-pi-onvif-youtube-stream/multi_stream.sh &
0 */10 * * * /home/pi/raspberry-pi-onvif-youtube-stream/multi_stream.sh &
```

---

## Updating the Repository

To push changes to GitHub:

```sh
git add .
git commit -m "Updated streaming script"
git push origin main
```

---

## Notes

- Adjust **bitrate** in `.env` for better performance.
- Check **logs** for debugging: `tail -f /var/log/syslog`
- Ensure `.env` is **not shared** as it contains sensitive credentials.

---

## License

MIT License

---

### 🚀 Now your Raspberry Pi Zero is streaming multiple ONVIF cameras to YouTube automatically!
