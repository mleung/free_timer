require 'rubygems'
require 'costagent'
require 'yaml'

class MainForm
  
  def initialize
    build_ui
    hook_up_events
    load_freeagent_data
  end
  
  def show
    @window.show_all
    @window.present    
  end
  
  private 
    
    def load_freeagent_data
      config = YAML.load_file("freeagent.yml")
      account = config['account']
      @costagent = CostAgent.new(account['domain'], account['username'], account['password'])
      @projects = @costagent.projects("all")
      project_store = Gtk::TreeStore.new(String, Integer)
      @projects.each do |p|
        iter = project_store.append(nil)
        iter[0] = p.name
        iter[1] = p.id
      end
      @project_combo.model = project_store
    end
    
    def load_tasks
      @tasks = @costagent.tasks(@project_combo.active_iter[1])
      task_store = Gtk::TreeStore.new(String, Integer)
      @tasks.each do |t|
        iter = task_store.append(nil)
        iter[0] = t.name
        iter[1] = t.id
      end
      @task_combo.model = task_store
    end
    
    def build_ui
      create_window
      create_widgets
    end
    
    def create_window
      @window = Gtk::Window.new
      @window.deletable = false
      @window.title = "Free Timer"
      @window.set_size_request(250, 250)
      # Closing the form shouldn't kill the app. You have to kill it from the menu.
      #@window.signal_connect("destroy") { false }
      @window.resizable = false
      @window.window_position = Gtk::Window::POS_CENTER_ALWAYS
      @window.border_width = 10
    end
    
    def hook_up_events
      @start_button.signal_connect("clicked") { start_button_clicked }
      @project_combo.signal_connect("changed") do
        load_tasks 
      end
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
        
        update_elapsed_time_display        
      else
        @timer.stop
        @start_button.label = "Start"
      end
    end
    
    def update_elapsed_time_display
      t = Thread.new do
        while @running
          elapsed = Time.at(@timer.elapsed[0]).gmtime.strftime('%R:%S')
          @time_label.set_markup("<span size='xx-large'>#{elapsed}</span>")
        end
      end
      t.run
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
      
      comment_box = Gtk::HBox.new(false, 0)
      @comment_entry = Gtk::Entry.new
      comment_box.pack_start(@comment_entry, true, true, 5)
      
      mid_vert_box.add(project_box)
      mid_vert_box.add(task_box)
      mid_vert_box.add(comment_box)
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
    
    def post_timer
      xml =<<EOF
          <?xml version="1.0" encoding="UTF-8"?>
          <timeslip>
              <dated-on>#{Time.now.strftime("%Y-%m-%dT%H:%M:%SZ")}</dated-on>
              <project-id type="integer">#{@project_combo.active_iter[1]}</project-id>
              <task-id>#{@task_combo.active_iter[1]}</task-id>
              <user-id>1</user-id>
              <comment>#{@comment_entry.text}</comment>
              <hours>#{@timer.elapsed[0]}</hours>
          </timeslip>
      EOF
      res = @costagent.client("timeslips").post(xml, :content_type => :xml)
    end
  
        
end