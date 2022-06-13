FACE_CARDS = %w(Queen King Jack Ace)
GAME_SIZE = 21
DEALER_STAY = 17

def prompt(msg)
  puts "=> #{msg}"
end

def initialize_deck
  deck = []
  4.times do |num|
    2.upto(10) { |num| deck << num.to_s }
    FACE_CARDS.each { |face| deck << face }
  end
  deck.shuffle
end

def deal!(hand, deck)
  hand << deck.pop
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

def display_result(player_hand, dealer_hand, player_total, dealer_total, score)
  puts "=============="
  prompt "Dealer has #{read_hand(dealer_hand)}, for a total of: #{dealer_total}"
  prompt "Player has #{read_hand(player_hand)}, for a total of: #{player_total}"
  puts "=============="
  if player_total > 21
    prompt "You busted! Dealer wins."
    prompt "The score is: Player #{score[0]}, Dealer #{score[1] += 1}"
  elsif dealer_total > 21
    prompt "Dealer busts! You win."
    prompt "The score is: Player #{score[0] += 1}, Dealer #{score[1]}"
  elsif player_total > dealer_total
    prompt "You win!"
    prompt "The score is: Player #{score[0] += 1}, Dealer #{score[1]}"
  elsif dealer_total > player_total
    prompt "Dealer wins."
    prompt "The score is: Player #{score[0]}, Dealer #{score[1] += 1}"
  else
    prompt "It's a tie!"
    prompt "The score is: Player #{score[0]}, Dealer #{score[1]}"
  end
  prompt "#{who_won?(score)} reaches 5 points first!" if winning_score?(score)
  pause
end

def winning_score?(score)
  score[0] >= 5 || score[1] >= 5
end

def who_won?(score)
  return "Player" if score [0] >= 5
  "Dealer"
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
  
def main_game(score, deck = initialize_deck, player_hand = [], dealer_hand = [], 
  player_total = 0, dealer_total = 0)
  2.times { deal!(player_hand, deck) }
  2.times { deal!(dealer_hand, deck) }
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
        display_result(player_hand, dealer_hand, player_total, dealer_total, score)
        break
      end
      prompt "You now have: #{read_hand(player_hand)}"
      prompt "Your total is: #{player_total}"
    elsif answer.start_with?('s')
      prompt "You stay at #{player_total}"
      prompt "Dealer Turn..."
      loop do
        break if dealer_total >= DEALER_STAY
        prompt "Dealer hits at #{dealer_total}"
        deal!(dealer_hand, deck)
        dealer_total = total(dealer_hand)
      end
      pause
      prompt "Dealer stays" unless dealer_total > 21
      display_result(player_hand, dealer_hand, player_total, dealer_total, score)
      break
    else
      prompt "Please enter either hit or stay"
    end
  end
end

score = [0, 0]
prompt "Welcome to Twenty_One!"
prompt "Find the rules at: https://bargames101.com/21-card-game-rule/"
pause
loop do
  main_game(score)
  break if winning_score?(score)
  prompt "Press enter to continue or type stop to exit"
  answer = gets.chomp.downcase
  break if answer.start_with?('s')
  system 'clear'
end
prompt "Thank you for playing Twenty One! Goodbye!"
