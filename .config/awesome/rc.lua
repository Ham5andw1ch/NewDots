-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
    title = "Oops, there were errors during startup!",
    text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
        title = "Oops, an error happened!",
        text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
--beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
beautiful.init(gears.filesystem.get_configuration_dir() .. "mytheme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "alacritty"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    --awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    --awful.layout.suit.fair,
    --awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    --awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    --awful.layout.suit.magnifier,
    --awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
    { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
    { "manual", terminal .. " -e man awesome" },
    { "edit config", editor_cmd .. " " .. awesome.conffile },
    { "restart", awesome.restart },
    { "quit", function() awesome.quit() end },
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
{ "open terminal", terminal }
                                  }
                              })
                              mylauncher = wibox.widget {
                                  awful.widget.launcher({ image = "/home/donov/.config/awesome/2x/arch.png", top = 4,
                                  command = "AdvancedRofi.sh" }),
                                  left = 2,
                                  top = 2,
                                  bottom = 2,
                                  right = 2,
                                  widget = wibox.container.margin,
                              }
                             -- myNotif = wibox.widget {
                             --     awful.widget.launcher({ image = "/home/donov/.config/awesome/2x/menu.png", top = 4,
                             --     command = "ShowNotifications.sh" }),
                             --     left = 2,
                             --     top = 2,
                             --     bottom = 2,
                             --     right = 2,
                             --     widget = wibox.container.margin,
                             -- }

                              -- Menubar configuration
                              menubar.utils.terminal = terminal -- Set the terminal for applications that require it
                              -- }}}

                              -- Keyboard map indicator and switcher
                              mykeyboardlayout = awful.widget.keyboardlayout()

                              -- {{{ Wibar
                              -- Create a textclock widget
                              mytextclock = wibox.widget.textclock()

                              -- Create a wibox for each screen and add it
                              local taglist_buttons = gears.table.join(
                              awful.button({ }, 1, function(t) t:view_only() end),
                              awful.button({ modkey }, 1, function(t)
                                  if client.focus then
                                      client.focus:move_to_tag(t)
                                  end
                              end),
                              awful.button({ }, 3, awful.tag.viewtoggle),
                              awful.button({ modkey }, 3, function(t)
                                  if client.focus then
                                      client.focus:toggle_tag(t)
                                  end
                              end)
                              --awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                              --awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                              )

                              local tasklist_buttons = gears.table.join(
                              awful.button({ }, 1, function (c)
                                  if c == client.focus then
                                      c.minimized = true
                                  else
                                      c:emit_signal(
                                      "request::activate",
                                      "tasklist",
                                      {raise = true}
                                      )
                                  end
                              end),
                              awful.button({ }, 3, function()
                                  awful.menu.client_list({ theme = { width = 250 } })
                              end),
                              awful.button({ }, 4, function ()
                                  awful.client.focus.byidx(1)
                              end),
                              awful.button({ }, 5, function ()
                                  awful.client.focus.byidx(-1)
                              end))

                              local function set_wallpaper(s)
                                  -- Wallpaper
                                  if beautiful.wallpaper then
                                      local wallpaper = beautiful.wallpaper
                                      -- If wallpaper is a function, call it with the screen
                                      if type(wallpaper) == "function" then
                                          wallpaper = wallpaper(s)
                                      end
                                      gears.wallpaper.maximized(wallpaper, s, true)
                                  end
                              end

                              -- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
                              screen.connect_signal("property::geometry", set_wallpaper)
                              awful.screen.connect_for_each_screen(function(s)

                                  -- Each screen has its own tag table.
                                  awful.tag({ " 一 ", " 二 ", " 三 ", " 四 ", " 五 ", " 六 ", "7"}, s, awful.layout.layouts[1])

                                  -- Create a promptbox for each screen
                                  s.mypromptbox = awful.widget.prompt()
                                  -- Create an imagebox widget which will contain an icon indicating which layout we're using.
                                  -- We need one layoutbox per screen.
                                  s.mylayoutbox = wibox.widget{
                                      awful.widget.layoutbox(s),
                                      left = 2,
                                      top = 2,
                                      bottom = 2,
                                      right = 2,
                                      widget = wibox.container.margin,
                                  }
                                  s.mylayoutbox:buttons(gears.table.join(
                                  awful.button({ }, 1, function () awful.layout.inc( 1) end),
                                  awful.button({ }, 3, function () awful.layout.inc(-1) end),
                                  awful.button({ }, 4, function () awful.layout.inc( 1) end),
                                  awful.button({ }, 5, function () awful.layout.inc(-1) end)))
                                  -- Create a taglist widget
                                  function noscratch(t)
                                      if t.name == "7" then
                                          return false
                                      else
                                          return true
                                      end
                                  end
                                  s.mytaglist = awful.widget.taglist {
                                      screen  = s,
                                      filter  = noscratch,
                                      --layout = {
                                      --        spacing = 5,
                                      --        layout = wibox.layout.fixed.horizontal
                                      --    },
                                      buttons = taglist_buttons,
                                      --widget_template = {
                                      --    {
                                      --        forced_width = 15,
                                      --        id     = 'text_role',
                                      --        widget = wibox.widget.textbox,
                                      --    },
                                      --    layout = wibox.layout.fixed.horizontal,
                                      --}
                                  }



                                  -- Create a tasklist widget
                                  s.mytasklist = awful.widget.tasklist {
                                      screen   = s,
                                      filter   = awful.widget.tasklist.filter.currenttags,
                                      buttons  = tasklist_buttons,
                                      style    = {
                                          shape_border_width = 5,
                                          shape_border_color = '#777777',
                                      },
                                      layout   = {
                                          spacing = 0,
                                          max_widget_size = 150,
                                          layout  = wibox.layout.flex.horizontal
                                      },
                                      -- Notice that there is *NO* wibox.wibox prefix, it is a template,
                                      -- not a widget instance.
                                      widget_template = {
                                          {
                                              {
                                                  {
                                                      {
                                                          {
                                                              {
                                                                  id     = 'icon_role',
                                                                  widget = wibox.widget.imagebox,

                                                              },
                                                              left = 4,
                                                              right = 4,
                                                              top = 4,
                                                              bottom = 4,
                                                              widget  = wibox.container.margin,
                                                          },
                                                          {
                                                              id = 'text_role',
                                                              widget = wibox.widget.textbox,
                                                          },
                                                          forced_height = beautiful.barHeight -2,
                                                          layout = wibox.layout.fixed.horizontal,
                                                      },
                                                      right = 2,
                                                      widget  = wibox.container.margin,

                                                  },
                                                  {
                                                      max_value = 1,
                                                      value = 1,
                                                      border_width = 0,
                                                      color = beautiful.underline_color,
                                                      forced_height = 1,
                                                      widget = wibox.widget.progressbar,

                                                  },
                                                  layout = wibox.layout.align.vertical,
                                              },
                                              id            = 'background_role',
                                              widget        = wibox.container.background,
                                          },
                                          left = 2,
                                          right = 2,
                                          widget = wibox.container.margin,

                                      },
                                  }
                                  s.mydock = awful.widget.tasklist {
                                      screen   = s,
                                      filter   = awful.widget.tasklist.filter.currenttags,
                                      buttons  = tasklist_buttons,
                                      style    = {
                                          shape_border_width = 5,
                                          shape_border_color = '#777777',
                                      },
                                      layout   = {
                                          spacing = 0,
                                          max_widget_size = 32,
                                          layout  = wibox.layout.flex.vertical
                                      },
                                      -- Notice that there is *NO* wibox.wibox prefix, it is a template,
                                      -- not a widget instance.
                                      widget_template = {
                                          {
                                              {
                                                  {
                                                      max_value = 1,
                                                      value = 1,
                                                      border_width = 0,
                                                      color = beautiful.underline_color,
                                                      forced_width = 3,
                                                      widget = wibox.widget.progressbar,

                                                  },
                                                  {
                                                      {
                                                          {
                                                              id     = 'icon_role',
                                                              widget = wibox.widget.imagebox,

                                                          },
                                                          margins = 2,
                                                          widget  = wibox.container.margin,
                                                      },
                                                      forced_width = 26,
                                                      layout = wibox.layout.fixed.vertical,

                                                  },
                                                  layout = wibox.layout.align.horizontal,
                                              },
                                              id            = 'background_role',
                                              widget        = wibox.container.background,
                                          },
                                          top = 2,
                                          bottom = 2,
                                          widget = wibox.container.margin,

                                      },
                                  }

                                  s.mySeparate = wibox.widget.separator {
                                      orientation = "horizontal",
                                      span_ratio = 0

                                  }
                                  s.separate = wibox.widget{
                                      markup = ' | ',
                                      align  = 'right',
                                      valign = 'center',
                                      widget = wibox.widget.textbox
                                  }
                                  mytext = wibox.widget{
                                      markup = '',
                                      align  = 'right',
                                      valign = 'center',
                                      widget = wibox.widget.textbox
                                  }
                                  s.space = wibox.widget{
                                      markup = ' ',
                                      align  = 'right',
                                      valign = 'center',
                                      widget = wibox.widget.textbox
                                  }
                                  s.tspace = wibox.widget{
                                      markup = '   ',
                                      align  = 'right',
                                      valign = 'center',
                                      widget = wibox.widget.textbox
                                  }

                                  s.my_systray = wibox.widget {
                                      wibox.widget.systray(),
                                      left   = 2,
                                      top    = 2,
                                      bottom = 2,
                                      right  = 2,
                                      widget = wibox.container.margin,
                                  }
                                  s.my_layoutbox = wibox.widget {
                                      wibox.widget.systray(),
                                      left   = 2,
                                      top    = 2,
                                      bottom = 2,
                                      right  = 2,
                                      widget = wibox.container.margin,
                                  }

                                  local cbuttons = gears.table.join(
                                  awful.button({ }, 1, function()
                                      local screen1 = awful.screen.focused()

                                      screen1.closing = true
                                      local num = #screen1.clients
                                      for i,item in pairs(screen1.clients) do
                                          if item.class == "Xfdesktop" then
                                              num = num -1
                                          end
                                      end
                                      if num > 0 then
                                          for k,c in pairs(screen1.clients) do
                                              if c.class ~= "Xfdesktop" then
                                                  c.minimized = true
                                              end
                                          end
                                      else
                                         -- awful.spawn("notify-send ".. #screen1.client_memory)
                                          if #screen1.client_memory ~= 0 then
                                              for k,c in pairs(screen1.client_memory) do
                                                    c.minimized = false
                                              end
                                          end
                                      end
                                      screen1.closing = false

                                  end)
                                  )


                                  s.my_button = wibox.widget {
                                          max_value        = 1,
                                          value            = 0,
                                          opacity = 0,
                                          border_width = 0,
                                          color = beautiful.bg_focus,
                                          widget = wibox.widget.progressbar
                          }

                                s.my_bar = wibox.widget {
                                  s.my_button,
                                  buttons = cbuttons,
                                  forced_width     = 7,
                                  layout           = wibox.layout.fixed.horizontal
                              }

                              s.my_button:connect_signal("mouse::enter",function(b)
                                  b.value = 1
                                  b.opacity = 1


                              end)

                              s.my_button:connect_signal("mouse::leave",function(b)
                                  b.value = 0
                                  b.opacity = 0
                              end)
                              s.mywibox= awful.wibar({type ="dock", ontop = true, screen = s,height = 24,position = "bottom"})


                              -- Add widgets to the wibox
                              s.mywibox:setup {
                                  layout = wibox.layout.align.horizontal,
                                  { -- Left widgets
                                  s.mywibox= awful.wibar({type ="dock", ontop = true, screen = s,height = beautiful.barHeight,position = "bottom"})


                                  -- Add widgets to the wibox
                                  s.mywibox:setup {
                                      layout = wibox.layout.align.horizontal,
                                      { -- Left widgets
                                      layout = wibox.layout.fixed.horizontal,
                                      s.space,
                                      mylauncher,
                                      s.space,
                                      s.mypromptbox,
                                  },
                                  s.mytasklist,
                                  { -- Right widgets
                                  layout = wibox.layout.fixed.horizontal,
                                  s.space,
                                  mylauncher,
                                  s.space,
                                  s.mypromptbox,
                              },
                              s.mytasklist,
                              { -- Right widgets
                              layout = wibox.layout.fixed.horizontal,
                              s.space,
                              s.mytaglist,
                              s.space,
                              mytextclock,
                              s.space,
                              s.my_systray,
                             -- myNotif,
                              s.space,
                              s.mylayoutbox,
                              s.my_bar

                          },
                      }
                  end)
                  -- }}}

                  -- {{{ Mouse bindings
                  --root.buttons(gears.table.join(
                  --//awful.button({ }, 4, awful.tag.viewnext),
                  --awful.button({ }, 5, awful.tag.viewprev)
                  --))
                  -- }}}

                  -- {{{ Key bindings
                  globalkeys = gears.table.join(
                  awful.key({ modkey,   "Shift"}, "s", function () awful.spawn("xrandr --output DP-0 --pos 0x0 --mode 1920x1080 --rate 144 --primary --output HDMI-0 --off") end,
                  {description="show help", group="awesome"}),
                  awful.key({ modkey,           }, "s", function() awful.spawn("xrandr --output DP-0 --pos 0x0 --mode 1920x1080 --rate 144 --primary --output HDMI-0 --pos 1920x0 --mode 1920x1080") end,
                  {description="show help", group="awesome"}),
                  awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
                  {description = "view previous", group = "tag"}),
                  awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
                  {description = "view next", group = "tag"}),
                  awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
                  {description = "go back", group = "tag"}),

                  awful.key({ modkey,           }, "j",
                  function ()
                      awful.client.focus.byidx( 1)
                  end,
                  {description = "focus next by index", group = "client"}
                  ),
                  awful.key({ modkey,           }, "k",
                  function ()
                      awful.client.focus.byidx(-1)
                  end,
                  {description = "focus previous by index", group = "client"}
                  ),
                  --awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
                  --{description = "show main menu", group = "awesome"}),

                  -- Layout manipulation
                  awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
                  {description = "swap with next client by index", group = "client"}),
                  awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
                  {description = "swap with previous client by index", group = "client"}),
                  awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
                  {description = "focus the next screen", group = "screen"}),
                  awful.key({ modkey, }, ".", function () awful.screen.focus_relative( 1) end,
                  {description = "focus the next screen", group = "screen"}),
                  awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
                  {description = "focus the previous screen", group = "screen"}),
                  awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
                  {description = "jump to urgent client", group = "client"}),

                  awful.key({ "Mod1",           }, "Tab",
                  function () awful.spawn("rofi -show window -theme material_center.rasi")
                  end,
                  {description = "view all open clients", group = "client"}),

                  awful.key({ modkey,           }, "Tab",
                  function ()
                      -- awful.client.focus.history.previous()
                      awful.client.focus.byidx(-1)
                      if client.focus then
                          client.focus:raise()
                      end
                  end,
                  {description = "go back", group = "client"}),

                  awful.key({ modkey, "Shift"   }, "Tab",
                  function ()
                      -- awful.client.focus.history.previous()
                      awful.client.focus.byidx(1)
                      if client.focus then
                          client.focus:raise()
                      end
                  end,
                  {description = "go forward", group = "client"}),

                  -- Standard program
                  awful.key({ modkey,"Shift" }, "Return", function () awful.spawn(terminal) end,
                  {description = "open a terminal", group = "launcher"}),
                  awful.key({ modkey, "Control" }, "r", awesome.restart,
                  {description = "reload awesome", group = "awesome"}),
                  awful.key({ modkey, "Shift"   }, "q", function() awful.spawn("powerDMenuTheme.sh") end,
                  {description = "quit awesome", group = "awesome"}),
                  awful.key({}, "Print", function () awful.spawn("superShot 3") end,
                  {description = "open a terminal", group = "launcher"}),
                  awful.key({"Shift"}, "Print", function () awful.spawn("superShot 4") end,
                  {description = "open a terminal", group = "launcher"}),
                  awful.key({modkey,}, "Print", function () awful.spawn("superShot 1") end,
                  {description = "open a terminal", group = "launcher"}),
                  awful.key({modkey,"Shift"}, "Print", function () awful.spawn("superShot 2") end,
                  {description = "open a terminal", group = "launcher"}),

                  awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
                  {description = "increase master width factor", group = "layout"}),
                  awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
                  {description = "decrease master width factor", group = "layout"}),
                  awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
                  {description = "increase the number of master clients", group = "layout"}),
                  awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
                  {description = "decrease the number of master clients", group = "layout"}),
                  awful.key({ modkey, }, "i",     function () awful.tag.incnmaster( 1, nil, true) end,
                  {description = "increase the number of master clients", group = "layout"}),
                  awful.key({ modkey, }, "d",     function () awful.tag.incnmaster(-1, nil, true) end,
                  {description = "decrease the number of master clients", group = "layout"}),
                  awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
                  {description = "increase the number of columns", group = "layout"}),
                  awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
                  {description = "decrease the number of columns", group = "layout"}),
                  awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
                  {description = "select previous", group = "layout"}),
                  awful.key({ modkey, }, "space", function () awful.layout.inc(1)                end,
                  {description = "select previous", group = "layout"}),

                  awful.key({ modkey, "Control" }, "n",
                  function ()
                      local c = awful.client.restore()
                      -- Focus restored client
                      if c then
                          c:emit_signal(
                          "request::activate", "key.unminimize", {raise = true}
                          )
                      end
                  end,
                  {description = "restore minimized", group = "client"}),

                  -- Prompt
                  awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
                  {description = "run prompt", group = "launcher"}),

                  awful.key({ modkey }, "x",
                  function ()
                      awful.prompt.run {
                          prompt       = "Run Lua code: ",
                          textbox      = awful.screen.focused().mypromptbox.widget,
                          exe_callback = awful.util.eval,
                          history_path = awful.util.get_cache_dir() .. "/history_eval"
                      }
                  end,
                  {description = "lua execute prompt", group = "awesome"}),
                  -- Menubar
                  awful.key({ modkey }, "p", function () awful.spawn("rofi -show run -theme material") end,
                  {description = "show the menubar", group = "launcher"}),

                  awful.key({ modkey, "Shift" }, "p", function ()   awful.spawn("rofi -show drun -icon-theme Papirus-Dark -theme material") end,
                  {description = "show the menubar", group = "launcher"}),


                  awful.key({ modkey }, "t", function () awful.spawn("compton -Fbc -I .1 -O .1 --backend xrender ") awful.spawn("notify-send \"Compton Enabled\"") end,
                  {description = "show the menubar", group = "launcher"}),
                  awful.key({ modkey,"Shift" }, "t", function () awful.spawn("killall compton") awful.spawn("notify-send \"Compton Disabled\"")end,
                  {description = "show the menubar", group = "launcher"}),

                  awful.key({}, "XF86AudioRaiseVolume", function () awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%")  awful.spawn("play /home/donov/.config/awesome/sound/Pop.wav") end,
                  {description = "show the menubar", group = "launcher"}),
                  awful.key({}, "XF86AudioLowerVolume", function () awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%") awful.spawn("play /home/donov/.config/awesome/sound/Pop.wav")end,
                  {description = "show the menubar", group = "launcher"}),
                  awful.key({}, "XF86AudioMute", function () awful.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle") awful.spawn("play /home/donov/.config/awesome/sound/Pop.wav")end,
                  {description = "show the menubar", group = "launcher"})
                  )

                  clientkeys = gears.table.join(
                  awful.key({ modkey,           }, "f",
                  function (c)
                      c.fullscreen = not c.fullscreen
                      c:raise()
                  end,
                  {description = "toggle fullscreen", group = "client"}),
                  awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
                  {description = "close", group = "client"}),
                  awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
                  {description = "toggle floating", group = "client"}),
                  awful.key({ modkey,        }, "Return", function (c) c:swap(awful.client.getmaster()) end,
                  {description = "move to master", group = "client"}),
                  awful.key({ modkey, "Shift"}, ".",      function (c) c:move_to_screen()               end,
                  {description = "move to screen", group = "client"}),
                  --awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
                  --{description = "toggle keep on top", group = "client"}),
                  awful.key({ modkey,           }, "n",
                  function (c)
                      -- The client currently has the input focus, so it cannot be
                      -- minimized, since minimized clients can't have the focus.
                      c.minimized = true
                  end ,
                  {description = "minimize", group = "client"}),
                  awful.key({ modkey,           }, "m",
                  function (c)
                      c.maximized = not c.maximized
                      c:raise()
                  end ,
                  {description = "(un)maximize", group = "client"}),
                  awful.key({ modkey, "Control" }, "m",
                  function (c)
                      c.maximized_vertical = not c.maximized_vertical
                      c:raise()
                  end ,
                  {description = "(un)maximize vertically", group = "client"}),
                  awful.key({ modkey, "Shift"   }, "m",
                  function (c)
                      c.maximized_horizontal = not c.maximized_horizontal
                      c:raise()
                  end ,
                  {description = "(un)maximize horizontally", group = "client"})
                  )

                  -- Bind all key numbers to tags.
                  -- Be careful: we use keycodes to make it work on any keyboard layout.
                  -- This should map on the top row of your keyboard, usually 1 to 9.
                  for i = 1, 9 do
                      globalkeys = gears.table.join(globalkeys,
                      -- View tag only.
                      awful.key({ modkey }, "#" .. i + 9,
                      function ()
                          local screen = awful.screen.focused()
                          local tag = screen.tags[i]
                          if tag and tag.name ~= "7"then
                              tag:view_only()
                          end
                      end,
                      {description = "view tag #"..i, group = "tag"}),
                      -- Toggle tag display.
                      awful.key({ modkey, "Control" }, "#" .. i + 9,
                      function ()
                          local screen = awful.screen.focused()
                          local tag = screen.tags[i]
                          if tag and tag.name ~= "7" then
                              awful.tag.viewtoggle(tag)
                          end
                      end,
                      {description = "toggle tag #" .. i, group = "tag"}),
                      -- Move client to tag.
                      awful.key({ modkey, "Shift" }, "#" .. i + 9,
                      function ()
                          if client.focus then
                              local tag = client.focus.screen.tags[i]
                              if tag and tag.name ~= "7" then
                                  client.focus:move_to_tag(tag)
                              end
                          end
                      end,
                      {description = "move focused client to tag #"..i, group = "tag"}),
                      -- Toggle tag on focused client.
                      awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                      function ()
                          if client.focus then
                              local tag = client.focus.screen.tags[i]
                              if tag and tag.name ~= "7" then
                                  client.focus:toggle_tag(tag)
                              end
                          end
                      end,
                      {description = "toggle focused client on tag #" .. i, group = "tag"})
                      )
                  end

                  clientbuttons = gears.table.join(
                  awful.button({ }, 1, function (c)
                      c:emit_signal("request::activate", "mouse_click", {raise = true})
                  end),
                  awful.button({ modkey }, 1, function (c)
                      c:emit_signal("request::activate", "mouse_click", {raise = true})
                      awful.mouse.client.move(c)
                  end),
                  awful.button({ modkey }, 3, function (c)
                      c:emit_signal("request::activate", "mouse_click", {raise = true})
                      awful.mouse.client.resize(c)
                  end)
                  )

                  -- Set keys
                  root.keys(globalkeys)
                  -- }}}

                  -- {{{ Rules
                  -- Rules to apply to new clients (through the "manage" signal).
                  awful.rules.rules = {
                      -- All clients will match this rule.
                      { rule = { },
                      properties = { border_width = beautiful.border_width,
                      border_color = beautiful.border_normal,
                      focus = awful.client.focus.filter,
                      raise = true,
                      keys = clientkeys,
                      buttons = clientbuttons,
                      screen = awful.screen.preferred,
                      placement = awful.placement.no_overlap+awful.placement.no_offscreen
                  }
              },
              -- Floating clients.
              { rule_any = {
                  instance = {
                      "DTA",  -- Firefox addon DownThemAll.
                      "copyq",  -- Includes session name in class.
                      "pinentry",
                  },
                  class = {
                      "Arandr",
                      "Blueman-manager",
                      "Gpick",
                      "Kruler",
                      "MessageWin",  -- kalarm.
                      "Sxiv",
                      "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
                      "Wpa_gui",
                      "veromix",
                      "xtightvncviewer"},

                      -- Note that the name property shown in xprop might be set slightly after creation of the client
                      -- and the name shown there might not match defined rules here.
                      name = {
                          "Event Tester",  -- xev.
                      },
                      role = {
                          "AlarmWindow",  -- Thunderbird's calendar.
                          "ConfigManager",  -- Thunderbird's about:config.
                          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
                      }
                  }, properties = { floating = true }},

                  -- Add titlebars to normal clients and dialogs
                  { rule_any = {type = { "normal", "dialog" }
              }, properties = { titlebars_enabled = true }
          },
          { rule = { class = "Xfdesktop" },
          properties = { sticky = true, border_width = 0, screen = 1, tag = "7",} },

          { rule = { class = "Plank" },
          properties = {
              titlebars_enabled = false,
              border_width = 0,
              floating = true,
              sticky = true,
              ontop = true,
              focusable = false,
              below = true
          }
      },

      -- Set Firefox to always map on the tag named "2" on screen 1.
      -- { rule = { class = "Firefox" },
      --   properties = { screen = 1, tag = "2" } },
  }
  -- }}}

  -- {{{ Signals
  -- Signal function to execute when a new client appears.
  client.connect_signal("manage", function (c)
      -- Set the windows at the slave,
      -- i.e. put it at the end of others instead of setting it master.
      if not awesome.startup then awful.client.setslave(c) end
      if awesome.startup
          and not c.size_hints.user_position
          and not c.size_hints.program_position then
          -- Prevent clients from being unreachable after screen count changes.
          awful.placement.no_offscreen(c)
      end
  end)

  -- Add a titlebar if titlebars_enabled is set to true in the rules.
  --          client.connect_signal("request::titlebars", function(c)
  --              -- buttons for the titlebar
  --              local buttons = gears.table.join(
  --              awful.button({ }, 1, function()
  --                  c:emit_signal("request::activate", "titlebar", {raise = true})
  --                  awful.mouse.client.move(c)
  --              end),
  --              awful.button({ }, 3, function()
  --                  c:emit_signal("request::activate", "titlebar", {raise = true})
  --                  awful.mouse.client.resize(c)
  --              end)
  --              )
  --                  align  = 'right',
  --                  valign = 'center',
  --                  widget = wibox.widget.textbox
  --              }
  --
  --              awful.titlebar(c) : setup {
  --                  { -- Left
  --                  awful.titlebar.widget.iconwidget(c),
  --                  c.space,
  --                  layout  = wibox.layout.fixed.horizontal
  --              },
  --        { -- Middle
  --              { -- Title
  --              align  = "center",
  --
  --              widget = awful.titlebar.widget.titlewidget(c)
  --          },
  --          buttons = buttons,
  --          layout  = wibox.layout.flex.horizontal
  --      },
  --    { -- Right
  --      awful.titlebar.widget.minimizebutton(c),
  --      awful.titlebar.widget.maximizedbutton(c),
  --      awful.titlebar.widget.closebutton    (c),
  --      layout = wibox.layout.fixed.horizontal()
  --    },
  --    layout = wibox.layout.align.horizontal
  --    }
  --end)


  client.connect_signal("request::titlebars", function(c)
      -- buttons for the titlebar
      local buttons = gears.table.join(
      awful.button({ }, 1, function()
          c:emit_signal("request::activate", "titlebar", {raise = true})
          if c.maximized then
              oldWidth = c.width
              oldHeight = c.height
              c.maximized = false;
              c.x = c.screen.geometry.x
              c.y = c.screen.geometry.y
              c.width = oldWidth
              c.height = oldHeight
          end
          awful.mouse.client.move(c)
      end),
      awful.button({ }, 3, function()
          c:emit_signal("request::activate", "titlebar", {raise = true})
          if c.maximized then
              oldWidth = c.width
              oldHeight = c.height
              c.maximized = false;
              c.x = c.screen.geometry.x
              c.y = c.screen.geometry.y
              c.width = oldWidth
              c.height = oldHeight
          end
          awful.mouse.client.resize(c)
      end)
      )
      c.space = wibox.widget{
          markup = '  ',
          align  = 'right',
          valign = 'center',
          widget = wibox.widget.textbox
      }

      awful.titlebar(c, {size = 20}) : setup {
          { -- Left
          {
              awful.titlebar.widget.iconwidget(c),
              buttons = buttons,
              layout  = wibox.layout.fixed.horizontal
          },
          margins = 1,
          widget = wibox.container.margin,
      },
      { -- Middle
      { -- Title
      align  = 'center',
      widget = awful.titlebar.widget.titlewidget(c)
  },
  buttons = buttons,
  layout  = wibox.layout.flex.horizontal
  },
  { -- Right
  {
      buttons = buttons,
      layout = wibox.layout.flex.horizontal
  },
  {
      buttons = buttons,
      layout = wibox.layout.flex.horizontal
  },

      {
          {
        awful.titlebar.widget.minimizebutton(c),
            margins = 0,
            widget = wibox.container.margin,
        },
          {
        awful.titlebar.widget.maximizedbutton(c),
            margins = 0,
            widget = wibox.container.margin,
        },
          {
        awful.titlebar.widget.closebutton    (c),
            margins = 0,
            widget = wibox.container.margin,
        },
      layout = wibox.layout.fixed.horizontal
  },
  layout = wibox.layout.align.horizontal
                  },
                  layout = wibox.layout.flex.horizontal
              }
          end)


          -- Enable sloppy focus, so that focus follows mouse.
          client.connect_signal("mouse::enter", function(c)
              c:emit_signal("request::activate", "mouse_enter", {raise = false})
          end)
          bannedList = {"plank","dockx","komorebi","xfdesktop"}

          client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
          client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
          -- }}}
          -- Hide bars when app go fullscreen
          local b = true

          function updateBarsVisibility()
              for s in screen do
                  if s.selected_tag then

                      --            awful.spawn("notify-send " .. s.selected_tag.layout.name)
                      s.mywibox.visible = not s.selected_tag.fullscreenMode
                  end
              end
          end

          _G.tag.connect_signal(
          'property::selected',
          function(t)
              if #t.screen.clients == 0 then
                  t.fullscreenMode = false
              end
              updateBarsVisibility()
          end
          )

          --tag.connect_signal("property::layout", function(t)
          --      local full = false
          --      for k,c in pairs(t:clients()) do
          --           if(c.focus and c.fullscreen) then
          --               full = true
          --           end
          --      end
          --      t.fullscreenMode = t.layout.name == "fullscreen" and full
          --      updateBarsVisibility()
          --  end)


          _G.client.connect_signal(
          'property::minimized',
          function(c)
              if #c.screen.clients == 0 then
                  c.first_tag.fullscreenMode = false
              end
              updateBarsVisibility()
          end
          )
          function isException(title)
              -- awful.spawn("notify-send " .. title)
              for i,item in pairs(bannedList) do
                  if item == title then
                      return true
                  end
              end
              return false

          end
          _G.client.connect_signal(
          'property::fullscreen',
          function(c)
              b = c.fullscreen
              if c.first_tag ~= nil then
                  c.first_tag.fullscreenMode = c.fullscreen or c.screen.selected_tag.layout.name == "fullscreen"
              end
              updateBarsVisibility()
          end
          )

          _G.client.connect_signal(
          'focus',
          function(c)
              if c.instance ~= nil then
                  local icon = menubar.utils.lookup_icon(c.instance)
                  local lower_icon = menubar.utils.lookup_icon(c.instance:lower())
                  if icon ~= nil then
                      local new_icon =gears.surface(icon) 
                      c.icon = new_icon._native
                  elseif lower_icon ~= nil then 
                      local new_icon = gears.surface(lower_icon)
                      c.icon = new_icon._native
                  elseif c.icon == nil then
                      local new_icon = gears.surface(menubar.utils.lookup_icon("application-default-icon"))
                      c.icon = new_icon._native
                  end
              else
                  local new_icon = gears.surface(menubar.utils.lookup_icon("application-default-icon"))
                  c.icon = new_icon._native

              end
              --awful.spawn("notify-send ha")
              b = c.fullscreen
              c.first_tag.fullscreenMode = c.fullscreen or c.screen.selected_tag.layout.name == "fullscreen"
              updateBarsVisibility()
          end
          )

          _G.client.connect_signal(
          'unmanage',
          function(c)
              if c.fullscreen then
                  c.screen.selected_tag.fullscreenMode = not c.fullscreen
                  updateBarsVisibility()
              end
          end
          )
          client.connect_signal("property::floating", function(c)
              local b = false
              if c.first_tag ~= nil then
                  b = c.first_tag.layout.name == "floating"
              end
              if not isException(c.instance) then
                  test = isException(c.instance)
                  -- awful.spawn("notify-send " .. string.format("%s",test))
                  if c.floating or b then
                      awful.titlebar.show(c)
                  else
                      awful.titlebar.hide(c)
                  end
              else
                  awful.titlebar.hide(c)
              end
          end)
          screen.connect_signal("property::geometry", function(s)
              awful.spawn("/home/donov/.config/wpg/wp_init.sh")
          end)

          tag.connect_signal("property::layout", function(t)
              local clients = t:clients()
              for k,c in pairs(clients) do
                  if not isException(c.instance) then
                      test = isException(c.instance)
                      --awful.spawn("notify-send " .. string.format("%s",test))
                      if c.floating or c.first_tag.layout.name == "floating" then
                          awful.titlebar.show(c)
                      else
                          awful.titlebar.hide(c)
                      end
                  else
                      awful.titlebar.hide(c)
                  end
              end
          end)
          tag.connect_signal("tagged", function(t)
              local clients = t:clients()
              for k,c in pairs(clients) do
                  if not isException(c.instance) then
                      test = isException(c.instance)
                      --awful.spawn("notify-send " .. string.format("%s",test))
                      if c.floating or c.first_tag.layout.name == "floating" then
                          awful.titlebar.show(c)
                      else
                          awful.titlebar.hide(c)
                      end
                  else
                      awful.titlebar.hide(c)
                  end
              end
          end)
          screen.connect_signal("tag::history::update", function(s)
              local clients = s.selected_tag:clients()
              for k,c in pairs(clients) do
                  if not isException(c.instance) then
                      test = isException(c.instance)
                      --awful.spawn("notify-send " .. string.format("%s",test))
                      if c.floating or c.first_tag.layout.name == "floating" then
                          awful.titlebar.show(c)
                      else
                          awful.titlebar.hide(c)
                      end
                  else
                      awful.titlebar.hide(c)
                  end
              end
          end)

          --
          -- Show Desktop Code
          --
          function table.shallow_copy(t)
              local t2 = {}
              for k,v in pairs(t) do
                  t2[k] = v
              end
              return t2
          end
          function table.shallow_copy_except(t,d)
              local t2 = {}
              for k,v in pairs(t) do
                  if v.name ~= d.name then
                    t2[k] = v
                else
                   -- awful.spawn("notify-send hi")
                end
              end
              return t2
          end


          screen.connect_signal("tag::history::update", function(s)
              if s.closing ~= true then
                  if s.clients ~= nil then
                      if s.lul == nil then
                          s.lul = false
                      end
                      s.lul = not s.lul
                      local tags = s.clients
                      local num = #s.clients
                      for k,d in pairs(tags) do
                          if d.class == "Xfdesktop" then
                              num = num -1
                          end
                      end
                      s.client_memory = table.shallow_copy(s.clients)
                  end
              end
          end)

          function clientStuff(c)
              if awful.screen.focused().closing ~= true then
                  local tags = awful.screen.focused().clients
                  local num = #awful.screen.focused().clients
                  for k,d in pairs(tags) do
                      if d.class == "Xfdesktop" then
                          num = num -1
                      end
                  end
