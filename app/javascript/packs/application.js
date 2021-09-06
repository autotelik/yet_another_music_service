// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
//import Turbolinks from "turbolinks"
//Turbolinks.start()

import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()

ActiveStorage.start()

import "@hotwired/turbo-rails"

import "controllers"

require("jquery")

$ = require('jquery');
window.jQuery = $;
window.$ = $;

const images = require.context('../../assets/images', true)

require.context('../images', true)

import "../stylesheets/application";
