import React from "react";
import "./ChatInputForm.css"

class ChatInputForm extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            message: ""
        };
    }

    handleMessageInput = (event) => {
        this.setState({
            message: event.target.value
        });
    };


    render() {
        return (
            <form id={this.props.id} onSubmit={this.props.handleMessageSubmit(this.state.message)}>
                <input
                    className="chatTextInput"
                    type={"text"}
                    placeholder={"Say something..."}
                    value={this.state.message}
                    onChange={this.handleMessageInput}
                />
            </form>
        );
    }
}

export default ChatInputForm;