--                  awful.spawn("notify-send "..num)
                  awful.screen.focused().client_memory = table.shallow_copy(c.screen.clients)
              end
          end
          function clientCloseStuff(c)
              if c.screen.closing ~= true then
                  local tags = c.screen.clients
                  local num = #c.screen.clients
                  for k,d in pairs(tags) do
                      if d.class == "Xfdesktop" or d == c then
                          num = num -1
                      end
                  end
                  if num > 0 then
                      c.screen.client_memory = table.shallow_copy(c.screen.clients)
                      for k,d in pairs(c.screen.client_memory) do
                          --awful.spawn("notify-send " .. d.class)
                          if d == c then
                              c.screen.client_memory[k] = nil
                          end
                      end
                  end
              end
          end
          client.connect_signal("property::minimized", function(c)
              clientStuff(c)
          end)
          client.connect_signal("unmanage", function(c)
              clientStuff(c)
          end)
          client.connect_signal("manage", function(c)
              clientStuff(c)
          end)


          --
          -- Icon Code
          --

          client.connect_signal("manage", function(c)
              c.size_hints_honor = false
              if c.instance ~= nil then
                  local icon = menubar.utils.lookup_icon(c.instance)
                  local lower_icon = menubar.utils.lookup_icon(c.instance:lower())
                  if icon ~= nil then
                      local new_icon =gears.surface(icon) 
                      c.icon = new_icon._native
                  elseif lower_icon ~= nil then 
                      local new_icon = gears.surface(lower_icon)
                      c.icon = new_icon._native
                  elseif c.icon == nil then
                      local new_icon = gears.surface(menubar.utils.lookup_icon("application-default-icon"))
                      c.icon = new_icon._native
                  end
              else
                  local new_icon = gears.surface(menubar.utils.lookup_icon("application-default-icon"))
                  c.icon = new_icon._native

              end
              if not isException(c.instance) then
                  test = isException(c.instance)
                  --awful.spawn("notify-send " .. string.format("%s",test))
                  if c.floating or c.first_tag.layout.name == "floating" then
                      awful.titlebar.show(c)
                  else
                      awful.titlebar.hide(c)
                  end
              else
                  awful.titlebar.hide(c)
              end
          end)
          client.connect_signal("manage", function (c, startup)
    -- Enable round corners with the shape api
    c.shape = function(cr,w,h)
        gears.shape.rounded_rect(cr,w,h,6)
    end
end)
