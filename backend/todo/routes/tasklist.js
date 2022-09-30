const TaskDao = require("../models/TaskDao");

 class TaskList {
   /**
    * Handles the various APIs for displaying and managing tasks
    * @param {TaskDao} taskDao
    */
   constructor(taskDao) {
     this.taskDao = taskDao;
   }

   /*async showTasks(req, res) {
     const querySpec = {
       query: "SELECT * FROM root r WHERE r.completed=@completed",
       parameters: [
         {
           name: "@completed",
           value: false
         }
       ]
     };

     const items = await this.taskDao.find(querySpec);
     res.render("index", {
       title: "My ToDo List ",
       tasks: items
     });
   }*/

   async showIndex(req, res) {
    const querySpec = {
      query: "SELECT * FROM root r WHERE r.completed=@completed",
      parameters: [
        {
          name: "@completed",
          value: false
        }
      ]
    };

    const items = await this.taskDao.find(querySpec);
    res.render("index", {
      title: "Contralands",
      tasks: items
    });
  }

   /*async postTask(req, res){
    res.send(req)
   }*/

   /*async getAll(req, res){
    const querySpec = {
      query: "SELECT * FROM root r WHERE r.completed=@completed",
      parameters: [
        {
          name: "@completed",
          value: false
        }
      ]
    };

    const items = await this.taskDao.find(querySpec);
    res.send(items);
   }*/

   async getUser(req, res){
    const querySpec = {
      query: "SELECT * FROM root r WHERE r.username=@username" ,
      parameters: [
        {
          name: "@username",
          value: req.body.username
        }
      ]
    };

    const items = await this.taskDao.findUser(querySpec);
    res.send(items[0]);
   }

   async getWeapon(req, res){
    const querySpec = {
      query: "SELECT * FROM root r WHERE r.id=@id" ,
      parameters: [
        {
          id: "@id",
          value: req.body.id
        }
      ]
    };

    const items = await this.taskDao.findWeapon(querySpec);
    res.send(items);
   }

   async getLogin(req, res){
    const querySpec = {
      query: "SELECT * FROM root r WHERE r.username=@username and r.password=@password" ,
      parameters: [
        {
          name: "@username",
          value: req.body.username
        },
        {
          name: "@password",
          value: req.body.password
        }
      ]
    };

    const items = await this.taskDao.findUser(querySpec);
    res.send(items[0]);
   }

   /*async addTask(req, res) {
     const item = req.body;

     await this.taskDao.addItem(item);
     res.redirect("/");
   }*/

   async addUser(req, res) {
    const querySpec = {
      query: "SELECT * FROM root r WHERE r.username=@username" ,
      parameters: [
        {
          name: "@username",
          value: req.body.username
        }
      ]
    };

    const item = req.body;
    const user = await this.taskDao.findUser(querySpec);
    if(Object.keys(user).length === 0){
      await this.taskDao.addUser(item);
      res.send(item);
    }
    else
      res.send();
   }

   async addWeapon(req, res) {
    const item = req.body;

    await this.taskDao.addWeapon(item);
    res.send(item);
   }

   /*async completeTask(req, res) {
     const completedTasks = Object.keys(req.body);
     const tasks = [];

     completedTasks.forEach(task => {
       tasks.push(this.taskDao.updateItem(task));
     });

     await Promise.all(tasks);

     res.redirect("/");
   }*/
 }

 module.exports = TaskList;