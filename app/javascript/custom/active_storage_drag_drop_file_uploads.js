// File Upload based https://edgeguides.rubyonrails.org/active_storage_overview.html#direct-uploads
//
import { DirectUpload } from "@rails/activestorage"

class Uploader {

	// Ths ID of the Form to which hidden fields must be appended
	// File object to upload
	// The input file form element- should contain data link Url supplied by Rails direct download
	// The progress element ID
	//
	constructor(form_id, file, input, progress_id) {

		this.file        = file
		this.url         = input.dataset.directUploadUrl

		this.form_id     = form_id
		this.input       = input
		this.progress_id = progress_id

		console.log('DirectUpload created');
		this.upload = new DirectUpload(this.file, this.url, this)
	}

	start() {
		console.log('Uploader upload started : ' + this.url);

		this.upload.create((error, blob) => {

			if (error) {
				// Handle the error
				alert('Sorry cannot process upload : ' + error)
			}
			else {
				let progressBar = document.getElementById(this.progress_id);
				progressBar.style.display = 'inline';

				// We'll deal with progress as %
				progressBar.max = 100;

				// Add an appropriately-named hidden input to the form with a
				// value of blob.signed_id so that the blob ids will be
				// transmitted in the normal upload flow
				const hiddenField = document.createElement('input')

				hiddenField.setAttribute("type", "hidden");
				hiddenField.setAttribute("value", blob.signed_id);
				hiddenField.name = this.input.name

				var form = document.getElementById(this.form_id)

				form.appendChild(hiddenField)

				console.log('Add direct upload hidden field to:');
				console.log(hiddenField);
				console.log('Add hidden field to:' );
				console.log(form);
			}
		})
	}

	// Event Listeners to manage Progress bar for active storage based on
	// https://edgeguides.rubyonrails.org/active_storage_overview.html#direct-uploads

	directUploadWillStoreFileWithXHR(request) {
		request.upload.addEventListener("progress", event => this.directUploadDidProgress(event))
	}

	directUploadDidProgress(event) {
		// Use event.loaded and event.total to update the progress bar
		console.log("direct upload progress event: %o", event)
		const progressElement = document.getElementById(this.progress_id)

		let progress = (event.loaded / event.total) * 100;

		console.log("Update progress element value to : " + progress)
		progressElement.value = progress;
	}
}

// Expects callback : parseFileCallback
//
// Which is called after a File is selected, and prior to the upload being started,
// so can be used for things like validation of file type selected.
// Expected to return true if upload should proceed, false otherwise
//
export const manageUpload = function(formID,
                                     inputFileID,
                                     directUploadProgressID,
                                     messagesID,
                                     parseFileCallback)
{

	var form_id = formID
	var input   = document.getElementById(inputFileID);

	var directUploadProgressID = directUploadProgressID

	var parseCallback = parseFileCallback;

	// Bind to normal file selection
	input.addEventListener('change', (event) => {
		console.log("CHANGE EVENT ON " + input)

		// clear any messages from previous attempts
		document.getElementById(messagesID).innerHTML = null;
		document.getElementById(messagesID + "-errors").innerHTML = null;

		// TODO: provide a bulk upload option
		//
		// Array.from(input.files).forEach(file => uploadFile(file))
		uploadFile(input.files[0])

		// you might clear the selected files from the input
		input.value = null
	})

	// Start background Uploading
	function uploadFile(file)
	{
		if(parseCallback(file, messagesID))
		{
			// Make the preview panel visible
			document.getElementById(directUploadProgressID).classList.remove("d-none");

			var uploader = new Uploader(form_id, file, input, directUploadProgressID);

			uploader.start();
		}
	}
}

// Output response to client
function addMessage(messagesID, msg)
{
	var outputElement = document.getElementById(messagesID);
	outputElement.innerHTML += msg;
	outputElement.innerHTML += "</br>";
}

// Hook - On file select/drop perform Validation and update UI with preview/icons, progress bar etc
//
export const validateImageFile = function(file, messagesID)
{
	var file_name = file.name;

	console.log('Validate Image File : ' + file_name);

	var isImage = (/\.(?=gif|jpg|jpeg|png)/gi).test(file_name);

	if (isImage)
	{
		// Generate Thumbnail Preview
		console.log('Generating Thumbnail Preview');
		let preview = $('#image-upload-preview')

		preview.attr("src", URL.createObjectURL(file));
		preview.addClass("img-preview img-preview-lg");
		preview.removeClass("d-none");    // make it visible
	}
	else {
		addMessage(messagesID + "-errors", "Unsupported file type - sorry we cannot process :</br>" + file_name);

		return false;
	}

	addMessage(messagesID, "Uploading  " + file_name);

	return true;
}


// Hook - On select/drop perform Validation and update UI with preview/icons, progress bar etc
//
export const validateAudioFile = function(file, messagesID)
{
	var file_name = file.name;

	console.log('Validate Audio File : ' + file_name);

	var isAudio = (/\.(?=wav|mp3|flac|alac|aiff)/gi).test(file_name);

	if (!isAudio) {
		addMessage(messagesID + "-errors", "Unsupported file type - sorry we cannot process :</br>" + file_name);

		return false;
	}

	addMessage(messagesID, "Uploading : " + file_name);
	return true;
}



