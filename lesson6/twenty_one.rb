SUITS = %w(H S D C)
FACE_CARDS = %w(Queen King Jack Ace)
GAME_SIZE = 21
DEALER_STAY = 17

def prompt(msg)
  puts "=> #{msg}"
end

def initialize_deck
  deck = []
  SUITS.each do |suit|
    2.upto(10) { |num| deck << [suit, num.to_s] }
    FACE_CARDS.each { |face| deck << [suit, face] }
  end
  deck
end

def deal!(hand, deck)
  hand << deck.delete(deck.sample)
end

def read_hand(hand, player = nil)
  return "Dealer has: #{hand[0][1]} and unknown card." if player == :dealer
  
  result = ""
  hand.each do |card|
    unless card == hand.last
      result << "#{card[1]}, "
    else
      result.chop!.chop! << " and #{card[1]}"
    end
  end
  result
end

def stay?
  prompt "Hit or stay?"
  loop do
    action = gets.chomp.downcase
    case action
    when 'stay' then return true
    when 'hit' then return false
    else
      prompt "Please enter either hit or stay"
    end
  end
end

def total(hand)
  total = 0
  non_ace_cards = hand.select { |card| card[1] unless card[1] == 'Ace' }
  aces = hand.size - non_ace_cards.size
  non_ace_cards.each do |card|
    total += FACE_CARDS.include?(card[1]) ? 10 : card[1].to_i
  end
  aces.times { total += total + 11 > 21 ? 1 : 11 }
  total
end

def busted?(total)
  total > GAME_SIZE
end

def play_again?
  prompt "Keep playing? (y/n)"
  answer = gets.chomp
  answer.downcase.start_with?('n')
end

def display_result(player_hand, dealer_hand, player_total, dealer_total)
  puts "=============="
  prompt "Dealer has #{read_hand(dealer_hand)}, for a total of: #{dealer_total}"
  prompt "Player has #{read_hand(player_hand)}, for a total of: #{player_total}"
  puts "=============="
end

def winning_score?(score)
  score[0] >= 5 || score[1] >= 5
end

def who_won?(score)
  return "Player" if score [0] >= 5
  "Dealer"
end

score = [0, 0]
prompt "Welcome to Twenty-One!"
loop do
  system('clear')
  deck = initialize_deck
  player_hand = []
  dealer_hand = []
  2.times { deal!(player_hand, deck) }
  2.times { deal!(dealer_hand, deck) }
  player_total = total(player_hand)
  dealer_total = total(dealer_hand)
  
  prompt read_hand(dealer_hand, :dealer)
  prompt "You have: " + read_hand(player_hand)
  prompt "Your total is: #{player_total}"
  
  loop do
    break if busted?(player_total) || stay?
    deal!(player_hand, deck)
    player_total = total(player_hand)
    prompt "Dealer passes you a card"
    prompt "You now have: " + read_hand(player_hand)
    prompt "Your total is: #{player_total}"
  end
  
  if busted?(player_total)
    display_result(player_hand, dealer_hand, player_total, dealer_total)
    prompt "You busted! Dealer wins."
    prompt "The score is: Player #{score[0]}, Dealer #{score[1] += 1}"
    prompt "#{who_won?(score)} reaches 5 points first!" if winning_score?(score)
    play_again? ? break : next
  end
  
  prompt "You stay at #{player_total}"
  prompt "Dealer Turn..."
  
  loop do
    break if dealer_total >= DEALER_STAY
    prompt "Dealer hits at #{dealer_total}"
    deal!(dealer_hand, deck)
    dealer_total = total(dealer_hand)
  end
  
  if busted?(dealer_total)
    display_result(player_hand, dealer_hand, player_total, dealer_total)
    prompt "Dealer busts! You win." 
    prompt "The score is: Player #{score[0] += 1}, Dealer #{score[1]}"
    prompt "#{who_won?(score)} reaches 5 points first!" if winning_score?(score)
    play_again? ? break : next
  end
  
  prompt "Dealer stays at #{dealer_total}"
  display_result(player_hand, dealer_hand, player_total, dealer_total)
  
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
  prompt "#{who_won?(score)} reaches 5 points first!" if winning_score?(score)
  
  break if play_again?
end

prompt "Thank you for playing Twenty One! Goodbye!"
