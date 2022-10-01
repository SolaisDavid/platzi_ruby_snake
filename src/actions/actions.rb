module Actions
  def self.move_snake(state)
    next_direction = state.curr_direction
    next_position = calc_next_position(state)

    # Validar siguiente casilla
    if is_position_food?(state, next_position)
      grow_snake(state, next_position)
      generate_new_food(state)
    elsif is_position_valid?(state, next_position)
      move_snake_to(state, next_position)
    else
      end_game(state)
    end
  end

  def self.change_direction(state, direction)
    if is_next_direction_valid?(state, direction)
      state.curr_direction = direction
    else
      puts "Invalid direction"
    end

    state
  end

  private

  def self.generate_new_food(state)
    new_food = Model::Food.new(rand(state.grid.rows), rand(state.grid.cols))
    state.food = new_food

    state
  end
  
  def self.is_position_food?(state, position)
    state.food.row == position.row && state.food.col == position.col
  end

  def self.grow_snake(state, position)
    new_positions = state.snake.positions.prepend(position)
    state.snake.positions = new_positions

    state
  end

  def self.is_next_direction_valid?(state, direction)
    case state.curr_direction
    when Model::Direction::UP
      return true if direction != Model::Direction::DOWN
    when Model::Direction::DOWN
      return true if direction != Model::Direction::UP
    when Model::Direction::LEFT
      return true if direction != Model::Direction::RIGHT
    when Model::Direction::RIGHT
      return true if direction != Model::Direction::LEFT
    end

    return false
  end

  def self.calc_next_position(state)
    curr_position = state.snake.positions.first
    case state.curr_direction
    when Model::Direction::UP
      return Model::Coord.new(
        curr_position.row - 1,
        curr_position.col
      )
    when Model::Direction::DOWN
      return Model::Coord.new(
        curr_position.row + 1,
        curr_position.col
      )
    when Model::Direction::LEFT
      return Model::Coord.new(
        curr_position.row,
        curr_position.col - 1
      )
    when Model::Direction::RIGHT
      return Model::Coord.new(
        curr_position.row,
        curr_position.col + 1
      )
    end
  end

  def self.is_position_valid?(state, position)
    # Verificar el grid
    return false if (position.row >= state.grid.rows || position.row < 0) || (position.col >= state.grid.cols || position.col < 0)
    # Verificar no superposicion con la serpiente
    return !(state.snake.positions.include? position)
  end

  def self.move_snake_to(state, next_position)
    new_positions = [next_position] + state.snake.positions[0...-1]
    state.snake.positions = new_positions
    state
  end

  def self.end_game(state)
    state.game_over = true
    state
  end
end