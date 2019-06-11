# Playgrounds

Playground for Playbook UI Kits


## Getting Started

```bash
# ruby version 2.5.0
bundle install
```

```bash
# node version 8.9.4
yarn install --check-files
```

```bash
# Run your server
rails s
```

View prototype on [http://localhost:3000](http://localhost:3000).



## New Prototype
```bash
# Always start from master
git checkout origin master
```

```bash
# pull latest master branch locally
git pull origin master
```

```bash
# create a new prototype branch
git checkout -b demo/my-prototype-name
```

```bash
# push new prototype up to start a pull request for team review
git push origin demo/my-prototype-name
```

---

# Help

<details><summary>Adding new pages</summary>
<p>
  
## Adding New Pages
When you start the server, the root page is [index.html.erb](https://github.com/powerhome/playgrounds/blob/master/app/views/pages/index.html.erb).

If you have a multi-page prototype, you will want to add additional pages.  Please follow the guide below:

### 1. Create the new page
Create a new file in `app/views/pages/my_new_page.html.erb`.

Please note:
1. The file extension ends in `.html.erb`. This is required.
2. The file is multiple words (my new page), and it has underscores.
3. The file is named all lowercase.

---

### 2. Add to controller
```erb
# app/controllers/pages_controller.rb

class PagesController < ApplicationController
  def index; end
  def my_new_page; end
end
```

Please note:
1. The def is named exactly like the html.erb file created above.

---

### 3. Create a new route
```erb
# config/routes.rb

Rails.application.routes.draw do
  get "my-new-page-custom", to: "pages#my_new_page"
  root 'pages#index'
end
```

Please note:
1. `my-new-page-custom` can be anything, and does not have to relate the the html or controller. This defines what is in the url, example http://localhost:3000/my-new-page-custom.
2. `pages#my_new_page` the value after #, must be identical to what you added to the pages controller above.

</p>
</details>

<details><summary>Using Playbook Kits</summary>
  
  ## Using Playbook Kits
  
  ### Confirm styles are imported
  ```scss
  // app/assets/stylesheets/application.scss
  
  @import "playbook";
  ```
  
  *Warning!* Using both storybook and playbook design libraries may cause style bleed.
  
  ### Use kits in views
  ```erb
  # Use kits in your prototype views
  
  <%= pb_rails("card") do %>
    <%= pb_rails("caption", props: {text: "This is a caption"}) %>
  <% end %>
  ```
</details>

<details><summary>Using Storybook</summary>
  
  ## Using Storybook
  
  ### Confirm styles are imported
  ```scss
  // app/assets/stylesheets/application.scss
  
  @import "storybook";
  ```
  
  *Warning!* Using both storybook and playbook design libraries may cause style bleed.
</details>

# Troubleshooting

<details>
  <summary>Yarn packages are out of date</summary>
  
  ## Yarn packages are out of date
If you try running playgrounds by `rails s`, but the terminal says:

```bash
========================================
  Your Yarn packages are out of date!
  Please run `yarn install --check-files` to update.
========================================
```

#### Try the following:
```bash
# Use the correct version of node required by the project
nvm use 8.9.4
```

```bash
# Run yarn install
yarn install --check-files
```

```bash
# Try running your rails server again
rails s
```
</details>
