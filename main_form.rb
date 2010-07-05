require 'rubygems'

class MainForm
  
  def self.show
    @running = false
    build_ui
    hook_up_events
    
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
        @window.set_size_request(200, 200)
        # Closing the form shouldn't kill the app. You have to kill it from the menu.
        @window.signal_connect("destroy") { false }
        @window.resizable = false
        @window.window_position = Gtk::Window::POS_CENTER_ALWAYS
        @window.border_width = 10
      end
      
      def hook_up_events
        @start_button.signal_connect("clicked") { start_button_clicked }
      end
      
      def start_button_clicked
        if @start_button.label == "Start"
          @running = true
          unless @timer
            # Calling new automatically starts the timer.
            @timer = GLib::Timer.new
          else
            @timer.continue
          end
          @start_button.label = "Stop"
          
          t = Thread.new do
            while @running
              update_elapsed_time_display
            end
          end
          t.run
          
        else
          @timer.stop
          @start_button.label = "Start"
        end
      end
      
      def update_elapsed_time_display
        elapsed = Time.at(@timer.elapsed[0]).gmtime.strftime('%R:%S')
        @time_label.set_markup("<span size='xx-large'>#{elapsed}</span>")
      end
      
      # FIXME: Break this up into a few smaller methods.
      def create_widgets
        top_box = Gtk::HBox.new(false, 0)
        @start_button = Gtk::Button.new("Start")
        top_box.pack_start(@start_button, true, true, 5)
        @time_label = Gtk::Label.new
        @time_label.set_markup("<span size='xx-large'>00:00:00</span>")        
        top_box.pack_end(@time_label, false, false, 5)
        
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