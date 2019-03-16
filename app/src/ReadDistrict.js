import React from "react";

class ReadDistrict extends React.Component {
  state = { dataKey: null };

  componentDidMount() {
    const { drizzle } = this.props;
    //console.log(drizzle);
    //console.log(drizzleState);
    const contract = drizzle.contracts.Level1;

    // let drizzle know we want to watch the `myString` method
    const dataKey = contract.methods["addr"].cacheCall();

    // save the `dataKey` to local component state for later reference
    this.setState({ dataKey });
  }

  render() {
    // get the contract state from drizzleState
    const { Level1 } = this.props.drizzleState.contracts;

    // using the saved `dataKey`, get the variable we're interested in
    const addr = Level1.addr[this.state.dataKey];

    // if it exists, then we display its value
    return <p>My stored string: {addr && addr.value}</p>;
  }
}

export default ReadDistrict;
