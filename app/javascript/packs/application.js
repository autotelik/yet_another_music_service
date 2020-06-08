// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
require("jquery")

import 'bootstrap'

$ = require('jquery');
window.jQuery = $;
window.$ = $;

require('../custom/active_storage_drag_drop_file_uploads')
require('./event_listeners')

// Uncomment to copy all static images under assets/images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
const images = require.context('../../assets/images', true)
const imagePath = (name) => images(name, true)

import select2 from 'select2/dist/js/select2';
import "select2/dist/css/select2.css";

// Hook up select2 to jquery
//select2($);