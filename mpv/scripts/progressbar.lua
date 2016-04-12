local msg = require('mp.msg')
local options = require('mp.options')
local script_name = 'torque-progressbar'
mp.get_osd_size = mp.get_osd_size or mp.get_screen_size
local log = {
  debug = function(format, ...)
    return msg.debug(format:format(...))
  end,
  info = function(format, ...)
    return msg.info(format:format(...))
  end,
  warn = function(format, ...)
    return msg.warn(format:format(...))
  end,
  dump = function(item, ignore)
    local level = 2
    if "table" ~= type(item) then
      msg.info(tostring(item))
      return 
    end
    local count = 1
    local tablecount = 1
    local result = {
      "{ @" .. tostring(tablecount)
    }
    local seen = {
      [item] = tablecount
    }
    local recurse
    recurse = function(item, space)
      for key, value in pairs(item) do
        if not (key == ignore) then
          if "table" == type(value) then
            if not (seen[value]) then
              tablecount = tablecount + 1
              seen[value] = tablecount
              count = count + 1
              result[count] = space .. tostring(key) .. ": { @" .. tostring(tablecount)
              recurse(value, space .. "  ")
              count = count + 1
              result[count] = space .. "}"
            else
              count = count + 1
              result[count] = space .. tostring(key) .. ": @" .. tostring(seen[value])
            end
          else
            if "string" == type(value) then
              value = ("%q"):format(value)
            end
            count = count + 1
            result[count] = space .. tostring(key) .. ": " .. tostring(value)
          end
        end
      end
    end
    recurse(item, "  ")
    count = count + 1
    result[count] = "}"
    return msg.info(table.concat(result, "\n"))
  end
}
local settings = {
  ['hover-zone-height'] = 40,
  ['top-hover-zone-height'] = 40,
  ['enable-bar'] = true,
  ['bar-height-inactive'] = 2,
  ['bar-height-active'] = 8,
  ['bar-foreground'] = 'EEEEEE',
  ['bar-background'] = '262626',
  ['enable-elapsed-time'] = true,
  ['elapsed-foreground'] = 'EEEEEE',
  ['elapsed-background'] = '262626',
  ['enable-remaining-time'] = true,
  ['remaining-foreground'] = 'EEEEEE',
  ['remaining-background'] = '262626',
  ['enable-hover-time'] = true,
  ['hover-time-foreground'] = 'EEEEEE',
  ['hover-time-background'] = '262626',
  ['enable-title'] = false,
  ['title-font-size'] = 30,
  ['title-foreground'] = 'EEEEEE',
  ['title-background'] = '262626',
  ['pause-indicator'] = false,
  ['pause-indicator-foreground'] = '262626',
  ['pause-indicator-background'] = 'EEEEEE',
  ['enable-chapter-markers'] = true,
  ['chapter-marker-width'] = 2,
  ['chapter-marker-width-active'] = 4,
  ['chapter-marker-active-height-fraction'] = 1,
  ['chapter-marker-before'] = 'EEEEEE',
  ['chapter-marker-after'] = '262626',
  ['request-display-duration'] = 1,
  ['redraw-period'] = 0.03,
  ['font'] = 'Source Sans Pro Semibold',
  ['time-font-size'] = 30,
  ['hover-time-font-size'] = 26,
  ['hover-time-left-margin'] = 124,
  ['hover-time-right-margin'] = 140,
  ['elapsed-offscreen-pos'] = -100,
  ['remaining-offscreen-pos'] = -100,
  ['title-offscreen-pos'] = -40
}
options.read_options(settings, script_name)
local OSDAggregator
do
  local _class_0
  local _base_0 = {
    addSubscriber = function(self, subscriber)
      if not subscriber then
        return 
      end
      self.subscriberCount = self.subscriberCount + 1
      subscriber.aggregatorIndex = self.subscriberCount
      self.subscribers[self.subscriberCount] = subscriber
      self.script[self.subscriberCount] = subscriber:stringify()
    end,
    removeSubscriber = function(self, index)
      table.remove(self.subscribers, index)
      table.remove(self.script, index)
      self.subscriberCount = self.subscriberCount - 1
      for i = index, self.subscriberCount do
        self.subscribers[i].aggregatorIndex = i
      end
    end,
    update = function(self, needsRedraw)
      do
        local _with_0 = self.inputState
        _with_0.mouseX, _with_0.mouseY = mp.get_mouse_pos()
      end
      local w, h = mp.get_osd_size()
      local needsResize = false
      if w ~= self.w or h ~= self.h then
        self.w, self.h = w, h
        needsResize = true
      end
      for sub = 1, self.subscriberCount do
        local theSub = self.subscribers[sub]
        local update = false
        if theSub:update(self.inputState) then
          update = true
        end
        if (needsResize and theSub:updateSize(w, h)) or update then
          needsRedraw = true
          self.script[sub] = theSub:stringify()
        end
      end
      if needsRedraw == true then
        return mp.set_osd_ass(self.w, self.h, table.concat(self.script, '\n'))
      end
    end,
    pause = function(self, event, paused)
      self.paused = paused
      if self.paused then
        return self.updateTimer:stop()
      else
        return self.updateTimer:resume()
      end
    end,
    forceUpdate = function(self)
      self.updateTimer:kill()
      self:update(true)
      if not (self.paused) then
        return self.updateTimer:resume()
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.script = { }
      self.subscribers = { }
      self.inputState = {
        mouseX = -1,
        mouseY = -1,
        mouseInWindow = true,
        displayRequested = false
      }
      self.subscriberCount = 0
      self.w = 0
      self.h = 0
      self.updateTimer = mp.add_periodic_timer(settings['redraw-period'], (function()
        local _base_1 = self
        local _fn_0 = _base_1.update
        return function(...)
          return _fn_0(_base_1, ...)
        end
      end)())
      mp.register_event('shutdown', function()
        return self.updateTimer:kill()
      end)
      mp.add_forced_key_binding("mouse_leave", "mouse-leave", function()
        self.inputState.mouseInWindow = false
      end)
      mp.add_forced_key_binding("mouse_enter", "mouse-enter", function()
        self.inputState.mouseInWindow = true
      end)
      local displayDuration = settings['request-display-duration']
      local displayRequestTimer = mp.add_timeout(0, function() end)
      return mp.add_key_binding("tab", "request-display", function(event)
        local _exp_0 = event.event
        if "down" == _exp_0 then
          displayRequestTimer:kill()
          self.inputState.displayRequested = true
        elseif "up" == _exp_0 then
          displayRequestTimer = mp.add_timeout(displayDuration, function()
            self.inputState.displayRequested = false
          end)
        end
      end, {
        complex = true
      })
    end,
    __base = _base_0,
    __name = "OSDAggregator"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  OSDAggregator = _class_0
end
local AnimationQueue
do
  local _class_0
  local _base_0 = {
    registerAnimation = function(self, animation)
      if self.list then
        self.list.next = animation
      end
      animation.prev = self.list
      animation.isRegistered = true
      self.list = animation
      self.animationCount = self.animationCount + 1
      return self:startAnimation()
    end,
    unregisterAnimation = function(self, animation)
      local prev = animation.prev
      local next = animation.next
      if prev then
        prev.next = next
      end
      if next then
        next.prev = prev
      end
      if self.list == animation then
        self.list = prev
      end
      animation.next = nil
      animation.prev = nil
      animation.isRegistered = false
      self.animationCount = self.animationCount - 1
      if 0 == self.animationCount then
        self:stopAnimation()
      end
      return prev
    end,
    startAnimation = function(self)
      if self.animating then
        return 
      end
      self.timer:resume()
      self.animating = true
    end,
    stopAnimation = function(self)
      if not (self.animating) then
        return 
      end
      self.timer:kill()
      self.animating = false
    end,
    destroyAnimationStack = function(self)
      self:stopAnimation()
      local currentAnimation = self.list
      while currentAnimation do
        currentAnimation.isRegistered = false
        currentAnimation = self.list.prev
        self.list.prev = nil
        self.list.next = nil
        self.list = currentAnimation
      end
    end,
    animate = function(self)
      local currentAnimation = self.list
      local currentTime = mp.get_time()
      while currentAnimation do
        if currentAnimation:update(currentTime) then
          currentAnimation = self:unregisterAnimation(currentAnimation)
        else
          currentAnimation = currentAnimation.prev
        end
      end
      return self.aggregator:forceUpdate()
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, aggregator)
      self.aggregator = aggregator
      self.list = nil
      self.animationCount = 0
      self.animating = false
      self.timer = mp.add_periodic_timer(settings['redraw-period'], (function()
        local _base_1 = self
        local _fn_0 = _base_1.animate
        return function(...)
          return _fn_0(_base_1, ...)
        end
      end)())
      return self.timer:kill()
    end,
    __base = _base_0,
    __name = "AnimationQueue"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  AnimationQueue = _class_0
end
local Animation
do
  local _class_0
  local _base_0 = {
    update = function(self, currentTime)
      self.currentTime = currentTime
      local progress = math.max(0, math.min(1, (self.currentTime - self.startTime) * self.durationR))
      if progress == 1 then
        self.isFinished = true
      end
      if self.accel then
        progress = math.pow(progress, self.accel)
      end
      self.value = (1 - progress) * self.initialValue + progress * self.endValue
      self:updateCb(self.value)
      if self.isFinished and self.finishedCb then
        self:finishedCb()
      end
      return self.isFinished
    end,
    interrupt = function(self, reverse, queue)
      if reverse ~= self.isReversed then
        self:reverse()
      end
      if not (self.isRegistered) then
        self:restart()
        return queue:registerAnimation(self)
      end
    end,
    reverse = function(self)
      self.isReversed = not self.isReversed
      self.initialValue, self.endValue = self.endValue, self.initialValue
      self.startTime = 2 * self.currentTime - self.duration - self.startTime
      self.accel = 1 / self.accel
    end,
    restart = function(self)
      self.startTime = mp.get_time()
      self.currentTime = self.startTime
      self.isFinished = false
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, initialValue, endValue, duration, updateCb, finishedCb, accel)
      if accel == nil then
        accel = 1
      end
      self.initialValue, self.endValue, self.duration, self.updateCb, self.finishedCb, self.accel = initialValue, endValue, duration, updateCb, finishedCb, accel
      self.value = self.initialValue
      self.startTime = mp.get_time()
      self.currentTime = self.startTime
      self.durationR = 1 / self.duration
      self.isFinished = (self.duration <= 0)
      self.isRegistered = false
      self.isReversed = false
    end,
    __base = _base_0,
    __name = "Animation"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Animation = _class_0
end
local Rect
do
  local _class_0
  local _base_0 = {
    setPosition = function(self, x, y)
      self.x = x or self.x
      self.y = y or self.y
    end,
    setDimensions = function(self, w, h)
      self.w = w or self.w
      self.h = h or self.h
    end,
    move = function(self, x, y)
      self.x = self.x + (x or 0)
      self.y = self.y + (y or 0)
    end,
    stretch = function(self, w, h)
      self.w = self.w + (w or 0)
      self.h = self.h + (h or 0)
    end,
    containsPoint = function(self, x, y)
      return ((x >= self.x) and (y >= self.y) and (x < self.x + self.w) and (y < self.y + self.h))
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, x, y, w, h)
      self.x, self.y, self.w, self.h = x, y, w, h
    end,
    __base = _base_0,
    __name = "Rect"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Rect = _class_0
end
local Subscriber
do
  local _class_0
  local active_height
  local _parent_0 = Rect
  local _base_0 = {
    stringify = function(self)
      if not self.hovered and not self.animation.isRegistered then
        return ""
      end
      return table.concat(self.line)
    end,
    updateSize = function(self, w, h)
      self.y = h - active_height
      self.w, self.h = w, active_height
    end,
    update = function(self, inputState, hoverCondition)
      do
        local _with_0 = inputState
        if hoverCondition == nil then
          hoverCondition = (self:containsPoint(_with_0.mouseX, _with_0.mouseY) or _with_0.displayRequested)
        end
        local update = self.needsUpdate
        self.needsUpdate = false
        if (_with_0.mouseInWindow or _with_0.displayRequested) and hoverCondition then
          if not (self.hovered) then
            update = true
            self.hovered = true
            self.animation:interrupt(false, self.animationQueue)
          end
        else
          if self.hovered then
            update = true
            self.hovered = false
            self.animation:interrupt(true, self.animationQueue)
          end
        end
        return update
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self)
      _class_0.__parent.__init(self, 0, 0, 0, 0)
      self.hovered = false
      self.needsUpdate = false
    end,
    __base = _base_0,
    __name = "Subscriber",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  local self = _class_0
  active_height = settings['hover-zone-height']
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Subscriber = _class_0
end
local BarAccent
do
  local _class_0
  local barSize
  local _parent_0 = Subscriber
  local _base_0 = {
    updateSize = function(self, w, h)
      _class_0.__parent.__base.updateSize(self, w, h)
      self.yPos = h - barSize
      self.sizeChanged = true
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "BarAccent",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  local self = _class_0
  barSize = settings['bar-height-active']
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  BarAccent = _class_0
end
local ProgressBar
do
  local _class_0
  local _parent_0 = Subscriber
  local _base_0 = {
    clickUpSeek = function(self)
      local x, y = mp.get_mouse_pos()
      if self:containsPoint(x, y) then
        return mp.commandv("seek", x * 100 / self.w, "absolute-percent", "keyframes")
      end
    end,
    stringify = function(self)
      return table.concat(self.line)
    end,
    updateSize = function(self, w, h)
      _class_0.__parent.__base.updateSize(self, w, h)
      self.line[2] = ([[%d,%d]]):format(0, h)
      self.line[8] = ([[%d 0 %d 1 0 1]]):format(w, w)
      return true
    end,
    animateHeight = function(self, animation, value)
      self.line[6] = ([[%g]]):format(value)
      self.needsUpdate = true
    end,
    update = function(self, inputState)
      local update = _class_0.__parent.__base.update(self, inputState)
      local position = mp.get_property_number('percent-pos', 0)
      if position ~= self.lastPosition then
        update = true
        self.line[4] = ([[%g]]):format(position)
        self.lastPosition = position
      end
      return update
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, animationQueue)
      self.animationQueue = animationQueue
      _class_0.__parent.__init(self)
      local minHeight = settings['bar-height-inactive'] * 100
      local maxHeight = settings['bar-height-active'] * 100
      self.line = {
        ([[{\an1\bord0\c&H%s&\pos(]]):format(settings['bar-foreground']),
        0,
        [[)\fscx]],
        0,
        [[\fscy]],
        minHeight,
        [[\p1}m 0 0 l ]],
        0
      }
      self.lastPosition = 0
      self.animation = Animation(minHeight, maxHeight, 0.25, (function()
        local _base_1 = self
        local _fn_0 = _base_1.animateHeight
        return function(...)
          return _fn_0(_base_1, ...)
        end
      end)())
      return mp.add_key_binding("mouse_btn0", "seek-to-mouse", (function()
        local _base_1 = self
        local _fn_0 = _base_1.clickUpSeek
        return function(...)
          return _fn_0(_base_1, ...)
        end
      end)())
    end,
    __base = _base_0,
    __name = "ProgressBar",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  ProgressBar = _class_0
end
local ProgressBarBackground
do
  local _class_0
  local _parent_0 = Subscriber
  local _base_0 = {
    stringify = function(self)
      return table.concat(self.line)
    end,
    updateSize = function(self, w, h)
      _class_0.__parent.__base.updateSize(self, w, h)
      self.line[2] = ([[%d,%d]]):format(0, h)
      self.line[6] = ([[%d 0 %d 1 0 1]]):format(w, w)
      return true
    end,
    animateHeight = function(self, animation, value)
      self.line[4] = ([[%g]]):format(value)
      self.needsUpdate = true
    end,
    update = function(self, inputState)
      return _class_0.__parent.__base.update(self, inputState)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, animationQueue)
      self.animationQueue = animationQueue
      _class_0.__parent.__init(self)
      local minHeight = settings['bar-height-inactive'] * 100
      local maxHeight = settings['bar-height-active'] * 100
      self.line = {
        ([[{\an1\bord0\c&H%s&\pos(]]):format(settings['bar-background']),
        0,
        [[)\fscy]],
        minHeight,
        [[\p1}m 0 0 l ]],
        0
      }
      self.animation = Animation(minHeight, maxHeight, 0.25, (function()
        local _base_1 = self
        local _fn_0 = _base_1.animateHeight
        return function(...)
          return _fn_0(_base_1, ...)
        end
      end)())
    end,
    __base = _base_0,
    __name = "ProgressBarBackground",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  ProgressBarBackground = _class_0
end
local ChapterMarker
do
  local _class_0
  local minWidth, maxWidth, minHeight, maxHeight, maxHeightFrac, beforeColor, afterColor
  local _base_0 = {
    stringify = function(self)
      return table.concat(self.line)
    end,
    updateSize = function(self, w, h)
      self.line[2] = ([[%d,%d]]):format(math.floor(self.position * w), h)
      return true
    end,
    animateSize = function(self, value)
      self.line[4] = ([[%g]]):format((maxWidth - minWidth) * value + minWidth)
      self.line[6] = ([[%g]]):format((maxHeight * maxHeightFrac - minHeight) * value + minHeight)
    end,
    update = function(self, position)
      local update = false
      if not self.passed and (position > self.position) then
        self.line[8] = afterColor
        self.passed = true
        update = true
      elseif self.passed and (position < self.position) then
        self.line[8] = beforeColor
        self.passed = false
        update = true
      end
      return update
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, position, w, h)
      self.position = position
      self.line = {
        [[{\an2\bord0\p1\pos(]],
        ([[%d,%d]]):format(math.floor(self.position * w), h),
        [[)\fscx]],
        ([[%g]]):format(minWidth),
        [[\fscy]],
        ([[%g]]):format(minHeight),
        [[\c&H]],
        beforeColor,
        [[&}m 0 0 l 1 0 1 1 0 1]]
      }
      self.passed = false
    end,
    __base = _base_0,
    __name = "ChapterMarker"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  local self = _class_0
  minWidth = settings['chapter-marker-width'] * 100
  maxWidth = settings['chapter-marker-width-active'] * 100
  minHeight = settings['bar-height-inactive'] * 100
  maxHeight = settings['bar-height-active'] * 100
  maxHeightFrac = settings['chapter-marker-active-height-fraction']
  beforeColor = settings['chapter-marker-before']
  afterColor = settings['chapter-marker-after']
  ChapterMarker = _class_0
end
local Chapters
do
  local _class_0
  local _parent_0 = Subscriber
  local _base_0 = {
    createMarkers = function(self, w, h)
      self.line = { }
      self.markers = { }
      local totalTime = mp.get_property_number('length', 0)
      local chapters = mp.get_property_native('chapter-list', { })
      for _index_0 = 1, #chapters do
        local chapter = chapters[_index_0]
        local marker = ChapterMarker(chapter.time / totalTime, w, h)
        table.insert(self.markers, marker)
        table.insert(self.line, marker:stringify())
      end
    end,
    stringify = function(self)
      return table.concat(self.line, '\n')
    end,
    redrawMarker = function(self, i)
      self.line[i] = self.markers[i]:stringify()
    end,
    redrawMarkers = function(self)
      for i, marker in ipairs(self.markers) do
        self.line[i] = marker:stringify()
      end
    end,
    updateSize = function(self, w, h)
      _class_0.__parent.__base.updateSize(self, w, h)
      for i, marker in ipairs(self.markers) do
        marker:updateSize(w, h)
        self.line[i] = marker:stringify()
      end
      return true
    end,
    animateSize = function(self, animation, value)
      for i, marker in ipairs(self.markers) do
        marker:animateSize(value)
        self.line[i] = marker:stringify()
      end
      self.needsUpdate = true
    end,
    update = function(self, inputState)
      local update = _class_0.__parent.__base.update(self, inputState)
      local currentPosition = mp.get_property_number('percent-pos', 0) * 0.01
      for i, marker in ipairs(self.markers) do
        if marker:update(currentPosition) then
          self:redrawMarker(i)
          update = true
        end
      end
      return update
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, animationQueue)
      self.animationQueue = animationQueue
      _class_0.__parent.__init(self)
      self.line = { }
      self.markers = { }
      self.animation = Animation(0, 1, 0.25, (function()
        local _base_1 = self
        local _fn_0 = _base_1.animateSize
        return function(...)
          return _fn_0(_base_1, ...)
        end
      end)())
    end,
    __base = _base_0,
    __name = "Chapters",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Chapters = _class_0
end
local TimeElapsed
do
  local _class_0
  local _parent_0 = BarAccent
  local _base_0 = {
    updateSize = function(self, w, h)
      _class_0.__parent.__base.updateSize(self, w, h)
      self.line[2] = ([[%g,%g]]):format(self.position, self.yPos)
      return true
    end,
    animatePos = function(self, animation, value)
      self.position = value
      self.line[2] = ([[%g,%g]]):format(self.position, self.yPos)
      self.needsUpdate = true
    end,
    update = function(self, inputState)
      local update = _class_0.__parent.__base.update(self, inputState)
      if update or self.hovered then
        local timeElapsed = math.floor(mp.get_property_number('time-pos', 0))
        if timeElapsed ~= self.lastTime then
          update = true
          self.line[4] = ([[%d:%02d:%02d]]):format(math.floor(timeElapsed / 3600), math.floor((timeElapsed / 60) % 60), math.floor(timeElapsed % 60))
          self.lastTime = timeElapsed
        end
      end
      return update
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, animationQueue)
      self.animationQueue = animationQueue
      _class_0.__parent.__init(self)
      self.line = {
        ([[{\fn%s\bord2\fs%d\pos(]]):format(settings.font, settings['time-font-size']),
        [[-100,0]],
        ([[)\c&H%s&\3c&H%s&\an1}]]):format(settings['elapsed-foreground'], settings['elapsed-background']),
        0
      }
      local offscreenPos = settings['elapsed-offscreen-pos']
      self.lastTime = -1
      self.position = offscreenPos
      self.animation = Animation(offscreenPos, 2, 0.25, (function()
        local _base_1 = self
        local _fn_0 = _base_1.animatePos
        return function(...)
          return _fn_0(_base_1, ...)
        end
      end)(), nil, 0.25)
    end,
    __base = _base_0,
    __name = "TimeElapsed",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  TimeElapsed = _class_0
end
local TimeRemaining
do
  local _class_0
  local _parent_0 = BarAccent
  local _base_0 = {
    updateSize = function(self, w, h)
      _class_0.__parent.__base.updateSize(self, w, h)
      self.position = self.w - self.animation.value
      self.line[2] = ([[%g,%g]]):format(self.position, self.yPos)
      return true
    end,
    animatePos = function(self, animation, value)
      self.position = self.w - value
      self.line[2] = ([[%g,%g]]):format(self.position, self.yPos)
      self.needsUpdate = true
    end,
    update = function(self, inputState)
      local update = _class_0.__parent.__base.update(self, inputState)
      if update or self.hovered then
        local timeRemaining = math.floor(mp.get_property_number('playtime-remaining', 0))
        if timeRemaining ~= self.lastTime then
          update = true
          self.line[4] = ([[–%d:%02d:%02d]]):format(math.floor(timeRemaining / 3600), math.floor((timeRemaining / 60) % 60), math.floor(timeRemaining % 60))
          self.lastTime = timeRemaining
        end
      end
      return update
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, animationQueue)
      self.animationQueue = animationQueue
      _class_0.__parent.__init(self)
      self.line = {
        ([[{\fn%s\bord2\fs%d\pos(]]):format(settings.font, settings['time-font-size']),
        [[-100,0]],
        ([[)\c&H%s&\3c&H%s&\an3}]]):format(settings['remaining-foreground'], settings['remaining-background']),
        0
      }
      local offscreenPos = settings['remaining-offscreen-pos']
      self.lastTime = -1
      self.position = offscreenPos
      self.animation = Animation(offscreenPos, 4, 0.25, (function()
        local _base_1 = self
        local _fn_0 = _base_1.animatePos
        return function(...)
          return _fn_0(_base_1, ...)
        end
      end)(), nil, 0.25)
    end,
    __base = _base_0,
    __name = "TimeRemaining",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  TimeRemaining = _class_0
end
local HoverTime
do
  local _class_0
  local rightMargin, leftMargin
  local _parent_0 = BarAccent
  local _base_0 = {
    animateAlpha = function(self, animation, value)
      self.line[4] = ([[%02X]]):format(value)
      self.needsUpdate = true
    end,
    updateSize = function(self, w, h)
      _class_0.__parent.__base.updateSize(self, w, h)
      self.yposChanged = true
    end,
    update = function(self, inputState)
      do
        local _with_0 = inputState
        local update = _class_0.__parent.__base.update(self, inputState, (self:containsPoint(_with_0.mouseX, _with_0.mouseY) and _with_0.mouseInWindow))
        if update or self.hovered then
          if _with_0.mouseX ~= self.lastX or self.sizeChanged then
            self.line[2] = ("%g,%g"):format(math.min(self.w - rightMargin, math.max(leftMargin, _with_0.mouseX)), self.yPos)
            self.sizeChanged = false
            self.lastX = _with_0.mouseX
            local hoverTime = mp.get_property_number('length', 0) * _with_0.mouseX / self.w
            if hoverTime ~= self.lastTime and (self.hovered or self.animation.isRegistered) then
              update = true
              self.line[6] = ([[%d:%02d:%02d]]):format(math.floor(hoverTime / 3600), math.floor((hoverTime / 60) % 60), math.floor(hoverTime % 60))
              self.lastTime = hoverTime
            end
          end
        end
        return update
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, animationQueue)
      self.animationQueue = animationQueue
      _class_0.__parent.__init(self)
      self.line = {
        ([[{\fn%s\bord2\fs%d\pos(]]):format(settings.font, settings['hover-time-font-size']),
        [[-100,0]],
        ([[)\c&H%s&\3c&H%s&\an2\alpha&H]]):format(settings['hover-time-foreground'], settings['hover-time-background']),
        [[FF]],
        [[&}]],
        0
      }
      self.lastTime = 0
      self.lastX = -1
      self.position = -100
      self.animation = Animation(255, 0, 0.25, (function()
        local _base_1 = self
        local _fn_0 = _base_1.animateAlpha
        return function(...)
          return _fn_0(_base_1, ...)
        end
      end)())
    end,
    __base = _base_0,
    __name = "HoverTime",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  local self = _class_0
  rightMargin = settings['hover-time-right-margin']
  leftMargin = settings['hover-time-left-margin']
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  HoverTime = _class_0
end
local PauseIndicator
do
  local _class_0
  local scaleTags
  local _base_0 = {
    stringify = function(self)
      return table.concat(self.line)
    end,
    updateSize = function(self, w, h)
      w, h = 0.5 * w, 0.5 * h
      self.line[6] = ([[%g,%g]]):format(w, h)
      self.line[14] = ([[%g,%g]]):format(w, h)
      return true
    end,
    update = function()
      return true
    end,
    animate = function(self, animation, value)
      local scale = value * 50 + 100
      local scaleStr = scaleTags:format(scale, scale)
      local alphaStr = ("%02X"):format(value * 255)
      self.line[2] = scaleStr
      self.line[10] = scaleStr
      self.line[4] = alphaStr
      self.line[12] = alphaStr
    end,
    destroy = function(self, animation)
      return self.aggregator:removeSubscriber(self.aggregatorIndex)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, queue, aggregator, paused)
      self.aggregator = aggregator
      local w, h = mp.get_osd_size()
      w, h = 0.5 * w, 0.5 * h
      self.line = {
        ([[{\an5\bord0\c&H%s&]]):format(settings['pause-indicator-background']),
        [[\fscx0\fscy0]],
        [[\alpha&H]],
        0,
        [[&\pos(]],
        ([[%g,%g]]):format(w, h),
        [[)\p1}]],
        0,
        ([[{\an5\bord0\c&H%s&]]):format(settings['pause-indicator-foreground']),
        [[\fscx0\fscy0]],
        [[\alpha&H]],
        0,
        [[&\pos(]],
        ([[%g,%g]]):format(w, h),
        [[)\p1}]],
        0
      }
      if paused then
        self.line[8] = "m 15 0 l 60 0 b 75 0 75 0 75 15 l 75 60 b 75 75 75 75 60 75 l 15 75 b 0 75 0 75 0 60 l 0 15 b 0 0 0 0 15 0 m 23 20 l 23 55 33 55 33 20 m 42 20 l 42 55 52 55 52 20\n"
        self.line[16] = [[m 0 0 l 0 75 m 23 20 l 23 55 33 55 33 20 m 42 20 l 42 55 52 55 52 20 m 75 0 l 75 75]]
      else
        self.line[8] = "m 15 0 l 60 0 b 75 0 75 0 75 15 l 75 60 b 75 75 75 75 60 75 l 15 75 b 0 75 0 75 0 60 l 0 15 b 0 0 0 0 15 0 m 23 18 l 23 57 58 37.5\n"
        self.line[16] = [[m 0 0 l 0 75 m 23 18 l 23 57 58 37.5 m 75 0 l 75 75]]
      end
      do
        local _base_1 = self
        local _fn_0 = _base_1.animate
        self.animationCb = function(...)
          return _fn_0(_base_1, ...)
        end
      end
      do
        local _base_1 = self
        local _fn_0 = _base_1.destroy
        self.finishedCb = function(...)
          return _fn_0(_base_1, ...)
        end
      end
      queue:registerAnimation(Animation(0, 1, 0.3, self.animationCb, self.finishedCb))
      return self.aggregator:addSubscriber(self)
    end,
    __base = _base_0,
    __name = "PauseIndicator"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  local self = _class_0
  scaleTags = [[\fscx%g\fscy%g]]
  PauseIndicator = _class_0
end
local Playlist
do
  local _class_0
  local _parent_0 = Subscriber
  local _base_0 = {
    updateSize = function(self, w, h)
      _class_0.__parent.__base.updateSize(self, w, h)
      self.topBox.w = w
    end,
    animatePos = function(self, animation, value)
      self.line[2] = ([[4,%g]]):format(value)
      self.needsUpdate = true
    end,
    updatePlaylistInfo = function(self)
      local title = mp.get_property('media-title', '')
      local position = mp.get_property_number('playlist-pos', 0)
      local total = mp.get_property_number('playlist-count', 1)
      self.line[4] = ([[%d/%d – %s]]):format(position + 1, total, title)
      self.needsUpdate = true
    end,
    update = function(self, inputState)
      do
        local _with_0 = inputState
        _class_0.__parent.__base.update(self, inputState, (self:containsPoint(_with_0.mouseX, _with_0.mouseY) or self.topBox:containsPoint(_with_0.mouseX, _with_0.mouseY)))
        return _with_0
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, animationQueue)
      self.animationQueue = animationQueue
      _class_0.__parent.__init(self)
      local offscreenPos = settings['title-offscreen-pos']
      self.line = {
        ([[{\an7\fn%s\bord2\fs%d\pos(]]):format(settings.font, settings['title-font-size']),
        ([[4,%g]]):format(offscreenPos),
        ([[)\c&H%s&\3c&H%s&}]]):format(settings['title-foreground'], settings['title-background']),
        0
      }
      self.topBox = Rect(0, 0, 0, settings['top-hover-zone-height'])
      self.animation = Animation(offscreenPos, 0, 0.25, (function()
        local _base_1 = self
        local _fn_0 = _base_1.animatePos
        return function(...)
          return _fn_0(_base_1, ...)
        end
      end)(), nil, 0.25)
    end,
    __base = _base_0,
    __name = "Playlist",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Playlist = _class_0
end
local aggregator = OSDAggregator()
local animationQueue = AnimationQueue(aggregator)
if settings['enable-bar'] then
  aggregator:addSubscriber(ProgressBarBackground(animationQueue))
  aggregator:addSubscriber(ProgressBar(animationQueue))
end
local chapters = nil
if settings['enable-chapter-markers'] then
  chapters = Chapters(animationQueue)
  aggregator:addSubscriber(chapters)
end
if settings['enable-elapsed-time'] then
  aggregator:addSubscriber(TimeElapsed(animationQueue))
end
if settings['enable-remaining-time'] then
  aggregator:addSubscriber(TimeRemaining(animationQueue))
end
if settings['enable-hover-time'] then
  aggregator:addSubscriber(HoverTime(animationQueue))
end
local playlist = nil
if settings['enable-title'] then
  playlist = Playlist(animationQueue)
  aggregator:addSubscriber(playlist)
end
if settings['pause-indicator'] then
  local notFrameStepping = true
  local PauseIndicatorWrapper
  PauseIndicatorWrapper = function(event, paused)
    if notFrameStepping then
      return PauseIndicator(animationQueue, aggregator, paused)
    else
      if paused then
        notFrameStepping = true
      end
    end
  end
  mp.add_key_binding('.', 'step-forward', function()
    notFrameStepping = false
    return mp.commandv('frame_step')
  end, {
    repeatable = true
  })
  mp.add_key_binding(',', 'step-backward', function()
    notFrameStepping = false
    return mp.commandv('frame_back_step')
  end, {
    repeatable = true
  })
  mp.observe_property('pause', 'bool', PauseIndicatorWrapper)
end
local initDraw
initDraw = function()
  mp.unregister_event(initDraw)
  local width, height = mp.get_osd_size()
  if chapters then
    chapters:createMarkers(width, height)
  end
  if playlist then
    playlist:updatePlaylistInfo()
  end
  return mp.command('script-message-to osc disable-osc')
end
local fileLoaded
fileLoaded = function()
  return mp.register_event('playback-restart', initDraw)
end
return mp.register_event('file-loaded', fileLoaded)
