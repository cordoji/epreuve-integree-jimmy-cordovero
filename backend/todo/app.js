const CosmosClient = require('@azure/cosmos').CosmosClient
 const config = require('./config')
 const TaskList = require('./routes/tasklist')
 const TaskDao = require('./models/taskDao')

 const express = require('express')
 const path = require('path')
 const logger = require('morgan')
 const cookieParser = require('cookie-parser')
 const bodyParser = require('body-parser')

 const app = express()

 // view engine setup
 app.set('views', path.join(__dirname, 'views'))
 app.set('view engine', 'jade')

 // uncomment after placing your favicon in /public
 //app.use(favicon(path.join(__dirname, 'public', 'favicon.ico')));
 app.use(logger('dev'))
 app.use(bodyParser.json())
 app.use(bodyParser.urlencoded({ extended: false }))
 app.use(cookieParser())
 app.use(express.static(path.join(__dirname, 'public')))

 //Todo App:
 const cosmosClient = new CosmosClient({
   endpoint: config.host,
   key: config.authKey
 })
 const taskDao = new TaskDao(
  cosmosClient, 
  config.databaseId, 
  config.containerUserId, 
  config.containerWeaponId, 
  config.containerInventoryId,
  config.containerEquipmentId,
  config.containerAuctionHouseId)

 const taskList = new TaskList(taskDao)
 taskDao
   .init(err => {
     console.error(err)
   })
   .catch(err => {
     console.error(err)
     console.error(
       'Shutting down because there was an error settinig up the database.'
     )
     process.exit(1)
   })

 app.get('/', (req, res, next) => taskList.showIndex(req, res).catch(next))
 app.get('/auctioned', (req, res, next) => taskList.showAuctioned(req, res).catch(next))
 app.post('/inventory', (req, res, next) => taskList.getInventory(req, res).catch(next))
 app.post('/all', (req, res, next) => taskList.getAll(req, res).catch(next))

 //app.get('/all', (req, res, next) => taskList.getAll(req, res).catch(next))
 app.post('/user', (req, res, next) => taskList.getUser(req, res).catch(next))
 app.post('/weapon', (req, res, next) => taskList.getWeapon(req, res).catch(next))
 app.post('/login', (req, res, next) => taskList.getLogin(req, res).catch(next))
 //app.post('/addtask', (req, res, next) => taskList.addTask(req, res).catch(next))
 app.post('/adduser', (req, res, next) => taskList.addUser(req, res).catch(next))
 app.post('/addweapon', (req, res, next) => taskList.addWeapon(req, res).catch(next))
 app.post('/addinventory', (req, res, next) => taskList.addInventory(req, res).catch(next))
 app.post('/addcoin', (req, res, next) => taskList.addCoin(req, res).catch(next))
 app.post('/updateweapon', (req, res, next) => taskList.updateWeapon(req, res).catch(next))
 app.post('/switchweapon', (req, res, next) => taskList.switchWeapon(req, res).catch(next))
 app.post('/auction', (req, res, next) => taskList.auctionWeapon(req, res).catch(next))
 app.post('/sell', (req, res, next) => taskList.sellWeapon(req, res).catch(next))
 //app.post('/addtask', (req, res, next) => taskList.postTask(req, res).catch(next))
 /*app.post('/completetask', (req, res, next) =>
   taskList.completeTask(req, res).catch(next)
 )*/
 app.set('view engine', 'jade')

 // catch 404 and forward to error handler
 app.use(function(req, res, next) {
   const err = new Error('Not Found')
   err.status = 404
   next(err)
 })

 // error handler
 app.use(function(err, req, res, next) {
   // set locals, only providing error in development
   res.locals.message = err.message
   res.locals.error = req.app.get('env') === 'development' ? err : {}

   // render the error page
   res.status(err.status || 500)
   res.render('error')
 })

 module.exports = app