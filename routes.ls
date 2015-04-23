require! <[jsonfile body-parser fs mongoose nodemailer]>

db-pass = (fs.readFileSync \db).toString! / '\n'
mail-pass = (fs.readFileSync \mail).toString! / '\n'
mongoose.connect "mongodb://#{db-pass[0]}:#{db-pass[1]}@59.127.231.73/nckugraduation"
db = mongoose.connection
db.on 'error', console.error.bind(console, 'connection error:')

transporter = nodemailer.createTransport {
  service: \Gmail
  auth:
    user: mail-pass[0]
    pass: mail-pass[1]
}

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
    start-date = new Date "4/23/2015 23:59:00"
    max-amount = 20
    @app.post \/t-shirt (req, res) !->
      cur-date = new Date!
      if cur-date.getTime! < start-date.getTime!
        res.send check: false, info: \不是開放時間！

      <-! setTimeout _, 3000
      (err, c) <-! User.count {}
      console.log c
      if c >= max-amount
        res.send check: false, info: \數量已滿！

      obj = req.body

      need-return = false
      if obj.name is ''
        need-return = true
      if obj.id is ''
        need-return = true
      if obj.department is ''
        need-return = true
      if obj.email isnt /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
        need-return = true
      if obj.phone isnt /[0-9]{10}/
        need-return = true

      if need-return
        res.send check: false, info: "Wrong data!"

      User.findOne {id: obj.id.toLowerCase!}, (err, user) !->
        if user
          check = false
          info = \您已經填過預購單了！
        else
          tmp = new User {time:obj.time, name:obj.name, department:obj.department, id:obj.id.toLowerCase!, email:obj.email, phone:obj.phone, amount:obj.amount, t-shirts:obj.t-shirts}
          tmp.save!
          check = true
          info = \預購成功！
          transporter.sendMail {
            from: "國立成功大學應屆畢業生聯合會 <nckugraduation@gmail.com>"
            to: tmp.email
            subject: "畢業紀念T 預購確認信"
            html: "
            <br>
            #{tmp.name} 同學您好：<br>
            <br>
            "
          }

        res.send check: check, info:info


# vi:et:ft=ls:nowrap:sw=2:ts=2
