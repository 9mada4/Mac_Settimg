-- Hammerspoon configuration for window management
-- ① ショートカット：Ctrl + Option + Command + →　で右モニターに送る
-- ② ショートカット：Ctrl + Option + Command + ←　で左モニターに送る
-- ③ ショートカット：Command + ろ でGUIメニューを起動し，ウィンドウの配置を選択

local leftMargin = 150  -- 左端だけの余白
local rightMargin = 60  -- 右端だけの余白

-- ショートカット：Ctrl + Option + Command + →　で右モニターに送る
hs.hotkey.bind({"shift", "alt", "cmd"}, "Up", function()
  local win = hs.window.focusedWindow()
  if win then
    local screen = win:screen():next()
    win:moveToScreen(screen)
  end
end)

-- ショートカット：Ctrl + Option + Command + ←　で左モニターに送る
hs.hotkey.bind({"shift", "alt", "cmd"}, "Down", function()
  local win = hs.window.focusedWindow()
  if win then
    local screen = win:screen():previous()
    win:moveToScreen(screen)
  end
end)

local function arrangeWindows(mode)
  local app = hs.application.frontmostApplication()
  local wins = app and app:allWindows() or {}
  if #wins < 1 then return end

  local screen = wins[1]:screen()
  local frame = screen:frame()

  if mode == "centered" then
    local width = frame.w - leftMargin
    wins[1]:setFrame({
      x = frame.x + leftMargin,
      y = frame.y,
      w = width,
      h = frame.h
    })

  elseif mode == "leftHalfThenRight" then
    local half = (frame.w - leftMargin) / 2
    wins[1]:setFrame({
      x = frame.x + leftMargin,
      y = frame.y,
      w = half,
      h = frame.h
    })
    if wins[2] then
      wins[2]:setFrame({
        x = frame.x + leftMargin + half,
        y = frame.y,
        w = half,
        h = frame.h
      })
    end
    
  elseif mode == "rightHalfThenLeft" then
    local half = (frame.w - leftMargin) / 2
    wins[1]:setFrame({
      x = frame.x + leftMargin + half,
      y = frame.y,
      w = half,
      h = frame.h
    })
    if wins[2] then
      wins[2]:setFrame({
        x = frame.x + leftMargin,
        y = frame.y,
        w = half,
        h = frame.h
      })
    end

  elseif mode == "leftTwoThirdsThenRight" then
    local widthL = (frame.w - leftMargin) * 2 / 3
    local widthR = (frame.w - leftMargin) / 3
    wins[1]:setFrame({
      x = frame.x + leftMargin,
      y = frame.y,
      w = widthL,
      h = frame.h
    })
    if wins[2] then
      wins[2]:setFrame({
        x = frame.x + leftMargin + widthL,
        y = frame.y,
        w = widthR,
        h = frame.h
      })
    end

  elseif mode == "customLayout" then
    -- First window: full width with margins on both sides
    wins[1]:setFrame({
      x = frame.x + leftMargin,
      y = frame.y,
      w = frame.w - (leftMargin + rightMargin),
      h = frame.h
    })
    -- Second window: half width, right-aligned, 2/3 height bottom-aligned
    local halfWidth = frame.w / 2
    local twoThirdHeight = frame.h * 2 / 3
    if wins[2] then
      wins[2]:setFrame({
        x = frame.x + frame.w - halfWidth,
        y = frame.y + (frame.h - twoThirdHeight),
        w = halfWidth,
        h = twoThirdHeight
      })
    end

  elseif mode == "cascadeStack" then
    local app = hs.application.frontmostApplication()
    local wins = app:allWindows()
    if #wins == 0 then return end

    local screen = wins[1]:screen()
    local frame = screen:frame()

    local offsetX, offsetY = 40, 20
    local width = (frame.w - leftMargin) * 0.9
    local height = frame.h * 0.9

    for i, win in ipairs(wins) do
      win:setFrame({
        x = frame.x + leftMargin + offsetX * (i - 1),
        y = frame.y + offsetY * (i - 1),
        w = width,
        h = height
      })
    end

  elseif mode == "moveToNextScreen" then
    local win = hs.window.focusedWindow()
    if win then
      win:moveToScreen(win:screen():next())
    end

  elseif mode == "moveToPrevScreen" then
    local win = hs.window.focusedWindow()
    if win then
      win:moveToScreen(win:screen():previous())
    end
  end
end

-- GUIメニューを表示
local choices = {
  { text = "中央に配置", mode = "centered" },
  { text = "■■□　□□□\n■■□　□●●\n■■□　□●●", mode = "customLayout" },
  { text = "■□|□●", mode = "leftHalfThenRight" },
  { text = "●□|□■", mode = "rightHalfThenLeft" },
  { text = "■■□|□□●", mode = "leftTwoThirdsThenRight" },
  { text = "📁 重ねて表示", mode = "cascadeStack" },
  { text = "⬆ 別モニターに移動　Shift⬆ + ⌥ + ⌘ + ⬆", mode = "moveToNextScreen" },
  { text = "⬇ メインモニターに移動　Shift⬆ + ⌥ + ⌘ + ⬇", mode = "moveToPrevScreen" },
}

-- GUIの表示と実行
local function showLayoutChooser()
  local chooser = hs.chooser.new(function(choice)
    if choice then
      arrangeWindows(choice.mode)
    end
  end)
  chooser:choices(choices)
  chooser:placeholderText("ウィンドウレイアウトを選んでください")
  chooser:show()
end

-- Bind keys
hs.hotkey.bind({"shift", "alt", "cmd"}, 94, showLayoutChooser)
hs.hotkey.bind({"shift", "cmd"}, 94, showLayoutChooser)
hs.hotkey.bind("cmd", 94, showLayoutChooser)