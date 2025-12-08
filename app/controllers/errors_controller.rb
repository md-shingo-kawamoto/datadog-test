class ErrorsController < ApplicationController
  # 通常の例外エラーをテスト
  def test
    Datadog::Tracing.trace('error.test') do |span|
      span.set_tag('error.type', 'RuntimeError')
      span.set_tag('custom.tag', 'intentional_error')
      
      raise StandardError, "これは意図的なテストエラーです (APM監視用)"
    end
  end

  # データベースエラーをテスト
  def database
    Datadog::Tracing.trace('error.database') do |span|
      span.set_tag('error.type', 'ActiveRecord::RecordNotFound')
      
      # 存在しないIDを検索してエラーを発生させる
      Todo.find(999999999)
    end
  end

  # タイムアウトエラーをテスト
  def timeout
    Datadog::Tracing.trace('error.timeout') do |span|
      span.set_tag('error.type', 'Timeout')
      span.set_tag('custom.sleep_duration', '10s')
      
      # 重い処理をシミュレート
      sleep 10
      
      raise Timeout::Error, "処理がタイムアウトしました"
    end
  end
end

