import React from 'react'
import ReactDOM from 'react-dom'

import Hello from "./hello_react.jsx";

const ReactContainer = () => (
  <div>
    <h3>React Kits</h3>
    <Hello name="Jason Cyprets" />
  </div>
)

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <ReactContainer/>,
    document.getElementById("react"),
  )
})