pragma solidity >=0.4.23 <=0.6.0;
contract Customer {

  event OrderRaisedOrUpdated(uint idOrder);

  struct AvailableCustomer {
    uint idCustomer;
    bytes32 customerName;
  }

  struct Orderlog {
    uint idOrder;
    uint idCustomer;
    bytes32 itemName;
    uint quantity;
    bool status;
  }

  uint numberOfItemsPurchased;
  uint numberOfItemsReceived;

  mapping (uint => AvailableCustomer) customers;
  mapping (uint => Orderlog) orderLogs;

  constructor() public {
      customers[0] = AvailableCustomer(1, "John Snow");
  }

  function purchaseItem(bytes32 itemName, uint quantity) public {
    uint idOrder = numberOfItemsPurchased++;
    orderLogs[idOrder] = Orderlog(idOrder, 0, itemName, quantity, false);
    emit OrderRaisedOrUpdated(idOrder);
  }

  function recieveItem(uint idOrder) public {
      numberOfItemsReceived++;
      orderLogs[idOrder].status = true;
      emit OrderRaisedOrUpdated(idOrder);
  }

  function getOrderDetails(uint idOrder) view public returns (bytes32, uint, bool){
    return (orderLogs[idOrder].itemName, orderLogs[idOrder].quantity, orderLogs[idOrder].status);
  }

  function getNumberOfItemsPurchased() view public returns (uint) {
    return numberOfItemsPurchased;
  }

  function getNumberOfItemsReceived() view public returns (uint) {
    return numberOfItemsReceived;
  }

}
