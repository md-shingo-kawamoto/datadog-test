# Rails TODO App with Datadog APM

Datadog APM監視付きのRails TODOアプリケーションです。意図的にエラーを発生させてDatadogでAPMエラーを確認することができます。

## 構成

- **app**: Rails 7.1アプリケーション
- **db**: MySQL 8.0データベース
- **nginx**: リバースプロキシ
- **datadog**: Datadog Agentコンテナ（APM監視）

## 必要な環境

- Docker
- Docker Compose
- Datadog APIキー

## セットアップ

### 1. Datadog APIキーの設定

まず、環境変数にDatadog APIキーを設定します：

```bash
export DD_API_KEY=your_datadog_api_key_here
```

または、`.env`ファイルを作成して以下を記述：

```
DD_API_KEY=your_datadog_api_key_here
```

### 2. アプリケーションの起動

```bash
# コンテナをビルドして起動
docker compose up --build

# バックグラウンドで起動する場合
docker compose up -d --build
```

### 3. アプリケーションへのアクセス

- **アプリケーション（nginx経由）**: http://localhost
- **アプリケーション（直接）**: http://localhost:3000
- **ヘルスチェック**: http://localhost/health

## 使い方

### TODOアプリケーション

1. ブラウザで http://localhost にアクセス
2. 「新規作成」ボタンをクリックしてTODOを追加
3. タイトルと説明を入力して保存
4. 完了ボタンで完了/未完了を切り替え
5. 編集・削除も可能

### APMエラーのテスト

意図的にエラーを発生させるエンドポイントを用意しています：

#### 1. 通常の例外エラー
```bash
curl http://localhost/error/test
```
RuntimeErrorが発生します。Datadogでエラートレースを確認できます。

#### 2. データベースエラー
```bash
curl http://localhost/error/database
```
存在しないレコードを検索してActiveRecord::RecordNotFoundエラーを発生させます。

#### 3. タイムアウトエラー
```bash
curl http://localhost/error/timeout
```
10秒のスリープ後にタイムアウトエラーを発生させます。

### Datadogでの確認

1. [Datadog APM](https://app.datadoghq.com/apm/home)にアクセス
2. Service: `todo-app`を選択
3. Tracesタブでトレース情報を確認
4. エラーが発生したトレースは赤色で表示されます
5. エラーの詳細、スタックトレース、カスタムタグなどが確認できます

## 主要なコマンド

```bash
# コンテナの起動
docker-compose up

# コンテナの停止
docker-compose down

# ログの確認
docker-compose logs -f app

# データベースのリセット
docker-compose exec app bundle exec rails db:reset

# Railsコンソールの起動
docker-compose exec app bundle exec rails console

# データベースマイグレーション
docker-compose exec app bundle exec rails db:migrate
```

## Datadog設定の確認

### 環境変数

以下の環境変数でDatadogの設定を行っています：

- `DD_API_KEY`: Datadog APIキー
- `DD_AGENT_HOST`: Datadog Agentのホスト名（コンテナ名: datadog）
- `DD_TRACE_AGENT_PORT`: APMポート（8126）
- `DD_ENV`: 環境名（development）
- `DD_SERVICE`: サービス名（todo-app）
- `DD_VERSION`: バージョン（1.0.0）

### トレーシング対象

- Railsアプリケーション全体
- MySQL2クエリ
- カスタムスパン（エラーテストエンドポイント）

## トラブルシューティング

### データベース接続エラー

```bash
# データベースコンテナの状態を確認
docker-compose ps db

# データベースのログを確認
docker-compose logs db
```

### Datadog接続エラー

```bash
# Datadog Agentの状態を確認
docker-compose exec datadog agent status

# DD_API_KEYが正しく設定されているか確認
docker-compose exec datadog env | grep DD_API_KEY
```

### アプリケーションエラー

```bash
# アプリケーションのログを確認
docker-compose logs app

# コンテナ内でRailsコンソールを起動
docker-compose exec app bundle exec rails console
```

## ファイル構成

```
.
├── app/
│   ├── controllers/
│   │   ├── todos_controller.rb     # TODO CRUD操作
│   │   ├── errors_controller.rb    # エラーテスト用
│   │   └── health_controller.rb    # ヘルスチェック
│   ├── models/
│   │   └── todo.rb                 # TODOモデル
│   └── views/
│       ├── layouts/
│       │   └── application.html.erb
│       └── todos/
│           ├── index.html.erb      # TODO一覧
│           ├── new.html.erb        # 新規作成
│           └── edit.html.erb       # 編集
├── config/
│   ├── application.rb              # Datadog設定を含む
│   ├── database.yml                # MySQL設定
│   └── routes.rb                   # ルーティング
├── docker-compose.yml              # Docker構成
├── Dockerfile                      # RailsアプリのDockerfile
├── nginx/
│   ├── Dockerfile                  # NginxのDockerfile
│   └── nginx.conf                  # Nginx設定
└── README.md                       # このファイル
```

## 開発のヒント

### カスタムスパンの追加

```ruby
Datadog::Tracing.trace('custom.operation') do |span|
  span.set_tag('custom.tag', 'value')
  # your code here
end
```

### エラーの記録

```ruby
Datadog::Tracing.trace('operation') do |span|
  begin
    # your code
  rescue => e
    span.set_error(e)
    raise
  end
end
```

## ライセンス

MIT
