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

def someone_won?(board)
  !!game_winner(board)
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
  if score[0] >= 5
    'Player'
  elsif score[1] >= 5
    'Computer'
  end
end

def increment_score!(score, match_winner)
  match_winner == "Player" ? score[0] += 1 : score[1] += 1
end

def place_piece!(board, player)
  player == "Player" ? player_places_piece!(board) : perfect_comp_move!(board)
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
  else create_threat(board)
    board[create_threat(board)] = COMPUTER_MARKER
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

def create_threat(board)
  corners = [1, 3, 7, 9]
  empty_corners = board.keys.select do |key|
    key if corners.include?(key) && board[key] == INITIAL_MARKER
  end
  if empty_corners_with_threat(board, empty_corners)
    return empty_corners_with_threat(board, empty_corners)
  elsif any_threat(board)
    return any_threat
  end
  return empty_corners.sample unless empty_corners.empty?
  empty_squares(board).sample
end

def empty_corners_with_threat(board, empty_corners)
  WINNING_LINES.each do |line|
    if board.values_at(*line).count(INITIAL_MARKER) == 2 &&
       board.values_at(*line).include?(COMPUTER_MARKER)
      line.each do |num|
        return num if board[num] == INITIAL_MARKER &&
                      empty_corners.include?(num)
      end
    end
  end
  nil
end

def any_threat(board)
  WINNING_LINES.each do |line|
    if board.values_at(*line).count(INITIAL_MARKER) == 2 &&
       board.values_at(*line).include?(COMPUTER_MARKER)
      line.each do |num|
        return num if board[num] == INITIAL_MARKER
      end
    end
  end
  nil
end

score = [0, 0]
prompt "Welcome to Tic Tac Toe!"
prompt "First to 5 wins!"
loop do
  prompt "Do you want to go first? (y/n)"
  answer = gets.chomp.downcase
  current_player = answer.start_with?('n') ? 'Computer' : 'Player'
  board = initialize_board
  loop do
    display_board(board)
    place_piece!(board, current_player)
    current_player = alternate_player(current_player)
    break if someone_won?(board) || board_full?(board)
  end
  display_board(board)
  if someone_won?(board)
    prompt "#{game_winner(board)} won!"
    increment_score!(score, game_winner(board))
    prompt "Score is: Player #{score[0]}, Dealer #{score[1]}"
    if match_winner(score) == 'Player'
      prompt 'You reached 5 points first!'
      break
    elsif match_winner(score) == 'Computer'
      prompt 'Computer reached 5 points first'
      break
    end
  else
    prompt "It's a tie!"
  end
  prompt 'Continue? (y/n)'
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end

prompt('Thanks for playing Tic Tac Toe! Goodbye!')
