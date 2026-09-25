#!/usr/bin/env bash
# 从视频/音频中抽取 16kHz 单声道 wav（whisper 输入格式）
# 用法: bash scripts/extract_audio.sh inbox/lesson01.mp4 [输出路径]
set -euo pipefail

IN="${1:?用法: bash scripts/extract_audio.sh <输入文件> [输出wav]}"
OUT="${2:-work/$(basename "${IN%.*}").wav}"
mkdir -p "$(dirname "$OUT")"

# 优先系统 ffmpeg，否则用 venv 里 imageio-ffmpeg 自带的静态 ffmpeg
FFMPEG="$(command -v ffmpeg || true)"
if [ -z "$FFMPEG" ] && [ -x /home/user/tools/venv/bin/python ]; then
  FFMPEG="$(/home/user/tools/venv/bin/python -c "import imageio_ffmpeg;print(imageio_ffmpeg.get_ffmpeg_exe())" 2>/dev/null || true)"
fi
[ -n "$FFMPEG" ] || { echo "找不到 ffmpeg"; exit 1; }

echo "输入: $IN"
"$FFMPEG" -hide_banner -loglevel error -i "$IN" -vn -ac 1 -ar 16000 -c:a pcm_s16le -y "$OUT"
echo "输出: $OUT  ($(du -h "$OUT" | cut -f1))"
