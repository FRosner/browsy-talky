import React from "react";
import "./hello.css"

class Hello extends React.Component {
    render() {
        const name = this.props.name;
        const style = this.props.highlighted ? {
            color: "red"
        } : {};
        return <p className="hello" style={style} onClick={this.props.handleHighlightGreeting(name)}>Hello from {name}</p>;
    }
}

export default Hello;