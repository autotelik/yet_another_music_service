import { Controller } from "stimulus"

import WaveSurfer from 'wavesurfer.js';

export default class extends Controller {

    static values = {
        settings: String,
        trackId: String,
        audioUrl: String,
        listItemId: String,
        nextTrack: String,
        prevTrack: String,
        volume: Number
    }

    static targets = ["player", "volumeSlider"]

    handleFrameRendered(event) {
        console.log('IN handleFrameRendered - ID ' + event.target.id);

        if(event.target.id == "player-in-navbar") {
            console.log('handleFrameRendered is player-in-navbar' + event);
        }
    }

    // Create WaveSurfer instance, load audio and render the Wav

    connect() {
        console.log('WaveSurfer process new Track load');
        
        this.pauseControl().hide();
        this.playControl().show();
        
        this.volumeValue = 100.0;

        this.settings = {}

        if (this.settingsValue) {
            this.settings = JSON.parse(this.settingsValue).settings;
        }
        else {
            // See - yams_audio_engine/app/services/yams_audio/player_settings_builder.rb
            this.settings = {
                
                autoplay: false,
                random: false,
                repeat: null,
                save_interval: 1000,
        
                waveform: {
                    colors: {
                        wave_color: 'green',
                        progress_color: 'purple',
                        cursor_color: 'black'
                    }
                },

                // could holds details of the control elements such as play/prev/volume buttons
                controls: {},
                visual: {},

                timer: null
            }
        }

        console.log(this.settings);

        if (this.audioUrlValue) {

            this.playerElem().show();

            this.engine = WaveSurfer.create({
                container:     '#waveform',
                waveColor:     this.settings.waveform.wave_color,
                progressColor: this.settings.waveform.progress_color,
                cursorColor:   this.settings.waveform.cursor_color,
                barWidth: 3,
                hideScrollbar: true,
                backend: 'MediaElement'
            });

            this.engine.load(this.audioUrlValue);

            console.log('WaveSurfer created => #waveform');

            this.engine.on('ready', function(){
                console.log('Engine READY')
            });


            // console.log('WaveSurfer Engine ON');

            if (this.settings.autoplay) {
                // console.log('AutoPlay ON- Play')
                this.play();
            }

            $("li").removeClass("yams-audio-list-selected");

            $('#' + this.listItemIdValue).addClass("yams-audio-list-selected");
        }
        else {
            // console.log('WARNING NO AUDIO !? - Check audioUrlValue')
            this.playerElem().hide();
        }

    }

    play(event){
        event.stopPropagation()   // otherwise calls rails server as well - maybe cos we use <a href='#' ?
        //event.preventDefault()

        console.log('Clicked PLAY ON: ' + $('#' + this.listItemIdValue));
    
        this.pauseControl().show();
        this.playControl().hide();

        //console.log('PLAY - Save Callback every - ' + this.save_interval + ' ms');
        //this.timer = setInterval(this.save_current_state, this.save_interval);
       
        $("li").removeClass("yams-audio-list-selected");

        $('#' + this.listItemIdValue).addClass("yams-audio-list-selected");

        this.engine.play();
    }
    
    pause(event){
        event.stopPropagation()
        //console.log('Clicked PAUSE');

        this.pauseControl().hide();
        this.playControl().show();
		
		this.engine.pause();
    }

    previous(event) {
        event.stopPropagation() 
        //console.log('Clicked PREVIOUS');

        let findId = this.listItemIdValue;

        // TODO: best way of passing the playlist ID in ?
        let playList = this.listItems('#yams-audio-radio-playlist');

        playList.each(function(i, li) {
            //console.log(i);
            //console.log(li.id);
         
            // when i == 0 li == empty string - probably the header row ?
            if (li.id == findId && i > 1) {
                 // TODO - for now we assume its the Cover image we click to Play
                //  - find more sustainable way of passing this info in
                $('#' + playList[i-1].id).find('img').trigger('click');
                return false;
            }
        });
    }

    next(event) {
        event.stopPropagation()  
    
        let findId = this.listItemIdValue;

        //console.log('Clicked NEXT ON : ' + findId);

        // TODO: best way of passing the playlist ID in ?
        let playList = this.listItems('#yams-audio-radio-playlist');

        playList.each(function(i, li) {
            
            if (li.id == findId && playList[i+1]) {
                 // TODO - for now we assume its the Cover image we click - find more sustainable way of passing this info in
                $('#' + playList[i+1].id).find('img').trigger('click');
                return false;
            }
        });
    }

    volumeMute(event) {
        event.stopPropagation()  
        console.log('Clicked MUTE');
       
        $('#yams-player-controls-volume-mute').hide();
        $('#yams-player-controls-volume-off').show();
        
        this.volumeValue = this.volumeSliderTarget.value;
        console.log(this.volumeValue);

        this.volumeSliderTarget.value = 0;

        this.engine.setVolume(0);
    }

    volumeOff(event) {
        event.stopPropagation()  
        console.log('Clicked VOLUME OFF');

        $('#yams-player-controls-volume-mute').show();
        $('#yams-player-controls-volume-off').hide();

        this.volumeSliderTarget.value = this.volumeValue;

        this.engine.setVolume((this.volumeValue / this.maxVolume()));
    }

    volumeSliderChange(event) {
        event.stopPropagation()  

        let value = parseInt(this.volumeSliderTarget.value);

        if (isNaN(value)) value = 1;
    
    
        if (value == 0) {
            $('#yams-player-controls-volume-mute').hide();
            $('#yams-player-controls-volume-off').show();
        } else  {
            $('#yams-player-controls-volume-mute').show();
            $('#yams-player-controls-volume-off').hide();
        }

        this.volumeValue = value;

        this.engine.setVolume(value / this.maxVolume());
    }

    listItems(id) {
        return $(id + ' li')
    }

    maxVolume() {
       return 100.0;
    }

    pauseControl() {
        return $('#yams-player-controls-pause');
    }

    playControl() { 
        return $('#yams-player-controls-play');
    }

    playerElem() {
        return $('#' + this.playerTarget.id)
    }

}

