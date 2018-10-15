formData = new FormData();
var number_of_songs_to_add = 0;
$(document).ready(function() {
    $("#form_data_man_login").submit(function(e) {
        e.preventDefault();
        data_man_login();
    });

    // $("#search_song_key_word").keyup(function() {
    //     alert("keyup")
    //     data_man_search_song();
    // });

        $("#form_data_man_search_song").submit(function(e) {
            e.preventDefault();
            data_man_search_song();
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

        if(title.trim().length > 0 && artist != "0") {
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
            alert("Please fill-out all fields.");
        }
    });

    $("#form_add_artist").submit(function(e) {
        e.preventDefault();
        var name = $("#artist_name").val();

        if(name.trim().length > 0) {
            $.ajax({
                url: "add_artist/",
                type: "POST",
                data: {"name": name, "csrfmiddlewaretoken": getCookie("csrftoken")},
                success: function (data) {
                    if(data.message == "incorrect method") {
                        alert("You are not allowed to do this.");
                    } else if(data.message == "artist exists") {
                        alert("The artist you are tying to add already exists.")
                    } else {
                        console.log("success in adding artist = " + JSON.stringify(data))
                        alert("New artist has been successfully added!")
                        location.reload();
                    }
                    
                },
                error: function(data) {
                    console.log("error in adding artist: " + JSON.stringify(data))
                }
            });
        } else {
            alert("Please fill-out valid name.")
        }
    });

    $("#form_add_genres").submit(function(e) {
        e.preventDefault();
        var genre = $("#genre").val();
        var genre_image = $("#genre_image");

        if(genre.trim().length > 0) {
            if(genre_image.prop('files').length > 0) {
                file = genre_image.prop('files')[0];
                console.log("genre image = " + file);
                formData.append("genre_image", file);
                formData.append("csrfmiddlewaretoken", getCookie("csrftoken"));

                formData.append("genre", genre);
                $.ajax({
                    url: "add_genre/",
                    type: "POST",
                    data: formData,
                    processData: false,
                    contentType: false,
                    success: function (data) {
                        if(data.message == "incorrect method") {
                            alert("You are not allowed to do this.");
                        } else if(data.message == "genre exists") {
                            alert("The genre you are tying to add already exists.")
                        } else {
                            console.log("success in adding genre = " + JSON.stringify(data))
                            alert("New genre has been successfully added!")
                            location.reload();
                        }
                        
                    },
                    error: function(data) {
                        console.log("error in adding artist: " + JSON.stringify(data))
                    }
                });

            } else {
                alert("Please attach a valid image for this genre.")
            }

            
        } else {
            alert("Please fill-out valid genre.")
        }
    });

});

function data_man_search_song() {
    var search_song_key_word = $("#search_song_key_word").val();
    if(search_song_key_word.trim().length > 0) {
        $.ajax({
            url: "search_song/",
            type: "GET",
            data: {"keyword": search_song_key_word, "csrfmiddlewaretoken": getCookie("csrftoken")},
            success: function (data) {
                console.log("data search song=  " + JSON.stringify(data))
                if(data.content != "") {
                    $("#tbody_data_man_songs").html(data.content);
                } else {
                    alert("No songs retrieved with that keyword.")
                }
            },
            error: function(data) {
                console.log("error in searching song: " + JSON.stringify(data))
            }
        });
    } else {
        location.reload();
    }
}

function data_man_search_artist() {
    var search_artist_key_word = $("#search_artist_key_word").val();
    if(search_artist_key_word.trim().length > 0) {
        $.ajax({
            url: "search_artist/",
            type: "GET",
            data: {"keyword": search_artist_key_word, "csrfmiddlewaretoken": getCookie("csrftoken")},
            success: function (data) {
                console.log("data search artist =  " + JSON.stringify(data))
                if(data.content != "") {
                    $("#tbody_data_man_artists").html(data.content);
                } else {
                    alert("No artists retrieved with that keyword.")
                }
            },
            error: function(data) {
                console.log("error in searching artists: " + JSON.stringify(data))
            }
        });
    } else {
        location.reload();
    }
}

function data_man_search_album() {
    var search_album_key_word = $("#search_album_key_word").val();
    if(search_album_key_word.trim().length > 0) {
        $.ajax({
            url: "search_album/",
            type: "GET",
            data: {"keyword": search_album_key_word, "csrfmiddlewaretoken": getCookie("csrftoken")},
            success: function (data) {
                console.log("data search album =  " + JSON.stringify(data))
                if(data.content != "") {
                    $("#tbody_data_man_albums").html(data.content);
                } else {
                    alert("No albums retrieved with that keyword.")
                }
            },
            error: function(data) {
                console.log("error in searching albums: " + JSON.stringify(data))
            }
        });
    } else {
        location.reload();
    }
}

