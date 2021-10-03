import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.warnings = true
application.debug    = true
window.Stimulus      = application

import DropzoneController from "./dropzone_controller"
Stimulus.register("dropzone", DropzoneController)

import YamsAudioPlayerController from "./yams_audio_player_controller"
Stimulus.register("yams-audio-player", YamsAudioPlayerController)

export { application }
