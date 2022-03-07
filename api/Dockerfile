FROM ruby:3.1.1

# RUN aptg-get update && apt-get install -y \
RUN apt-get update && apt-get install -y \
      build-essential \
      libpq-dev \
      nodejs \
      postgresql-client \
      vim

# yarnのインストール
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
      echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
      apt-get update && apt-get install -y yarn

#aptキャッシュの削除
RUN rm -rf /var/lib/apt/lists/*

# 作業ディレクトリ指定
WORKDIR /myapp

# ファイルコピー
COPY Gemfile Gemfile.lock /myapp/

# gemの導入
RUN bundle install && \
      yarn install --check-files && \
      rails webpacker:install
