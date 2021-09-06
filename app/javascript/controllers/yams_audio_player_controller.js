import { Controller } from "stimulus"

import WaveSurfer from 'wavesurfer.js';

export default class extends Controller {

    static values = {
        settings: String,
        trackId: String,
        audioUrl: String
    }

    static targets = ["player"]


    handleFrameRendered(event) {
        console.log('IN handleFrameRendered - ID ' + event.target.id);

        if(event.target.id == "player-in-navbar") {
            console.log('handleFrameRendered is player-in-navbar' + event);
        }
    }

    connect() {

        $('#yams-player-controls-pause').hide();
        $('#yams-player-controls-play').show();

        if (this.settingsValue) {
            this.settings = JSON.parse(this.settingsValue);
        }
        else {
            this.settings = {
                state: null,
                engine: null,

                save_interval: 1000,

                is_radio: false,

            
                autoplay: false,
                random: false,
                repeat: null,
                volume: 1,
        
                colors: {
                    wave_color: 'green',
                    progress_color: 'purple',
                    cursor_color: 'black'
                },

                // could holds details of the control elements such as play/prev/volume buttons
                controls: {},
                visual: {},

                timer: null
            }
        }

        console.log(this.settings);

        if (this.audioUrlValue) {

            this.engine = WaveSurfer.create({
                container: '#waveform',
                waveColor:     this.settings.colors.wave_color,
                progressColor: this.settings.colors.progress_color,
                cursorColor:   this.settings.colors.cursor_color,
                barWidth: 3,
                hideScrollbar: true,
                backend: 'MediaElement'
            });


            this.engine.load(this.audioUrlValue);


            console.log('WaveSurfer created => #waveform');

            this.engine.on('ready', function(){

                // console.log('Engine READY')

                // self.audio_data.position = 0;
                // self.seek(self.audio_data.position);

                // self.visual.current_position.html(formatTime(self.audio_data.position));
                // self.visual.total_duration.html(formatTime(self.engine.getDuration()));

                // self.volume(self.settings.volume);
                // // self.controls.volume.get(0).value = self.settings.volume * 100;
                // self.controls.volume.attr('value',  self.settings.volume * 100);

                // var volume = parseInt(self.controls.volume.attr('value'));
                // self.controls.volume.change();

            

                // self.engine.on('finish', function(){
                //     self.save_current_state();
                //     clearInterval(self.timer);
                //     self.next();
                //     console.log('Track finished');
                // })
            });

            if (this.settings.autoplay) {
                console.log('AutoPlay ON- Play')
                this.play();
            }

            console.log('WaveSurfer Engine ON');

        }
        else {
            console.log('WARNING NO AUDIO !? - Check audioUrlValue')
        }

    }


    play(){
        console.log('Someone clicked PLAY');
    
        $('#yams-player-controls-pause').show();
        $('#yams-player-controls-play').hide();

            //this.controls.play.addClass('d-none');
            //this.controls.pause.removeClass('d-none');

            //data-action': "click->yams-audio-player#play:capture")


            //console.log('PLAY - Save Callback every - ' + this.save_interval + ' ms');
            //this.timer = setInterval(this.save_current_state, this.save_interval);
       
        console.log('Calling Engine Play');
        this.engine.play();
         
    }
    
    pause(){
        console.log('Someone clicked PAUSE');

        $('#yams-player-controls-pause').hide();
        $('#yams-player-controls-play').show();

		
		//this.audio_data.autoplay = false;
		//this.save_current_state();
		
		//clearInterval(this.timer);

		this.engine.pause();
    }

    // render the track in player
    render_and_play_audio_file(event)
    {
        console.log('START render_and_play_audio_file');
    }


// 		console.log("Loading Audio Engine from URL " + track.audio_url)
// 		


// 		this.visual.pages.children('li').removeClass('yams-audio-active');
// 		var visual_page = $('#page-' + this.audio_data.page);
// 		visual_page.addClass('yams-audio-active')
// */
// 		var self = this;

// 		this.engine.on('ready', function(){

// 			console.log('Engine READY')

// 			self.audio_data.position = 0;
// 			self.seek(self.audio_data.position);

// 			self.visual.current_position.html(formatTime(self.audio_data.position));
// 			self.visual.total_duration.html(formatTime(self.engine.getDuration()));

// 			self.volume(self.settings.volume);
// 			// self.controls.volume.get(0).value = self.settings.volume * 100;
// 			self.controls.volume.attr('value',  self.settings.volume * 100);

// 			var volume = parseInt(self.controls.volume.attr('value'));
// 			self.controls.volume.change();

// 			if (self.settings.autoplay) {
// 				console.log('AutoPlay ON- Play')
// 				self.play();
// 			}

// 			self.engine.on('finish', function(){
// 				self.save_current_state();
// 				clearInterval(self.timer);
// 				self.next();
// 				console.log('Track finished');
// 			})
// 		});


// 	} */
}



