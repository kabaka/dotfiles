-- This is terribly messy and may be full of deprecated crap. Sorry. I don't
-- really like having to mess with it often, as it "just works" and I
-- reloading or restarting the WM is kind of a pain.


-- Libraries

awful       = require("awful")
require("awful.autofocus")
awful.rules = require("awful.rules")
beautiful   = require("beautiful")
naughty     = require("naughty")
vicious     = require("vicious")
wibox       = require("wibox")


-- Various Configuration Shit

modkey      = "Mod4"
terminal    = "xfce4-terminal"
editor      = os.getenv("EDITOR") or "vim"
editor_cmd  = terminal .. " -e " .. editor


-- Themes define colours, icons, and wallpapers
-- XXX: Update this!
beautiful.init("~/.config/awesome/themes/kabaka/theme.lua")


-- naughty.config.default_preset.font = "Bitstream Vera Sans Mono 13"

layouts = {
  awful.layout.suit.floating,
  awful.layout.suit.tile,
  awful.layout.suit.tile.left,
  awful.layout.suit.tile.bottom,
  awful.layout.suit.tile.top,
  awful.layout.suit.fair,
  awful.layout.suit.fair.horizontal,
  awful.layout.suit.spiral,
  awful.layout.suit.spiral.dwindle,
  awful.layout.suit.max,
  awful.layout.suit.max.fullscreen,
  awful.layout.suit.magnifier
}


-- TODO: Per-screen tags?
tags = {
  names = {
    "IRC", "Mail", "Browser", "Local", "Remote",
    "1", "2", "3", "4"
  },
  layout = {
    layouts[2], layouts[2], layouts[3], layouts[2], layouts[2],
    layouts[1], layouts[2], layouts[2], layouts[1]
  }
}

for s = 1, screen.count() do
  tags[s] = awful.tag(tags.names, s, tags.layout)
end


myawesomemenu = {
  {
    "restart",
    awesome.restart
  },
  {
    "quit",
    awesome.quit
  }
}

mymainmenu = awful.menu({
  items = {
    {
      "awesome",
      myawesomemenu, beautiful.awesome_icon
    },
    {
      "terminal",
      terminal
    }
  }
})

mylauncher = awful.widget.launcher({
  image = beautiful.awesome_icon,
  menu = mymainmenu
})



-- Widgets

-- VM Blue: #034FA3

separator = wibox.widget.textbox()
separator:set_markup(' <span color="#555555">|</span> ')


cpuwidget = awful.widget.graph()

cpuwidget:set_width(50)
cpuwidget:set_background_color("#000000")
cpuwidget:set_color({
  type = "linear",
  from = { 0, 0 },
  to = { 0, 20 },
  stops = {
    { 0,    "#FFFFFF" },
    { 1,    "#034FA3" }
  }
})

vicious.register(cpuwidget, vicious.widgets.cpu, "$1", 0.5)


cputxtwidget = wibox.widget.textbox()

cputxtwidget.width = 120
cputxtwidget.align = "center"
vicious.cache(vicious.widgets.cpu)

vicious.register(cputxtwidget, vicious.widgets.cpu,
  "$2<span font_size='6000'>%</span> $3<span font_size='6000'>%</span> $4<span font_size='6000'>%</span> $5<span font_size='6000'>%</span>",
  0.5)


netwidget = wibox.widget.textbox()
vicious.register(netwidget, vicious.widgets.net,
  '<span color="#CC9393">${eth0 down_kb}</span> <span font_size="6000">KiB/s</span> <span color="#7F9F7F">${eth0 up_kb}</span> <span font_size="6000">KiB/s</span>',
  1)

mpdwidget = wibox.widget.textbox()

--vicious.register(mpdwidget, vicious.widgets.mpd,
--  function (widget, args)
--    if args["{state}"] == "Stop" then
--      return "No Music Playing"
--    else
--      split_pos = args["{time}"]:find(":")
--
--      elapsed_seconds = args["{time}"]:sub(0, split_pos-1)
--      elapsed_seconds = tonumber(elapsed_seconds)
--
--      duration_seconds = tonumber(args["{Time}"])
--
--      return args["{Artist}"]..' - '.. args["{Title}"]
--    end
--  end, 5, {nil, "192.168.1.40", "6600"})



memwidget = awful.widget.progressbar()

memwidget:set_width(8)
memwidget:set_vertical(true)
memwidget:set_background_color("#000000")
memwidget:set_border_color(nil)
memwidget:set_color({
  type = "linear",
  from = { 0, 0 },
  to = { 0, 20 },
  stops = {
    { 0,    "#FFFFFF" },
    { 1,    "#034FA3" }
  }
})

vicious.cache(vicious.widgets.mem)
vicious.register(memwidget, vicious.widgets.mem, "$1", 13)

memtxtwidget = wibox.widget.textbox()
vicious.register(memtxtwidget, vicious.widgets.mem,
  "$1% (<span rise='2048' font_size='8000'>$2 MiB</span>/<span rise='-2048' font_size='8000'>$3 MiB</span>)",
  13)


