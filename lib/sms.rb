require 'open-uri'
class SMSGateway

  def self.send(number, code)
    Resque.after_fork = Proc.new do
      Rails.logger.auto_flushing = true
    end
    log = Logger.new 'log/sms.log'

    msg = URI.encode("Hello. Your Photobook verification code is: " + code.to_s)

    if APP_CONFIG['sms_gate'] == 0
      uri = 'http://smsc.ru/sys/send.php?login=' + APP_CONFIG['smsc_login'] + '&psw=' + APP_CONFIG['smsc_pw'] + '&phones=' + number + '&mes=' + msg
      open(uri)
      log.debug("Sending sms verification code to " + number)
    else
      system './lib/sms.sh', number, msg
      log.debug("Sending sms verification code to " + number + " using custom gateway")
    end

  end

end
