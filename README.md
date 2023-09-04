# Team Sorter Bot

Telegram bot that helps with organization of sport events and venues. Features includes creating list of players, divide into balanced teams, player rating management.

## How to use
- Go to [Team Sorter Bot](https://t.me/team_sorter_bot) and `/start`.
- Send admin request by `/become_admin` and wait for verification.
- Get the link for authorization using `/login` command.

## Commands
- `/start` - initiates the questions regarding the venue and creates list for player signup.
- `/become_admin`- send admin request for verification.
- `/login` - generates link for Telegram authorization. Telegram sends user info with hash and it is checked using HMAC_SHA256 on server side.
- `/change_rating %integer% %float% ` - changes rating of the player. First integer param is for position on the last list. Second float param is for new rating. E.g `/change_rating 2 5.5`.

## Inline Commands
![Screenshot from 2023-09-01 20-09-13](https://github.com/Nmerey/team_sorter/assets/32390632/0690f7be-fc95-4be1-9a10-0029ddec0335)

- `+` - register yourself on the players list. Default rating is 5.0, can be changed on Player Management Dashboard or using `/change_rating` command.
- `-` - remove yourself from the players list.
- `Add Friend` - add a friend who is not part of the chat group bot is on. Name and rating will be asked on the chat.
- `Remove Friend` - remove a friend from the list. Last added friend will be removed first.
- `Sort Teams` - Divide players to balanced teams with equal or near equal average team rating.
  > The most important command of the bot, imho. Saved us ton of time and money. It uses pretty complicated algorithm to find teams that are perfectly balanced. First the bot calculates the average rating for teams(`sum_of_player_ratins/number_of_teams`). Then it generates all unique combination of teams and among them bot finds teams which are equal to average rating. Then valid team is taken out of the players list and process is repeated untill there is no players left in players list. You might ask what happens if there is no team that matches the average rating. Good point, at that point bot also generates all combinations of unique teams and sorts them by average rating and then takes the team that is absolutely the closest to average rating. Pretty fun stuff right ?! It is located as a separate [Service Object](https://github.com/Nmerey/team_sorter/blob/b241b3fdf14622bfc7bb53b4ccea2f655549b9de/app/services/player_services/divide_to_teams.rb), please have a look.

## Technologies

### Backend
- Ruby 3.1.3
- Rails 7.0.6
- Postgresql 15.1
### Frontend
- Tailwind
- Slim
### Services
- Telegram API
- ActiveJob - for message queing
- Domcloud.io - free hosting. Special thanks to [@willnode](https://github.com/willnode)
- Telegram bot gem - Telegram API method wrapper. Big ups to [@printercu](https://github.com/printercu)
