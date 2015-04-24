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
  price: Number
  t-shirts: [color: String, size: String]
}
User = mongoose.model 'users', UserSchema

CounterSchema = new mongoose.Schema {
  counter:
    type: Number
    default: 0
}
Counter = mongoose.model \counter, CounterSchema

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
    start-date = new Date "4/24/2015 01:30:00"
    end-date = new Date "12/24/2015 23:59:59"
    max-amount = 27
    t-shirt-price = 349

    Counter.findOne {}, (err, counter) !->
      if counter
        console.log \counter
      else
        tmp = new Counter {counter: 0}
        tmp.save!

    @app.post \/t-shirt (req, res) !->
      cur-date = new Date!

      <-! setTimeout _, 3000
      if cur-date.getTime! < start-date.getTime! or cur-date.getTime! > end-date.getTime!
        res.send check: false, info: \不是開放時間！
        return

      (err, c) <-! Counter.findOne {}
      if c.counter >= max-amount
        res.send check: false, info: \數量已滿！
        return

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
      if obj.amount > 5
        need-return = true

      if need-return
        res.send check: false, info: "Wrong data!"
        return

      User.findOne {id: obj.id.toLowerCase!}, (err, user) !->
        if user
          check = false
          info = \您已經填過預購單了！
        else
          c.counter += obj.amount
          c.save!
          console.log c.counter

          tmp = new User {time:obj.time, name:obj.name, department:obj.department, id:obj.id.toLowerCase!, email:obj.email, phone:obj.phone, amount:obj.amount, price: obj.amount * t-shirt-price, t-shirts:obj.t-shirts}
          tmp.save!
          check = true
          info = \預購成功！
          transporter.sendMail {
            from: "國立成功大學應屆畢業生聯合會 <nckugraduation@gmail.com>"
            to: tmp.email
            subject: "畢業紀念T 預購確認信"
            html: "
            <br>
            #{obj.name} 同學您好：<br>
            <br>
            恭喜您成功預購 104級畢業紀念T-shirt， <br>
            以下是您的預購訂單：<br>
            <br>
            #{
              for i in obj.t-shirts
                "[ #{i.color}, #{i.size} ]"
            }<br>
            <br>
            總共金額為 #{obj.amount * t-shirt-price}<br>
            <br>
            以下有幾點注意事項：<br>
            1. 請三天內至郵局轉帳或匯款（請勿使用無摺存款）<br> 
            2. 填寫「<a href='http://goo.gl/gcJyl0'>2015 NCKU 畢業紀念T繳費確認</a>」表單<br>
            3. 收取畢聯會繳費成功 e-mail<br>
            <br>
            需完成以上所有事項才算預購完成！<br>
            本次畢業紀念Ｔ購買因為沒有開放現場繳費及郵寄服務，訂購順序將以填寫「2015 NCKU 畢業紀念T繳費確認」google表單之時間排序（經校對後無誤），畢聯會將於５／１１～１５開始開放現場領取，領取時間及地點將另外發文通知，逾時不候。１０４級畢業生聯合會感謝大家的配合☺ <br>
            <br>
            １０４級畢聯會官網：<a href='http://nckugraduation.tw'> http://nckugraduation.tw </a><br>
            「2015 NCKU 畢業紀念T繳費確認」google 表單：<a href='http://goo.gl/gcJyl0'> http://goo.gl/gcJyl0 </a><br>

            "
          }

        res.send check: check, info:info


# vi:et:ft=ls:nowrap:sw=2:ts=2
