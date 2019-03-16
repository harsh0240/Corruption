import React from "react";

class SetDistrict extends React.Component {

  state = { stackId: null, v1: null, v2: null};


  handleKeyDown2 = e => {
    // if the enter key is pressed, set the value with the string
    if (e.keyCode === 13) {
      this.v1 = e.target.value;
    }
  };

  handleKeyDown2 = e => {
    // if the enter key is pressed, set the value with the string
    if (e.keyCode === 13) {
      this.v2 = e.target.value;
    }
  };

  setValue = () => {
    const { drizzle, drizzleState } = this.props;
    const contract = drizzle.contracts.Level1;

    // let drizzle know we want to call the `set` method with `value`
    const stackId = contract.methods["registerDistrict"].cacheSend(this.v1, String(this.v2), {
      from: drizzleState.accounts[0]
    });

    // save the `stackId` for later reference
    this.setState({ stackId });
  };

  getTxStatus = () => {
    // get the transaction states from the drizzle state
    const { transactions, transactionStack } = this.props.drizzleState;

    // get the transaction hash using our saved `stackId`
    const txHash = transactionStack[this.state.stackId];

    // if transaction hash does not exist, don't display anything
    if (!txHash) return null;

    // otherwise, return the transaction status
    return `Transaction status: ${transactions[txHash] && transactions[txHash].status}`;
  };

  render() {
    return (
      <div>
        <input type="text" onKeyDown={this.handleKeyDown1} />
        <input type="text" onKeyDown={this.handleKeyDown2} />
        <div>{this.getTxStatus()}</div>
      </div>
    );
  }
}

export default SetDistrict;
