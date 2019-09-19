import React from 'react'
import PropTypes from 'prop-types'

import {
  Avatar,
  Button,
  Image,
} from 'playbook-ui'

const Hello = props => (
  <div>
    <div className="my-5">
      <Avatar
          name="Terry Johnsons"
          size="sm"
          url="https://randomuser.me/api/portraits/men/44.jpg"
      />
      <div className="my-3">
        {`Hola, ${props.name}!`}
      </div>
      <Button
          onClick={()=>{alert("Whydya push me?!")}}
          type="primary"
          text="Push It (real good)!"
      />
    </div>
    <Image url="https://unsplash.it/500/400/?image=634" />
  </div>
)

Hello.defaultProps = {
  name: 'David'
}

Hello.propTypes = {
  name: PropTypes.string
}

export default Hello
