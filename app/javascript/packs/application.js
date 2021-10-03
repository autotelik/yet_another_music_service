// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
import 'core-js/stable'
import 'regenerator-runtime/runtime'

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
Turbolinks.start()

import "channels"

// Direct Uploads
import * as ActiveStorage from "@rails/activestorage"
ActiveStorage.start()

import "@hotwired/turbo-rails"

// Stimulus
import "../controllers"

import "bootstrap";

$ = require('jquery');
window.jQuery = $;
window.$ = $;

//import 'select2'
//import 'select2/dist/css/select2.css'

// ASSETS - IMAGES - SCSS

const images = require.context('../../assets/images', true)
require.context('../images', true)

import "../stylesheets/application";
