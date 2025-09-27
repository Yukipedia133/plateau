# plateau/Dockerfile
FROM python:3.12-slim

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# 基本ツール（curl/unzipなど）。C系は入れない方針（ホイール活用）
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl ca-certificates unzip git \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

# 依存インストール
COPY requirements.txt /tmp/requirements.txt
RUN pip install --upgrade pip && pip install -r /tmp/requirements.txt

# プロジェクトをマウント前提。存在しないときのために最低限作成
RUN mkdir -p /workspace/script /workspace/data /workspace/output /workspace/cache

# キャッシュ/一時フォルダを明示（ホストへマウント可）
ENV XDG_CACHE_HOME=/workspace/cache \
    GDAL_CACHEMAX=128 \
    PROJ_NETWORK=ON

# デフォルトはbashで入れる。compose側で上書き可
CMD ["/bin/bash"]