weatherwidget = wibox.widget.textbox()
weatherwidget:set_text(awful.util.pread("~/scripts/awesome/weather-standalone.rb"))

weathertimer = timer({ timeout = 900 })

weathertimer:connect_signal("timeout",  function()

  weathertime:stop()

  weatherwidget:set_text(
    awful.util.pread("~/scripts/awesome/weather-standalone.rb")
  )

  weathertimer.timeout = 900
  weathertimer:start()

end)

weathertimer:start()


mailwidget = wibox.widget.textbox()

mytextclock = wibox.widget.textbox()

vicious.register(mytextclock, vicious.widgets.date, "%a, %F, %T", 1)

mytextclock:buttons(awful.util.table.join(
  awful.button(
    { }, 1,
    function ()
      naughty.notify({text = awful.util.pread("cal"), timeout = 0, screen = mouse.screen})
    end
  )
))



volwidget = wibox.widget.textbox()

volwidget:set_text(
  awful.util.pread("amixer | grep Master -A5 | egrep -o '[0-9]+%'")
)

volwidget:buttons(awful.util.table.join(
  awful.button(
    { }, 4,
    function ()
      volwidget:set_text(
        awful.util.pread("amixer sset Master 5+ | egrep -o '[0-9]+%'")
      )
    end
  ),

  awful.button(
    { }, 5,
    function ()
      volwidget:set_text(
        awful.util.pread("amixer sset Master 5- | egrep -o '[0-9]+%'")
      )
    end
  )
))


voltimer = timer({ timeout = 15 })

voltimer:connect_signal("timeout", function()
  volwidget.text = awful.util.pread("amixer sget Master | egrep -o '[0-9]+%'")
end)

voltimer:start()



-- Create a systray
mysystray = wibox.widget.systray()

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
  awful.button({ }, 1, function (c)
    if not c:isvisible() then
      awful.tag.viewonly(c:tags()[1])
    end
    client.focus = c
    c:raise()
  end),
  awful.button({ }, 3, function ()
    if instance then
      instance:hide()
      instance = nil
    else
      instance = awful.menu.clients({ width=250 })
    end
  end),
  awful.button({ }, 4, function ()
    awful.client.focus.byidx(1)
    if client.focus then client.focus:raise() end
  end),
  awful.button({ }, 5, function ()
    awful.client.focus.byidx(-1)
    if client.focus then client.focus:raise() end
  end)
)

for s = 1, screen.count() do
  -- Create a promptbox for each screen
  mypromptbox[s] = awful.widget.prompt()
  -- Create an imagebox widget which will contains an icon indicating which layout we're using.
  -- We need one layoutbox per screen.
  mylayoutbox[s] = awful.widget.layoutbox(s)
  mylayoutbox[s]:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
    awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
    awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
    awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)
  ))
  -- Create a taglist widget
  mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

  -- Create a tasklist widget
  mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

  -- Create the wibox
  mywibox[s] = awful.wibox({ position = "top", screen = s })

  -- Widgets that are aligned to the left
  local left_layout = wibox.layout.fixed.horizontal()

  left_layout:add(mylauncher)
  left_layout:add(mytaglist[s])
  left_layout:add(mypromptbox[s])

  -- Widgets that are aligned to the right
  local right_layout = wibox.layout.fixed.horizontal()

  if s == 1 then
    right_layout:add(wibox.widget.systray())
  end

  right_layout:add(mpdwidget)
  right_layout:add(separator)

  right_layout:add(weatherwidget)
  right_layout:add(separator)

  right_layout:add(memtxtwidget)
  right_layout:add(separator)

  right_layout:add(memwidget)
  right_layout:add(separator)

  right_layout:add(cputxtwidget)
  right_layout:add(separator)

  right_layout:add(cpuwidget)
  right_layout:add(separator)

  right_layout:add(netwidget)
  right_layout:add(separator)

  right_layout:add(mytextclock)
  right_layout:add(separator)

  right_layout:add(mylayoutbox[s])
  right_layout:add(separator)

  right_layout:add(volwidget)

  local layout = wibox.layout.align.horizontal()

  layout:set_left(left_layout)

  -- task lists are for pleebs
  --layout:set_middle(mytasklist[s])

  layout:set_right(right_layout)

  mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
