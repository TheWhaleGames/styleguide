---
---
do ($ = jQuery, window, document) ->
  pluginName = 'lazyduck'

  defaults = 
    srcset:
      breakpoint: 768
      large: 'data-src-large'
      small: 'data-src-small'
    delay: 50
    threshold: '50%'

  class LazyDuck
    constructor: (@element, options) ->
      @settings = $.extend {}, defaults, options
      @initialize()

    initialize: ->
      @setViewport()
      @throttledRun = if @settings.delay then @throttle(@run, @settings.delay) else @run
      @throttledRun()
      $(window).on 'lazyduck', (e) =>
        @throttledRun()
      $(window).on 'scroll.lazyduck', (e) =>
        @throttledRun()
      $(window).on 'resize.lazyduck', (e) =>
        @setViewport()
        @throttledRun()

    setViewport: ->
      @viewportHeight = window.innerHeight || document.documentElement.clientHeight
      @viewportWidth = window.innerWidth || document.documentElement.clientWidth
      @setThreshold()

    setThreshold: ->
      matches = @settings.threshold.toString().match(/^\s*(\d+)\s*(px|%)?\s*$/)
      if !matches || !matches.length
        console.error('number of px or %')
        return

      value = matches[1]
      unit = matches[2]

      if unit == '%'
        @thresholdHeight = Math.floor(@viewportHeight * value / 100)
        @thresholdWidth = Math.floor(@viewportWidth * value / 100)
      else
        @thresholdHeight = @thresholdWidth = value

    inview: (element) ->
      # if @getStyle(element).display == 'none'
      if !$(element).is(":visible")
        return false
      wt = $(window).scrollTop()
      wb = wt + $(window).height()
      et = $(element).offset().top
      eb = et + $(element).height()
      return eb >= wt - @thresholdHeight && et <= wb + @thresholdHeight

    getStyle: (element) ->
      if window.getComputedStyle
        getComputedStyle(element)
      else
        element.currentStyle

    run: ->
      unless @inview(@element)
        return
      if @viewportWidth >= @settings.srcset.breakpoint
        src = @element.getAttribute(@settings.srcset.large)
      else
        src = @element.getAttribute(@settings.srcset.small)

      tagName = @element.tagName.toLowerCase()
      if tagName == 'img'
        @element.setAttribute('src', src)
      else
        @element.style.backgroundImage = "url(#{src})"

    throttle: (fn, delay) ->
      return ->
        if timer
          clearTimeout(timer)
        timer = setTimeout(fn.bind(@), delay)

  $.fn.lazyduck = (options) ->
    @each ->
      unless $.data @, "plugin_#{pluginName}"
        $.data @, "plugin_#{pluginName}", new LazyDuck @, options
