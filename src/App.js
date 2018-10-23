import React, { Component } from 'react';
import logo from './logo.svg';
import './App.css';
import Hello from "./components/hello";

class App extends Component {
  constructor(props) {
    super(props);
    this.state = {
      names: [],
      highlightedGreeting: null,
      filter: ""
    };
  }

  componentDidMount() {
    fetch("https://api.github.com/users/frosner")
        .then(response => response.json())
        .then((userInfo) => {
          this.setState({
              names: [userInfo.name, "Aleks Paleks", "Oleks Poleks"]
          });
        })
  }

  handleHighlightGreeting = (name) => () => {
      this.setState({
         highlightedGreeting: name
      });
  };

  handleFilter = (event) => {
    this.setState({
        filter: event.target.value
    });
  };

  render() {
    return (
      <div className="App">
        <header className="App-header">
          <input type={"text"} placeholder={"Filter..."} value={this.state.filter} onChange={this.handleFilter} />
          <img src={logo} className="App-logo" alt="logo" />
            {this.state.names.filter((name) => name.includes(this.state.filter)).map((name) => {
              const highlighted = name === this.state.highlightedGreeting;
              return <Hello
                  key={name}
                  name={name}
                  highlighted={highlighted}
                  handleHighlightGreeting={this.handleHighlightGreeting}
              />
            })}
        </header>
      </div>
    );
  }
}

export default App;
