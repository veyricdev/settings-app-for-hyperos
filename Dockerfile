FROM ubuntu:22.04

# Cài đặt Unzip, Sudo, Wget và dos2unix (để sửa lỗi ký tự xuống dòng của Windows)
RUN apt-get update && apt-get install -y \
    sudo \
    unzip \
    wget \
    dos2unix \
    && rm -rf /var/lib/apt/lists/*

# Tải payload-dumper-go bản Linux mới nhất vào bộ nhớ lõi của Docker
RUN wget -qO payload.tar.gz https://github.com/ssut/payload-dumper-go/releases/download/1.2.2/payload-dumper-go_1.2.2_linux_amd64.tar.gz \
    && tar -xzf payload.tar.gz \
    && mv payload-dumper-go /usr/local/bin/ \
    && chmod +x /usr/local/bin/payload-dumper-go \
    && rm payload.tar.gz

# Định nghĩa thư mục làm việc
WORKDIR /workspace
