# frozen_string_literal: false

# Controller class for interactions between Telegram bot and the server using Webhook.
# Telegram commands ends with bang(!)

class TelegramWebhookController < Telegram::Bot::UpdatesController
  include ValidationHandler
  include TelegramWebhookHelper
  include AuthHelper
  include Telegram::Bot::UpdatesController::MessageContext
  

  before_action :set_venue, only: %i[callback_query divide_teams change_rating!]
  before_action :set_player, only: %i[callback_query start! become_admin! change_rating!]
  before_action :set_authorization, only: %i[change_rating! start! sort_teams]

  def ping!
    respond_with :message, text: 'pong'
  end

  def login!
    respond_with :message, text: 'Please login through this link to access Dashboard',
    reply_markup: AuthHelper::LOGIN_MARKUP
  end

  def become_admin!
    @admin = Admin.new(player_id: @player&.id)

    if @admin.save
      respond_with :message, text: 'Your request was sent!'
    else
      respond_with :message, text: 'Already sent! Check Dashboard for access', reply_markup: AuthHelper::LOGIN_MARKUP
    end
  end
  
  def start!
    respond_with :message, text: 'Location?'
    save_context :get_location
  end

  def get_location(*location)
    session[:location] = location.join(' ')

    respond_with :message, text: 'Date? (ex. 23.04)'
    save_context :get_date
  end

  def get_date(date)
    check_date(date)
    session[:date] = formatted_date(date)

    respond_with :message, text: 'Time? (ex. 19.00)'
    save_context :get_time
  end

  def get_time(time)
    session[:time] = time
    finalize_venue
  end

  def change_rating!(*data)
    position_on_list  = data[0].to_i - 1
    rating            = data[1]
    player            = @venue.players.game_ordered[position_on_list]

    check_change_rating_args(rating: rating, player: player)

    if player.update(rating: rating)
      respond_with :message, text: "#{player.name}'s rating has been updated to #{player.rating}"
      show_edit_reply
    else
      respond_with :message, text: 'Something went wrong!'
    end
  end

  # rubocop:disable all
  def callback_query(data)
    send(data)
    show_edit_reply
  end

  def add_friend
    session[:venue_id]  = @venue.id
    session[:callback]  = payload['message']
    session[:friend_id] = from['id']

    respond_with :message, text: 'Name and Rating ? (ex. Chapa 5.5)'
    save_context :create_friend
  end

  def create_friend(*friend_data)
    check_friend_args(friend_data)

    @venue              = Venue.find(session[:venue_id])
    player              = Player.new(format_friend_params(friend_data))
    payload['message']  = session[:callback]

    if player.save
      game = Game.create(player: player, venue: @venue)
      show_edit_reply
    else
      friend_not_saved_message
    end
  end

  def sort_teams
    respond_with :message, text: 'Number of Teams and Players (ex. 3 15)'
    save_context :divide_teams
  end

  def divide_teams(*teams_data)
    teams_count   = teams_data[0].to_i
    players_count = teams_data[1].to_i
    total_players = @venue.players.count

    check_division_args(teams_count, players_count, total_players)

    sorted_teams = PlayerServices::DivideToTeams.new(@venue, teams_count, players_count).call

    list_of_teams(sorted_teams)
  end

  private
  
  def set_venue
    @venue = Venue.where(chat_title: chat['title']).last
  end

  def set_player
    @player = Player.find_or_create_by(t_id: from['id']) do |player|
      player.assign_attributes(player_params)
    end
  end

  def add_player
    Game.create!(player: @player, venue: @venue)
  end

  def remove_player
    player  = Player.find_by(t_id: from['id'])
    game    = Game.find_by(venue: @venue, player: @player)
    game.destroy
  end

  def remove_friend
    @venue.players.where(friend_id: from['id']).last.destroy
  end

  # rubocop:enable all

  def finalize_venue
    @venue = Venue.new(venue_params)

    return unless @venue.save

    session[:venue_id] = @venue.id
    respond_with :message, text: @venue.markup_text, reply_markup: REPLY_MARKUP
  end

  def player_params
    {
      name:     from['first_name'],
      surname:  from['last_name'],
      nickname: "@#{from['username']}",
      t_id:     from['id']
    }
  end

  def venue_params
    {
      location:   session[:location],
      date:       session[:date],
      time:       session[:time],
      chat_id:    chat['id'],
      chat_title: chat['title'],
      owner_id:   from['id']
    }
  end

  def format_friend_params(friend_data)
    {
      name:      friend_data[0],
      rating:    friend_data[1],
      friend_id: session[:friend_id]
    }
  end
end
