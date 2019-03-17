import React, { Component } from 'react';
import './App.css';
import { Grid, Row, Col, Jumbotron } from 'react-bootstrap';
import GovClient from './Gov';

class App extends Component {

  constructor(props){
    super(props);
    this.state = {}
  }

  render() {
    return (
      <div className="App">
        <Jumbotron>
          <h1>Corruption is a big no no!!</h1>
          <p>By 5 reasons why!</p>
        </Jumbotron>
        <Grid>
            <Row className="show-grid">
                <Col xs={12} md={6}>
                  <GovClient />
                </Col>
            </Row>
        </Grid>
      </div>
    );
  }
}

export default App;
