
class MainForm
    
  def self.show
    build_ui
  end
  
  private 
  
    def self.build_ui
      window = Gtk::Window.new
    
      # Closing the form shouldn't kill the app. You have to kill it from the menu.
      window.signal_connect("destroy") { false }
      
      window.resizable = false
      window.window_position = Gtk::Window::POS_CENTER_ALWAYS
      window.set_default_size(1000, 1000)
      window.border_width = 10
      #window.add(button)
      window.show_all 
    end
  
end