
cp /etc/xdg/awesome/rc.lua ~/.config/awesome

xfce4-taskmanager (task manager)
xfce4-power-manager
xfce4-settings
demu (app menu)
rofi (app menu)
scrot (screensaver)
nitrogen (transparency0
picom
ranger (file manager)
file-roller
numlockx (turn on the numlock by default at boot)
mlocate
trash-cli (cli tool for the trash)
glances (system monitoring)
vnstat
pywal (color scheme)
tor
dunst
awesome-extra



-- Autostart Applications
awful.spawn.with_shell(“picom”)
awful.spawn.with_shell(“nitrogen --restore”)

terminal = “alacritty”

-- Prompt
awful.screen.focused().mypromptbox:run() --> awful.util.spawn(“dmenu_run”)

-- Firefox
awful.key({ modkey }, “b”, function () awful.util.spawn(“firefox”) end,
{description = “firefox”, group = “applications”}),

}, properties = { titlebars_enabled = true }

echo "numlockx &" >> ~/.xinitrc


# comment out the menu
-- {{{ Menu
-- Create a launcher widget and a main menu
--myawesomemenu = {
--   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
--   { "manual", terminal .. " -e man awesome" },
--   { "edit config", editor_cmd .. " " .. awesome.conffile },
--   { "restart", awesome.restart },
--   { "quit", function() awesome.quit() end },
--}
--mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                      { "open terminal", terminal }
--                                    }
--                         }}
--mylauncher - awful.widget.launcher({ image = beautiful.awesome_icon,
--                                     menu = mymainmenu })

sudo updatedb (for mlocate)


# TODO how do we access the shared drives

>> trash-list
>> trash-empty


## wallpaper (theme.lua)
-- absolute path
theme.wallpaper = "/path/to/wallpaper.png"

-- relative to your themes directory
theme.wallpaper = theme_path .. "path/to/wallpaper.png"

OR (rc.lua)

-- absolute path
beautiful.wallpaper = "/path/to/wallpaper.png"

-- relative to the configuration directory
beautiful.wallpaper = awful.util.get_configuration_dir() .. "path/to/wallpaper.png"


# hide or show the wibox
awful.key({ modkey }, "b",
          function ()
              myscreen = awful.screen.focused()
              myscreen.mywibox.visible = not myscreen.mywibox.visible
          end,
          {description = "toggle statusbar"}
),

As of awesome 3.4, it is possible to remove the small gaps between windows; in the awful.rules.rules table there is a properties section, add to it
 size_hints_honor = false


 client.connect_signal("focus", function(c)
                              c.border_color = beautiful.border_focus
                              c.opacity = 1
                           end)
client.connect_signal("unfocus", function(c)
                                c.border_color = beautiful.border_normal
                                c.opacity = 0.7
                             end)

~/.conkyrc
own_window yes
own_window_transparent yes
own_window_type desktop

 { -- Right widgets
       layout = wibox.layout.fixed.horizontal,
       spacing = 10,
       mykeyboardlayout,
       ...


          { rule_any = {type = { "normal", "dialog" }
     }, properties = { titlebars_enabled = true }
   },


   awful.titlebar.hide(c)


   -- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end)
))
-- }}}

# TODO: need to remapt the mod key to something beside command (MOD1 - option key∑) 


comment out the bottom lines so that the focus does not follow the mouse


