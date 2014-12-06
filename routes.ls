require! <[jsonfile body-parser]>

module.exports =
  init: (server) !->
    jsonfile.spaces = 4
    @app = server
    @app.use bodyParser.json!
    @app.use bodyParser.urlencoded {+extended}

  getEvent: !->
    event = jsonfile.readFileSync \event.json
    @app.get \/loadEvent (req, res) !->
      res.send event
      res.end!

  sendReply: !->
    @app.post \/writeReply (req, res) !->
      json-ary = jsonfile.readFileSync \comment.json
      json-ary.push req.body
      jsonfile.writeFileSync \comment.json, json-ary
      setTimeout ->
        res.send json-ary
      , 3000



# vi:et:ft=ls:nowrap:sw=2:ts=2
