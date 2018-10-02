var song_id_to_add = 0;

$(document).ready(function() {

    $("#form_add_playlist").submit(function() {
        add_playlist();
        return false;
    });

    $("#btn_add_playlist").click(function(e) {
       add_playlist(); 
    });

    $("#btn_add_song_to_a_playlist").click(function(e) {
        var playlist_id = $("#playlist_where_song_will_be_added").val();
        $.ajax({
            url: "/playlist/song/add/",
            method: "POST",
            data: {"playlist_id": playlist_id, "song_id": song_id_to_add, "csrfmiddlewaretoken": getCookie("csrftoken")},
            success: function(data) {
                console.log("Success adding song to a playlist: " + JSON.stringify(data));
                // data = JSON.parse(data);
                $('#modal_add_song_to_a_playlist').modal('toggle');
            },
            error: function(data) {
                console.log("Error in adding song to a playlist: " + JSON.stringify(data));
            }
        });
    });

    
});

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

 function add_playlist() {
    var title = $("#playlist_name").val();
    if(title.trim().length != 0) {
        $.ajax({
            url: "/playlist/add/",
            method: "POST",
            data: {"title": title, "csrfmiddlewaretoken": getCookie("csrftoken")},
            success: function(data) {
                if(data.message == "exist") {
                    alert("Playlist " + title + " already exists!")
                } else {
                    console.log("parsed data = " + data);
                    // var row = document.getElementById("tr_no_playlist_message");
                    // row.parentNode.removeChild(row);
                    if(document.getElementById("table_playlists").rows.length == 0) {
                        document.getElementById("p_no_playlist_message").style.display = "none";
                        console.log("Removed")
                    } else console.log("More than 1")
                    $("#table_playlists").append("<tr id='tr_playlist_"+data.playlist_id+"'>"+
                                                    "<td style=\'padding: 5px;\'><i title=\'Rename playlist\' onclick=\'rename_playlist("+data.playlist_id+", "+title+")\' class=\'fa fa-edit\'></i></td>" +
                                                    "<td style=\'padding: 5px;\'><i title=\'Delete playlist\' onclick=\'remove_playlist("+data.playlist_id+", "+title+")\' class=\'fa fa-trash-alt\'></i></td>"+
                                                    "<td style=\'padding: 5px;\'><a href=\"{% url 'playlist_songs' "+data.playlist_id+" %}\" id=\'a_playlist_"+data.playlist_id+"\'>"+title+"</a></td>" +
                                                  "</tr>");
                    $('#modal_add_playlist').modal('toggle');
                }
                
            },
            error: function(data) {
    
                console.log("Error in adding playlist: " + JSON.stringify(data));
            }
        });
    } else {
        alert("Playlist title should not be blank.")
    }
    
 }

 function set_song_id_to_add(song_id) {
    song_id_to_add = song_id;
 }

 function remove_song_from_a_play_list(playlist_id, song_id, title, row_number) {
    var answer = confirm("Remove " + title + " from this playlist?");
    if(answer == true) {
        $.ajax({
            url: "/playlist/song/remove/",
            method: "POST",
            data: {"playlist_id": playlist_id, "song_id": song_id, "csrfmiddlewaretoken": getCookie("csrftoken")},
            success: function(data) {
                console.log("Success in removing song from a playlist: " + JSON.stringify(data));
                var row = document.getElementById("song_tr_"+row_number);
                row.parentNode.removeChild(row);
            },
            error: function(data) {
                console.log("Error in removing song from a playlist: " + JSON.stringify(data));
            }
        });
    }
 }

 function rename_playlist(playlist_id, playlist_name) {
    var new_name = prompt("You are about to rename " + playlist_name + ". \nEnter a new playlist name: ");
    if(new_name.trim() != "") {
        $.ajax({
            url: "/playlist/rename/",
            method: "POST",
            data: {"playlist_id": playlist_id, "new_name": new_name, "csrfmiddlewaretoken": getCookie("csrftoken")},
            success: function(data) {
                console.log("Success in renaming a playlist: " + JSON.stringify(data));
                // var row = document.getElementById("tr_playlist_"+playlist_id);
                // row.parentNode.removeChild(row);
                document.getElementById("a_playlist_"+playlist_id).innerHTML = new_name
            },
            error: function(data) {
                console.log("Error in renaming a playlist: " + JSON.stringify(data));
            }
        });
    }
 }

 function remove_playlist(playlist_id, playlist_name) {
    var answer = confirm("Delete " + playlist_name + "?");
    if(answer == true) {
        $.ajax({
            url: "/playlist/delete/",
            method: "POST",
            data: {"playlist_id": playlist_id, "csrfmiddlewaretoken": getCookie("csrftoken")},
            success: function(data) {
                console.log("Success in deleting a playlist: " + JSON.stringify(data));
                var row = document.getElementById("tr_playlist_"+playlist_id);
                row.parentNode.removeChild(row);
            },
            error: function(data) {
                console.log("Error in deleting a playlist: " + JSON.stringify(data));
            }
        });
    }
}