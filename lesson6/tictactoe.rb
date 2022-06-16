INITIAL_MARKER = ' '
PLAYER_MARKER = 'X'
COMPUTER_MARKER = 'O'
WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] +
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] +
                [[1, 5, 9], [3, 5, 7]]

def prompt(msg)
  puts "=> #{msg}"
end

# rubocop:disable Metrics/AbcSize
def display_board(board)
  system 'clear'
  puts ''
  puts '     |     |'
  puts "  #{board[1]}  |  #{board[2]}  |  #{board[3]}"
  puts '     |     |'
  puts '-----+-----+-----'
  puts '     |     |'
  puts "  #{board[4]}  |  #{board[5]}  |  #{board[6]}"
  puts '     |     |'
  puts '-----+-----+-----'
  puts '     |     |'
  puts "  #{board[7]}  |  #{board[8]}  |  #{board[9]}"
  puts '     |     |'
  puts ''
end
# rubocop:enable Metrics/AbcSize

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

def empty_squares(board)
  board.keys.select { |num| board[num] == INITIAL_MARKER }
end

def player_places_piece!(board)
  square = ''
  loop do
    prompt "Choose a square: #{(joinor(empty_squares(board)))}"
    square = gets.chomp.to_i
    break if empty_squares(board).include?(square)
    prompt "Sorry that's not a valid choice"
  end
  board[square] = PLAYER_MARKER
end

def board_full?(board)
  empty_squares(board).empty?
end

def joinor(board)
  return board.first if board.size == 1
  temp = board.clone
  last = temp.pop
  temp.join(', ') << " or #{last}"
end

def game_winner(board)
  WINNING_LINES.each do |line|
    if board.values_at(*line).count(PLAYER_MARKER) == 3
      return 'Player'
    elsif board.values_at(*line).count(COMPUTER_MARKER) == 3
      return 'Computer'
    end
  end
  nil
end

def match_winner(score)
  if score[:player] >= 5
    'Player'
  elsif score[:computer] >= 5
    'Computer'
  end
end

def increment_score!(score, winner)
  score[:player] += 1 if winner == "Player"
  score[:computer] += 1 if winner == "Computer"
end

def place_piece!(board, player, difficulty)
  if %w(i impossible).include?(difficulty)
    player == "Player" ? player_places_piece!(board) : perfect_comp_move!(board)
  else
    player == "Player" ? player_places_piece!(board) : random_comp_move!(board)
  end
end

def random_comp_move!(board)
  board[empty_squares(board).sample] = COMPUTER_MARKER
end

def alternate_player(player)
  player == "Player" ? 'Computer' : 'Player'
end

def perfect_comp_move!(board)
  if winning_move(board)
    board[winning_move(board)] = COMPUTER_MARKER
  elsif block_player(board)
    board[block_player(board)] = COMPUTER_MARKER
  elsif open_middle?(board)
    board[5] = COMPUTER_MARKER
  elsif create_threat(board)
    board[create_threat(board)] = COMPUTER_MARKER
  else
    random_comp_move!(board)
  end
end

def block_player(board)
  WINNING_LINES.each do |line|
    if board.values_at(*line).count(PLAYER_MARKER) == 2 &&
       board.values_at(*line).include?(INITIAL_MARKER)
      line.each { |num| return num if board[num] == INITIAL_MARKER }
    end
  end
  nil
end

def open_middle?(board)
  board[5] == INITIAL_MARKER
end

def winning_move(board)
  WINNING_LINES.each do |line|
    if board.values_at(*line).count(COMPUTER_MARKER) == 2 &&
       board.values_at(*line).include?(INITIAL_MARKER)
      line.each { |num| return num if board[num] == INITIAL_MARKER }
    end
  end
  nil
end

def detect_threat_squares(board)
  result = []
  WINNING_LINES.each do |line|
    if board.values_at(*line).count(INITIAL_MARKER) == 2 &&
       board.values_at(*line).include?(COMPUTER_MARKER)
      line.each do |num|
        result << num if board[num] == INITIAL_MARKER
      end
    end
  end
  result
end

def create_threat(board)
  corners = [1, 3, 7, 9]
  empty_corners = empty_squares(board).intersection(corners)
  threat_squares = detect_threat_squares(board)
  threat_squares.each { |num| return num if empty_corners.include?(num) }
  return threat_squares.sample unless threat_squares.empty?
  empty_corners.sample unless empty_corners.empty?
end

def display_introduction
  system 'clear'
  prompt "Welcome to Tic Tac Toe!"
  prompt "Alternate placing symbols in a 3x3 board"
  prompt "The goal is to get 3 in a row"
  prompt "First to 5 wins match!"
end

def goes_first
  prompt "Do you want to go first? (y/n)"
  answer = gets.chomp.downcase
  system 'clear'
  %w(n no).include?(answer) ? 'Computer' : 'Player'
end

def alternate_turns(board, current_player, difficulty)
  display_board(board)
  loop do
    place_piece!(board, current_player, difficulty)
    display_board(board)
    break if game_winner(board) || board_full?(board)
    current_player = alternate_player(current_player)
  end
end

def end_screen(board, score)
  winner = game_winner(board)
  increment_score!(score, winner)
  if winner
    prompt "#{winner} won!"
  else
    prompt "It's a tie!"
  end
  prompt "Score is: Player #{score[:player]}, Computer #{score[:computer]}"
  prompt "#{match_winner(score)} reached 5 points first!" if match_winner(score)
end

def stop_early?
  prompt "Press enter to continue or type exit to stop"
  answer = gets.chomp.downcase
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

def what_difficulty(answer = nil)
  prompt "Would you like the easy or impossible difficulty? (e/i)"
  loop do
    answer = gets.chomp.downcase
    break if %w(e easy i impossible).include?(answer)
    prompt "Please enter easy or impossible (e/i)"
  end
  answer
end

loop do
  display_introduction
  difficulty = what_difficulty
  score = { player: 0, computer: 0 }
  loop do
    board = initialize_board
    display_board(board)
    current_player = goes_first
    alternate_turns(board, current_player, difficulty)
    end_screen(board, score)
    break if match_winner(score)
    break if stop_early?
  end
  break unless play_again?
end
prompt('Thanks for playing Tic Tac Toe! Goodbye!')
