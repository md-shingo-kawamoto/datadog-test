FROM ruby:3.2.2

# 必要なパッケージをインストール
RUN apt-get update -qq && apt-get install -y \
  nodejs \
  default-mysql-client \
  build-essential \
  libmariadb-dev \
  && rm -rf /var/lib/apt/lists/*

# 作業ディレクトリを設定
WORKDIR /app

# GemfileとGemfile.lockをコピー
COPY Gemfile ./

# bundlerをインストールしてgemをインストール
RUN gem install bundler && bundle install

# アプリケーションコードをコピー
COPY . .

# tmpとlogディレクトリを作成
RUN mkdir -p tmp/pids tmp/sockets log

# ポート3000を公開
EXPOSE 3000

# エントリーポイントスクリプトをコピー
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# Railsサーバーを起動
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
