
profile-map =
  \1 :
    \office : \會長
    \name : \李念庭
    \color : \#2EA7E0
  \2 :
    \office : \副會長
    \name : \陳沛瑾
    \color : \#2EA7E0
  \3 :
    \office : \財務秘書
    \name : \王芷苑
    \color : \#2EA7E0
  \4 :
    \office : \行政秘書
    \name : \湯又明
    \color : \#2EA7E0
  \5 :
    \office : \活動部長
    \name : \賴弈豪
    \color : \#F39800
  \6 :
    \office : \活動部長
    \name : \陳侑新
    \color : \#F39800
  \7 :
    \office : \宣傳部長
    \name : \薛智豪
    \color : \#E61673
  \8 :
    \office : \宣傳部長
    \name : \郭芳萍
    \color : \#E61673
  \9 :
    \office : \編輯部長
    \name : \吳泓瑞
    \color : \#C30D23
  \10 :
    \office : \編輯部長
    \name : \彭霆博
    \color : \#C30D23
  \11 :
    \office : \公關學術部
    \name : \劉力慈
    \color : \#43B9AE
  \12 :
    \office : \公關學術部
    \name : \楊子平
    \color : \#43B9AE
  \13 :
    \office : \畢典負責人
    \name : \陳貞霓
    \color : \#74BB32

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
                    <a> #{event.tittle} </a>
                  </h3>
                </div>
                <div class='ss-right'>
                  <a class='ss-circle ss-circle-3'> #{event.content} </a>
                </div>
              </div>
            ")
          else
            $ \#ss-container .append("
              <div class='ss-row #{event.scale}'>
                <div class='ss-left'>
                  <a class='ss-circle ss-circle-3'> #{event.content} </a>
                </div>
                <div class='ss-right'>
                  <h3>
                    <span>November 22, 2011</span>
                    <a> #{event.tittle} </a>
                  </h3>
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
        $ \#book .animate {right: $('#page_'+i).position!.left}, 500
        # $ \#ss-links .animate {left: "10px"}, 100
      else if pre-state_ == 1
        # $ \#ss-links .animate {left: "-#{$ \#ss-links .width!}"}, 100
        $ \#book .animate {right: $('#page_'+i).position!.left}, 500
        $ "\#page_#pre-state_" .hide!
      else
        $ \#book .animate {right: $('#page_'+i).position!.left}, 500
        $ "\#page_#pre-state_" .hide!

      if i == 2
        css!

      console.log winWidth

  #$ \.info .click !->
  #  mask!

  resize!
  reply!
  profile!

mask = ->
  $ \body .append "<div id='mask'></div>"
  $ \#mask .animate {opacity:"0.3"}
  $ \#mask .click ->
    <- $ \#mask .animate {opacity:"0"}
    $ \#mask .remove!