awful.button({ }, 3, function () mymainmenu:toggle() end),
awful.button({ }, 4, awful.tag.viewnext),
awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
  awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
  awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
  awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

  awful.key({ modkey,           }, "j",
  function ()
    awful.client.focus.byidx( 1)
    if client.focus then client.focus:raise() end
  end),
  awful.key({ modkey,           }, "k",
  function ()
    awful.client.focus.byidx(-1)
    if client.focus then client.focus:raise() end
  end),
  awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

  -- Layout manipulation
  awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
  awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
  awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
  awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
  awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
  awful.key({ modkey,           }, "Tab",
    function ()
      awful.client.focus.history.previous()
      if client.focus then
        client.focus:raise()
      end
    end),

  -- Standard program
  awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
  awful.key({ modkey, "Control" }, "r", awesome.restart),
  awful.key({ modkey, "Shift"   }, "q", awesome.quit),

  awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
  awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
  awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
  awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
  awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
  awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
  awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
  awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

  awful.key({ modkey, "Control" }, "n", awful.client.restore),

  -- Prompt
  awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

  awful.key({ modkey }, "x",
  function ()
    awful.prompt.run({ prompt = "Run Lua code: " },
    mypromptbox[mouse.screen].widget,
    awful.util.eval, nil,
    awful.util.getdir("cache") .. "/history_eval")
  end),
  -- Menubar
  awful.key({ modkey }, "p", function() menubar.show() end)
)

clientkeys = awful.util.table.join(
  awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
  awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
  awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
  awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
  awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
  awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
  awful.key({ modkey,           }, "n",
  function (c)
    -- The client currently has the input focus, so it cannot be
    -- minimized, since minimized clients can't have the focus.
    c.minimized = true
  end),
  awful.key({ modkey,           }, "m",
  function (c)
    c.maximized_horizontal = not c.maximized_horizontal
    c.maximized_vertical   = not c.maximized_vertical
  end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
  globalkeys = awful.util.table.join(globalkeys,
  awful.key({ modkey }, "#" .. i + 9,
  function ()
    local screen = mouse.screen
    local tag = awful.tag.gettags(screen)[i]
    if tag then
      awful.tag.viewonly(tag)
    end
  end),
  awful.key({ modkey, "Control" }, "#" .. i + 9,
  function ()
    local screen = mouse.screen
    local tag = awful.tag.gettags(screen)[i]
    if tag then
      awful.tag.viewtoggle(tag)
    end
  end),
  awful.key({ modkey, "Shift" }, "#" .. i + 9,
  function ()
    local tag = awful.tag.gettags(client.focus.screen)[i]
    if client.focus and tag then
      awful.client.movetotag(tag)
    end
  end),
  awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
  function ()
    local tag = awful.tag.gettags(client.focus.screen)[i]
    if client.focus and tag then
      awful.client.toggletag(tag)
    end
  end))
end

clientbuttons = awful.util.table.join(
  awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
  awful.button({ modkey }, 1, awful.mouse.client.move),
  awful.button({ modkey }, 3, awful.mouse.client.resize)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
  -- All clients will match this rule.
  {
    rule = { },
    properties = { border_width = beautiful.border_width,
    border_color = beautiful.border_normal,
    focus = awful.client.focus.filter,
    size_hints_honor = false,
    keys = clientkeys,
    buttons = clientbuttons }
  },
  {
    rule = {
      class = "MPlayer"
    },
    properties = {
      floating = true
    }
  },
  {
    rule = {
      class = "pinentry"
    },
    properties = {
      floating = true
    }
  },
  { rule = { class = "gimp" },
  properties = { floating = true } },
  -- Set Firefox to always map on tags number 2 of screen 1.
  -- { rule = { class = "Firefox" },
  --   properties = { tag = tags[1][2] } },
}
-- }}}



-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
  -- Enable sloppy focus
  c:connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
      and awful.client.focus.filter(c) then
      client.focus = c
    end
  end)

  if not startup then
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- awful.client.setslave(c)

    -- Put windows in a smart way, only if they does not set an initial position.
    if not c.size_hints.user_position and not c.size_hints.program_position then
      awful.placement.no_overlap(c)
      awful.placement.no_offscreen(c)
    end
  end

  local titlebars_enabled = false
  if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
    -- buttons for the titlebar
    local buttons = awful.util.table.join(
    awful.button({ }, 1, function()
      client.focus = c
      c:raise()
      awful.mouse.client.move(c)
    end),
    awful.button({ }, 3, function()
      client.focus = c
      c:raise()
      awful.mouse.client.resize(c)
    end)
    )

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(awful.titlebar.widget.iconwidget(c))
    left_layout:buttons(buttons)

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    right_layout:add(awful.titlebar.widget.floatingbutton(c))
    right_layout:add(awful.titlebar.widget.maximizedbutton(c))
    right_layout:add(awful.titlebar.widget.stickybutton(c))
    right_layout:add(awful.titlebar.widget.ontopbutton(c))
    right_layout:add(awful.titlebar.widget.closebutton(c))

    -- The title goes in the middle
    local middle_layout = wibox.layout.flex.horizontal()
    local title = awful.titlebar.widget.titlewidget(c)
    title:set_align("center")
    middle_layout:add(title)
    middle_layout:buttons(buttons)

    -- Now bring it all together
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_right(right_layout)
    layout:set_middle(middle_layout)

    awful.titlebar(c):set_widget(layout)
  end
end)

client.connect_signal("focus",
  function(c) c.border_color = beautiful.border_focus end)

client.connect_signal("unfocus",
  function(c) c.border_color = beautiful.border_normal end)

