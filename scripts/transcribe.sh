#!/usr/bin/env bash
# 本地语音转文字（whisper.cpp，无需联网）
# 用法: bash scripts/transcribe.sh work/lesson01.wav [语言代码] [模型路径]
set -euo pipefail

WAV="${1:?用法: bash scripts/transcribe.sh <wav> [zh] [模型]}"
LANG="${2:-zh}"
MODEL="${3:-/home/user/tools/whisper/models/ggml-small.bin}"

BIN=""
for c in /home/user/tools/whisper/whisper.cpp/build/bin/whisper-cli \
         /home/user/tools/whisper/whisper.cpp/build/bin/main \
         /home/user/tools/whisper/whisper.cpp/main; do
  [ -x "$c" ] && { BIN="$c"; break; }
done
[ -n "$BIN" ] || { echo "找不到 whisper-cli，请先编译 whisper.cpp"; exit 1; }

echo "音频: $WAV"
echo "模型: $(basename "$MODEL")   语言: $LANG   线程: 2"
echo "提示：2 核机器上速度约为实时的 0.3~0.6 倍，长音频建议放后台跑。"

"$BIN" -m "$MODEL" -f "$WAV" -l "$LANG" -t 2 -pp \
  -otxt -osrt -ovtt -ml 0 \
  -of "${WAV%.*}"

echo "完成: ${WAV%.*}.txt / .srt / .vtt"
