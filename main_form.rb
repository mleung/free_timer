
class MainForm
  
  def self.show
    build_ui
  end
  
  private 
    
    class << self 
      
      def build_ui
        create_window
        create_widgets
        @window.show_all
      end
      
      def create_window
        @window = Gtk::Window.new
        @window.title = "Free Timer"
        @window.set_size_request(300, 250)
        # Closing the form shouldn't kill the app. You have to kill it from the menu.
        @window.signal_connect("destroy") { false }
        @window.resizable = false
        @window.window_position = Gtk::Window::POS_CENTER_ALWAYS
        @window.border_width = 10
      end
      
      # FIXME: Break this up into a few smaller methods.
      def create_widgets
        top_box = Gtk::HBox.new(false, 0)
        @start_button = Gtk::Button.new("Start")
        top_box.pack_start(@start_button, true, true, 5)
        time_label = Gtk::Label.new
        time_label.set_markup("<span size='xx-large'>00:00:00</span>")        
        top_box.pack_end(time_label, false, false, 5)
        
        mid_vert_box = Gtk::VBox.new(false, 0)
        
        project_box = Gtk::HBox.new(false, 0)
        @project_combo = Gtk::ComboBox.new
        project_box.pack_start(@project_combo, true, true, 5)
        
        task_box = Gtk::HBox.new(false, 0)
        @task_combo = Gtk::ComboBox.new
        task_box.pack_start(@task_combo, true, true, 5)
        
        mid_vert_box.add(project_box)
        mid_vert_box.add(task_box)
        mid_vert_box.spacing = 5
        
        bottom_box = Gtk::HBox.new
        @post_button = Gtk::Button.new("Post Timer")
        bottom_box.pack_end(@post_button, false, 0)
        
        main_box = Gtk::VBox.new(false, 0)
        main_box.spacing = 20
        main_box.add(top_box)
        main_box.add(mid_vert_box)
        main_box.add(bottom_box)
        
        @window.add(main_box)
      end
      
    end
  
end