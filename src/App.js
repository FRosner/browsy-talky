import React, { Component } from 'react';
import './App.css';
import ChatInputForm from "./components/ChatInputForm";
import MessageContainer from "./components/MessageContainer";

class App extends Component {
  componentDidMount() {
    fetch("https://api.github.com/users/frosner")
        .then(response => response.json())
        .then((userInfo) => {
          this.setState({
              names: [userInfo.name, "Aleks Paleks", "Oleks Poleks"]
          });
        })
  }

  handleMessageSubmit = (message) => (event) => {
    event.preventDefault();
    console.log(message); // TODO send message to server
  };

  render() {
    return (
      <div>
          <ChatInputForm id={"mainChatInputForm"} handleMessageSubmit={this.handleMessageSubmit}/>
          <MessageContainer id={"mainMessageContainer"}/>
      </div>
    );
  }
}

export default App;
