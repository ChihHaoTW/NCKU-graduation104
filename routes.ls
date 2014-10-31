require! <[jsonfile]>

module.exports =
  init: (server) !->
    this.server = server

  getEvent: !->
    event = jsonfile.readFileSync \event.json
    this.server.get \/loadEvent (req, res) !->
      res.send event
      res.end!

  #sendReply: !->
   # this.server.post \writeReply (req, res) !->


# vi:et:ft=ls:nowrap:sw=2:ts=2
