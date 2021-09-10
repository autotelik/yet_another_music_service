import { Controller } from "stimulus"

// Import UJS so we can access the Rails.ajax method
import Rails from "@rails/ujs";

// Manages loading Tracks from Playlists/Albums etc

export default class extends Controller {

    static values = {
        settings: String,
        trackId: String,
        url: String
    }

    connect() {

        if (this.settingsValue) {
            this.settings = JSON.parse(this.settingsValue);
        }
        else {
            this.settings = {
                state: null,
                engine: null,

                save_interval: 1000,

                is_radio: false,

                settings: {
                    autoplay: false,
                    random: false,
                    repeat: null,
                    volume: 1
                },

                colors: {
                    wave_color: 'green',
                    progress_color: 'purple',
                    cursor_color: 'black'
                },

                // Holds details of the control elements such as play/prev/volume buttons
                controls: {},
                visual: {},

                timer: null
            }
        }

        console.log('TrackListing Settings: ' + this.settings);
    }

    load(event){
        console.log('Calling YAMS : ' + event.currentTarget.dataset.url);

        Rails.ajax({
            url: event.currentTarget.dataset.url,
            type: 'GET',
            error:function(e){
                alert("FAILED TO GET TRACK" + e);
            }
        })
    }


}

