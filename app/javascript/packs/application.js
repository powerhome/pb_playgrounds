// Support component names relative to this directory:
const componentRequireContext = require.context("components", true)
const ReactRailsUJS = require("react_ujs")
ReactRailsUJS.useContext(componentRequireContext)

import "./environment_js/fontawesome.js"
import "./environment_js/regular.js"
import "playbook/vendor.js"
