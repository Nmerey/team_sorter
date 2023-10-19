# frozen_string_literal: true

# Helper module for all Authentication and Authorization actions. `check_auth?` checks Telegram
# parameters by comparing params HMAC_SHA256 and given hash.
module AuthHelper
  LOGIN_MARKUP = {
    inline_keyboard: [
      [
        { text: 'Login', login_url: { url: "https://#{ENV['WEBHOOK_URL']}" } }
      ]
    ]
  }.freeze

  def set_current_player
    if session[:telegram_id]
      @current_player = Player.find_by(t_id: session[:telegram_id])
    else
      redirect_to root_path
    end
  end

  def not_authorized_message
    respond_with :message, text: "#{@player&.name} #{@player&.surname} /become_admin to use the bot!"
  end

  def authorized?
    @player&.admin&.accepted?
  end

  def set_authorization
    raise not_authorized_message unless authorized?
  end

  def check_auth?(auth_data)
    check_data = auth_data.except('hash').sort.to_h.map { |k, v| "#{k}=#{v}" }.join("\n")
    hashed_token = Digest::SHA256.digest(ENV['BOT_TOKEN'])
    telegram_hash = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), hashed_token, check_data)
    auth_data['hash'] == telegram_hash
  end
end
