pragma solidity >=0.4.23 <=0.6.0;

contract Gov {

  event ProcessAnOrder(uint idOfCustomer, uint idOrder, bool status);

  struct Item {
    uint idItem;
    bytes32 itemName;
    uint price;
  }

  struct Orderlog {
    uint idOfCustomer;
    uint idOrder;
    bool status;
  }
  event ItemAdded(uint idItem);

  uint numberOfItemsAvailableForSale;
  uint numberOfOrdersProcessed;

  mapping (uint => Item) items;
  mapping (uint => Orderlog) orderLogs;


  function addItem(bytes32 itemName, uint price) public {
    uint idItem = numberOfItemsAvailableForSale++;
    items[idItem] = Item(idItem, itemName, price);
    emit ItemAdded(idItem);
  }

  function processOrder(uint idOrder, uint idCustomer) public {
    orderLogs[idOrder] = Orderlog(idCustomer, idOrder, true);
    numberOfOrdersProcessed ++;
    emit ProcessAnOrder(idCustomer, idOrder, true);
  }

  function getItem(uint idItem) view public returns (bytes32, uint){
    return (items[idItem].itemName, items[idItem].price);
  }

  function getStatus(uint idOrder) view public returns (bool) {
    return (orderLogs[idOrder].status);
  }

  function getTotalNumberOfAvailableItems() view public returns (uint) {
    return numberOfItemsAvailableForSale;
  }

  function getTotalNumberOfOrdersProcessed() view public returns (uint){
    return numberOfOrdersProcessed;
  }

}
