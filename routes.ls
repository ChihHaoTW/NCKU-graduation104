require! <[jsonfile body-parser fs]>

module.exports =
  init: (server) !->
    jsonfile.spaces = 4
    @app = server
    @app.use bodyParser.json!
    @app.use bodyParser.urlencoded {+extended}

  getEvent: !->
    @app.get \/loadEvent (req, res) !->
      event = jsonfile.readFileSync \event.json
      res.send event
      res.end!

  sendReply: !->
    @app.post \/writeReply (req, res) !->
      json-ary = jsonfile.readFileSync \comment.json
      json-ary.push req.body
      jsonfile.writeFileSync \comment.json, json-ary
      setTimeout ->
        res.send req.body
        res.end!
      , 3000

  getFiles: (path, file-dir) !->
    @app.get \/loadFiles (req, res) !->
      files = fs.readdirSync path+file-dir
      res.send [ file-dir + '/' + str for str in files ]
      res.end!

  staticRouter: !->
    @app.get "/:var(home|members|contact|download)?" (req, res) !->
      res.sendfile \public/index.html


# vi:et:ft=ls:nowrap:sw=2:ts=2