mymainmenu = awful.menu({ items = { 
--                                  { "Menü", ts_menu,"/usr/share/icons/oxygen/base/22x22/places/start-here-kde.png" },
                                    { "",""}, 
--                                  { "Shutdown", 'kshutdown',"/usr/share/icons/oxygen/base/22x22/actions/system-shutdown.png"},
                                    { "Quit", function() awesome.quit() end,"/usr/share/icons/oxygen/base/22x22/actions/system-log-out.png" };
                                    { "",""}, 
--                                  { "Notizzettel","/usr/bin/knotes","/usr/share/icons/oxygen/base/22x22/apps/knotes.png"},  
--                                  { "File Manager", "dolphin","/usr/share/icons/oxygen/base/22x22/apps/system-file-manager.png" }, 
--                                  { "Search","kfind","/usr/share/icons/hicolor/22x22/apps/kfind.png" },
                                    { "",""}, 
                                    { "Browser", "firefox", "/usr/share/pixmaps/firefox-esr.png" },
--                                  { "E-mail", "icedove","/usr/share/pixmaps/icedove.xpm" },  
                                    { "",""}, 
                                    { "Terminal", konsole, "/usr/share/icons/oxygen/base/22x22/categories/applications-utilities.png" },
--                                  { "Synaptic","kdesudo synaptic-pkexec","/usr/share/synaptic/pixmaps/synaptic_32x32.xpm"},
                                    { "",""},
--                                  { "System-settings","kdesudo systemsettings5","/usr/share/icons/oxygen/base/22x22/categories/preferences-system.png"},
--                                  { "Bluetooth","blueman-applet","/usr/share/icons/hicolor/32x32/apps/blueman.png"},
                                    { "Network-Manager", "nm-applet","/usr/share/icons/gnome/base/22x22/places/network_local.png" },
                                    { "",""}, 
--                                  { "gtkam","/usr/bin/gtkam","/usr/share/gtkam/pixmaps/camera.xpm"},
                                    { "",""}, 
                                    { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "Debian", debian.menu.Debian_menu.Debian, "/usr/share/icons/gnome/22x22/places/debian-swirl.png" },
                                  }
                        })

-- Load ts_menu
require("ts_menu") 

audio = {
--      {"Spotify","/usr/bin/spotify","/usr/share/icons/hicolor/32x32/apps/spotify-client.png"}, 
--      {"Audacity","/usr/bin/audacity","/usr/share/pixmaps/audacity32.xpm"},
--      {"Clementine","/usr/bin/clementine","/usr/share/pixmaps/clementine.xpm"},
--      {"",""},
--      {"Ex Falso","/usr/bin/exfalso","/usr/share/pixmaps/exfalso.png"},
--      {"Puddletag","/usr/bin/puddletag","/usr/share/pixmaps/puddletag.png"},
--      {"TuxGuitar","tuxguitar","/usr/share/pixmaps/tuxguitar.xpm"},
--      {"Timidity","timidity -ig","/usr/share/pixmaps/timidity.xpm"},
}

office = {
        {"ding","/usr/bin/ding","/usr/share/pixmaps/dbook.xpm"},
        {"writer","/usr/bin/libreoffice --writer","/usr/share/icons/hicolor/32x32/apps/libreoffice-writer.png"},
        {"calculation","/usr/bin/libreoffice --calc","/usr/share/icons/hicolor/32x32/apps/libreoffice-calc.png"},
        {"impress","/usr/bin/libreoffice --impress","/usr/share/icons/hicolor/32x32/apps/libreoffice-impress.png"},
        {"base","/usr/bin/libreoffice --base","/usr/share/icons/hicolor/32x32/apps/libreoffice-base.png"},
        {"",""},
        {"pdfshuffler","/usr/bin/pdfshuffler","/usr/share/icons/hicolor/scalable/apps/pdfshuffler.svg"},
        {"pdfchain","/usr/bin/pdfchain","/usr/share/icons/hicolor/32x32/apps/pdfchain.png"},
        {"pdfmod","/usr/bin/pdfmod","/usr/share/icons/hicolor/32x32/apps/pdfmod.png"},
        {"",""},
        {"KMyMoney","/usr/bin/kmymoney","/usr/share/icons/hicolor/32x32/apps/kmymoney.png"},
}

development = {
        {"UMLet","/usr/bin/umlet","/usr/share/umlet/img/umlet_logo24.png"},
        {"Ruler","/usr/bin/kruler","/usr/share/kde4/apps/kdewidgets/pics/kruler.png"},
        {"Link Status prüfen","/usr/bin/klinkstatus","/usr/share/icons/hicolor/32x32/apps/klinkstatus.png"},
        {"netbeans","/usr/bin/netbeans","/usr/share/icons/hicolor/32x32/apps/netbeans.png"},
}

