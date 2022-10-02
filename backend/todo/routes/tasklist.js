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

   async showAuctioned(req, res) {
    const querySpec = {
      query: "SELECT * FROM root r WHERE r.location=@location",
      parameters: [
        {
          name: "@location",
          value: "auction_house"
        }
      ]
    };

    const items = await this.taskDao.findAuctioned(querySpec);
    res.send(items);
  }

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

   async getAll(req, res){
    const querySpec = {
      query: "SELECT * FROM root r WHERE r.owner=@owner AND r.location!=@location" ,
      parameters: [
        {
          name: "@owner",
          value: req.body.owner_username
        },
        {
          name: "@location",
          value: "auction_house"
        }
      ]
    };

    const items = await this.taskDao.findAll(querySpec);
    res.send(items);
   }

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

   async getInventory(req, res){
    const querySpec = {
      query: "SELECT * FROM root r WHERE r.owner=@owner" ,
      parameters: [
        {
          name: "@owner",
          value: req.body.owner_username
        }
      ]
    };

    const items = await this.taskDao.findInventory(querySpec);
    res.send(items);
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

   async addInventory(req, res) {
    const item = req.body;

    await this.taskDao.addInventory(item);
    res.send(item);
   }

   async addCoin(req, res) {
    const item = req.body;

    this.taskDao.updateCoin(item.id, item.coins);
    res.send();
  }

  async updateWeapon(req, res) {
    const item = req.body;

    this.taskDao.updateWeapon(item);
    res.send(item);
  }

  async switchWeapon(req, res) {
    const item = req.body;

    this.taskDao.switchWeapon(item);
    res.send(item);
  }

  async auctionWeapon(req, res) {
    const item = req.body;

    this.taskDao.auctionWeapon(item);
    res.send(item);
  }

  async sellWeapon(req, res) {
    const item = req.body;

    const buyer = await this.taskDao.sellWeapon(item);
    res.send(buyer);
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