profile = ->
  for let i from 1 to 12

    $ "\#name-#i p" .text profile-map[(($ "\#profile-#i" .children \img .attr \id) / \-).1][\name] .css \color, profile-map[(($ "\#profile-#i" .children \img .attr \id) / \-).1][\color]

    if i % 2 == 1
      $ "\#profile-#i" .css \borderTopColor, profile-map[(($ "\#profile-#i" .children \img .attr \id) / \-).1][\color]
    else
      $ "\#profile-#i" .css \borderBottomColor, profile-map[(($ "\#profile-#i" .children \img .attr \id) / \-).1][\color]

    $ "\#profile-#i" .click !->
      new-id = (($ @ .children \img .attr \id) / \-).1
      old-id = (($ "\#profile-0" .children \img .attr \id) / \-).1

      if i % 2 == 1
        <- $ @ .children \img .animate {top:\-60vh}
        do
          <- $ "\#cur-profile .name, \#cur-profile .office" .animate {opacity: 0}
          $ "\#cur-profile .name" .text profile-map[new-id][\name]
          $ "\#cur-profile .office" .text profile-map[new-id][\office]
          $ @ .animate {opacity: 1}
        <- $ "\#profile-0 img" .animate {left:- $ "\#profile-0 img" .width!*2 + \px}
        $ "\#profile-#i" .append($ "\#profile-0 img" .detach!)
        $ "\#profile-0" .append($ "\#profile-#i img:first-child" .detach!)
        $ "\#profile-#i img" .css {left: "", top:\-60vh}
        $ "\#profile-0 img" .css {left:- $ "\#profile-0 img" .width!*2 + \px, top:""}
        $ "\#profile-0 img" .animate {left:""}
        $ "\#profile-#i img" .animate {top:""}
        $ "\#profile-#i" .animate {borderTopColor: profile-map[old-id][\color]}
      else
        <- $ @ .children \img .animate {bottom:\-60vh}
        do
          <- $ "\#cur-profile .name, \#cur-profile .office" .animate {opacity: 0}
          $ "\#cur-profile .name" .text profile-map[new-id][\name]
          $ "\#cur-profile .office" .text profile-map[new-id][\office]
          $ @ .animate {opacity: 1}
        <- $ "\#profile-0 img" .animate {left:- $ "\#profile-0 img" .width!*2 + \px}
        $ "\#profile-#i" .append($ "\#profile-0 img" .detach!)
        $ "\#profile-0" .append($ "\#profile-#i img:first-child" .detach!)
        $ "\#profile-#i img" .css {left: "", bottom:\-60vh}
        $ "\#profile-0 img" .css {left:- $ "\#profile-0 img" .width!*2 + \px, bottom:""}
        $ "\#profile-0 img" .animate {left:""}
        $ "\#profile-#i img" .animate {bottom:""}
        $ "\#profile-#i" .animate {borderBottomColor: profile-map[old-id][\color]}

pro = ->
  for let i from 1 to 13
    $ "\#col#i" .click !->
      col-height = $ "\#col1" .height!
      do
        <- $ "\#info img" .animate {left:- $ @ .width!*2 + \px}
        $ \#info .empty!
      $ \#info .height col-height
      $ \#info .css \margin-top, -col-height/2+25
      for let j from 1 to 13
        if j == i
          if j % 2 == 1
            <- $ "\#col#j" .animate {top:\-60vh}
            $ @ .children \a .children \div .children \img .clone! .css(\left, - $ @ .width!*5 + \px) .appendTo $ \#info
            $ "\#info img" .animate {left:\10%}
          else
            <- $ "\#col#j" .animate {bottom:\-60vh}
            $ @ .children \a .children \div .children \img .clone! .css(\left, - $ @ .width!*5 + \px) .appendTo $ \#info
            $ "\#info img" .animate {left:\10%}
        else if j % 2 == 1
          $ "\#col#j" .delay 50*j .animate {top:-col-height/2 + \px}
        else
          $ "\#col#j" .delay 50*j .animate {bottom:-col-height/2 + \px}
        $ "\#col#j" .animate {opacity:"0.5"}

reply-click = true
reply = ->
  $ \#reply .click ->
    return if not reply-click
    temp =
      name: $ \#name .val!
      department: $ \#department .val!
      email: $ \#email .val!
      comment: $ \#comment .val!

    console.log temp

    $.ajax {
      type: \POST
      url: \/writeReply
      contentType: \application/json
      data: JSON.stringify temp
      beforeSend: ->
        reply-click := false
        $ \#reply .addClass \loading
      success: ->
        console.log "Post success!"
        $ \#reply .removeClass \loading .text \DONE! .css \cursor, \default
      complete: ->
        $ \#name .val ''
        $ \#department .val ''
        $ \#email .val ''
        $ \#comment .val ''
        setTimeout ->
          $ \#reply .text \Reply .css \cursor, \pointer
          reply-click := true
        , 3000
    }

css = ->
  $ \#profile-content .css \height, \100%
  $ \#profile-content .css(\height, $ \#profile-content .height! - 12)


# vi:et:ft=ls:nowrap:sw=2:ts=2
