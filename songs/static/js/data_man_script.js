formData = new FormData();
var number_of_songs_to_add = 0;
$(document).ready(function() {
    $("#form_add_song").submit(function(e) {
        e.preventDefault();
        add_song();
        
    });

    $('#path').change(function(){
        console.log("changed.") 
        if($(this).prop('files').length > 0) {
            file = $(this).prop('files')[0];
            // var audio = document.getElementById("audio_to_upload");
            // audio.src = file.;
            // audio.load();
            formData.append("audio", file);
            formData.append("size", file.size);
            formData.append("type", file.type);
            // formData.append("duration", audio.duration);
            console.log(file);
        }
    });

    $("#album_cover").change(function() {
        console.log("changed album cover") 
        if($(this).prop('files').length > 0) {
            file = $(this).prop('files')[0];
            formData.append("cover", file);
            console.log(file);
        }
    });
    
    $("#btn_add_songs").click(function(e) {
        number_of_songs_to_add = prompt("How many songs to add?");
        if(number_of_songs_to_add != null) {
            if(isNaN(number_of_songs_to_add)) {
                alert("Input was not valid.")
            } else {
                number_of_songs_to_add = parseInt(number_of_songs_to_add);

                var elements = "<br><p class='alert alert-warning'>Please enter song information below.</p>";

                for(var i = 1; i <= number_of_songs_to_add; i++) {
                    elements += "<h4>Song "+ i +"</h4>";
                    elements += "<label>Song Title:</label>";
                    elements += "<input required class='form-control' id='song_"+i+"_title' />";
                    elements += "<label>Genre:</label>";
                    elements += "<select required class='form-control' id='song_"+i+"_genres' multiple>"+ $("#div_genre_options_container").html() +"</select>"
                    elements += "<label>Path:</label>";
                    elements += "<input required type='file' accept='audio/*' class='form-control' id='song_"+i+"_path'>";
                    elements += "<br>";
                }
                elements += "<button onclick='add_album_with_songs(); return false;' id='btn_album_submit' class='btn btn-primary'>Submit</button> <button class='btn btn-danger' onclick='location.reload()'>Cancel</button>"

                $("#div_songs_input_container").html(elements);
                $("#div_album_primary_buttons_container").hide();
            }
        }   
    });

    $("#btn_add_album").click(function() {
        var title = $("#album_title").val();
        var artist = $("#album_artist").val();

        if(title.trim().length > 0) {
            formData.append("title", title);
            formData.append("artist", artist);
            formData.append("csrfmiddlewaretoken", getCookie("csrftoken"));


            $.ajax({
                url: "add_album/",
                type: "POST",
                data: formData,
                processData: false,
                contentType: false,
                success: function (data) {
                    console.log("success = " + JSON.stringify(data))
                    alert("New album has been successfully added!")
                    location.reload();
                },
                error: function(data) {
                    console.log("error in adding album: " + JSON.stringify(data))
                }
            });
        } else {
            alert("You missed album title.");
        }
    })

})

function add_song() {
    
    var title = $("#title").val();
    
    if(title.trim().length != "") {
        var audio_file = $("#path").val();
        console.log("path: " + audio_file);

        var album = $("#album").val();
        var genres = $("#genres").val();

        console.log("genres = " + genres)

        formData.append("title", title);
        formData.append("album", album);
        formData.append("genres", genres);
        formData.append("csrfmiddlewaretoken", getCookie("csrftoken"));
        
        console.log(formData.keys());
        console.log(formData.values());

        $.ajax({
            url: "add_song/",
            type: "POST",
            data: formData,
            processData: false,
            contentType: false,
            success: function (data) {
                console.log("success = " + JSON.stringify(data))
                alert("New song has been successfully added!")
                location.reload();
                formData = new FormData();
            },
            error: function(data) {
                console.log("error in adding song: " + JSON.stringify(data))
            }
        });
    }
    
    
}

function add_album_with_songs() {
    alert("works");
    var title = $("#album_title").val();
    var artist = $("#album_artist").val();

    if(title.trim().length > 0) {
        formData.append("album_title", title);
        formData.append("artist", artist);
        formData.append("csrfmiddlewaretoken", getCookie("csrftoken"));

        for(var i = 1; i <= number_of_songs_to_add; i++) {
            var song_title = $("#song_"+i+"_title").val();
            var genres = $("#song_"+i+"_genres").val();
            var audio_file = $("#song_"+i+"_path");
            
            if(song_title.trim().length > 0 && genres.length > 0) {
                if(audio_file.prop('files').length > 0) {
                    file = audio_file.prop('files')[0];
                    size = file.size / 1048576
                    if(size > 10) {
                        alert("Audio file for song " + i + " is too large.")
                        break;
                    } else {
                        formData.append("audio_file_"+i, file);
                        formData.append("size_"+i, size);
                        formData.append("audio_format_"+i, file.type);
                        console.log("audiooo = " + file);
                        formData.append("song_title_"+i, song_title);
                        formData.append("genres_"+i, genres);
                    }
                } else {
                    alert("Please choose a valid file.")
                    break;
                }
            } else {
                alert("Please don't leave blanks.");
                break;
            }
        }

        formData.append("number_of_songs_to_add", number_of_songs_to_add);

        $.ajax({
            url: "add_album_with_songs/",
            type: "POST",
            data: formData,
            processData: false,
            contentType: false,
            success: function (data) {
                if(data.message == "incorrect method") {
                    alert("You are not allowed to do this.")
                } else {
                    alert("New album and songs has been successfully added!");
                }
                console.log("success in adding album and songs = " + JSON.stringify(data))
                location.reload();
            },
            error: function(data) {
                console.log("error in adding album and songs: " + JSON.stringify(data))
            }
        });

        return false;
    } else {
        alert("You missed album title.");
    }
}


function getCookie(c_name) {
    if (document.cookie.length > 0) {
        c_start = document.cookie.indexOf(c_name + "=");
        if (c_start != -1) {
            c_start = c_start + c_name.length + 1;
            c_end = document.cookie.indexOf(";", c_start);
            if (c_end == -1) c_end = document.cookie.length;
            return unescape(document.cookie.substring(c_start, c_end));
        }
    }
}