

import React, { Component } from 'react';
import { GovContract, customerContract, web3 } from "./EthereumSetup";
import { Grid, Row, Col, Panel, Tabs, Tab, FormGroup, InputGroup, Button, FormControl, Table } from 'react-bootstrap';
import './index.css'
class GovsClient extends Component {

    constructor(props) {
        super(props);
        this.state = {
            GovContract_blockchainRecordedItemIds: [],
            GovContract_blockchainRecordedPurchaseOrderServices: [],
            customerContract_blockchainRecordedPurchaseOrderIds: []
        }

        /* event listeners */
        this.GovContract_itemAddedEvents = GovContract.ItemAdded({}, {
            fromBlock: 0,
            toBlock: 'latest'
        });

        this.GovContract_processAnOrderEvents = GovContract.ProcessAnOrder({}, {
            fromBlock: 0,
            toBlock: 'latest'
        });

        this.customerContract_orderRaisedEvents = customerContract.OrderRaisedOrUpdated({}, {
            fromBlock: 0,
            toBlock: 'latest'
        });

        /* Getters */
        this.GovContract_getTotalNumberOfAvailableItems = this.GovContract_getTotalNumberOfAvailableItems.bind(this);
        this.GovContract_getTotalNumberOfOrdersProcessed = this.GovContract_getTotalNumberOfOrdersProcessed.bind(this);
        this.customerContract_getOrderDetails = this.customerContract_getOrderDetails.bind(this);

        /* transactions */
        this.GovContract_addItem = this.GovContract_addItem.bind(this);
        this.GovContract_processOrder = this.GovContract_processOrder.bind(this);
        this.customerContract_recieveItem = this.customerContract_recieveItem.bind(this);

        this.triggerGovContractEventListeners = this.triggerGovContractEventListeners.bind(this);
        this.addNewItemToMarketByGov = this.addNewItemToMarketByGov.bind(this);
    }

    componentDidMount(){
        this.triggerGovContractEventListeners();
    }

    triggerGovContractEventListeners() {
        this.GovContract_itemAddedEvents.watch((err, eventLogs) => {
            if (err) {
                console.error('[Event Listener Error]', err);
            } else {
                this.setState({
                    GovContract_blockchainRecordedItemIds: [...this.state.GovContract_blockchainRecordedItemIds,
                        parseInt(eventLogs.args.idItem.toString())
                    ]
                });
            }
        })
        this.GovContract_processAnOrderEvents.watch((err, eventLogs) => {
            if (err) {
                console.error('[Event Listener Error]', err);
            } else {
                console.log('[Event Logs]', eventLogs);
                this.setState({
                    GovContract_blockchainRecordedPurchaseOrderServices: [...this.state.GovContract_blockchainRecordedPurchaseOrderServices,
                        {
                            'idOfCustomer': parseInt(eventLogs.args.idOfCustomer.toString()),
                            'idOrder': parseInt(eventLogs.args.idOrder.toString()),
                            'status': eventLogs.args.status
                        }
                    ]
                });
            }
        })

        this.customerContract_orderRaisedEvents.watch((err, eventLogs) => {
            if (err) {
                console.error('[Event Listener Error]', err);
            } else {
                console.log('[Event Logs]', eventLogs);
                if (this.state.customerContract_blockchainRecordedPurchaseOrderIds.indexOf(parseInt(eventLogs.args.idOrder.toString()))  === -1){
                    alert(eventLogs.args.idOrder)
                    this.setState({
                        customerContract_blockchainRecordedPurchaseOrderIds: [...this.state.customerContract_blockchainRecordedPurchaseOrderIds,
                            parseInt(eventLogs.args.idOrder.toString())
                        ]
                    });
                }
            }
        });
    }

    GovContract_getTotalNumberOfAvailableItems() {
        return GovContract.getTotalNumberOfAvailableItems.call();
    }
    GovContract_getTotalNumberOfOrdersProcessed() {
        return GovContract.getTotalNumberOfOrdersProcessed.call();
    }
    customerContract_getOrderDetails(idOrder) {
        return customerContract.getOrderDetails.call(idOrder);
    }

