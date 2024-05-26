FROM python:3

WORKDIR /app

# 设置 Python 和 Node.js 环境
ARG POETRY_VERSION=1.2.2
RUN apt-get update && \
    curl -sL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    pip install --no-cache-dir poetry==$POETRY_VERSION

# 复制项目文件
COPY package*.json ./
COPY pyproject.toml ./
COPY poetry.lock ./

# 设置环境变量，避免下载无用的Chromium
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

# 安装依赖
RUN poetry install && \
    npm install && \
    npm install -g tsc-watch && \
    npm cache clean --force

# 复制项目源代码
COPY . .

# 复制 CSV 文件到容器的 /data 目录
COPY ["./data/pred_lstm.csv", "/data/pred_lstm.csv"]
COPY ["./data/pred_gru.csv", "/data/pred_gru.csv"]
COPY ["./data/pred_saes.csv", "/data/pred_saes.csv"]

CMD ["npm", "run", "dev"]
