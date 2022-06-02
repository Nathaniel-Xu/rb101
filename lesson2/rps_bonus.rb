VALID_CHOICES = %w(rock paper scissors lizard spock)
WIN_CONDITIONS = { 
  o: %w(scissors lizard),
  a: %w(rock spock),
  c: %w(paper lizard),
  p: %w(scissors rock),
  i: %w(spock paper)
}

def prompt(message)
  puts("=> #{message}")
end

def win?(first, second)
  WIN_CONDITIONS[first[1].intern].include?(second)
end

def display_results(player, computer)
  if win?(player, computer)
    prompt("You won!")
  elsif win?(computer, player)
    prompt("Computer won!")
  else
    prompt("It's a tie!")
  end
end

def increment_score(player, computer, score)
  if win?(player, computer)
    score[0] += 1
  elsif win?(computer, player)
    score[1] += 1
  end
  score
end

score = [0, 0]
choice = nil
loop do
  loop do
    prompt("Choose one: #{VALID_CHOICES.join(', ')}")
    choice = gets.chomp
    
    if VALID_CHOICES.include?(choice)
      break
    else
      prompt("That's not a valid choice")
    end
  end
  
  computer_choice = VALID_CHOICES.sample
  
  puts("You chose: #{choice}; Computer chose #{computer_choice}")
  
  display_results(choice, computer_choice)
  
  score = increment_score(choice, computer_choice, score)
  
  if score[0] >= 3
    puts "You reached three wins first!"
    break
  elsif score[1] >= 3
    puts "The computer reached three wins first!"
    break
  end
  
  prompt("Do you want to play again? (y/*)")
  break unless gets.chomp.downcase.start_with?('y')
end