    GovContract_addItem(itemName, price) {
        GovContract.addItem(itemName, price, {
            from: web3.eth.accounts[0]
        }, (err, results) => {
            if (err) {
                console.error('[Gov Contract] Error during adding new item to marketPlace', err);
            } else {
                console.log('[Gov Contract] - New Item added to Marketplace', results.toString());
            }
        });
    }
    GovContract_processOrder(idOrder, idCustomer) {
        GovContract.processOrder(idOrder, idCustomer, {
            from: web3.eth.accounts[0]
        }, (err, results) => {
            if (err) {
                console.error('[Gov Contract] Error during procesing an order', err);
            } else {
                console.log('[Gov Contract] - order successfully processed by Gov', results.toString());
            }
        });
    }

    customerContract_recieveItem(idOrder) {
        customerContract.recieveItem(idOrder, {
            from: web3.eth.accounts[0]
        }, (err, results) => {
            if (err) {
                console.error('[Customer Contract] Error during recieving a processed item', err);
            } else {
                console.log('[Customer Contract] - Item successfully recieved by Customer', results.toString());
            }
        });
    }

    addNewItemToMarketByGov(e){
        e.preventDefault();
        const itemName = e.target.elements.itemName.value;
        const price = e.target.elements.price.value;
        this.GovContract_addItem(itemName, price);
    }

    render(){
        return (
            <div>
                <Grid>
                    <Row className="show-grid">
                        <Col xs={12} md={6}>
                        <Panel>
                            <Panel.Heading>Gov Section</Panel.Heading>
                            <Panel.Body>
                                <Tabs defaultActiveKey={1} id="uncontrolled-tab-example">
                                    <Tab eventKey={1} title="Contract to publish">
                                    <br/> <br/>
                                        <form onSubmit={this.addNewItemToMarketByGov}>
                                            <FormGroup>
                                            <InputGroup>
                                                <InputGroup.Button>
                                                <Button>Contract Name </Button>
                                                </InputGroup.Button>
                                                <FormControl ref="itemName" name="itemName" placeholder="" type="text"/>
                                            </InputGroup>

                                            <InputGroup>
                                                <InputGroup.Button>
                                                <Button>Tokens <small></small></Button>
                                                </InputGroup.Button>
                                                <FormControl ref="price" name="price" placeholder="" type="number"/>
                                            </InputGroup>
                                            </FormGroup>

                                            <FormGroup>
                                            <Button bsStyle="primary" label="Login" id="loginButton" type="submit" active>Publish!</Button>
                                            </FormGroup>
                                        </form>
                                    </Tab>
                                    <Tab eventKey={2} title="Validate">
                                        <h4>Validate</h4>
                                        <small>Click on tender to validate it!</small>
                                        <Table striped bordered condensed hover>
                                            <thead>
                                                <tr>
                                                <th>Order ID</th>
                                                <th>Customer Name</th>
                                                <th>Item Name</th>
                                                <th>Quantity</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                {this.state.customerContract_blockchainRecordedPurchaseOrderIds.map(orderId => {
                                                const orderDetails = this.customerContract_getOrderDetails(orderId);
                                                const orderedItemName = web3.toUtf8(String(orderDetails).split(',')[0]);
                                                const orderedItemQuantity = parseInt(String(orderDetails).split(',')[1]);

                                                return (<tr className="pointIt" onClick={() => this.GovContract_processOrder(orderId, 1)}>
                                                    <td>
                                                    {orderId}
                                                    </td>
                                                    <td>
                                                    John Snow
                                                    </td>
                                                    <td>
                                                    {orderedItemName}
                                                    </td>
                                                    <td>
                                                    {orderedItemQuantity}
                                                    </td>
                                                </tr>);
                                                }
                                            )}
                                            </tbody>
                                            </Table>

                                            <h4>Published contracts</h4>
                                            <Table striped bordered condensed hover>
                                                <thead>
                                                    <tr>
                                                    <th>Order ID</th>
                                                    <th>Customer Name</th>
                                                    <th>Order Completed</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    {this.state.GovContract_blockchainRecordedPurchaseOrderServices.map(po => {
                                                    return (<tr>
                                                        <td>
                                                        {po.idOrder}
                                                        </td>
                                                        <td>
                                                        John Snow
                                                        </td>
                                                        <td>
                                                        {po.status === true ? 'Completed' : 'InProgress'}
                                                        </td>
                                                    </tr>);
                                                    }
                                                )}
                                                </tbody>
                                            </Table>
                                    </Tab>
                                    </Tabs>
                            </Panel.Body>
                        </Panel>
                        </Col>
                    </Row>
                </Grid>
            </div>
        )
    }

}

export default GovsClient;
