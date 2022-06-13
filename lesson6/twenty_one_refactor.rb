FACE_CARDS = %w(Queen King Jack Ace)
GAME_SIZE = 21
DEALER_STAY = 17

def prompt(msg)
  puts "=> #{msg}"
end

def initialize_deck
  deck = []
  4.times do
    2.upto(10) { |num| deck << num.to_s }
    FACE_CARDS.each { |face| deck << face }
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

def total(hand)
  total = 0
  non_ace_cards = hand.select { |card| card unless card == 'Ace' }
  aces = hand.size - non_ace_cards.size
  non_ace_cards.each do |card|
    total += FACE_CARDS.include?(card) ? 10 : card.to_i
  end
  aces.times { total += total + 11 > 21 ? 1 : 11 }
  total
end

def display_hands(player_hand, dealer_hand, player_total, dealer_total)
  puts "=============="
  prompt "Dealer has #{read_hand(dealer_hand)}, for a total of: #{dealer_total}"
  prompt "Player has #{read_hand(player_hand)}, for a total of: #{player_total}"
  puts "=============="
end

def display_result(score, player_total, dealer_total)
  if player_total > dealer_total
    prompt "You win!"
    prompt "The score is: Player #{score[0] += 1}, Dealer #{score[1]}"
  elsif dealer_total > player_total
    prompt "Dealer wins."
    prompt "The score is: Player #{score[0]}, Dealer #{score[1] += 1}"
  else
    prompt "It's a tie!"
    prompt "The score is: Player #{score[0]}, Dealer #{score[1]}"
  end
  prompt "#{winner?(score)} reaches 5 points first!" if winner?(score)
  pause
end

def display_busted(score, player_total)
  if player_total > 21
    prompt "You busted! Dealer wins."
    prompt "The score is: Player #{score[0]}, Dealer #{score[1] += 1}"
  else
    prompt "Dealer busts! You win."
    prompt "The score is: Player #{score[0] += 1}, Dealer #{score[1]}"
  end
  prompt "#{winner?(score)} reaches 5 points first!" if winner?(score)
  pause
end

def winner?(score)
  if score[0] >= 5
    'Player'
  elsif score[1] >= 5
    'Dealer'
  end
end

def pause
  prompt "Press enter for next screen..."
  gets
  system "clear"
end

def read_hand(hand)
  temp = hand.clone
  last = temp.pop
  temp.join(', ') << " and #{last}"
end

score = [0, 0]
prompt "Welcome to Twenty_One!"
prompt "Find the rules at: https://bargames101.com/21-card-game-rule/"
pause
loop do
  deck = initialize_deck
  player_hand = initialize_hand(deck)
  dealer_hand = initialize_hand(deck)
  player_total = total(player_hand)
  dealer_total = total(dealer_hand)
  prompt "Dealer has: #{dealer_hand[0]} and ?"
  prompt "You have: #{read_hand(player_hand)}"
  prompt "Your total is: #{player_total}"
  loop do
    prompt "Hit or stay?"
    answer = gets.chomp.downcase
    if answer.start_with?('h')
      prompt "Dealer passes you a card"
      deal!(player_hand, deck)
      player_total = total(player_hand)
      pause
      if player_total > 21
        display_hands(player_hand, dealer_hand, player_total, dealer_total)
        display_busted(score, player_total)
        break
      end
      prompt "You now have: #{read_hand(player_hand)}"
      prompt "Your total is: #{player_total}"
    elsif answer.start_with?('s')
      prompt "You stay at #{player_total}"
      prompt "Dealer Turn..."
      loop do
        break if dealer_total >= DEALER_STAY
        prompt "Dealer hits"
        deal!(dealer_hand, deck)
        dealer_total = total(dealer_hand)
      end
      prompt "Dealer stays" unless dealer_total > 21
      pause
      display_hands(player_hand, dealer_hand, player_total, dealer_total)
      if dealer_total > 21
        display_busted(score, player_total)
      else
        display_result(score, player_total, dealer_total)
      end
      break
    else
      prompt "Please enter either hit or stay"
    end
  end
  break if winner?(score)
  prompt "Press enter to continue or type exit to stop"
  answer = gets.chomp.downcase
  break if answer.start_with?('e')
  system 'clear'
end
prompt "Thank you for playing Twenty One! Goodbye!"