photo = {
        {"gtkam","/usr/bin/gtkam","/usr/share/gtkam/pixmaps/camera.xpm"},
        {"Gwenview","/usr/bin/gwenview","/usr/share/icons/hicolor/32x32/apps/gwenview.png"},
        {"phototonic","/usr/bin/phototonic","/usr/share/pixmaps/phototonic.png"},
        {"digikam","/usr/bin/digikam","/usr/share/icons/oxygen/base/22x22/apps/digikam.png"},
--      {"SQLiteBrowser","/usr/bin/sqlitebrowser"},
        {"",""},
        {"RawTherapee","rawtherapee","/usr/share/pixmaps/rawtherapee.xpm"},
        {"GIMP","/usr/bin/gimp -n","/usr/share/pixmaps/gimp.xpm"},
}
photo_2 = {
--      {"FotoWall","/usr/bin/fotowall","/usr/share/pixmaps/fotowall.xpm"},
        {"Hugin","/usr/bin/hugin","/usr/share/pixmaps/hugin.png"},
        {"luminance-hdr","/usr/bin/luminance-hdr","/usr/share/icons/hicolor/32x32/apps/luminance-hdr.png"},
--      {"PhotoPrint","/usr/bin/photoprint","/usr/share/icons/hicolor/48x48/apps/fotoprint.png"},
        {"PTBatcherGUI","/usr/bin/PTBatcherGUI","/usr/share/pixmaps/ptbatcher.png"},
--      {"DNG-Koverter","/usr/bin/dngconverter","/usr/share/icons/hicolor/48x48/apps/kipi-dngconverter.png"},
}

graphics = {
--      {"Scribus","/usr/bin/scribus","/usr/share/pixmaps/scribus.xpm"},
        {"Inkscape","/usr/bin/inkscape","/usr/share/pixmaps/inkscape.xpm"},
        {"Office Draw","/usr/bin/libreoffice --draw","/usr/share/icons/hicolor/32x32/apps/libreoffice-draw.png"},
--      {"PTBatcherGUI","/usr/bin/PTBatcherGUI"},
}

internet = {
        {"Firefox", "firefox", "/usr/share/pixmaps/firefox-esr.png" },
        {"Icedove E-mail","icedove","/usr/share/pixmaps/icedove.xpm"},
        {"dropbox","/usr/bin/dropbox start -i","/usr/share/icons/hicolor/32x32/apps/dropbox.png"},
}

games = {
--      {"MegaGlest","/usr/games/megaglest","/usr/share/pixmaps/megaglest.xpm"},
--      {"widelands","/usr/games/widelands","/usr/share/icons/hicolor/32x32/apps/widelands.xpm"},
}

system = {
        {"Synaptic","kdesudo synaptic-pkexec","/usr/share/synaptic/pixmaps/synaptic_32x32.xpm"},
        {"Apper","kdesudo apper","/usr/share/icons/oxygen/base/22x22/categories/applications-other.png"},
        {"",""},
        {"Systems ettings","kdesudo systemsettings","/usr/share/icons/oxygen/base/22x22/categories/preferences-system.png"},
        {"",""},
        {"Krusader-root","kdesudo krusader","/usr/share/icons/hicolor/32x32/apps/krusader_root.png"},
        {"",""},
        {"K3b","/usr/bin/k3b","/usr/share/icons/hicolor/32x32/apps/k3b.png"},
        {"luckybackup","/usr/bin/luckybackup","/usr/share/pixmaps/luckybackup.png"},
--      {"luckybackup-root","su-to-root -X -c /usr/bin/luckybackup","/usr/share/pixmaps/luckybackup.xpm"},
        {"Partition Manager","kdesudo partitionmanager","/usr/share/icons/oxygen/base/22x22/apps/partitionmanager.png"},
        {"Gparted","kdesudo gparted","/usr/share/icons/hicolor/32x32/apps/gparted.png"},
        {"Kill","xkill","/usr/share/icons/gnome/32x32/actions/stop.png"},
        {"Refresh","xrefresh","/usr/share/icons/gnome/32x32/actions/reload.png"},
        {"System Information","kinfocenter","/usr/share/icons/oxygen/base/22x22/apps/hwinfo.png"},
        {"System Monitor","/usr/bin/ksysguard","/usr/share/icons/gnome/32x32/apps/ksysguard.png"},
}

video = {
        {"SMPlayer","smplayer","/usr/share/pixmaps/smplayer.xpm"},
        {"VLC media player","/usr/bin/qvlc","/usr/share/icons/hicolor/32x32/apps/vlc.xpm"},
        {"Dragon Player","/usr/bin/dragon","/usr/share/icons/hicolor/32x32/apps/dragonplayer.png"},
--      {"WinFF","/usr/bin/winff","/usr/share/pixmaps/winff.xpm"},
        {"MediaInfo","/usr/bin/mediainfo-gui","/usr/share/pixmaps/mediainfo.xpm"},
}

