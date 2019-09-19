import React from 'react'
import ReactDOM from 'react-dom'
import { Avatar } from 'playbook-ui'

const ReactContainer = () => (
  <div>
    <Avatar
      name="Terry Johnson"
      size="xl"
      status="offline"
      url="https://randomuser.me/api/portraits/men/44.jpg"
    />
  </div>
)

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <ReactContainer/>,
    document.getElementById("react_welcome_example"),
  )
})
