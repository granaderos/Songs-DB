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
            return unescape(document.cookie.substring(c_start,c_end));
        }
    }
    return "";
 }


 function add_playlist() {
    var title = $("#playlist_name").val();
    $.ajax({
        url: "playlist/add/",
        method: "POST",
        data: {"title": title, "csrfmiddlewaretoken": getCookie("csrftoken")},
        success: function(data) {
            console.log("Success adding playlist: " + JSON.stringify(data));
            data = JSON.parse(data);
            $("#ul_playlists").append("<li><a href=\"{% url 'playlist_songs' "+data.playlist_id+" %}\">"+title+"</a></li>");
            $('#modal_add_playlist').modal('toggle');
        },
        error: function(data) {
            console.log("Error in adding playlist: " + JSON.stringify(data));
        }
    });
 }

 function set_song_id_to_add(song_id) {
    song_id_to_add = song_id;
 }

 function remove_song_from_a_play_list(playlist_id, song_id, title) {
    var answer = confirm("Remove " + title + " from this playlist?");
    if(answer == true) {
        $.ajax({
            url: "/playlist/song/remove/",
            method: "POST",
            data: {"playlist_id": playlist_id, "song_id": song_id, "csrfmiddlewaretoken": getCookie("csrftoken")},
            success: function(data) {
                console.log("Success in removing song from a playlist: " + JSON.stringify(data));
                var row = document.getElementById("tr_song_"+song_id);
                row.parentNode.removeChild(row);
            },
            error: function(data) {
                console.log("Error in removing song from a playlist: " + JSON.stringify(data));
            }
        });
    }
 }