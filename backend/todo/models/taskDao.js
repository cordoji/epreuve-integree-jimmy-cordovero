// @ts-check
const CosmosClient = require('@azure/cosmos').CosmosClient
const debug = require('debug')('todo:taskDao')

// For simplicity we'll set a constant partition key
const partitionKey = undefined
class TaskDao {
  /**
   * Manages reading, adding, and updating Tasks in Cosmos DB
   * @param {CosmosClient} cosmosClient
   * @param {string} databaseId
   * @param {string} containerUserId
   * @param {string} containerWeaponId
   * @param {string} containerInventoryId
   * @param {string} containerEquipmentId
   * @param {string} containerAuctionHouseId
   */
  constructor(cosmosClient, databaseId, containerUserId, containerWeaponId, containerInventoryId, containerEquipmentId, containerAuctionHouseId) {
    this.client = cosmosClient
    this.databaseId = databaseId
    this.collectionUserId = containerUserId
    this.collectionWeaponId = containerWeaponId
    this.collectionInventoryId = containerInventoryId
    this.collectionEquipementId = containerEquipmentId
    this.collectionAuctionHouseId = containerAuctionHouseId

    this.database = null
    this.userContainer = null
    this.weaponContainer = null
    this.inventoryContainer = null
    this.equipmentContainer = null
    this.auctionHouseContainer = null
  }

  async init() {
    debug('Setting up the database...')
    const dbResponse = await this.client.databases.createIfNotExists({
      id: this.databaseId
    })
    this.database = dbResponse.database
    debug('Setting up the database...done!')

    const coResponseUser = await this.database.containers.createIfNotExists({
      id: this.collectionUserId
    })
    this.userContainer = coResponseUser.container

    const coResponseWeapon = await this.database.containers.createIfNotExists({
      id: this.collectionWeaponId
    })
    this.weaponContainer = coResponseWeapon.container

    const coResponseInventory = await this.database.containers.createIfNotExists({
      id: this.collectionInventoryId
    })
    this.inventoryContainer = coResponseInventory.container

    const coResponseEquipment = await this.database.containers.createIfNotExists({
      id: this.collectionEquipementId
    })
    this.equipmentContainer = coResponseEquipment.container

    const coResponseAuctionHouse = await this.database.containers.createIfNotExists({
      id: this.collectionAuctionHouseId
    })
    this.auctionHouseContainer = coResponseAuctionHouse.container
  }

  async findUser(querySpec) {
    debug('Querying for users from the database')
    if (!this.userContainer) {
      throw new Error('Collection is not initialized.')
    }
    const { resources } = await this.userContainer.items.query(querySpec).fetchAll()
    return resources
  }

  async findWeapon(querySpec) {
    debug('Querying for weapons from the database')
    if (!this.weaponContainer) {
      throw new Error('Collection is not initialized.')
    }
    const { resources } = await this.weaponContainer.items.query(querySpec).fetchAll()
    return resources
  }

  /*async addItem(item) {
    debug('Adding an item to the database')
    item.date = Date.now()
    item.completed = false
    const { resource: doc } = await this.container.items.create(item)
    return doc
  }*/

  async addUser(item) {
    debug('Adding a user to the database')
    item.date = Date.now()
    const { resource: doc } = await this.userContainer.items.create(item)
    return doc
  }

  async addWeapon(item) {
    debug('Adding a weapon to the database')
    item.date = Date.now()
    const { resource: doc } = await this.weaponContainer.items.create(item)
    return doc
  }

  async addInventory(item) {
    debug('Adding a weapon to the inventory in the database')
    item.date = Date.now()
    const { resource: doc } = await this.inventoryContainer.items.create(item)
    return doc
  }

  /*async updateItem(itemId) {
    debug('Update an item in the database')
    const doc = await this.getItem(itemId)
    doc.completed = true

    const { resource: replaced } = await this.container
      .item(itemId, partitionKey)
      .replace(doc)
    return replaced
  }*/

  async updateUser(itemId) {
    debug('Update a user in the database')
    const doc = await this.getUser(itemId)
    doc.completed = true

    const { resource: replaced } = await this.userContainer
      .item(itemId, partitionKey)
      .replace(doc)
    return replaced
  }

  async updateWeapon(itemId) {
    debug('Update a weapon in the database')
    const doc = await this.getWeapon(itemId)
    doc.completed = true

    const { resource: replaced } = await this.weaponContainer
      .item(itemId, partitionKey)
      .replace(doc)
    return replaced
  }

  /*async getItem(itemId) {
    debug('Getting an item from the database')
    const { resource } = await this.container.item(itemId, partitionKey).read()
    return resource
  }*/

  async getUser(itemId) {
    debug('Getting a user from the database')
    const { resource } = await this.userContainer.item(itemId, partitionKey).read()
    return resource
  }

  async getWeapon(itemId) {
    debug('Getting a weapon from the database')
    const { resource } = await this.weaponContainer.item(itemId, partitionKey).read()
    return resource
  }
}

module.exports = TaskDao