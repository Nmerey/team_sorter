require 'rails_helper'

RSpec.describe TelegramWebhookController, telegram_bot: :rails do
  let(:default_chat_id) { 456 }
  
  describe '#ping!' do
    subject { -> { dispatch_command :ping } }
    it { should respond_with_message 'pong' }
  end

  describe '#start!' do
    subject {-> { dispatch_command :start }}
    
    let(:player) { create(:player) }
    let(:admin) { Admin.create(player_id: player.id) }
    let(:from) { {
      first_name: player.name,
      last_name: player.surname,
      username: player.nickname,
      id: player.t_id
    }}

    context 'when not authorized' do
      it { should respond_with_message "#{player.name} #{player.surname} /become_admin to use the bot!"}
    end

    context 'when authorized' do
      before { admin.accepted! }

      it { should respond_with_message "Location?" }
      
      it "should ask for date after recieving locaiton" do
        expect { dispatch_message('Test Location').to respond_with_message "Date?" }
      end

      it "should ask for time after recieving time" do
        expect { dispatch_message('12.12').to respond_with_message "Time?" }
      end

      it "should create new venue successfully" do
        expect { dispatch_message('18.00').to eq(Venue.last) }
      end
    end
  end

  describe '#become_admin!' do
    subject {-> { dispatch_command :become_admin }}

    it { should change { Admin.count }.by(1) }
  end

  describe '#login!' do
    subject {-> { dispatch_command :login }}

    let(:markup_login_url) { AuthHelper::LOGIN_MARKUP }
    it { should make_telegram_request(bot, :sendMessage).with({
      text:'Please login through this link to access Dashboard',
      reply_markup: markup_login_url,
      chat_id: default_chat_id
      })
    }
  end
end