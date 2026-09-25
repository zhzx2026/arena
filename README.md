# 课程资料整理（笔记 / 答案）

> 状态：**等待原始资料上传**。整理后的笔记放 `notes/`，题目答案放 `answers/`，原始大文件只留在 `inbox/`（不入库）。

## 目录约定

```
inbox/     原始资料（视频/音频/PDF/图片…）— 不提交进 Git
notes/     整理后的课堂笔记（Markdown，按章节）
answers/   题目与答案（Markdown，题目—答案对照）
scripts/   处理脚本（音频抽取、语音转写、切分）
tools/     本地工具链（whisper 模型等，不入库）
```

## 命名规范

- 笔记：`notes/<课程>/<章节序号>-<标题>.md`
- 答案：`answers/<课程>/<章节序号>-<标题>.md`
- 每个 Markdown 开头写 front-matter：来源文件、时间范围、整理日期。

## 处理流水线（视频 → 笔记）

```bash
# 1. 把原始文件放进 inbox/（例如 inbox/lesson01.mp4）
# 2. 抽音频：16kHz 单声道 wav（识别效果最好、体积最小）
bash scripts/extract_audio.sh inbox/lesson01.mp4

# 3. 语音转文字（本地 whisper.cpp，无网络依赖）
bash scripts/transcribe.sh work/lesson01.wav zh

# 4. 结果在 work/*.txt / *.srt，人工/脚本整理成 notes/
```

## 环境说明

- 沙箱出口受限，仅 `github.com` / `api.github.com` / `pypi.org` 可达，网盘直链无法下载。
- 机器为 2 核 / 3GB 内存，本地转写速度约为实时的 0.3~0.6 倍（1 小时视频约需 2~3 小时），长视频会分批后台处理。
