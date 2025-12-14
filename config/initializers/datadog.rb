# frozen_string_literal: true

require 'ddtrace'

Datadog.configure do |c|
  # 基本設定
  c.env = ENV.fetch('DD_ENV', 'development')
  c.service = ENV.fetch('DD_SERVICE', 'todo-app')
  c.version = ENV.fetch('DD_VERSION', '1.0.0')

  # Agent接続設定
  c.agent.host = ENV.fetch('DD_AGENT_HOST', 'localhost')
  c.agent.port = ENV.fetch('DD_TRACE_AGENT_PORT', 8126).to_i

  # トレーシング設定
  c.tracing.enabled = true
  c.tracing.report_hostname = true  # ホスト名のレポート
  c.tracing.log_injection = true    # ログとトレースの関連付け

  # Railsインストゥルメンテーション
  c.tracing.instrument :rails, analytics_enabled: true

  # MySQL2インストゥルメンテーション
  c.tracing.instrument :mysql2, analytics_enabled: true, service_name: 'todo-app-mysql'

  # HTTPリクエストのインストゥルメンテーション
  c.tracing.instrument :http, analytics_enabled: true

  # Rackインストゥルメンテーション（リクエスト詳細）
  c.tracing.instrument :rack, analytics_enabled: true, request_queuing: true

  # Active Recordインストゥルメンテーション
  c.tracing.instrument :active_record, analytics_enabled: true

  # タグの追加
  c.tags = {
    'team' => 'backend',
    'component' => 'todo-app'
  }
end

