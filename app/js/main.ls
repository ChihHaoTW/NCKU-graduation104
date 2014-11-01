$ !->

  $ \#page_2 .hide!
  $ \#page_3 .hide!

  state = 3
  pre-state = 1
  count = 0
  winWidth = $ window .width!

  $.getJSON \/loadEvent (json) !->
    console.log json

    for let year in json
      for let month in year.content
        $ \#ss-container .append("
				<div class='ss-row'>
          <div class='ss-left'>
            <h2 id='#{month.month}'>#{month.month}</h2>
          </div>
          <div class='ss-right'>
            <h2>#{year.year}</h2>
          </div>
        </div>
        ")
        for let day in month.content
          event = day.content
          count_ = count++ % 2
          if count_ == 0
            $ \#ss-container .append("
              <div class='ss-row #{event.scale}'>
                <div class='ss-left'>
                  <h3>
                    <span>November 22, 2011</span>
                    <a href='#'> #{event.tittle} </a>
                  </h3>
                </div>
                <div class='ss-right'>
                  <a href='#' class='ss-circle ss-circle-3'> #{event.content} </a>
                </div>
              </div>
            ")
          else
            $ \#ss-container .append("
              <div class='ss-row #{event.scale}'>
                <div class='ss-left'>
                  <a href='#' class='ss-circle ss-circle-3'> #{event.content} </a>
                </div>
                <div class='ss-right'>
                </div>
              </div>
            ")

    scroll!

  for let i from 1 to state
    $('#icon_'+i).click !->
      return if i == pre-state

      pre-state_ = pre-state
      pre-state := i

      $ "\#page_#i" .show!
      $('#icon_'+i).addClass \active
      $('#icon_'+i).addClass \red
      $('#icon_'+pre-state_).removeClass \active
      $('#icon_'+pre-state_).removeClass \red

      if i == 1
        $ "\#page_#pre-state_" .hide!
        <- $ \#book .animate {right: $('#page_'+i).position!.left}, 500
        $ \#ss-links .animate {left: "10px"}, 100
      else if pre-state_ == 1
        $ \#ss-links .animate {left: "-#{$ \#ss-links .width!}"}, 100
        $ \#book .animate {right: $('#page_'+i).position!.left}, 500
        $ "\#page_#pre-state_" .hide!
      else
        $ \#book .animate {right: $('#page_'+i).position!.left}, 500
        $ "\#page_#pre-state_" .hide!

      console.log winWidth

  $ \.info .click !->
    mask!

  resize!

mask = ->
  $ \body .append "<div id='mask'></div>"
  $ \#mask .animate {opacity:"0.3"}
  $ \#mask .click ->
    <- $ \#mask .animate {opacity:"0"}
    $ \#mask .remove!

# vi:et:ft=ls:nowrap:sw=2:ts=2
