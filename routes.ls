require! <[jsonfile body-parser fs mongoose]>

db-pass = (fs.readFileSync \db).toString! / '\n'
mongoose.connect "mongodb://#{db-pass[0]}:#{db-pass[1]}@59.127.231.73/nckugraduation"
db = mongoose.connection
db.on 'error', console.error.bind(console, 'connection error:')

UserSchema = new mongoose.Schema {
  time: Date
  name: String
  department: String
  id: String
  email: String
  phone: String
  amount: Number
  t-shirts: [color: String, size: String]
}
User = mongoose.model 'users', UserSchema

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
    @app.get "/:var(home|members|contact|download|t-shirt)?" (req, res) !->
      res.sendfile \public/index.html

  t-shirt: !->
    @app.post \/t-shirt (req, res) !->
      console.log req.body
      obj = req.body
      User.findOne {id: obj.id.toLowerCase!}, (err, user) !->
        if user
          info = \您已經填過預購單了！
        else
          tmp = new User {time:obj.time, name:obj.name, department:obj.department, id:obj.id.toLowerCase!, email:obj.email, phone:obj.phone, amount:obj.amount, t-shirts:obj.t-shirts}
          tmp.save!
          info = \預購成功！

        res.send info:info


# vi:et:ft=ls:nowrap:sw=2:ts=2
