$ !->

  state = 3
  pre-state = 1
  winWidth = $ window .width!

  $ window .onscroll = ->
    $ window .scrollTo 0,0

  $.getJSON \/loadEvent (json) !->
    console.log json
    for let event in json
      console.log event
      $ \#ss-container .append("
        <div class='ss-row ss-large'>
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
    scroll!

  for let i from 1 to state
    $('#icon_'+i).click !->
      return if i == pre-state

      if i == 1
        <- $ \#book .animate {right: $('#page_'+i).position!.left}, 500
        $ \#ss-links .animate {left: "10px"}, 100
      else if pre-state == 1
        $ \#book .animate {right: $('#page_'+i).position!.left}, 500
        $ \#ss-links .animate {left: "-#{$ \#ss-links .width!}"}, 500
      else
        $ \#book .animate {right: $('#page_'+i).position!.left}, 500

      $('#icon_'+i).addClass \active
      $('#icon_'+pre-state).removeClass \active
      pre-state := i
      console.log winWidth

  resize!



# vi:et:ft=ls:nowrap:sw=2:ts=2
