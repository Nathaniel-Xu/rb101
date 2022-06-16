SUITS = %w(Hearts Diamonds Spades Clubs)
FACE_CARDS = %w(Queen King Jack Ace)
GAME_SIZE = 21
DEALER_STAY = 17
GAMES_TO_WIN = 5

def prompt(msg)
  puts "=> #{msg}"
end

def pause
  prompt "Press enter for next screen..."
  gets
  system "clear"
end

def display_introduction
  system 'clear'
  prompt "Welcome to Twenty_One!"
  prompt "Find the rules at: https://bargames101.com/21-card-game-rule/"
  prompt "First to #{GAMES_TO_WIN} wins!"
  pause
end

def initialize_deck
  deck = []
  SUITS.each do |suit|
    2.upto(10) { |num| deck << [num, suit] }
    FACE_CARDS.each { |face| deck << [face, suit] }
  end
  deck.shuffle
end

def deal!(hand, deck)
  hand << deck.pop
end

def initialize_hand(deck)
  hand = []
  2.times { deal!(hand, deck) }
  hand
end

def initialize_game_data
  {
    player: {
      cards: nil,
      total: nil
    },
    dealer: {
      cards: nil,
      total: nil
    },
    score: {
      player: 0,
      dealer: 0
    }
  }
end

def populate!(game_data, deck)
  game_data[:player][:cards] = initialize_hand(deck)
  game_data[:dealer][:cards] = initialize_hand(deck)
  game_data[:player][:total] = total(game_data[:player][:cards])
  game_data[:dealer][:total] = total(game_data[:dealer][:cards])
end

def busted?(player)
  player[:total] > GAME_SIZE
end

def total(cards)
  total = 0
  non_ace_cards = cards.select { |card| card unless card[0] == 'Ace' }
  aces = cards.size - non_ace_cards.size
  non_ace_cards.each do |card|
    total += FACE_CARDS.include?(card[0]) ? 10 : card[0]
  end
  aces.times { total += total + 11 > GAME_SIZE ? 1 : 11 }
  total
end

def increment_total!(player)
  player[:total] = total(player[:cards])
end

def read_cards(cards)
  result = '['
  cards = cards.map { |card| card.join(' of ') }
  result << cards.join(', ') << ']'
end

def display_interface(player, dealer)
  prompt "Dealer has: [#{dealer[:cards][0].join(' of ')}, ?]"
  prompt "You have: #{read_cards(player[:cards])}"
  prompt "Your total is: #{player[:total]}"
end

def match_winner(game_data)
  if game_data[:score][:player] >= GAMES_TO_WIN
    'Player'
  elsif game_data[:score][:dealer] >= GAMES_TO_WIN
    'Dealer'
  end
end

def display_score(game_data, score)
  result = detect_result(game_data[:player], game_data[:dealer])
  if result == :player || result == :dealer_busted
    prompt "Score: Player #{score[:player] += 1}, Dealer #{score[:dealer]}"
  elsif result == :dealer || result == :player_busted
    prompt "Score: Player #{score[:player]}, Dealer #{score[:dealer] += 1}"
  else
    prompt "Score: Player #{score[:player]}, Dealer #{score[:dealer]}"
  end
end

def display_cards(player, dealer)
  puts "=============="
  prompt "Dealer cards: #{read_cards(dealer[:cards])} = #{dealer[:total]}"
  prompt "Player cards: #{read_cards(player[:cards])} = #{player[:total]}"
  puts "=============="
end

def deal_to_player(game_data, deck)
  prompt "Dealer passes you a card"
  deal!(game_data[:player][:cards], deck)
  increment_total!(game_data[:player])
  pause
end

def hit_or_stay(answer = nil)
  prompt "Hit or stay? (h/s)"
  loop do
    answer = gets.chomp.downcase
    break if %w(h hit s stay).include?(answer)
    prompt "Please enter hit or stay (h/s)"
  end
  answer
end

def player_turn(game_data, deck)
  loop do
    display_interface(game_data[:player], game_data[:dealer])
    answer = hit_or_stay
    if %w(h hit).include?(answer)
      deal_to_player(game_data, deck)
      break if busted?(game_data[:player])
    elsif %w(s stay).include?(answer)
      break
    end
  end
end

def dealer_turn(game_data, deck)
  prompt "You stay at #{game_data[:player][:total]}"
  prompt "Dealer Turn..."
  loop do
    break if game_data[:dealer][:total] >= DEALER_STAY
    prompt "Dealer hits"
    deal!(game_data[:dealer][:cards], deck)
    increment_total!(game_data[:dealer])
  end
  prompt "Dealer stays" unless busted?(game_data[:player])
  pause
end

def detect_result(player, dealer)
  if player[:total] > GAME_SIZE
    :player_busted
  elsif dealer[:total] > GAME_SIZE
    :dealer_busted
  elsif dealer[:total] < player[:total]
    :player
  elsif dealer[:total] > player[:total]
    :dealer
  else
    :tie
  end
end

def display_result(game_data)
  result = detect_result(game_data[:player], game_data[:dealer])
  case result
  when :player_busted
    prompt "You busted! Dealer wins."
  when :dealer_busted
    prompt "Dealer busted! You win."
  when :player
    prompt "You win!"
  when :dealer
    prompt "Dealer wins."
  when :tie
    prompt "It's a tie!"
  end
end

def end_screen(game_data)
  display_cards(game_data[:player], game_data[:dealer])
  display_result(game_data)
  display_score(game_data, game_data[:score])
  if match_winner(game_data)
    prompt %W(#{match_winner(game_data)} reaches #{GAMES_TO_WIN}
              points first!).join(' ')
  end
end

def stop_early?
  prompt "Press enter to continue or type exit to stop"
  answer = gets.chomp.downcase
  system 'clear'
  true if %w(e exit).include?(answer)
end

def play_again?(answer = nil)
  prompt "Play again? (y/n)"
  loop do
    answer = gets.chomp.downcase
    break if %w(y yes n no).include?(answer)
    prompt "Enter yes or no (y/n)"
  end
  true if %w(y yes).include?(answer)
end

loop do
  system 'clear'
  display_introduction
  game_data = initialize_game_data
  loop do
    deck = initialize_deck
    populate!(game_data, deck)
    player_turn(game_data, deck)
    dealer_turn(game_data, deck) unless busted?(game_data[:player])
    end_screen(game_data)
    break if match_winner(game_data)
    break if stop_early?
  end
  break unless play_again?
end
prompt "Thank you for playing Twenty One! Goodbye!"
