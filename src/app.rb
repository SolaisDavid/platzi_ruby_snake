require_relative "view/ruby2d.rb" # Incluir otros archivos de ruby usando un path relativo
require_relative "model/state.rb"
require_relative "actions/actions.rb"

class App

  def initialize
    @state = Model::initial_state
  end

  def start
    @view = View::Ruby2dView.new(self)
    Thread.new { init_timer(@view) } 
    @view.start(@state)
  end

  def init_timer(view)
    loop do 
      @state = Actions::move_snake(@state)
      @view.render_game(@state)
      sleep 0.5
    end
  end

  def send_action(action, params)
    # :change_direction, Model::Direction::UP
    new_state = Actions.send(action, @state, params)

    if new_state.hash != @state
      @state = new_state
      @view.render_game(@state)
    end
  end

end

app = App.new
app.start