require 'gtk2'
require 'main_form'

icon = Gtk::StatusIcon.new
icon.file = "clock.png"
icon.tooltip = "Free Timer"
@main_form = MainForm.new
icon.signal_connect('activate') { @main_form.show }

start = Gtk::MenuItem.new("Start")
quit = Gtk::ImageMenuItem.new(Gtk::Stock::QUIT)
quit.signal_connect('activate') { Gtk.main_quit }
menu = Gtk::Menu.new
menu.append(start)
menu.append(Gtk::SeparatorMenuItem.new)
menu.append(quit)
menu.show_all
# Show menu on right click
icon.signal_connect('popup-menu') { |tray, button, time| menu.popup(nil, nil, button, time) }

Gtk.main