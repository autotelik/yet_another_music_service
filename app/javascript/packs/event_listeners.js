import { manageUpload, validateAudioFile, validateImageFile } from 'custom/active_storage_drag_drop_file_uploads';

document.addEventListener("turbolinks:load", function() {

	// formID, inputFileID, directUploadProgressID, messagesID, parseFileCallback)

	if (document.getElementById('label-for-audio-upload')) {
		console.log("On Audio upload page - setup JS for Audio Uploads")
		manageUpload(
				'track-tracks-upload-form',
				'new-audio-upload-file-field',
				'audio-upload-progress',
				'audio-upload-messages',
				validateAudioFile
		);
	}

	if (document.getElementById('label-for-image-upload')) {
		console.log("An Image upload page - setup JS for Image Uploads")
		manageUpload(
				'track-tracks-upload-form',
				'new-image-upload-file-field',
				'image-upload-progress',
				'image-upload-messages',
				validateImageFile
		);
	}
});