function data_man_search_genre() {
    var search_genre_key_word = $("#search_genre_key_word").val();
    if(search_genre_key_word.trim().length > 0) {
        $.ajax({
            url: "search_genre/",
            type: "GET",
            data: {"keyword": search_genre_key_word, "csrfmiddlewaretoken": getCookie("csrftoken")},
            success: function (data) {
                console.log("data search genre =  " + JSON.stringify(data))
                if(data.content != "") {
                    $("#tbody_data_man_genres").html(data.content);
                } else {
                    alert("No genres retrieved with that keyword.")
                }
            },
            error: function(data) {
                console.log("error in searching genres: " + JSON.stringify(data))
            }
        });
    } else {
        location.reload();
    }
}

function data_man_login() {
    var username = $("#username").val();
    var password = $("#password").val();

    $.ajax({
        url: "/data_man_login/",
        type: "POST",
        data: {"username": username, "password": password, "csrfmiddlewaretoken": getCookie("csrftoken")},
        success: function (data) {
            console.log("login " + JSON.stringify(data))
            if(data.message != "success") {
                alert(data.message);
            } else {
                window.location = "dashboard"
            }
        },
        error: function(data) {
            console.log("error logging in : " + JSON.stringify(data))
        }
    });
}

function add_song() {
    
    var title = $("#title").val();
    var album = $("#album").val();
    
    if(title.trim().length != "" && album != "0") {
        var audio_file = $("#path").val();
        console.log("path: " + audio_file);

        var genres = $("#genres").val();

        formData.append("title", title);
        formData.append("album", album);
        formData.append("genres", genres);
        formData.append("csrfmiddlewaretoken", getCookie("csrftoken"));
        

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
    } else alert("Please check your inputs.");
    
    
}

function add_album_with_songs() {
    alert("works");
    var title = $("#album_title").val();
    var artist = $("#album_artist").val();

    if(title.trim().length > 0 && artist != "0") {
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
        alert("Please fill-out all fields.");
    }
}

function delete_song(id, title, artist) {
    var confirmation = confirm("Delete song " + title + " by  " + artist + "?");
    if(confirmation == true) {
        $.ajax({
            url: "delete_song/",
            type: "POST",
            data: {"song_id": id, "csrfmiddlewaretoken": getCookie("csrftoken")},
            success: function (data) {
                if(data.message == "deleted") {
                    console.log("success in deleting a song = " + JSON.stringify(data))
                    location.reload();
                } else console.log(data)
            },
            error: function(data) {
                console.log("error in deleting song: " + JSON.stringify(data))
            }
        });
    } else {
        console.log("Delete cancelled.");
    }
}

function show_update_artist_form(id, artist) {
    $("#td_artist_"+id).html($("#new_artist_form_container").html());
    $("#new_artist").val(artist);
    $("#new_artist_id").val(id);
    $("#new_artist").focus();
}

function update_artist() {
    var id = $("#new_artist_id").val();
    var artist = $("#new_artist").val();

    if(artist.trim().length > 0) {
        $.ajax({
            url: "update_artist/",
            type: "POST",
            data: {"artist_id": id, "artist": artist, "csrfmiddlewaretoken": getCookie("csrftoken")},
            success: function (data) {
                $("#td_artist_"+id).html(artist);

            },
            error: function(data) {
                console.log("error in updating artist: " + JSON.stringify(data))
            }
        });
    } else {
        alert("Artist name cannot be empty!");
        $("#new_artist").focus();
    }
}

function delete_artist(id, artist) {
    var confirmation = confirm("Delete " + artist + "?");
    if(confirmation == true) {
        $.ajax({
            url: "delete_artist/",
            type: "POST",
            data: {"artist_id": id, "csrfmiddlewaretoken": getCookie("csrftoken")},
            success: function (data) {
                alert("Successfully deleted!");
                location.reload();
            },
            error: function(data) {
                console.log("error in adding album and songs: " + JSON.stringify(data))
            }
        });
    }
}

function show_update_album_form(id, album) {
    $("#td_album_"+id).html($("#new_album_form_container").html());
    $("#new_album").val(album);
    $("#new_album_id").val(id);
    $("#new_album").focus();
}

function update_album() {
    var id = $("#new_album_id").val();
    var album = $("#new_album").val();

    if(album.trim().length > 0) {
        $.ajax({
            url: "update_album/",
            type: "POST",
            data: {"album_id": id, "album": album, "csrfmiddlewaretoken": getCookie("csrftoken")},
            success: function (data) {
                $("#td_album_"+id).html(album);

            },
            error: function(data) {
                console.log("error in updating album: " + JSON.stringify(data))
            }
        });
    } else {
        alert("Album title cannot be empty!");
        $("#new_album").focus();
    }

    return false;
}

function delete_album(id, album) {
    var confirmation = confirm("Delete " + album + "?");
    if(confirmation == true) {
        $.ajax({
            url: "delete_album/",
            type: "POST",
            data: {"album_id": id, "csrfmiddlewaretoken": getCookie("csrftoken")},
            success: function (data) {
                alert("Successfully deleted!");
                location.reload();
            },
            error: function(data) {
                console.log("error in deleting album: " + JSON.stringify(data))
            }
        });
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