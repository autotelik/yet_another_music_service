import { Controller } from "stimulus"

import Rails from "@rails/ujs";

// Manages loading Playlists from Lists

export default class extends Controller {

    static values = {
        header: String,
        url: String
    }

    connect() {
    }

    load(event){
        console.log('Calling YAMS : ');
        console.log(event.currentTarget.dataset);
        console.log(event.currentTarget.dataset.url);

/*         <%= link_to(playlist.name, yams_core.playlist_url(playlist, format: :json), id: "select_playlist_row_#{playlist.id}") %>

                  <script type="text/javascript" charset="utf-8">
										$('#<%= "select_playlist_row_#{playlist.id}" %>').click(function (event) {
											event.preventDefault(); // Prevent link from following its href

											$.ajax({
												type: 'GET',
												url: '<%= url_for(yams_core.playlist_url(playlist)) %>',
												dataType: "script"
											});
										});
                  </script> */

        // Rails.ajax({
        //     url: event.currentTarget.dataset.url,
        //     type: 'GET',
        //     //dataType: "script",
        //     error:function(e){
        //         alert("FAILED TO GET PLAYLIST" + e);
        //     }
        // })

        $('#current-playlist-header').html(event.currentTarget.dataset.header);
    }


}