tools = {
        {"Find","kfind","/usr/share/icons/hicolor/32x32/apps/kfind.png"},
    {"File Manager", "dolphin","/usr/share/icons/oxygen/base/22x22/apps/system-file-manager.png" }, 
        {"Krusader-root","kdesudo krusader","/usr/share/icons/hicolor/32x32/apps/krusader_root.png"},
        {"Terminal", "konsole", "/usr/share/icons/oxygen/base/22x22/categories/applications-utilities.png"},
        {"",""},
        {"Screenshot","/usr/bin/ksnapshot","/usr/share/icons/oxygen/base/22x22/apps/ksnapshot.png"},
        {"Filelight","filelight","/usr/share/icons/hicolor/32x32/apps/filelight.png"},
        {"Editor","kate","/usr/share/icons/hicolor/32x32/apps/kate.png"},
        {"Editor-root","kdesudo kate","/usr/share/icons/hicolor/32x32/apps/kate.png"},
        {"KWrite","kwrite","/usr/share/icons/oxygen/base/22x22/apps/accessories-text-editor.png"},
        {"Klipper","/usr/bin/klipper","/usr/share/icons/oxygen/base/32x32/apps/klipper.png"},
        {"Calculator","/usr/bin/xcalc","/usr/share/icons/oxygen/base/22x22/apps/accessories-calculator.png"},
        {"",""},
        {"Rename","/usr/bin/krename","/usr/share/icons/hicolor/32x32/apps/krename.png"},
        {"KDiff3","/usr/bin/kdiff3","/usr/share/icons/hicolor/32x32/apps/kdiff3.png"},
        {"Kompare","/usr/bin/kompare","/usr/share/icons/hicolor/32x32/apps/kompare.png"},
--      {"Komparator","/usr/bin/komparator4","/usr/share/icons/hicolor/32x32/apps/komparator4.png"},
        {"",""},
        {"KMix","/usr/bin/kmix","/usr/share/icons/hicolor/32x32/apps/kmix.png"},
}

ts_menu = {
        { "audio", audio, "/usr/share/icons/oxygen/base/22x22/mimetypes/audio-ac3.png" },
        { "office", office, "/usr/share/icons/oxygen/base/22x22/categories/applications-office.png" },
        { "development", development, "/usr/share/icons/oxygen/base/22x22/categories/applications-development.png" },
        { "photo", photo,"/usr/share/icons/oxygen/base/22x22/apps/showfoto.png" },
        { "photo_2", photo_2 },
        { "graphics", graphics, "/usr/share/icons/oxygen/base/22x22/categories/applications-graphics.png" },
        { "internet", internet, "/usr/share/icons/oxygen/base/22x22/categories/applications-internet.png" },
        { "games", games, "/usr/share/icons/oxygen/base/22x22/categories/applications-games.png" },
        { "system", system, "/usr/share/icons/oxygen/base/22x22/categories/applications-system.png" },
        { "video", video, "/usr/share/icons/gnome/32x32/mimetypes/video.png" },
        { "tools", tools, "/usr/share/icons/oxygen/base/22x22/categories/applications-utilities.png" },
}


 awful.tag.add("1", {
        icon               = "/usr/share/icons/oxygen/base/22x22/places/user-desktop.png",
        layout             = awful.layout.suit.tile,
        --        master_fill_policy = "master_width_factor",
        --        gap_single_client  = true,
        --        gap                = 1,
        screen             = s,
        selected           = true,
        }
    )
    awful.tag.add("2", {
        icon = "/usr/share/icons/oxygen/base/22x22/places/user-desktop.png",
        layout = awful.layout.suit.max,
        screen = s,
        }
    )
    awful.tag.add("3", {
        icon = "/usr/share/icons/oxygen/base/22x22/places/user-desktop.png",
        layout = awful.layout.suit.max,
        screen = s,
        }
    )
    awful.tag.add("4", {
        icon = "/usr/share/pixmaps/firefox-esr.png",
        layout = awful.layout.suit.max,
        screen = s,
        }
    )

     -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

              mykeyboardlayout,
            wibox.widget.systray(),

If you prefer the shortcuts for closing and maximizing the windows, titlebars are obsolete. "titlebars_enabled = true" can be changed to open new windows without titlebars.

    awful.spawn.easy_async("numlockx on")
    awful.spawn.easy_async("/usr/bin/kmix")
    awful.spawn.easy_async("nm-applet")