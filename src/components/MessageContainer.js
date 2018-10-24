import React from "react";
import "./MessageContainer.css"

class MessageContainer extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            messages: [{id: 1, content: "Sup?"}, {id: 2, content: "Not much!"}]
        };
    }

    render() {
        return (
            <ul id={this.props.id}>
                {this.state.messages.map((message) => {
                    return (
                        <li key={message.id}>
                            {message.content}
                        </li>
                    )
                })}
            </ul>
        );
    }
}

export default MessageContainer;