VkontakteApi.configure do |config|
  # параметры, необходимые для авторизации средствами vkontakte_api
  # (не нужны при использовании сторонней авторизации)
  config.app_id       = '4902646'
  config.app_secret   = 'la3G5IoNM4rGmD4y5EbN'
  config.redirect_uri = 'http://api.vkontakte.ru/blank.html'

  # максимальное количество повторов запроса при ошибках
  config.max_retries = 2

  # логгер
  #config.logger        = Rails.logger
  config.log_requests  = true  # URL-ы запросов
  config.log_errors    = true  # ошибки
  config.log_responses = true # удачные ответы

  # используемая версия API
  config.api_version = '5.21'
end
